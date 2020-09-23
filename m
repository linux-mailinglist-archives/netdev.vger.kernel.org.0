Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9197A275A75
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgIWOkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:40:45 -0400
Received: from mickerik.phytec.de ([195.145.39.210]:60594 "EHLO
        mickerik.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgIWOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:40:45 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 10:40:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a1; c=relaxed/simple;
        q=dns/txt; i=@phytec.de; t=1600871142; x=1603463142;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eZrZq7b5jE9lfQbUpANiarfQVMj5BBuPkcCgqdnooCc=;
        b=LROs7Ibzmbx2FI5DRgLM0a9y9sL3wTQwp80WxeNPnHloX6Xe8ht0X0Byy9C3zqnx
        A7pRtVZFPkZMT7n1BVSVKYAzRKucTEQ7gB235IprvBOLQ/yaDmxHIJCcY79C/Kap
        zUtAN7BxathykxwLA+jFcO2npP2kj8q40OBQCyJiA3s=;
X-AuditID: c39127d2-269ff70000001c25-66-5f6b5ae69c10
Received: from idefix.phytec.de (Unknown_Domain [172.16.0.10])
        by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id 43.2E.07205.6EA5B6F5; Wed, 23 Sep 2020 16:25:42 +0200 (CEST)
Received: from lws-riedmueller.phytec.de ([172.16.23.108])
          by idefix.phytec.de (IBM Domino Release 9.0.1FP7)
          with ESMTP id 2020092316254234-484320 ;
          Wed, 23 Sep 2020 16:25:42 +0200 
From:   Stefan Riedmueller <s.riedmueller@phytec.de>
To:     Fugang Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Christian Hemp <c.hemp@phytec.de>,
        Stefan Riedmueller <s.riedmueller@phytec.de>
Subject: [PATCH] net: fec: Keep device numbering consistent with datasheet
Date:   Wed, 23 Sep 2020 16:25:28 +0200
Message-Id: <20200923142528.303730-1-s.riedmueller@phytec.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 23.09.2020 16:25:42,
        Serialize by Router on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 23.09.2020 16:25:42
X-TNEFEvaluated: 1
Content-Transfer-Encoding: quoted-printable
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsWyRoCBS/dZVHa8wbqD2hZzzrewWKx8fpfd
        4sK2PlaLTY+vsVpc3jWHzeLYAjEHNo8tK28yeWxa1cnmsXlJvcfGdzuYPD5vkgtgjeKySUnN
        ySxLLdK3S+DKuHluPVPBOa6KFfu2sTYwtnN2MXJySAiYSHRtXsXUxcjFISSwjVHi56Qv7BDO
        NUaJ+ScOsIJUsQkYSSyY1sgEYosIqErs/LcDzGYW+M0o8f4X2CRhAS+JR09/MYLYLEA190/P
        YgexeQVsJfZc+sAEsU1eYual71BxQYmTM5+wgCyTELjCKDFh1WVWiCIhidOLzzJDLNCWWLbw
        NfMERr5ZSHpmIUktYGRaxSiUm5mcnVqUma1XkFFZkpqsl5K6iREYjIcnql/awdg3x+MQIxMH
        4yFGCQ5mJRHeG2rZ8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5N/CWhAkJpCeWpGanphakFsFk
        mTg4pRoYc77e2dEnJfvz9eyJFi9Db8jPEVzk8bHh9pPJlW/8/WOUhaKFw2ad6LmmNqdV9cmp
        +ZX5NrfXa+yPX3qp39S1b8oK1aUVrkHedbWLNyTN7Hh14H/LYm+v4vKP24/M1J5dK3u1YgPj
        YYVX265+3LCkaVNJOYdw0vkP/9U7+24X1cdNXp0gn14lqcRSnJFoqMVcVJwIAPDFtXc0AgAA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Hemp <c.hemp@phytec.de>

Make use of device tree alias for device enumeration to keep the device
order consistent with the naming in the datasheet.

Otherwise for the i.MX 6UL/ULL the ENET1 interface is enumerated as eth1
and ENET2 as eth0.

Signed-off-by: Christian Hemp <c.hemp@phytec.de>
Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
---
 drivers/net/ethernet/freescale/fec=5Fmain.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec=5Fmain.c b/drivers/net/ethe=
rnet/freescale/fec=5Fmain.c
index fb37816a74db..97dd41bed70a 100644
--- a/drivers/net/ethernet/freescale/fec=5Fmain.c
+++ b/drivers/net/ethernet/freescale/fec=5Fmain.c
@@ -3504,6 +3504,7 @@ fec=5Fprobe(struct platform=5Fdevice *pdev)
 	char irq=5Fname[8];
 	int irq=5Fcnt;
 	struct fec=5Fdevinfo *dev=5Finfo;
+	int eth=5Fid;
=20
 	fec=5Fenet=5Fget=5Fqueue=5Fnum(pdev, &num=5Ftx=5Fqs, &num=5Frx=5Fqs);
=20
@@ -3691,6 +3692,10 @@ fec=5Fprobe(struct platform=5Fdevice *pdev)
=20
 	ndev->max=5Fmtu =3D PKT=5FMAXBUF=5FSIZE - ETH=5FHLEN - ETH=5FFCS=5FLEN;
=20
+	eth=5Fid =3D of=5Falias=5Fget=5Fid(pdev->dev.of=5Fnode, "ethernet");
+	if (eth=5Fid >=3D 0)
+		sprintf(ndev->name, "eth%d", eth=5Fid);
+
 	ret =3D register=5Fnetdev(ndev);
 	if (ret)
 		goto failed=5Fregister;
--=20
2.25.1

