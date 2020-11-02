Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF672A293D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgKBL0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgKBLY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A45C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:58 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x7so14162444wrl.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=efbZKXhAztTr+3vbDGqT9spp9eWuy2ZoYZmE2LB/QTg=;
        b=HJXTGyXMt19r1ikj2+zTbCPdaXfc23shxZu/1Ox1YkwM2RWLkvtyRguUmH9IicwOGN
         1OUih7cZ7KDkf6s94C4Slvq0K9T85t+WZeZ7HXjI/4fWE9OJETg9WnFp7svfmdB6fdWd
         cHg3uDTE+1JaRthad5XzyKorSGn8czDs4Vt+WHlfX+u6wiXzOxDQAYwp8dVMJtwpKbkV
         qmDaUdZp2sv+yylhVSe+7i8QpFkD/K6j/W6TdsIfaDxgPd9NCX7IF5EyXaMBJJvd2vfQ
         xxgmBlYon1+fDBknu7jMEgR4mnHluW3hiDK7EsfqE7PpA+65kMrzSkgtfrYRxGMgkO+m
         Lgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=efbZKXhAztTr+3vbDGqT9spp9eWuy2ZoYZmE2LB/QTg=;
        b=SRbXQnIQ0WloTPnmVeqrD2u25S5ZFUmUjfjrMYFuf/RWiaipnbbh/OnAL4X29dMwSP
         jqdOjJW8TIsgUHWelATS8O3L2To3EXt131RHmKycJSu+W62cR9C0g6CCQ3QkfoczM9zt
         NQtugyQOfC/vzQ4F5aBFwNDypUXl2A6vADJ5T456x50pPv4C1mQ3A63SuoJydpV1DQjK
         P95epv6/F8v3F//DCNbrEj36Kpbjb/Zw03AMhQs3BZ7rddGiaXRdYCb4wMQlvYyRgSEr
         yEz2j9Cn47581N6td/3LkjazGU5NXeopywR5zqPM/R3fu4NaUcH0qaBL/CDjOanKlyFi
         hHww==
X-Gm-Message-State: AOAM533chrQCae6ePS0RsaGsIvQLUez6eKzMijNYC/tsjp5jhtsKu7pE
        Q6d3bj9jJdtkxkWheRfYI9J+DA==
X-Google-Smtp-Source: ABdhPJzoHFkR/mFt/vl1mK/9qPAQpnXQw+3L1GCgw/NDoLHm4ShmEPmKR3zhhINrevs5J3q/jHyvUw==
X-Received: by 2002:adf:fc07:: with SMTP id i7mr14507764wrr.223.1604316297481;
        Mon, 02 Nov 2020 03:24:57 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 29/41] rtl8188ee: phy: Remove set but unused variable 'reg_ea4'
Date:   Mon,  2 Nov 2020 11:23:58 +0000
Message-Id: <20201102112410.1049272-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function ‘_rtl88e_phy_path_a_iqk’:
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1351:33: warning: variable ‘reg_ea4’ set but not used [-Wunused-but-set-variable]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 9be032e8ec95b..12d0b3a87af7c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -1348,7 +1348,7 @@ static bool _rtl88e_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
 
 static u8 _rtl88e_phy_path_a_iqk(struct ieee80211_hw *hw, bool config_pathb)
 {
-	u32 reg_eac, reg_e94, reg_e9c, reg_ea4;
+	u32 reg_eac, reg_e94, reg_e9c;
 	u8 result = 0x00;
 
 	rtl_set_bbreg(hw, 0xe30, MASKDWORD, 0x10008c1c);
@@ -1365,7 +1365,7 @@ static u8 _rtl88e_phy_path_a_iqk(struct ieee80211_hw *hw, bool config_pathb)
 	reg_eac = rtl_get_bbreg(hw, 0xeac, MASKDWORD);
 	reg_e94 = rtl_get_bbreg(hw, 0xe94, MASKDWORD);
 	reg_e9c = rtl_get_bbreg(hw, 0xe9c, MASKDWORD);
-	reg_ea4 = rtl_get_bbreg(hw, 0xea4, MASKDWORD);
+	rtl_get_bbreg(hw, 0xea4, MASKDWORD);
 
 	if (!(reg_eac & BIT(28)) &&
 	    (((reg_e94 & 0x03FF0000) >> 16) != 0x142) &&
-- 
2.25.1

