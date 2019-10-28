Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D43DE7AFB
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391190AbfJ1VHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:07:22 -0400
Received: from mail-eopbgr750137.outbound.protection.outlook.com ([40.107.75.137]:55799
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730207AbfJ1VHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:07:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fubqZpJnaC8u5GQihyapZd/aXLRv3dEb8BL9o5zpcFFtZgQrSUlW0IicQCa1q0wktoIrA6beu7ElxqDyR2ceqdrorhQSUG7ZQQfiz19+5WbkGrtoiFXB9Rq7W+ImlfUZLkww0DdctbAPDsGJURxl6X4u1bBZsby67lnG1jOb1GDjSNkj+fMzgfNAcREMjGAav9H6o6+pZuaLneYXlcIX14YEETXUFOPrsrB5K0FJdQnoJjZ7grjeH5QtcoftECY2pafBOd0iyfEZzVU1LEY4JakuLW0rqEQmuD5P+hSWCRqyYAvhrtc+kzIP6+CGZkuf2uaFwwEi5xbUh8lTht7B7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXEKnuN40jJ5SBw+kVEj2OgD4rOSYa6KtHCy4GTVcp0=;
 b=MsH/aNLD6wsFdiQOg0ZtzVwP8gLPGPbK7eLxHJx9PM4ts4+T0DXiDuB3Ug53Yvu2SoM9mnQ2UqjczkXQ4mRmvC5uU33cvPM/Jf5NJdeh/9dDgziaHQQp0lspI5A9YuRQlp9275Sz7Us7KKwaqPdkhV6L8raKr0OcW0LxKPskZ0BH5U+TsM0wgCbDCiAvfZlO4a6qWKXIyzlr1qoCM+0ZMBDlSP8eUYtiEZXvV4ScnK8+2g3zeHqCUPV21GMjqgtSkCcVei/5WWuCQJP8iHZvwSwVCbUz7BkHBSYBlV8JVmUOwGaSAZ2eKxeK8acunTr0qY6UPXIEE/s7KLDZctz5Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXEKnuN40jJ5SBw+kVEj2OgD4rOSYa6KtHCy4GTVcp0=;
 b=KfLt3mCCdtZPX7zXPTxXGznGIz1TBdy+jkm/wTI1s4BY8RKAIoEahwdNqnUBelXEKCoyWiC6aY2Rz9ljBw+HgrCojkBGAlK2itE8lCfePiqDUDDR9d9Kl7GmZM7mIOoZunwpdQnatuIRrXbP+jqXHZfE/HaGuXc7WlnORsD7nks=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1404.namprd21.prod.outlook.com (20.180.22.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:07:11 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:07:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next, 4/4] hv_netvsc: Update document for XDP support
Thread-Topic: [PATCH net-next, 4/4] hv_netvsc: Update document for XDP support
Thread-Index: AQHVjdOqeF2skKD6Y0io1FAqZWRRAw==
Date:   Mon, 28 Oct 2019 21:07:11 +0000
Message-ID: <1572296801-4789-5-git-send-email-haiyangz@microsoft.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:102:1::44) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5df6643-1b7a-423a-8c18-08d75beacc99
x-ms-traffictypediagnostic: DM6PR21MB1404:|DM6PR21MB1404:|DM6PR21MB1404:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14049BFC29E7ADE4E00BE821AC660@DM6PR21MB1404.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(6512007)(446003)(36756003)(54906003)(50226002)(486006)(22452003)(2616005)(476003)(305945005)(14454004)(478600001)(2501003)(6392003)(66066001)(7846003)(66476007)(66446008)(64756008)(66556008)(66946007)(10290500003)(6436002)(386003)(10090500001)(102836004)(7736002)(99286004)(11346002)(76176011)(52116002)(5660300002)(186003)(26005)(6506007)(256004)(8936002)(81156014)(81166006)(6116002)(6486002)(3846002)(4326008)(8676002)(2201001)(316002)(110136005)(25786009)(2906002)(4720700003)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1404;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N2iu8QmvCapfjPeyHZjuDypd2A2cbxTl33hDk1j8ao+8ILwOJ+Fc2R6k4BdfcO78e8jF//lop4cZy87auDxGCJTpKZn/1fmNSLPRoHgmLU5Da8g4vRWKtj1/Mj0yMP3xCwcVLc1mIdsHG9QZDvKbqjGknOEataRn/XX5wO9QzYna8rEsiKT7LN0Dj4X93h1iMJv1hKDHEs6Blaxt2BZ/+9wVfa5Rt5QsOKJmZvx6mHbFm+GIgDi4uns7bsIMcMwmm6UZgm4mryky/XdvfnZ0U1IamvT8HyfjakdVsuOIW9q9vC4xJbHLu42oXshrqRhlpcBpCONoKoMtPJPcjojRl25f1QtFn68vyDS/VZZX2gPIKrfW2Ytyi3gdVJN6AVUObs0ohG7HFp8b16rhfZaY1KoMdFR4WWXR6+uWVCfomtJx0z8PHviqhvghED9FnO40
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5df6643-1b7a-423a-8c18-08d75beacc99
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:07:11.1213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMNWNELcFRmEOdzrLnQ8aJ1PWR/TcqXTh4no8W6DD5VLqb5BCr9e4fY8t8kLD991IRZAn7Fv7XtbDIlepQ/OOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the new section in the document regarding XDP support
by hv_netvsc driver.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 .../networking/device_drivers/microsoft/netvsc.txt         | 14 ++++++++++=
++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/networking/device_drivers/microsoft/netvsc.txt b=
/Documentation/networking/device_drivers/microsoft/netvsc.txt
index 3bfa635..69ccfca 100644
--- a/Documentation/networking/device_drivers/microsoft/netvsc.txt
+++ b/Documentation/networking/device_drivers/microsoft/netvsc.txt
@@ -82,3 +82,17 @@ Features
   contain one or more packets. The send buffer is an optimization, the dri=
ver
   will use slower method to handle very large packets or if the send buffe=
r
   area is exhausted.
+
+  XDP support
+  -----------
+  XDP (eXpress Data Path) is a feature that runs eBPF bytecode at the earl=
y
+  stage when packets arrive at a NIC card. The goal is to increase perform=
ance
+  for packet processing, reducing the overhead of SKB allocation and other
+  upper network layers.
+
+  hv_netvsc supports XDP in native mode, and transparently sets the XDP
+  program on the associated VF NIC as well.
+
+  XDP program cannot run with LRO (RSC) enabled, so you need to disable LR=
O
+  before running XDP:
+	ethtool -K eth0 lro off
--=20
1.8.3.1

