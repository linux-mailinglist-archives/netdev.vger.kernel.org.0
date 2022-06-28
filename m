Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9255C552
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbiF1JrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242407AbiF1JrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:47:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A422225E82;
        Tue, 28 Jun 2022 02:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0964B81D9C;
        Tue, 28 Jun 2022 09:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75818C341ED;
        Tue, 28 Jun 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656409590;
        bh=Pidffgv8+vxANZk99fiHBEcr5xE1kNKPmd0X8nIl4XY=;
        h=From:To:Cc:Subject:Date:From;
        b=nOcRjaFPNFScFiXdKrB2F8YYb6CPmWyMpALhxvrj3cjnCrtSSHb1z+KLKVayVCVda
         at8owWAD3BEqBPRjixrG39Cx0vu51KH26s0QaNFZI9hpYtmuwntZ1PeuqYcGsbBstt
         DKInp9Myza28C9F5Mmo31eFMfV2Kc8JOzfbNFZAWJWtVGt7np+qwiL1lcryxy7sUjC
         p5W0pHxXEX4FAr9kK8uZ/zcRkHryiIBDQ6IWmOMBxVam4kkykvl0yMbVuAELhJW4+a
         pqC+XiDPQEOcY9he59MFVJViMVrlXI42knJl/YF5d6vbYHlcclC/nS3jS9OJ46JdOK
         Y7rUWeaKNq8tA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o67nf-005HEj-Ip;
        Tue, 28 Jun 2022 10:46:27 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marco Elver <elver@google.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kasan-dev@googlegroups.com, linaro-mm-sig@lists.linaro.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, linux-sgx@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org
Subject: [PATCH 00/22] Fix kernel-doc warnings at linux-next
Date:   Tue, 28 Jun 2022 10:46:04 +0100
Message-Id: <cover.1656409369.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we're currently discussing about making kernel-doc issues fatal when
CONFIG_WERROR is enable, let's fix all 60 kernel-doc warnings 
inside linux-next:

	arch/x86/include/uapi/asm/sgx.h:19: warning: Enum value 'SGX_PAGE_MEASURE' not described in enum 'sgx_page_flags'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'rdi' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'rsi' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'rdx' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'rsp' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'r8' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:97: warning: Function parameter or member 'r9' not described in 'sgx_enclave_user_handler_t'
	arch/x86/include/uapi/asm/sgx.h:124: warning: Function parameter or member 'reserved' not described in 'sgx_enclave_run'
	drivers/devfreq/devfreq.c:707: warning: Function parameter or member 'val' not described in 'qos_min_notifier_call'
	drivers/devfreq/devfreq.c:707: warning: Function parameter or member 'ptr' not described in 'qos_min_notifier_call'
	drivers/devfreq/devfreq.c:717: warning: Function parameter or member 'val' not described in 'qos_max_notifier_call'
	drivers/devfreq/devfreq.c:717: warning: Function parameter or member 'ptr' not described in 'qos_max_notifier_call'
	drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:5095: warning: expecting prototype for amdgpu_device_gpu_recover_imp(). Prototype was for amdgpu_device_gpu_recover() instead
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:544: warning: Function parameter or member 'dmub_outbox_params' not described in 'amdgpu_display_manager'
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:544: warning: Function parameter or member 'num_of_edps' not described in 'amdgpu_display_manager'
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:544: warning: Function parameter or member 'disable_hpd_irq' not described in 'amdgpu_display_manager'
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:544: warning: Function parameter or member 'dmub_aux_transfer_done' not described in 'amdgpu_display_manager'
	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:544: warning: Function parameter or member 'delayed_hpd_wq' not described in 'amdgpu_display_manager'
	drivers/gpu/drm/amd/include/amd_shared.h:224: warning: Enum value 'PP_GFX_DCS_MASK' not described in enum 'PP_FEATURE_MASK'
	drivers/gpu/drm/scheduler/sched_main.c:999: warning: Function parameter or member 'dev' not described in 'drm_sched_init'
	drivers/usb/dwc3/core.h:1328: warning: Function parameter or member 'async_callbacks' not described in 'dwc3'
	drivers/usb/dwc3/gadget.c:675: warning: Function parameter or member 'mult' not described in 'dwc3_gadget_calc_tx_fifo_size'
	fs/attr.c:36: warning: Function parameter or member 'ia_vfsuid' not described in 'chown_ok'
	fs/attr.c:36: warning: Excess function parameter 'uid' description in 'chown_ok'
	fs/attr.c:63: warning: Function parameter or member 'ia_vfsgid' not described in 'chgrp_ok'
	fs/attr.c:63: warning: Excess function parameter 'gid' description in 'chgrp_ok'
	fs/namei.c:649: warning: Function parameter or member 'mnt' not described in 'path_connected'
	fs/namei.c:649: warning: Function parameter or member 'dentry' not described in 'path_connected'
	fs/namei.c:1089: warning: Function parameter or member 'inode' not described in 'may_follow_link'
	include/drm/gpu_scheduler.h:463: warning: Function parameter or member 'dev' not described in 'drm_gpu_scheduler'
	include/linux/dcache.h:309: warning: expecting prototype for dget, dget_dlock(). Prototype was for dget_dlock() instead
	include/linux/fscache.h:270: warning: Function parameter or member 'cookie' not described in 'fscache_use_cookie'
	include/linux/fscache.h:270: warning: Excess function parameter 'object' description in 'fscache_use_cookie'
	include/linux/fscache.h:287: warning: Function parameter or member 'cookie' not described in 'fscache_unuse_cookie'
	include/linux/fscache.h:287: warning: Excess function parameter 'object' description in 'fscache_unuse_cookie'
	include/linux/genalloc.h:54: warning: Function parameter or member 'start_addr' not described in 'genpool_algo_t'
	include/linux/kfence.h:221: warning: Function parameter or member 'slab' not described in '__kfence_obj_info'
	include/linux/regulator/driver.h:434: warning: Function parameter or member 'n_ramp_values' not described in 'regulator_desc'
	include/linux/textsearch.h:51: warning: Function parameter or member 'list' not described in 'ts_ops'
	include/linux/usb/typec_altmode.h:132: warning: Function parameter or member 'altmode' not described in 'typec_altmode_get_orientation'
	include/net/cfg80211.h:391: warning: Function parameter or member 'bw' not described in 'ieee80211_eht_mcs_nss_supp'
	include/net/cfg80211.h:437: warning: Function parameter or member 'eht_cap' not described in 'ieee80211_sband_iftype_data'
	include/net/cfg80211.h:507: warning: Function parameter or member 's1g' not described in 'ieee80211_sta_s1g_cap'
	include/net/cfg80211.h:1390: warning: Function parameter or member 'counter_offset_beacon' not described in 'cfg80211_color_change_settings'
	include/net/cfg80211.h:1390: warning: Function parameter or member 'counter_offset_presp' not described in 'cfg80211_color_change_settings'
	include/net/cfg80211.h:1430: warning: Enum value 'STATION_PARAM_APPLY_STA_TXPOWER' not described in enum 'station_parameters_apply_mask'
	include/net/cfg80211.h:2195: warning: Function parameter or member 'dot11MeshConnectedToAuthServer' not described in 'mesh_config'
	include/net/cfg80211.h:2341: warning: Function parameter or member 'short_ssid' not described in 'cfg80211_scan_6ghz_params'
	include/net/cfg80211.h:3328: warning: Function parameter or member 'kck_len' not described in 'cfg80211_gtk_rekey_data'
	include/net/cfg80211.h:3698: warning: Function parameter or member 'ftm' not described in 'cfg80211_pmsr_result'
	include/net/cfg80211.h:3828: warning: Function parameter or member 'global_mcast_stypes' not described in 'mgmt_frame_regs'
	include/net/cfg80211.h:4977: warning: Function parameter or member 'ftm' not described in 'cfg80211_pmsr_capabilities'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'u' not described in 'wireless_dev'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'links' not described in 'wireless_dev'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'valid_links' not described in 'wireless_dev'
	include/net/cfg80211.h:6076: warning: Function parameter or member 'is_amsdu' not described in 'ieee80211_data_to_8023_exthdr'
	include/net/cfg80211.h:6949: warning: Function parameter or member 'sig_dbm' not described in 'cfg80211_notify_new_peer_candidate'
	include/net/mac80211.h:6250: warning: Function parameter or member 'vif' not described in 'ieee80211_channel_switch_disconnect'
	mm/memory.c:1729: warning: Function parameter or member 'mt' not described in 'unmap_vmas'
	net/mac80211/sta_info.h:569: warning: Function parameter or member 'cur_max_bandwidth' not described in 'link_sta_info'

Mauro Carvalho Chehab (22):
  net: cfg80211: fix kernel-doc warnings all over the file
  net: mac80211: add a missing comma at kernel-doc markup
  net: mac80211: sta_info: fix a missing kernel-doc struct element
  x86/sgx: fix kernel-doc markups
  fscache: fix kernel-doc documentation
  fs: attr: update vfs uid/gid parameters at kernel-doc
  fs: namei: address some kernel-doc issues
  devfreq: shut up kernel-doc warnings
  drm: amdgpu: amdgpu_dm: fix kernel-doc markups
  drm: amdgpu: amdgpu_device.c: fix a kernel-doc markup
  drm: amd: amd_shared.h: Add missing doc for PP_GFX_DCS_MASK
  drm: gpu_scheduler: fix a kernel-doc warning
  drm: scheduler: add a missing kernel-doc parameter
  kfence: fix a kernel-doc parameter
  mm: document maple tree pointer at unmap_vmas() at memory.c
  genalloc: add a description for start_addr parameter
  textsearch: document list inside struct ts_ops
  regulator: fix a kernel-doc warning
  dcache: fix a kernel-doc warning
  usb: typec_altmode: add a missing "@" at a kernel-doc parameter
  usb: dwc3: document async_callbacks field
  usb: dwc3: gadget: fix a kernel-doc warning

 arch/x86/include/uapi/asm/sgx.h               | 10 +++++--
 drivers/devfreq/devfreq.c                     |  4 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |  2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  7 +++++
 drivers/gpu/drm/amd/include/amd_shared.h      |  1 +
 drivers/gpu/drm/scheduler/sched_main.c        |  1 +
 drivers/usb/dwc3/core.h                       |  2 ++
 drivers/usb/dwc3/gadget.c                     |  1 +
 fs/attr.c                                     |  4 +--
 fs/namei.c                                    |  3 ++
 include/drm/gpu_scheduler.h                   |  1 +
 include/linux/dcache.h                        |  2 +-
 include/linux/fscache.h                       |  4 +--
 include/linux/genalloc.h                      |  1 +
 include/linux/kfence.h                        |  1 +
 include/linux/regulator/driver.h              |  1 +
 include/linux/textsearch.h                    |  1 +
 include/linux/usb/typec_altmode.h             |  2 +-
 include/net/cfg80211.h                        | 28 ++++++++++++++-----
 include/net/mac80211.h                        |  2 +-
 mm/memory.c                                   |  2 ++
 net/mac80211/sta_info.h                       |  2 ++
 22 files changed, 65 insertions(+), 17 deletions(-)

-- 
2.36.1


