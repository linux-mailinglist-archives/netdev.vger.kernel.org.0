Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC1253E27
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgH0GuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:50:19 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45553 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0GuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:50:18 -0400
IronPort-SDR: 5SjhM9jq+1JRj0Our1dMKcL24jpI1/OXw7rlQ/6g6ZCXZXzJV3mB1eD8hKWitGz30rJ4ViYCm+
 G540Vr/MuDSwRBBoLPmHiAbUq5SxYhSSsoplVD3PhVKesePh5rWHIoAf2mtYzjFY/NnIqrsUHp
 yuu/gmtmOv6G7EPkWjZ/SI80IJSkifBO/cA4xsRXcfhUljxcsvPQX691lo4e7xHENgvkOoYc9W
 JplH2z+Ud3VHLRw9gpqNBXx0ETexXseOwKfzfro/OTffuvMvLWhfsSbYeiqXzQLuIWvbDDU/2T
 iRU=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AbPsOnROZfSOiopfUEG4l6mtUPXoX/o7sNwtQ0K?=
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
 =?us-ascii?q?fjTiSS4pWhywLAQEBAQEBAQEBNAECBAEBhEyCOyU3Bg4CAwEBAQMCBQEBBgE?=
 =?us-ascii?q?BAQEBAQUEAYYPRYI3IoNSASMjgT8SgyaCWCmzTYQQgUODRYFCgTiIJ4UZgUE?=
 =?us-ascii?q?/gRGDToQEhjAEtlKCbYMMhFySNg8hgnWdTy2SHqFcgXtNIBiDJFAZDZxoQjA?=
 =?us-ascii?q?3AgYKAQEDCVcBPQGNTYJGAQE?=
X-IPAS-Result: =?us-ascii?q?A2CCBAD4Vkdf/xCltltfgRCBQ4EeglBfjTiSS4pWhywLA?=
 =?us-ascii?q?QEBAQEBAQEBNAECBAEBhEyCOyU3Bg4CAwEBAQMCBQEBBgEBAQEBAQUEAYYPR?=
 =?us-ascii?q?YI3IoNSASMjgT8SgyaCWCmzTYQQgUODRYFCgTiIJ4UZgUE/gRGDToQEhjAEt?=
 =?us-ascii?q?lKCbYMMhFySNg8hgnWdTy2SHqFcgXtNIBiDJFAZDZxoQjA3AgYKAQEDCVcBP?=
 =?us-ascii?q?QGNTYJGAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:50:17 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/7 net-next] vxlan: check rtnl_configure_link return code correctly
Date:   Thu, 27 Aug 2020 08:50:01 +0200
Message-Id: <20200827065001.5734-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_configure_link is always checked if < 0 for error code.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 14f903d09c010..1e9ab1002281c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3890,7 +3890,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	}
 
 	err = rtnl_configure_link(dev, NULL);
-	if (err)
+	if (err < 0)
 		goto unlink;
 
 	if (f) {
-- 
2.27.0

