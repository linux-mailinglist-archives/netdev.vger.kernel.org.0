Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4051F253E23
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgH0Gtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:49:42 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45501 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0Gtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:49:41 -0400
IronPort-SDR: 4Cn4OioX1Z7w/w+lDi/ZP7H5zvJyt+kji+gaN6gulwgT48p5QhnoEvbuTbTRkPYBbF4fNe48rP
 6KIqou8kMDkO7y9pz7veqAOiTYaSYL6aSmvy33UuG0STVEZDGDvmdsVdfWrEzVetR8fLjfPzYz
 t5Q1BpUKQIhATn4bZ+jXJ4KL61MzzRxoikvGwhOheLKAOTHiaiiqBaDphHgkY3vCXDRTt6tYRW
 bFiiIeMQzZu83PP5va8JTs+hVG3a2dxpbVR/qkGeO9vEjv4qIxaG5gOgKe/8f6C9em6ZjBmSvQ
 HkA=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ARkQIIRNUB4IupYkiVmwl6mtUPXoX/o7sNwtQ0K?=
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
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CCBAD4Vkdf/xCltltfgRCBQ4EeglB?=
 =?us-ascii?q?fjTiSS5ICCwEBAQEBAQEBATQBAgQBAYRMgjslNwYOAgMBAQEDAgUBAQYBAQE?=
 =?us-ascii?q?BAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTiIJ4UZgUE?=
 =?us-ascii?q?/hF+EBIYwBLZSgm2DDIRckjYPIaBELZIeoVyBe00gGIMkUBkNnGhCMDcCBgo?=
 =?us-ascii?q?BAQMJVwE9AY1NgkYBAQ?=
X-IPAS-Result: =?us-ascii?q?A2CCBAD4Vkdf/xCltltfgRCBQ4EeglBfjTiSS5ICCwEBA?=
 =?us-ascii?q?QEBAQEBATQBAgQBAYRMgjslNwYOAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCN?=
 =?us-ascii?q?yKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTiIJ4UZgUE/hF+EBIYwBLZSg?=
 =?us-ascii?q?m2DDIRckjYPIaBELZIeoVyBe00gGIMkUBkNnGhCMDcCBgoBAQMJVwE9AY1Ng?=
 =?us-ascii?q?kYBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:49:40 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/7 net-next] vxlan: add unlikely to vxlan_remcsum check
Date:   Thu, 27 Aug 2020 08:49:23 +0200
Message-Id: <20200827064923.5632-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

small optimization around checking as it's being done in all
receptions

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 47c762f7f5b11..cc904f003f158 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1876,7 +1876,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	if (vs->flags & VXLAN_F_REMCSUM_RX)
-		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
+		if (unlikely(!vxlan_remcsum(&unparsed, skb, vs->flags)))
 			goto drop;
 
 	if (vxlan_collect_metadata(vs)) {
-- 
2.27.0

