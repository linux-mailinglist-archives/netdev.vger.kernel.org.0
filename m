Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBEC278944
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgIYNRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:17:22 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:53084 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728171AbgIYNRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:17:22 -0400
IronPort-SDR: USMfB1R/kPsaPPtMKtrw6y4KpdXbRn9yttPoAEjW98AUBN5H/7t9qQLV9gnatcQMyQEfL8HqRI
 JisXZ7sgVHzp6zaIAm8o1ASnzPywfSEnnIxb/5pFqcz/hbaoeRbKBZ1Y9cp0Ve2b8LP0jG0P2P
 k1EgUT0YEkp0qZBaK/uP7g6HKcwM68ApyNsUpFCU9/k8E5Xw6PT+okmfR4JvW1PTc9ZPC+Px0g
 vT4pQ8TQFTiG26FdkC8s8mxdu1MFUk8TXHwR3gWY5P8X/GNoeT5iS0mBFiT7C51I5qDx+6axi4
 GK8=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AqocG0xK5Wts6YGvlj9mcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXKvv4rarrMEGX3/hxlliBBdydt6sbzbCO+P2xEUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCe/bL9oMhm6sQrdu8kSjIB/Nqs/1x?=
 =?us-ascii?q?zFr2dSde9L321oP1WTnxj95se04pFu9jlbtuwi+cBdT6j0Zrw0QrNEAjsoNW?=
 =?us-ascii?q?A1/9DrugLYTQST/HscU34ZnQRODgPY8Rz1RJbxsi/9tupgxCmXOND9QL4oVT?=
 =?us-ascii?q?i+6apgVRnlgzoFOTEk6mHaksx+grxGrhyvpBJxxIHbbo6OOfZifa7QZ88WSH?=
 =?us-ascii?q?BdUspNUSFKH4Oyb5EID+oEJetWr5PyqEAPrRSkAwmnGePhyiVWiXDrw6I6ye?=
 =?us-ascii?q?UhHh3F3Ac9GN8Ovm7bo877NKoJSuC1z6nJzTPdYPNKwzvy85bHfwknrPqRUr?=
 =?us-ascii?q?1+bdDfxlMzFwPZkFqQs4rlMiub2OkOt2WV7+ttWOKxh2Mpqw98vySjytowho?=
 =?us-ascii?q?TIiYwbxU3J+CtnzYsoJdC1SlB2b9G4HJVeuC+XM4t4TMM8T2xsvisx174IuY?=
 =?us-ascii?q?ajcSUO1Zgr3QPTZv+Zf4SS/x7uVeacLS1liH9kfr+0mgy8/lK6yuLmU8m5yF?=
 =?us-ascii?q?NKri1YndbSrn0NzBnT6tSfSvt640ehxS6D1wDN5eFAJkA5ja7bK5k9zbEqkp?=
 =?us-ascii?q?oTsUPDHjTqmEnsiK+WcVkr9fKs6+v6ZbXmo4WTN45yig3mM6QunNKwAfggPw?=
 =?us-ascii?q?UKQmSX4/mw2b798UHjXblHj/07nrPEvJ3bPcgbo7S2Aw5R0oYt8Ra/CDKm3c?=
 =?us-ascii?q?wWnXYdN11FdgmKj5PqO1DOJvD3E+u/j063nzh13/zGJKHuAo3RLnjfl7fsZa?=
 =?us-ascii?q?ty5FRCyAUtyNBS/I9bBasfIP3tX0/xsNvYDhElMwCuxeboFsl93JsEWW2TGq?=
 =?us-ascii?q?+ZLL/SsViQ6+IsPumDf5UatS3+K/c7/f7ui2E2mVsHcamux5sXZ2iyHu56LE?=
 =?us-ascii?q?WBfXrsntABHH8Pvgo9Uezlk0ONXiJNaHaxRK88/Sw7CJm4AovZWo+sgaSL3D?=
 =?us-ascii?q?2nEZ1OemBGFleMHG/ud4qaR/cDdTydItF6nzwaWriuVZUh2QuttADk0bpnKP?=
 =?us-ascii?q?Tb+ikCuZLkzth16PXZlQsu+jxsE8Sdz2aNQnlwnmMJQT82wa9+rVV+ylidy6?=
 =?us-ascii?q?h4heJXFdhI6vNXXQc1K4Tcw/Z5C9/sQALBeMmGSFK8TtWhGzExQco7w8USbE?=
 =?us-ascii?q?ZlB9WikhfD0jKkA7APjLOLCoc58rnf33nxIcZy1WrG2LM6gFY4EYNzMjiqj7?=
 =?us-ascii?q?By8iDfDpDElkGembrsc6kAmGbO6W2K5WmDpkdVVEh3S6qWc2oYYx74pN7470?=
 =?us-ascii?q?WKYaWjBbk9MwBCgZqMI6FEQsbqnFNLWLHpNYKNMCqKh26sCEPQlfu3Z43wdj?=
 =?us-ascii?q?BF0Q=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQGCLV+NPpJiiliHLAsBAQEBAQEBAQE1AQIEAQG?=
 =?us-ascii?q?ES4IxJTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoMmglg?=
 =?us-ascii?q?puHKEEIURgUKBNgIBAQEBiCuFGoFBP4ERg06EBIYwBLc9gnGDE4RpkkwPIoJ?=
 =?us-ascii?q?7nhUtkluiGIF6TSAYgyRQGQ2caEIwNwIGCgEBAwlXAT0Bi1mCRgEB?=
X-IPAS-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLV+NPpJiiliHLAsBAQEBAQEBAQE1AQIEAQGES4IxJTgTAgMBA?=
 =?us-ascii?q?QEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoMmglgpuHKEEIURgUKBN?=
 =?us-ascii?q?gIBAQEBiCuFGoFBP4ERg06EBIYwBLc9gnGDE4RpkkwPIoJ7nhUtkluiGIF6T?=
 =?us-ascii?q?SAYgyRQGQ2caEIwNwIGCgEBAwlXAT0Bi1mCRgEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:17:20 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 4/5 net-next] vxlan: check rtnl_configure_link return code correctly
Date:   Fri, 25 Sep 2020 15:16:59 +0200
Message-Id: <20200925131659.56615-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

