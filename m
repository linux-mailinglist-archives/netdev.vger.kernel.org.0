Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424255345DB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbiEYVg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 17:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiEYVgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 17:36:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B815FC0;
        Wed, 25 May 2022 14:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653514583; x=1685050583;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=p2xIr7qIJQysFb3ESgxRnboAHXPwDgkY8y4Y8EPMgTo=;
  b=TIIYovGOjtUYEOw9NfLThc3il7tl+21cwYt5BIe4O7YKbFjBOXZdzfPy
   UQvT1moL6sREKi7lcRzV1QiLni9R4RlGilriyuUDfdSL8qoG5oiF28pCJ
   vCgR8ZvI59UM0dBNcpV4+7qNGZEcx//dY9vmSDO+EqcsMPTEDrCoVzW+s
   KfbjiBe6Y5Z6wYjy86JKAC50d48iQkdumalO4l6BCwOgvjP8NH6g/F9Hn
   pCMj+Cx7WROznI349+TVZgfzpt4QlBbdtFoM//ZNrJ5gmm/icAJKllw1z
   zrDnGIEdPd4GXujPwBamDnkbTbUe80jXoOz7A95vfDd0M0f3dhVFGbS+A
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="273942785"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="273942785"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 14:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="717928351"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2022 14:36:17 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntyfw-0003KS-WB;
        Wed, 25 May 2022 21:36:17 +0000
Date:   Thu, 26 May 2022 05:35:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8cb8311e95e3bb58bd84d6350365f14a718faa6d  Add linux-next specific files for 20220525

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
https://lore.kernel.org/llvm/202205251645.gusu3spL-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1093:9: warning: 'CAUSE' macro redefined [-Wmacro-redefined]
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2216) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]

Unverified Error/Warning (likely false positive, please contact us if interested):

.__mulsi3.o.cmd: No such file or directory
Makefile:686: arch/h8300/Makefile: No such file or directory
Makefile:765: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/riscv/purgatory/kexec-purgatory.c:1860:9: sparse: sparse: trying to concatenate 29720-character string (8191 bytes max)
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:309:9: sparse: sparse: dubious: x & !y
drivers/pinctrl/meson/pinctrl-meson8-pmx.c:60:25: warning: Value stored to 'func' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/staging/vt6655/card.c:758:16: sparse: sparse: cast to restricted __le64
drivers/vhost/vdpa.c:595 vhost_vdpa_unlocked_ioctl() warn: maybe return -EFAULT instead of the bytes remaining?
kernel/bpf/helpers.c:1468:29: sparse: sparse: symbol 'bpf_dynptr_from_mem_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1490:29: sparse: sparse: symbol 'bpf_dynptr_from_mem_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1516:29: sparse: sparse: symbol 'bpf_dynptr_read_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1542:29: sparse: sparse: symbol 'bpf_dynptr_write_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1569:29: sparse: sparse: symbol 'bpf_dynptr_data_proto' was not declared. Should it be static?
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1948 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
sound/soc/intel/avs/ipc.c:87:5-24: atomic_dec_and_test variation before object free at line 88.
{standard input}:3488: Error: unknown pseudo-op: `.l28'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arm-allmodconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-randconfig-s032-20220524
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r004-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r033-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- i386-randconfig-a012
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a014
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-m021
|   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- ia64-randconfig-r036-20220524
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- m68k-allyesconfig
|   |-- drivers-block-paride-bpck.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-comm.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-dstr.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-epat.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-epia.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-friq.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-frpw.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-kbic.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-on26.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-ppc6lnx.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-aio_aio12_8.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-das16m1.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-ni_at_ao.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-ni_daq_700.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-ethernet-apne.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-ethernet-xircom-xirc2ps_cs.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-tty-ipwireless-hardware.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-restricted-__le16-usertype-raw_data-got-int
|   `-- drivers-tty-ipwireless-hardware.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-short-unused-usertype-__v-got-restricted-__le16-assigned-usertype-raw_data
|-- microblaze-randconfig-m031-20220524
|   `-- drivers-vhost-vdpa.c-vhost_vdpa_unlocked_ioctl()-warn:maybe-return-EFAULT-instead-of-the-bytes-remaining
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- sound-soc-intel-avs-ipc.c:atomic_dec_and_test-variation-before-object-free-at-line-.
|-- openrisc-randconfig-s032-20220524
|   `-- __mulsi3.o.cmd:No-such-file-or-directory
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- arch-riscv-kernel-machine_kexec.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-got-void-noderef-__user-buf
|   |-- arch-riscv-purgatory-kexec-purgatory.c:sparse:sparse:trying-to-concatenate-character-string-(-bytes-max)
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-fork.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-atomic_t-usertype-lock-got-struct-atomic_t-noderef-__rcu
|   `-- kernel-seccomp.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-atomic_t-usertype-lock-got-struct-atomic_t-noderef-__rcu
|-- riscv-randconfig-r042-20220524
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- s390-randconfig-r014-20220524
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sh-buildonly-randconfig-r003-20220524
|   `-- standard-input:Error:unknown-pseudo-op:l28
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- arm-randconfig-c002-20220524
|   `-- drivers-pinctrl-meson-pinctrl-meson8-pmx.c:warning:Value-stored-to-func-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|-- hexagon-randconfig-r011-20220524
|   `-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|-- hexagon-randconfig-r035-20220524
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
`-- mips-randconfig-r022-20220524
    `-- drivers-net-wireless-intel-iwlwifi-pcie-trans.c:warning:CAUSE-macro-redefined

elapsed time: 858m

configs tested: 94
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm64                               defconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
powerpc                          allmodconfig
s390                             allmodconfig
m68k                             allmodconfig
powerpc                          allyesconfig
s390                             allyesconfig
m68k                             allyesconfig
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
m68k                            mac_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                              ul2_defconfig
mips                    maltaup_xpa_defconfig
xtensa                          iss_defconfig
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
xtensa                           allyesconfig
arc                                 defconfig
parisc                              defconfig
parisc64                            defconfig
s390                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                               defconfig
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
riscv                randconfig-r042-20220524
arc                  randconfig-r043-20220524
s390                 randconfig-r044-20220524
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-syz
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                           allyesconfig

clang tested configs:
mips                        bcm63xx_defconfig
mips                       lemote2f_defconfig
mips                         tb0287_defconfig
arm                          ep93xx_defconfig
arm                     am200epdkit_defconfig
powerpc                     tqm5200_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220524
hexagon              randconfig-r041-20220524
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
