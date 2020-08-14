Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ACA24491D
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgHNLnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbgHNLkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A3C061388
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:03 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so7215749wmi.2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gG0Q+CBV6XzXkxYgZy4yYbCI9O+7sDv4xpcBiJiFnN8=;
        b=XHuCB48hrXtTdiGZTFxB5RtS0CpIeu4tXXhCdwYRL152X5UX5mEtc3dR8P2tFlUV/j
         /cBC8T+oF80UTw3ioC4EsFWIZKiSgjSHDgmeipG3H/Ki8dP5RMKUXKobqkWI7skyOLs8
         RqhHxMe2VEITUmf6Pla02RAoKxLuGBkXmjgFC/INiR3yCPvWFcZKio+o2q2VnvHVvWRg
         FRQpBTvIzPEFUmVoqzNhmoPkCwmheXgB/zDICLB7hECVt2yvhe0xcitAQkNcMaOBAXis
         lwmlcMA5ZoZ0DIy4x05N4YTlVefIDDFqyhN5QnQ4eazVB3e1tfZKKe2sRaDLkxoDaIpu
         NAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gG0Q+CBV6XzXkxYgZy4yYbCI9O+7sDv4xpcBiJiFnN8=;
        b=SCI8VGcchLqG6nRzXZGU6HdhIhMiCvXDvwxlW7Tum5xBpQmHYLmewnlbxEjNRol1QR
         cWXnV5BByGLDyNZBNavshbh7UtteOYhqclfzp4BonV8OnyiVDFuiXsc3XdpLtLg1WCpr
         Y8dpnvcsnbGjXjzZzVFeh5+IgSHia3SiGi+YBipJ6d64oJcQSYMTI60mWURCC8WZSVAX
         wzxsgvO8neemD9YNgFGhkkr5iCEOAJCUn9pnjZcbQozHjlzxSsD1YgGHuXrcvQ6lBZUR
         T45WJg+TDl/x5qLRack97/12Z8eBmt45uXYmP5ABPjgKeaCqch4E5NQ+txlLPHHg7LEH
         VfCA==
X-Gm-Message-State: AOAM533NXofGjlvCtiAs5xloR3t63/GZilDtXEyI7JNNH+wWWamQitp6
        RKoHxxDiO85q0zogX1vT8xgiAg==
X-Google-Smtp-Source: ABdhPJylV7FjEHL4awdxmvDih66p+3WF1/+lPG47jF2qJp4rVPPFyUF/djeWznbOEDvSXTIVGL0epA==
X-Received: by 2002:a7b:cf0c:: with SMTP id l12mr2252326wmg.77.1597405202279;
        Fri, 14 Aug 2020 04:40:02 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH 13/30] net: wireless: ath: wil6210: cfg80211: Demote non-kerneldoc headers to standard comment blocks
Date:   Fri, 14 Aug 2020 12:39:16 +0100
Message-Id: <20200814113933.1903438-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No effort has been made to document any of the function parameters here.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/cfg80211.c:1749: warning: Function parameter or member 'ies' not described in '_wil_cfg80211_find_ie'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1749: warning: Function parameter or member 'ies_len' not described in '_wil_cfg80211_find_ie'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1749: warning: Function parameter or member 'ie' not described in '_wil_cfg80211_find_ie'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1749: warning: Function parameter or member 'ie_len' not described in '_wil_cfg80211_find_ie'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'ies1' not described in '_wil_cfg80211_merge_extra_ies'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'ies1_len' not described in '_wil_cfg80211_merge_extra_ies'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'ies2' not described in '_wil_cfg80211_merge_extra_ies'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'ies2_len' not described in '_wil_cfg80211_merge_extra_ies'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'merged_ies' not described in '_wil_cfg80211_merge_extra_ies'
 drivers/net/wireless/ath/wil6210/cfg80211.c:1780: warning: Function parameter or member 'merged_len' not described in '_wil_cfg80211_merge_extra_ies'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 0851d2bede891..1c42410d68e1a 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1739,7 +1739,7 @@ static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
 	return wil_p2p_cancel_listen(vif, cookie);
 }
 
-/**
+/*
  * find a specific IE in a list of IEs
  * return a pointer to the beginning of IE in the list
  * or NULL if not found
@@ -1766,7 +1766,7 @@ static const u8 *_wil_cfg80211_find_ie(const u8 *ies, u16 ies_len, const u8 *ie,
 				       ies_len);
 }
 
-/**
+/*
  * merge the IEs in two lists into a single list.
  * do not include IEs from the second list which exist in the first list.
  * add only vendor specific IEs from second list to keep
-- 
2.25.1

