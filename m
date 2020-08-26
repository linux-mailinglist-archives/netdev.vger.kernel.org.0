Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA8252A35
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgHZJgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgHZJfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405CAC061366
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:42 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o4so1107963wrn.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmeKWj6ihDtxXg7mmV0g02PkzMbJUwVy4vUADq1jq3Y=;
        b=lHkQ9kbI4YiHrMG+5c1O2DA0EUdgjZyvLmV+8YExFcXi1gdFNdZna7wI1C7eYgwRYz
         9Xk1+KxSEYrXF/zIdSTSg24AIl/kZzSC8uzCISjmVpPb5WPvkYGGet2Msnt5AYRohb/9
         tdTLogHLdCjhAebO1xjCBX6weShNPfIwXefOeUNOsk4XydWW3Dg3BLWF1dKUkFyUxjFH
         89+MNPaKS6ACrOuzatrjQoAYZCgN2RoMGXmYGEZ8aYPqTCfAjVCfkJdUGw7QdeinfKnR
         fQiS/5nY5m8XV04zepMGobk9n7MVwie/ajSLslD2eTM/u2MZs63wJfpm38MbNLDGKajP
         esjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmeKWj6ihDtxXg7mmV0g02PkzMbJUwVy4vUADq1jq3Y=;
        b=dPqHppyu7eGl7YaYFJkunX0Gy9NApNEUOqZFHFjCKxEfZyITPW5hnZrP2y9S3WEP6C
         THjTYay37CNlzxgHFE07jye/RdFIyywwU4LqfXuMS+kwEVG51XBfRtmEzAjRzAwnwkJ0
         C+iWUuxkYmWbntPUQT7A+qefrBaQL+b9ZyVu74zcylf2/MPkXnU9d0pntR4retH0dabF
         0puKJj/OmyRXR4+ot5NU9OqnHosrm02T64cvoVgdh5ch0eGtRfoVr9z+CmxhGiiHP5uB
         icGAtCIPBdbWziZx30Xj8Y7mxeSGL7V0MvD/tD2x5vXZaWgNEMYbXvyOy93qYdIXBbOy
         cDEQ==
X-Gm-Message-State: AOAM530UGMH9ogA1t0So2TSa13zn2qt3Z0lpwEv3hGl37+PO9s2wnQ2P
        PGiuQmYO9U7ZDeI9Ltr5QF6Ttw==
X-Google-Smtp-Source: ABdhPJysAlZ5GN6k56EGB8IkpZjoW4o5OuDOadTyLk2UwIoJAbWs4p5DNd4oDWJVopFCUT4nSOwAVg==
X-Received: by 2002:adf:ff90:: with SMTP id j16mr477311wrr.105.1598434480972;
        Wed, 26 Aug 2020 02:34:40 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 29/30] wireless: broadcom: brcm80211: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_info_rev1'
Date:   Wed, 26 Aug 2020 10:34:00 +0100
Message-Id: <20200826093401.1458456-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:1510:33: warning: ‘dot11lcnphytbl_rx_gain_info_rev1’ defined but not used [-Wunused-const-variable=]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c    | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
index be703be34616a..7526aa441de11 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1507,19 +1507,6 @@ const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[] = {
 	,
 };
 
-static const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[] = {
-	{&dot11lcn_gain_tbl_rev1,
-	 ARRAY_SIZE(dot11lcn_gain_tbl_rev1), 18,
-	 0, 32}
-	,
-	{&dot11lcn_aux_gain_idx_tbl_rev0,
-	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_rev0), 14, 0, 16}
-	,
-	{&dot11lcn_gain_idx_tbl_rev0,
-	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_rev0), 13, 0, 32}
-	,
-};
-
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_2G_rev2[] = {
 	{&dot11lcn_gain_tbl_2G,
 	 ARRAY_SIZE(dot11lcn_gain_tbl_2G), 18, 0,
-- 
2.25.1

