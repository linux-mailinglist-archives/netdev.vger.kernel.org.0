Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB658A4667
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 00:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfHaWBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 18:01:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38251 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfHaWBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 18:01:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so1467266wrx.5;
        Sat, 31 Aug 2019 15:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yEuPdy6ASwhJKW6dartSJLwpi4f/BFysZLH5JVYxHQ=;
        b=usspT5CNIeKkij/GcInOZgg+MatRCVTjwWmcH7uzhoXLr1Q31xZbjVR3f32M733NWB
         oQSOCwVGW10mx4B06Qj/+tTc0VbkQZereIr6FgzqaZvE6YWGWkRoeVCW6WIRMfS3XfSe
         9fwKr6fLDsmZRHHKPvGbeSRx+p/CZknOtvo52GuHUQQuw1TO/HqsQNVZJIf2CuI2u66W
         qF/xCvnPbUttO8OqlKrTyvXaqbYusMQRFbgDYIj9sRsnqa4BIP2SLazoe1HIEv9uLtvn
         4nlKIn+pZhYkONhOhj0uIKENVT3hPrWW+ZM9nfSUet2JHAm6qXI+NFT2M68IjW8TOX/P
         /mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=0yEuPdy6ASwhJKW6dartSJLwpi4f/BFysZLH5JVYxHQ=;
        b=dFU96JpxaqZyBEtrvqwdbtVMIwK8VMssryNsIX4YzwDOy8A8XNQT/jSAVAT9zKyEsQ
         VeshssoygiFlrnHuJmJ7PjAzmOvDmef5vNf2xDrXpYqggd8g4UFIrgXh1fiPqrw0c01d
         MwrSIutxvEAZs/70oE7cAanE2+AtLw9Lye+d+Q9ERxWErmZF6iweBXu3n2wZCKd2Wcb7
         EfnUeGxRLBPTTe6rf3IoakIqMFBXDcgK9ykHl0IAZPtJA5BF5TITicnrJbQDTUj6aoFO
         gS9XgToZo10OGeYlR/mNiWja4lrFp6/Q/kSPZbDF0BSUmsJSvhVKM5owdXxBqI/5DtbT
         kATA==
X-Gm-Message-State: APjAAAWzu30mxwTy9yCgA3REWyumkn6jRyuFrRoVp4vfNyzcQn3Rb384
        r4ID/t9N9bSEIL7FdhM7NNg=
X-Google-Smtp-Source: APXvYqwyvK5/VTscyfz6qINEgc49Nn/haWjIqp8NHL/RRmaNp+tow6fArj3i+Suc18bzKYioJTNwOQ==
X-Received: by 2002:adf:fd41:: with SMTP id h1mr17693907wrs.315.1567288870126;
        Sat, 31 Aug 2019 15:01:10 -0700 (PDT)
Received: from localhost.localdomain (ip5b4096c3.dynamic.kabel-deutschland.de. [91.64.150.195])
        by smtp.gmail.com with ESMTPSA id m19sm7370844wml.28.2019.08.31.15.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 15:01:09 -0700 (PDT)
From:   Krzysztof Wilczynski <kw@linux.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: Move static keyword to the front of declarations
Date:   Sun,  1 Sep 2019 00:01:08 +0200
Message-Id: <20190831220108.10602-1-kw@linux.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the static keyword to the front of declarations of
he_if_types_ext_capa_sta and he_iftypes_ext_capa, and
resolve the following compiler warnings that can be seen
when building with warnings enabled (W=1):

drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:427:1: warning:
  ‘static’ is not at beginning of declaration [-Wold-style-declaration]

drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:434:1: warning:
  ‘static’ is not at beginning of declaration [-Wold-style-declaration]

Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
---
Related: https://lore.kernel.org/r/20190827233017.GK9987@google.com

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d6499763f0dd..937a843fed56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -424,14 +424,14 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 	return ret;
 }
 
-const static u8 he_if_types_ext_capa_sta[] = {
+static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
-const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
+static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
 	{
 		.iftype = NL80211_IFTYPE_STATION,
 		.extended_capabilities = he_if_types_ext_capa_sta,
-- 
2.22.1

