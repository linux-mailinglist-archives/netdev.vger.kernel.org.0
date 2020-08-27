Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC06253E2A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgH0Guk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:50:40 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45576 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0Guk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:50:40 -0400
IronPort-SDR: GRLZ7WcFO6WVt6F6tdr/XT/maDaktNshkCXAQttBEndOQMdR+6zw7vGAjgtLKHV1SLTCfuOVv4
 9y/XC+5kbFOdmFIs9Ec2IL0k6F+PmTsWvJ7c6pVeY1Kdvtcp8Wm8mMV8s8tQkRNJa+JHdk2MDl
 L6AAleUCBlg2mhawADrbcgHCxYJEw+WbIibH2yDq/tSZW8q1tv5xym0Jbjufwlugv2aCHIws20
 bOlmG0TsCZ1fCU7NRP5rYqOl51BA2C3/zxES3gNNQCKg+WHiRql3tAKLiHaZLcAjm3v2MK2HAO
 fXQ=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AmxkVPxNXUp7UKYv6aqgl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0K/z4psbcNUDSrc9gkEXOFd2Cra4d1ayP6furADRcqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba5zIRmssAndqMcbjYR/JqotxR?=
 =?us-ascii?q?bCv2dFdflRyW50P1yYggzy5t23/J5t8iRQv+wu+stdWqjkfKo2UKJVAi0+P2?=
 =?us-ascii?q?86+MPkux/DTRCS5nQHSWUZjgBIAwne4x7kWJr6rzb3ufB82CmeOs32UKw0VD?=
 =?us-ascii?q?G/5KplVBPklCEKPCM//WrKiMJ/kbhbrQqhqRJh3oDaboKbOv1xca3SZt4WWW?=
 =?us-ascii?q?lMU9xNWyFbHo+wc40CBPcBM+ZCqIn9okMDoxukCga3BePg0DlIjWL2060gze?=
 =?us-ascii?q?suDB/J3BYhH90Ss3TfsdL4NKkIXu+uwqnF1i7Db/BW2Df79ofIbgotruqSUr?=
 =?us-ascii?q?9pd8fa1EYgGR/fgFqKtYzlIy2a1v4Ls2WD4eRtVuaihW4mpgxxvDSiyMcih5?=
 =?us-ascii?q?TVio4I1lzJ9Cp3zokoKNC2VkN2fN6pHZlOui+VK4d4TMwsTmVotig61LELvZ?=
 =?us-ascii?q?i2dzUJxpQ/3xPSb+GLf5KV7h/gSuqdOyp0iXNldb6lmhq/8E6twfDmWMauyl?=
 =?us-ascii?q?ZFtC9Fn8HJtnAKyhPc9NCKSuB4/ke9wTaP0B3T6v1cLUA0i6XbL5khz6Y0lp?=
 =?us-ascii?q?oUrUvMBCv2mEXxjK+NakUo4Oyo6+P7bbr8op+TKoh0igTkPaQvnMyzGeU4Mg?=
 =?us-ascii?q?4QUGiH4emx0KDv8VfkTLhJkPE6iLTVvZHaKMgBu6K0AhdZ0oM55Ba+Czem3s?=
 =?us-ascii?q?4YnX4CLF9ddhKIlZPmO1/VLfDjDve+g1Ksnyl3x/zcJbLuHI3BLmLfn7f5Yb?=
 =?us-ascii?q?Z990lcxRIuwt9F+ZJbFLQBLenuVUDrqtzXEBo5Mwizw+bpFNVxzIUeVnyTAq?=
 =?us-ascii?q?WBKqPdrUeI5v4zI+mLfIIVuyv9JOM/6PP1jn82h0Udfa+30psTcny4Ge5mI0?=
 =?us-ascii?q?qBa3r2ntgBCXsKvhY5TOHyjl2NTyJTaGusUKIi/Tw7Fo2mApnZRoy3g7yOwj?=
 =?us-ascii?q?27HptIaWBCEFyMFm3od4qcUfcWdC2SOtNhkiADVbW5T48h1BeutBL1yrZ+Le?=
 =?us-ascii?q?rb5DcYtZT929hx/ODTix4y+iJuD8iH0GGCUXt0nmUWSD8yxqx/plZ9ylib26?=
 =?us-ascii?q?hin/NYDcBT5+9OUgoiO57T1fd1C97pVwLafdeISFCmTcu6AT0rVd0+3YxGX0?=
 =?us-ascii?q?EoF9y8gxXr0yO0DroRkLKXQpo57uaU3GX7Lu5+xmzA2a1niEMpEeVVMmjzqK?=
 =?us-ascii?q?d19gHVT6DTnkmUjaehduxI0ifH+k+YznuIsV0eWgMmAvaNZmwWekaD9Yex3U?=
 =?us-ascii?q?jFVbL7Ubk=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgBgD4Vkdf/xCltltfgRCBRYEcglB?=
 =?us-ascii?q?fjTiSS5ICCwEBAQEBAQEBATQBAgQBAYRMgjslOBMCAwEBAQMCBQEBBgEBAQE?=
 =?us-ascii?q?BAQUEAYYPRUMBDAGBZiKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTgBiCa?=
 =?us-ascii?q?FGYFBP4RfijQEj26KK5w5gm2DDIRckjYPIaBELZIeoV2Bek0gGIMkUBkNnGh?=
 =?us-ascii?q?CMDcCBgoBAQMJVwE9AYUginMBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DgBgD4Vkdf/xCltltfgRCBRYEcglBfjTiSS5ICCwEBA?=
 =?us-ascii?q?QEBAQEBATQBAgQBAYRMgjslOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRUMBD?=
 =?us-ascii?q?AGBZiKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTgBiCaFGYFBP4RfijQEj?=
 =?us-ascii?q?26KK5w5gm2DDIRckjYPIaBELZIeoV2Bek0gGIMkUBkNnGhCMDcCBgoBAQMJV?=
 =?us-ascii?q?wE9AYUginMBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:50:35 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/7 net-next] vxlan: add VXLAN_NL2FLAG macro
Date:   Thu, 27 Aug 2020 08:50:19 +0200
Message-Id: <20200827065019.5787-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace common flag assignment with a macro.
This could yet be simplified with changelink/supported but it would
remove clarity

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 113 +++++---------------------------------------
 include/net/vxlan.h |  10 ++++
 2 files changed, 23 insertions(+), 100 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 1e9ab1002281c..e9b561b9d23e1 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4034,14 +4034,7 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 	if (data[IFLA_VXLAN_TTL])
 		conf->ttl = nla_get_u8(data[IFLA_VXLAN_TTL]);
 
-	if (data[IFLA_VXLAN_TTL_INHERIT]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_TTL_INHERIT,
-				    VXLAN_F_TTL_INHERIT, changelink, false,
-				    extack);
-		if (err)
-			return err;
-
-	}
+	VXLAN_NL2FLAG(IFLA_VXLAN_TTL_INHERIT, VXLAN_F_TTL_INHERIT, changelink, false);
 
 	if (data[IFLA_VXLAN_LABEL])
 		conf->label = nla_get_be32(data[IFLA_VXLAN_LABEL]) &
@@ -4061,37 +4054,10 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 	if (data[IFLA_VXLAN_AGEING])
 		conf->age_interval = nla_get_u32(data[IFLA_VXLAN_AGEING]);
 
-	if (data[IFLA_VXLAN_PROXY]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_PROXY,
-				    VXLAN_F_PROXY, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_RSC]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_RSC,
-				    VXLAN_F_RSC, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_L2MISS]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_L2MISS,
-				    VXLAN_F_L2MISS, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_L3MISS]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_L3MISS,
-				    VXLAN_F_L3MISS, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
+	VXLAN_NL2FLAG(IFLA_VXLAN_PROXY, VXLAN_F_PROXY, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_RSC, VXLAN_F_RSC, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_L2MISS, VXLAN_F_L2MISS, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_L3MISS, VXLAN_F_L3MISS, changelink, false);
 
 	if (data[IFLA_VXLAN_LIMIT]) {
 		if (changelink) {
@@ -4102,13 +4068,7 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 		conf->addrmax = nla_get_u32(data[IFLA_VXLAN_LIMIT]);
 	}
 
-	if (data[IFLA_VXLAN_COLLECT_METADATA]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_COLLECT_METADATA,
-				    VXLAN_F_COLLECT_METADATA, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
+	VXLAN_NL2FLAG(IFLA_VXLAN_COLLECT_METADATA, VXLAN_F_COLLECT_METADATA, changelink, false);
 
 	if (data[IFLA_VXLAN_PORT_RANGE]) {
 		if (!changelink) {
@@ -4142,60 +4102,13 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
-	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
-				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
-				    false, extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_RX,
-				    VXLAN_F_UDP_ZERO_CSUM6_RX, changelink,
-				    false, extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_REMCSUM_TX]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_REMCSUM_TX,
-				    VXLAN_F_REMCSUM_TX, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_REMCSUM_RX]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_REMCSUM_RX,
-				    VXLAN_F_REMCSUM_RX, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_GBP]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_GBP,
-				    VXLAN_F_GBP, changelink, false, extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_GPE]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_GPE,
-				    VXLAN_F_GPE, changelink, false,
-				    extack);
-		if (err)
-			return err;
-	}
-
-	if (data[IFLA_VXLAN_REMCSUM_NOPARTIAL]) {
-		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_REMCSUM_NOPARTIAL,
-				    VXLAN_F_REMCSUM_NOPARTIAL, changelink,
-				    false, extack);
-		if (err)
-			return err;
-	}
+	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_TX, VXLAN_F_UDP_ZERO_CSUM6_TX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_UDP_ZERO_CSUM6_RX, VXLAN_F_UDP_ZERO_CSUM6_RX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_TX, IFLA_VXLAN_REMCSUM_TX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_RX, VXLAN_F_REMCSUM_RX, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_GBP, VXLAN_F_GBP, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_GPE, VXLAN_F_GPE, changelink, false);
+	VXLAN_NL2FLAG(IFLA_VXLAN_REMCSUM_NOPARTIAL, VXLAN_F_REMCSUM_NOPARTIAL, changelink, false);
 
 	if (tb[IFLA_MTU]) {
 		if (changelink) {
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 3a41627cbdfe5..8a56b7a0f75f9 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -290,6 +290,16 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
 					 VXLAN_F_COLLECT_METADATA)
 
+
+#define VXLAN_NL2FLAG(iflag, flag, changelink, changelink_supported) {   \
+	if (data[iflag]) {						 \
+		err = vxlan_nl2flag(conf, data, iflag, flag, changelink, \
+				    changelink_supported, extack);       \
+		if (err)						 \
+			return err;					 \
+	}								 \
+}
+
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
 
-- 
2.27.0

