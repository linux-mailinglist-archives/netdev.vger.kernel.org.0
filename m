Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB9D3004
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfJJSNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:13:16 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45455 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfJJSNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:13:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so9991021qtj.12;
        Thu, 10 Oct 2019 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4YuaVjNZBW7Xle4GkpYsL3EQzfJiIHnoXEplvcurnuk=;
        b=ST+ddI+x6rgtpZNYnqRQcR/oMIBRE/v+SqIanyrEXlvwgWCEpfv0dqqu3Dce7l6dgq
         cU83uPHT7jL621Un2VQAirPzqMMiIMVonLVnR3AYCemD50gKjJual7TrypDwqq/EpKSM
         LQquv6vklr7u2ndGvni2OdfNGDrv+3cKxbvjoOb3DnF3e5DHanMc0fmI+2BgxjScfxMh
         sAjoW/npnO3XTjMLs5/rG6/GmDq/82gAZ+V0p3rnRe7L4vhGAWePRcK7oB/QY4WRJcrx
         E1BzaNickYL+BqfR0elYMhmBIhae+PTw9gkvHquQtszy4z3ra0pNfD+9W4P7P46+7jsi
         2TMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4YuaVjNZBW7Xle4GkpYsL3EQzfJiIHnoXEplvcurnuk=;
        b=MvGYsWkhZFmWyQPIL/gZmN9K5wCyzKoYBYh6er94a9E8TfJCNiqjqA87mteDJiiL8n
         S44nWkx9LHcSlzm+Rf6bnNm5hAvKugpq71zy9JqaNDJSnr4L5UDCx7mRSxwE7PPZn3JD
         rRa82z1CblPKXyl2lZWjybkXO0DaKhVG6NBZrRUaFPfSOR2zWea/MdCsoHTUNwYi1Yak
         JVNgrFH4f5zbfbL2rSk8Kih7aWM78/HJLHBsjM1yXTgXWW0SY2TlOmzMU6VhxABO5kgj
         hNP4gQNGwnTVOydON54su4sDIsA2+j19nV5TGwHV9ZfNuY1yYV3VsXWInIYrdph9WsVg
         PJow==
X-Gm-Message-State: APjAAAU25EbZmCgd6WP+txU3Dno319+gcxleMHHYbkS2ySFL8UAOcNqD
        wfMb1URDEqCuvY+61Ujry0kHrl3isfg=
X-Google-Smtp-Source: APXvYqya6/phIGH5jk5o06ga9V+25MGJAMocK8jDHw9Yolt8c9bI2QN0suU+B0YMF4k4s40iy40ovg==
X-Received: by 2002:aed:3762:: with SMTP id i89mr11987302qtb.175.1570731194300;
        Thu, 10 Oct 2019 11:13:14 -0700 (PDT)
Received: from alpha-Inspiron-5480.lan ([170.84.225.105])
        by smtp.gmail.com with ESMTPSA id 60sm2967275qta.77.2019.10.10.11.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 11:13:13 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH 1/2] mac80211_hwsim: adding more 5GHz channels
Date:   Thu, 10 Oct 2019 15:13:06 -0300
Message-Id: <20191010181307.11821-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These new 5GHz channels enable the use of the IEEE 802.11p standard

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 28 +++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 45c73a6f0..c20103792 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -148,23 +148,25 @@ static const char *hwsim_alpha2s[] = {
 };
 
 static const struct ieee80211_regdomain hwsim_world_regdom_custom_01 = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
 		REG_RULE(2484-10, 2484+10, 40, 0, 20, 0),
 		REG_RULE(5150-10, 5240+10, 40, 0, 30, 0),
 		REG_RULE(5745-10, 5825+10, 40, 0, 30, 0),
+		REG_RULE(5855-10, 5925+10, 40, 0, 33, 0),
 	}
 };
 
 static const struct ieee80211_regdomain hwsim_world_regdom_custom_02 = {
-	.n_reg_rules = 2,
+	.n_reg_rules = 3,
 	.alpha2 =  "99",
 	.reg_rules = {
 		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
 		REG_RULE(5725-10, 5850+10, 40, 0, 30,
 			 NL80211_RRF_NO_IR),
+		REG_RULE(5855-10, 5925+10, 40, 0, 33, 0),
 	}
 };
 
@@ -354,6 +356,24 @@ static const struct ieee80211_channel hwsim_channels_5ghz[] = {
 	CHAN5G(5805), /* Channel 161 */
 	CHAN5G(5825), /* Channel 165 */
 	CHAN5G(5845), /* Channel 169 */
+
+	CHAN5G(5855), /* Channel 171 */
+	CHAN5G(5860), /* Channel 172 */
+	CHAN5G(5865), /* Channel 173 */
+	CHAN5G(5870), /* Channel 174 */
+
+	CHAN5G(5875), /* Channel 175 */
+	CHAN5G(5880), /* Channel 176 */
+	CHAN5G(5885), /* Channel 177 */
+	CHAN5G(5890), /* Channel 178 */
+	CHAN5G(5895), /* Channel 179 */
+	CHAN5G(5900), /* Channel 180 */
+	CHAN5G(5905), /* Channel 181 */
+
+	CHAN5G(5910), /* Channel 182 */
+	CHAN5G(5915), /* Channel 183 */
+	CHAN5G(5920), /* Channel 184 */
+	CHAN5G(5925), /* Channel 185 */
 };
 
 static const struct ieee80211_rate hwsim_rates[] = {
@@ -1604,6 +1624,8 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 }
 
 static const char * const hwsim_chanwidths[] = {
+	[NL80211_CHAN_WIDTH_5] = "ht5",
+	[NL80211_CHAN_WIDTH_10] = "ht10",
 	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
 	[NL80211_CHAN_WIDTH_20] = "ht20",
 	[NL80211_CHAN_WIDTH_40] = "ht40",
@@ -2847,6 +2869,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	} else {
 		data->if_combination.num_different_channels = 1;
 		data->if_combination.radar_detect_widths =
+					BIT(NL80211_CHAN_WIDTH_5) |
+					BIT(NL80211_CHAN_WIDTH_10) |
 					BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
 					BIT(NL80211_CHAN_WIDTH_40) |
-- 
2.17.1

