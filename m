Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2572F5061A7
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiDSBSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiDSBS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:18:29 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A6A2FFF1
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 18:15:49 -0700 (PDT)
Date:   Tue, 19 Apr 2022 01:15:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail2; t=1650330945;
        bh=vGPe9oyRu6z4m0OTxHe6LWHmTuENY6PMjtLMb1ZCtVw=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=iy2tFF5ff1tGp9AWAravB8fvnSbPUavEzLcdhPxmkQO/9XqmbbGbQsm3JxgP1DSsl
         WVnfbamtD07T8ZiMB/nBGA/qkv1GejKTg4KJyj2fSsRoGpgQyn7uJDli4z+l75IaST
         4LMW+BDl3xq2eufBO9NSeAMi4BoIURyVjVO0bBxkbpZVY3eMwCZkrAMJPruClqeZv0
         ZN2tBoBFVXx5iCY61lzrHJsMQroMaUeCLQQLehbgAnaS9RYL9/k6u+cC2sTigYQ5cJ
         8/azlLvpIWOZqO0/KumJDor3T9Y2V5xQZZvKK3nUxPCT+Enx1CcCi9Pkui3sWWilbi
         p52mVJi0yCLAg==
To:     linux-wireless@vger.kernel.org
From:   Solomon Tan <solomonbstoner@protonmail.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblit@intel.com, johannes.berg@intel.com,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        kvalo@kernel.org, luciano.coelho@intel.com,
        Solomon Tan <solomonbstoner@protonmail.ch>
Reply-To: Solomon Tan <solomonbstoner@protonmail.ch>
Subject: [PATCH 3/3] iwlwifi: Replace space with tabs as code indent
Message-ID: <20220419011340.14954-4-solomonbstoner@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the checkpatch.pl warning that code indent should
use tabs.

Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wir=
eless/intel/iwlwifi/mvm/mvm.h
index c6bc85d4600a..0e5ba208e606 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1305,7 +1305,7 @@ static inline bool iwl_mvm_is_csum_supported(struct i=
wl_mvm *mvm)
 {
 =09return fw_has_capa(&mvm->fw->ucode_capa,
 =09=09=09   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT) &&
-               !IWL_MVM_HW_CSUM_DISABLE;
+=09=09!IWL_MVM_HW_CSUM_DISABLE;
 }

 static inline bool iwl_mvm_is_mplut_supported(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c b/drivers/=
net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
index 080a1587caa5..0f7fa6032c66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
@@ -104,9 +104,9 @@ static const struct wiphy_vendor_command iwl_mvm_vendor=
_commands[] =3D {
 };

 enum iwl_mvm_vendor_events_idx {
-        /* 0x0 - 0x3 are deprecated */
-        IWL_MVM_VENDOR_EVENT_IDX_ROAMING_FORBIDDEN =3D 4,
-        NUM_IWL_MVM_VENDOR_EVENT_IDX
+=09/* 0x0 - 0x3 are deprecated */
+=09IWL_MVM_VENDOR_EVENT_IDX_ROAMING_FORBIDDEN =3D 4,
+=09NUM_IWL_MVM_VENDOR_EVENT_IDX
 };

 static const struct nl80211_vendor_cmd_info
--
2.35.3


