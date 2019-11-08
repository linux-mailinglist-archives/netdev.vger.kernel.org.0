Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9C0F5BF9
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfKHXp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:29 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfKHXp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWdY7lnLsMxhJwbaPvg2pWOfFWECQvUYPWqAmVMyUfWVC9wRJSuFVg1gHFDA7WmDMFO247FJWizDMQomUf0ILaCLi+cGW/1jMDNCXgdy96s6V24FLN9Y8OPjlqjsde87BapN0wr7pNcPiEL0ZfnhBeUOFRBVcF7+yuQ3oMncVfpF7ug7xpiWophfU518UUNoYtjCRKhRUU9KycfxWHivk8q/irK4HMcJEsl2uG+fN2nma+2aSNawbKgIEaVpn/YvPbztnV/WeswcZ7a7SdeOYROvXna4n+qnrp9sJ1xqPFJoiihObWPELNV98wOkZVm/3h0wi02Dp3a0di461rkrBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnDQ9Dpxnldl42g7+QS74ZFvocXc9fG1wyPiCcxPUIo=;
 b=kWvXEdurNHyUvjnFJGUF7Q9ksTMtLCLp+qVIyR/hjFwkR4jiq+SZa9RG8dLXBUWUM5EgmNC19i95vCC65jrHh4PClFYuW1JWaEbRDJNT7eomgzqUV/mhPzJQnsVzvAVax6W1pDjxJo6RWcqvUuV05vO4f12j0a9HXt+dRCGK4c7aTlWmPe5sB4XCPEthcqQx4Gso8RQTaXJ13Zsf+6NPaKicovbC1/JvXyNp6KbXfGE5/p8hAsznEouhGCP6dYJYpLpjAB9tyxcK9ikxWq3wZdf1cCoxBABzuFyvehDXPcVyItuAKFODQo28fpY7Kf+uaF5G4t6szWIo+saiRps8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnDQ9Dpxnldl42g7+QS74ZFvocXc9fG1wyPiCcxPUIo=;
 b=URJBYmQtKNn5Hjmtz5jXp9U7H+4cIs/VYbLzuPX7DMQNs9Pp20t2zHbBQETqBGD3KVszUOEb8eyhpOOcR1wwo4KMKNUpn95Q3SihBpCqBRupFvs+Q0vsRTfP9evNHRjTxe8DbenT7cr/1ai3dt9pxLHaf0l5m0lliHel0B2Fhjc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Document flow_steering_mode devlink
 param
Thread-Topic: [PATCH mlx5-next 2/5] net/mlx5: Document flow_steering_mode
 devlink param
Thread-Index: AQHVlo6WSJIcdiJwUkSrCqoL1K1lIw==
Date:   Fri, 8 Nov 2019 23:45:22 +0000
Message-ID: <20191108234451.31660-3-saeedm@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b7a42b58-3e50-4796-4c39-08d764a5b847
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4334F906C2E63988B458384EBE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(107886003)(14454004)(4326008)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(446003)(8676002)(26005)(2906002)(76176011)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(11346002)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A71ZRuQMp/O2/Gkb1m/wJTiNpDL4wQ1ixEV7q9SM94GbyqRxhB3WFOg9pAKJJAIOjOWHhQ0UyJ1/PWY4ioRco1oUgEy0GAjfl/lrDpvi56oPx57P4WZzL/6t19Ikq8ifdLEgJ13bvoJf1myc4QWifzRgp0KWMm+pyt6efj5HmQY9HKhGCJNEbMASIJBXEHYrMGY6LoEbCfRC+EuulK0Umk3p7Wqj7QEyPiflJ9+ALn+1mr9guXTdqw6zZ7TdIImO4p2q7S7NkAf1OLixHEplo39F9IbG4vlWConQisIQDH3USqxwqCVU3BSJqnhP4t91zsULgJyUsoSErQ1cFn0daH9nJOi79Xvj6DZdCQtUeRy93wd4DS5ShQHTvw3FWEALvYCwyJiRZdb7S0Dph3PRmVjioMwjHrUP8bBdngNaTAUQm4mFbF2dKg+Cs/k6mVPf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a42b58-3e50-4796-4c39-08d764a5b847
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:22.3734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NiznduhP9kwGpO1S3PpGBtcnD346cEO8exm/IHdzCy0tMAislaTmpaCyaxHrg3FjuPPum/AMNhusuB1eZRSILQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Add documentation for current mlx5 supported devlink param.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/devlink-params-mlx5.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/networking/devlink-params-mlx5.txt

diff --git a/Documentation/networking/devlink-params-mlx5.txt b/Documentati=
on/networking/devlink-params-mlx5.txt
new file mode 100644
index 000000000000..8c0b82d655dc
--- /dev/null
+++ b/Documentation/networking/devlink-params-mlx5.txt
@@ -0,0 +1,12 @@
+flow_steering_mode	[DEVICE, DRIVER-SPECIFIC]
+			Controls the flow steering mode of the driver.
+			Two modes are supported:
+			1. 'dmfs' - Device managed flow steering.
+			2. 'smfs  - Software/Driver managed flow steering.
+			In DMFS mode, the HW steering entities are created and
+			managed through the Firmware.
+			In SMFS mode, the HW steering entities are created and
+			managed though by the driver directly into Hardware
+			without firmware intervention.
+			Type: String
+			Configuration mode: runtime
--=20
2.21.0

