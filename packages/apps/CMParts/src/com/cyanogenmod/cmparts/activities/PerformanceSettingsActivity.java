package com.cyanogenmod.cmparts.activities;

import com.cyanogenmod.cmparts.R;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.SystemProperties;
import android.preference.CheckBoxPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceScreen;
import android.provider.Settings;

import java.io.File;

/**
 * Performance Settings
 */
public class PerformanceSettingsActivity extends PreferenceActivity implements Preference.OnPreferenceChangeListener {

    private static final String COMPCACHE_PREF = "pref_compcache";
    
    private static final String COMPCACHE_PROP = "compcache.size";

    private static final String COMPCACHE_PERSIST_PROP = "persist.service.compcache";

    private static final String COMPCACHE_DEFAULT = "25";

    private static final String SWAP_PERSIST_PROP = "persist.sys.swap";

    private static final String SWAP_PREF = "pref_swap";

    private static final String SWAP_DEFAULT = "0";

    private static final String JIT_PREF = "pref_jit_mode";
    
    private static final String JIT_ENABLED = "int:jit";
    
    private static final String JIT_DISABLED = "int:fast";
    
    private static final String JIT_PERSIST_PROP = "persist.sys.jit-mode";
    
    private static final String JIT_PROP = "dalvik.vm.execution-mode";
    
    private static final String HEAPSIZE_PREF = "pref_heapsize";
    
    private static final String HEAPSIZE_PROP = "dalvik.vm.heapsize";
    
    private static final String HEAPSIZE_PERSIST_PROP = "persist.sys.vm.heapsize";
    
    private static final String HEAPSIZE_DEFAULT = "16m";
    
    private static final String USE_DITHERING_PREF = "pref_use_dithering";
    
    private static final String USE_DITHERING_PERSIST_PROP = "persist.sys.use_dithering";
    
    private static final String USE_DITHERING_DEFAULT = "1";

    private static final String LOCK_HOME_PREF = "pref_lock_home";

    private static final String LOCK_MMS_PREF = "pref_lock_mms";

    private static final int LOCK_HOME_DEFAULT = 0;

    private static final int LOCK_MMS_DEFAULT = 1;

    private ListPreference mCompcachePref;

    private CheckBoxPreference mSwapPref;

    private CheckBoxPreference mJitPref;

    private CheckBoxPreference mUseDitheringPref;

    private CheckBoxPreference mLockHomePref;

    private CheckBoxPreference mLockMmsPref;

    private ListPreference mHeapsizePref;

    private AlertDialog alertDialog;

    private int swapAvailable = -1;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setTitle(R.string.performance_settings_title);
        addPreferencesFromResource(R.xml.performance_settings);
        
        PreferenceScreen prefSet = getPreferenceScreen();
        
        mCompcachePref = (ListPreference) prefSet.findPreference(COMPCACHE_PREF);
        mSwapPref = (CheckBoxPreference) prefSet.findPreference(SWAP_PREF);
        if (isSwapAvailable()) {
            if (SystemProperties.get(COMPCACHE_PROP).equals("1"))
                SystemProperties.set(COMPCACHE_PROP,COMPCACHE_DEFAULT);
            mCompcachePref.setValue(SystemProperties.get(COMPCACHE_PERSIST_PROP,
                      SystemProperties.get(COMPCACHE_PROP, COMPCACHE_DEFAULT)));
            mCompcachePref.setOnPreferenceChangeListener(this);

            String useSwap = SystemProperties.get(SWAP_PERSIST_PROP, SWAP_DEFAULT);
            mSwapPref.setChecked("1".equals(useSwap));
        } else {
            prefSet.removePreference(mCompcachePref);
            prefSet.removePreference(mSwapPref);
        }

        mJitPref = (CheckBoxPreference) prefSet.findPreference(JIT_PREF);
        String jitMode = SystemProperties.get(JIT_PERSIST_PROP,
                SystemProperties.get(JIT_PROP, JIT_ENABLED));
        mJitPref.setChecked(JIT_ENABLED.equals(jitMode));
        
        mUseDitheringPref = (CheckBoxPreference) prefSet.findPreference(USE_DITHERING_PREF);
        String useDithering = SystemProperties.get(USE_DITHERING_PERSIST_PROP, USE_DITHERING_DEFAULT);
        mUseDitheringPref.setChecked("1".equals(useDithering));
        
        mHeapsizePref = (ListPreference) prefSet.findPreference(HEAPSIZE_PREF);
        mHeapsizePref.setValue(SystemProperties.get(HEAPSIZE_PERSIST_PROP, 
                SystemProperties.get(HEAPSIZE_PROP, HEAPSIZE_DEFAULT)));
        mHeapsizePref.setOnPreferenceChangeListener(this);

        mLockHomePref = (CheckBoxPreference) prefSet.findPreference(LOCK_HOME_PREF);
        mLockHomePref.setChecked(Settings.System.getInt(getContentResolver(),
                Settings.System.LOCK_HOME_IN_MEMORY, LOCK_HOME_DEFAULT) == 1);

        mLockMmsPref = (CheckBoxPreference) prefSet.findPreference(LOCK_MMS_PREF);
        mLockMmsPref.setChecked(Settings.System.getInt(getContentResolver(),
                Settings.System.LOCK_MMS_IN_MEMORY, LOCK_MMS_DEFAULT) == 1);

        // Set up the warning
        alertDialog = new AlertDialog.Builder(this).create();
        alertDialog.setTitle(R.string.performance_settings_warning_title);
        alertDialog.setMessage(getResources().getString(R.string.performance_settings_warning));
        alertDialog.setButton(DialogInterface.BUTTON_POSITIVE, "OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                return;
            }
        });
        
        alertDialog.show();
    }
    
    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
        if (preference == mSwapPref) {
		boolean checked = mSwapPref.isChecked();
		if (checked) {
			SystemProperties.set(SWAP_PERSIST_PROP, "1");
			SystemProperties.set(COMPCACHE_PERSIST_PROP, "0");
			mCompcachePref.setValue("0");
		} else {
			SystemProperties.set(SWAP_PERSIST_PROP, "0");
			SystemProperties.set(COMPCACHE_PERSIST_PROP, COMPCACHE_DEFAULT);
			mCompcachePref.setValue(COMPCACHE_DEFAULT);
		}
		return true;
        }
        if (preference == mJitPref) {
            SystemProperties.set(JIT_PERSIST_PROP, 
                    mJitPref.isChecked() ? JIT_ENABLED : JIT_DISABLED);
            return true;
        }
        
        if (preference == mUseDitheringPref) {
            SystemProperties.set(USE_DITHERING_PERSIST_PROP,
                    mUseDitheringPref.isChecked() ? "1" : "0");
            return true;
        }

        if (preference == mLockHomePref) {
            Settings.System.putInt(getContentResolver(),
                    Settings.System.LOCK_HOME_IN_MEMORY, mLockHomePref.isChecked() ? 1 : 0);
            return true;
        }

        if (preference == mLockMmsPref) {
            Settings.System.putInt(getContentResolver(),
                    Settings.System.LOCK_MMS_IN_MEMORY, mLockMmsPref.isChecked() ? 1 : 0);
            return true;
        }

        return false;
    }

    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == mHeapsizePref) {
            if (newValue != null) {
                SystemProperties.set(HEAPSIZE_PERSIST_PROP, (String)newValue);
                return true;
            }
        }
        if (preference == mCompcachePref) {
            if (newValue != null) {
                SystemProperties.set(COMPCACHE_PERSIST_PROP, (String)newValue);
                if ( ! newValue.equals("0") ) {
                        // CompCache is enabled - disable Swap
                        SystemProperties.set(SWAP_PERSIST_PROP, "0");
                        mSwapPref.setChecked(false);
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Check if swap support is available on the system
     */
    private boolean isSwapAvailable() {
        if (swapAvailable < 0) {
            swapAvailable = new File("/proc/swaps").exists() ? 1 : 0;
        }
        return swapAvailable > 0;
    }

}
