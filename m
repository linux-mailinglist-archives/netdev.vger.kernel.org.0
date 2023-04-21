Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577DB6EA2ED
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 06:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjDUEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 00:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDUEzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 00:55:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D337EE4F;
        Thu, 20 Apr 2023 21:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682052907; x=1713588907;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Si4cAZHmPhhzqevijyJbTADLO6LynaNev6gfuxwtaYU=;
  b=Qf0EeeS23T1M4DhiS8VHA8m5kD4ciQsJepnD5WYtMGcy0cDznBHmeNaE
   KJDvoS5aP0BeOyMbyjh6w1drt1tUDusshDHJ0iIy8WQ4VRpc0l0xAFLYe
   kEEStcsu+QPUw46cS2pIQhCAJ+MBL6FPdzpwnex2D8PWV3Awk058+3Hcx
   W48qO8J7Bi0nyubRlAIdBp5cmNJRfC3gfk+3aMY9gTpytQ48Fto8s/Mno
   +r2tfAzcBfmNIP0jItx2WP9/LrrByQVVSsQj9nID/UAAK53zOhIe3oX+Y
   X9s51ZhZZ7c8BJldGd8PMagT7RrsQJ5XuVOYBLGJBmnShDE4v4xYd+Gl8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343406618"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343406618"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 21:55:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="1021800153"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="1021800153"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2023 21:55:04 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ppinX-000gKU-0u;
        Fri, 21 Apr 2023 04:55:03 +0000
Date:   Fri, 21 Apr 2023 12:55:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mark Brown <broonie@kernel.org>, patches@opensource.cirrus.com,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 44bf136283e567b2b62653be7630e7511da41da2
Message-ID: <64421726.n6Dw4L+sJKeGhr0E%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 44bf136283e567b2b62653be7630e7511da41da2  Add linux-next specific files for 20230420

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202304172004.r3IPh5Ja-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304200812.6UqNDVZy-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304201027.2upm4i0C-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304201216.YgbKeHUJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304210303.nlMI0sRQ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304210349.DykCi88S-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304210552.jAaBFgWm-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

arc-elf-ld: drivers/net/phy/phy_device.c:3026: undefined reference to `devm_led_classdev_register_ext'
arch/arm64/mm/fixmap.c:187:10: warning: variable 'bm_pudp' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:184:19: warning: variable 'dmub' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm.c:138:15: warning: variable 'feature_support' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:122:14: warning: no previous prototype for function 'dmub_abm_get_current_backlight' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:133:14: warning: no previous prototype for function 'dmub_abm_get_target_backlight' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:144:6: warning: no previous prototype for function 'dmub_abm_set_level' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:163:6: warning: no previous prototype for function 'dmub_abm_set_ambient_level' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:183:6: warning: no previous prototype for function 'dmub_abm_init_config' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:213:6: warning: no previous prototype for function 'dmub_abm_set_pause' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:231:6: warning: no previous prototype for function 'dmub_abm_set_pipe' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:251:6: warning: no previous prototype for function 'dmub_abm_set_backlight_level' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dmub_abm_lcd.c:81:6: warning: no previous prototype for function 'dmub_abm_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:451:16: warning: variable 'j' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:1072:6: warning: no previous prototype for 'gfx_v9_4_3_disable_gpa_mode' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:1072:6: warning: no previous prototype for function 'gfx_v9_4_3_disable_gpa_mode' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:48:38: warning: unused variable 'golden_settings_gc_9_4_3' [-Wunused-const-variable]
drivers/net/phy/phy_device.c:3026: undefined reference to `devm_led_classdev_register_ext'
drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c:298:6: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
drivers/virt/fsl_hypervisor.c:799:52: error: too many arguments to function call, expected 2, have 3
fs/ext4/super.c:1262:13: warning: unused variable 'i' [-Wunused-variable]
fs/ext4/super.c:1262:6: warning: unused variable 'i' [-Wunused-variable]
phy_device.c:(.text+0x3548): undefined reference to `devm_led_classdev_register_ext'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/acpi/property.c:985 acpi_data_prop_read_single() error: potentially dereferencing uninitialized 'obj'.
fs/ext4/super.c:4722 ext4_check_feature_compatibility() warn: bitwise AND condition is false here
fs/ext4/verity.c:316 ext4_get_verity_descriptor_location() error: uninitialized symbol 'desc_size_disk'.
sound/soc/codecs/cs35l45.c:805:9-34: WARNING: Threaded IRQ with no primary handler requested without IRQF_ONESHOT (unless it is nested IRQ)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- alpha-randconfig-r021-20230409
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- alpha-randconfig-r025-20230410
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- arc-randconfig-r006-20230417
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- arc-randconfig-r024-20230416
|   |-- arc-elf-ld:drivers-net-phy-phy_device.c:undefined-reference-to-devm_led_classdev_register_ext
|   `-- drivers-net-phy-phy_device.c:undefined-reference-to-devm_led_classdev_register_ext
|-- arc-randconfig-r043-20230420
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- i386-randconfig-m021-20230417
|   `-- drivers-acpi-property.c-acpi_data_prop_read_single()-error:potentially-dereferencing-uninitialized-obj-.
|-- i386-randconfig-s001-20230417
|   `-- fs-ext4-super.c:warning:unused-variable-i
|-- i386-randconfig-s002-20230417
|   `-- fs-ext4-super.c:warning:unused-variable-i
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- ia64-randconfig-r023-20230410
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- ia64-randconfig-s043-20230416
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:sparse:sparse:cast-truncates-bits-from-constant-value-(ffff-becomes-ff)
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- loongarch-defconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- loongarch-randconfig-r013-20230418
|   `-- phy_device.c:(.text):undefined-reference-to-devm_led_classdev_register_ext
|-- microblaze-buildonly-randconfig-r006-20230418
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- microblaze-randconfig-c44-20230419
|   `-- sound-soc-codecs-cs35l45.c:WARNING:Threaded-IRQ-with-no-primary-handler-requested-without-IRQF_ONESHOT-(unless-it-is-nested-IRQ)
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- mips-randconfig-m041-20230416
|   |-- fs-ext4-super.c-ext4_check_feature_compatibility()-warn:bitwise-AND-condition-is-false-here
|   `-- fs-ext4-verity.c-ext4_get_verity_descriptor_location()-error:uninitialized-symbol-desc_size_disk-.
|-- mips-randconfig-s041-20230416
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:sparse:sparse:cast-truncates-bits-from-constant-value-(ffff-becomes-ff)
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- parisc-randconfig-r005-20230417
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- riscv-randconfig-r016-20230416
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- s390-buildonly-randconfig-r004-20230416
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- sparc64-randconfig-c024-20230417
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- sparc64-randconfig-r003-20230416
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c:warning:variable-j-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-gfx_v9_4_3_disable_gpa_mode
|-- x86_64-randconfig-a004-20230417
|   `-- fs-ext4-super.c:warning:unused-variable-i
|-- x86_64-randconfig-m001
|   `-- drivers-acpi-property.c-acpi_data_prop_read_single()-error:potentially-dereferencing-uninitialized-obj-.
`-- x86_64-randconfig-s023
    `-- fs-ext4-super.c:warning:unused-variable-i
clang_recent_errors
|-- arm-randconfig-r002-20230417
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-function-gfx_v9_4_3_disable_gpa_mode
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:unused-variable-golden_settings_gc_9_4_3
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- arm-randconfig-r026-20230409
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- arm64-randconfig-r001-20230418
|   |-- arch-arm64-mm-fixmap.c:warning:variable-bm_pudp-set-but-not-used
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- arm64-randconfig-r015-20230417
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:variable-dmub-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm.c:warning:variable-feature_support-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_get_current_backlight
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_get_target_backlight
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_init_config
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_set_ambient_level
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_set_backlight_level
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_set_level
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_set_pause
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dmub_abm_lcd.c:warning:no-previous-prototype-for-function-dmub_abm_set_pipe
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-function-gfx_v9_4_3_disable_gpa_mode
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:unused-variable-golden_settings_gc_9_4_3
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- arm64-randconfig-r024-20230415
|   |-- arch-arm64-mm-fixmap.c:warning:variable-bm_pudp-set-but-not-used
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- hexagon-randconfig-r045-20230420
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8195.c:warning:variable-ret-is-uninitialized-when-used-here
|-- i386-randconfig-r026-20230417
|   `-- fs-ext4-super.c:warning:unused-variable-i
|-- mips-randconfig-r025-20230409
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-function-gfx_v9_4_3_disable_gpa_mode
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:unused-variable-golden_settings_gc_9_4_3
|-- powerpc-buildonly-randconfig-r004-20230417
|   `-- drivers-virt-fsl_hypervisor.c:error:too-many-arguments-to-function-call-expected-have
|-- powerpc-randconfig-r032-20230420
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-function-gfx_v9_4_3_disable_gpa_mode
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:unused-variable-golden_settings_gc_9_4_3
|-- s390-randconfig-r022-20230415
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:no-previous-prototype-for-function-gfx_v9_4_3_disable_gpa_mode
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v9_4_3.c:warning:unused-variable-golden_settings_gc_9_4_3
`-- x86_64-randconfig-a012
    `-- fs-ext4-super.c:warning:unused-variable-i

elapsed time: 727m

configs tested: 184
configs skipped: 16

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r013-20230416   gcc  
alpha                randconfig-r021-20230409   gcc  
alpha                randconfig-r021-20230417   gcc  
alpha                randconfig-r025-20230410   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r006-20230417   gcc  
arc                  randconfig-r024-20230409   gcc  
arc                  randconfig-r025-20230417   gcc  
arc                  randconfig-r043-20230416   gcc  
arc                  randconfig-r043-20230417   gcc  
arc                  randconfig-r043-20230420   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r005-20230416   clang
arm                                 defconfig   gcc  
arm                         nhk8815_defconfig   gcc  
arm                           omap1_defconfig   clang
arm                             pxa_defconfig   gcc  
arm                  randconfig-r002-20230416   gcc  
arm                  randconfig-r002-20230417   clang
arm                  randconfig-r021-20230418   clang
arm                  randconfig-r026-20230409   clang
arm                  randconfig-r026-20230415   gcc  
arm                  randconfig-r046-20230416   clang
arm                  randconfig-r046-20230417   gcc  
arm                  randconfig-r046-20230420   clang
arm                        vexpress_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r001-20230418   clang
arm64                randconfig-r004-20230417   gcc  
arm64                randconfig-r015-20230417   clang
arm64                randconfig-r024-20230415   clang
csky         buildonly-randconfig-r001-20230420   gcc  
csky         buildonly-randconfig-r004-20230420   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r024-20230410   gcc  
hexagon              randconfig-r005-20230416   clang
hexagon              randconfig-r006-20230418   clang
hexagon              randconfig-r012-20230417   clang
hexagon              randconfig-r016-20230417   clang
hexagon              randconfig-r023-20230415   clang
hexagon              randconfig-r034-20230420   clang
hexagon              randconfig-r035-20230420   clang
hexagon              randconfig-r041-20230416   clang
hexagon              randconfig-r041-20230417   clang
hexagon              randconfig-r041-20230420   clang
hexagon              randconfig-r045-20230416   clang
hexagon              randconfig-r045-20230417   clang
hexagon              randconfig-r045-20230420   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230417   gcc  
i386                 randconfig-a002-20230417   gcc  
i386                 randconfig-a003-20230417   gcc  
i386                 randconfig-a004-20230417   gcc  
i386                 randconfig-a005-20230417   gcc  
i386                 randconfig-a006-20230417   gcc  
i386                 randconfig-a011-20230417   clang
i386                 randconfig-a012-20230417   clang
i386                 randconfig-a013-20230417   clang
i386                 randconfig-a014-20230417   clang
i386                 randconfig-a015-20230417   clang
i386                 randconfig-a016-20230417   clang
i386                 randconfig-r026-20230417   clang
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r001-20230417   gcc  
ia64         buildonly-randconfig-r005-20230418   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r023-20230409   gcc  
ia64                 randconfig-r023-20230410   gcc  
ia64                          tiger_defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r005-20230420   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r006-20230416   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r004-20230416   gcc  
m68k                 randconfig-r021-20230410   gcc  
m68k                 randconfig-r022-20230409   gcc  
microblaze   buildonly-randconfig-r004-20230418   gcc  
microblaze   buildonly-randconfig-r006-20230418   gcc  
microblaze           randconfig-r004-20230418   gcc  
microblaze           randconfig-r024-20230418   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ci20_defconfig   gcc  
mips                            gpr_defconfig   gcc  
mips                      maltasmvp_defconfig   gcc  
mips                 randconfig-r003-20230417   clang
mips                 randconfig-r012-20230416   clang
mips                 randconfig-r014-20230417   gcc  
mips                 randconfig-r025-20230409   clang
mips                 randconfig-r025-20230418   clang
mips                 randconfig-r026-20230410   clang
mips                   sb1250_swarm_defconfig   clang
nios2        buildonly-randconfig-r001-20230416   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r001-20230416   gcc  
nios2                randconfig-r003-20230418   gcc  
nios2                randconfig-r033-20230420   gcc  
openrisc             randconfig-r005-20230418   gcc  
openrisc             randconfig-r011-20230417   gcc  
parisc       buildonly-randconfig-r003-20230416   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r005-20230417   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r003-20230417   clang
powerpc      buildonly-randconfig-r004-20230417   clang
powerpc                       holly_defconfig   gcc  
powerpc                        icon_defconfig   clang
powerpc                      makalu_defconfig   gcc  
powerpc                     rainier_defconfig   gcc  
powerpc              randconfig-r022-20230410   gcc  
powerpc              randconfig-r023-20230417   clang
powerpc              randconfig-r032-20230420   clang
powerpc                     taishan_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230418   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230418   clang
riscv                randconfig-r016-20230416   gcc  
riscv                randconfig-r024-20230417   clang
riscv                randconfig-r042-20230416   gcc  
riscv                randconfig-r042-20230417   clang
riscv                randconfig-r042-20230420   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r004-20230416   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r022-20230415   clang
s390                 randconfig-r044-20230416   gcc  
s390                 randconfig-r044-20230417   clang
s390                 randconfig-r044-20230420   gcc  
sh                               allmodconfig   gcc  
sh                        apsh4ad0a_defconfig   gcc  
sh           buildonly-randconfig-r002-20230416   gcc  
sh           buildonly-randconfig-r005-20230417   gcc  
sh                   randconfig-r011-20230416   gcc  
sh                   randconfig-r023-20230418   gcc  
sh                   randconfig-r026-20230418   gcc  
sh                   randconfig-r031-20230420   gcc  
sh                          rsk7201_defconfig   gcc  
sh                          sdk7780_defconfig   gcc  
sh                     sh7710voipgw_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r021-20230415   gcc  
sparc                randconfig-r022-20230418   gcc  
sparc64      buildonly-randconfig-r002-20230417   gcc  
sparc64      buildonly-randconfig-r003-20230418   gcc  
sparc64      buildonly-randconfig-r003-20230420   gcc  
sparc64              randconfig-r003-20230416   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230417   gcc  
x86_64               randconfig-a002-20230417   gcc  
x86_64               randconfig-a003-20230417   gcc  
x86_64               randconfig-a004-20230417   gcc  
x86_64               randconfig-a005-20230417   gcc  
x86_64               randconfig-a006-20230417   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                               rhel-8.3   gcc  
xtensa                          iss_defconfig   gcc  
xtensa               randconfig-r015-20230416   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
