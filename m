Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126BF18AA13
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCSAwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:52:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:39148 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:52:42 -0400
IronPort-SDR: kqP3qPTQjFV5dfMYhd8Pg5mIveO65Z8xKYcMBJP+7UtLn6U+eRdyNll+9kX9Pbd+i8iwK6fPzw
 Mq93DthkxARg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 17:52:42 -0700
IronPort-SDR: pylb1Q2pqDgBW9TBZ6Otx8Gajj1wINJ5ppLWK1rtewRX62EIVSKUR//TprOAEKd0HFFBFFpRk9
 12DRW66XY4Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="418155202"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2020 17:52:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jEjQN-0003OP-85; Thu, 19 Mar 2020 08:52:39 +0800
Date:   Thu, 19 Mar 2020 08:52:09 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     kbuild-all@lists.01.org, Jes.Sorensen@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [RFC PATCH] rtl8xxxu: rtl8xxxu_desc_to_mcsrate() can be static
Message-ID: <20200319005209.GA16405@256b6bfaef2b>
References: <20200318082700.71875-3-chiu@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318082700.71875-3-chiu@endlessm.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: b509af994715 ("rtl8xxxu: Feed current txrate information for mac80211")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 rtl8xxxu_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 49dfa32b572a3..4f0d0bce48b03 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5404,7 +5404,7 @@ static struct ieee80211_rate rtl8xxxu_legacy_ratetable[] = {
 	{.bitrate = 540, .hw_value = 0x0b,},
 };
 
-void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
+static void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
 {
 	if (rate <= DESC_RATE_54M)
 		return;
