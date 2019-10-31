Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC46EB826
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfJaTzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:55:35 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:24827
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727044AbfJaTzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:55:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqbQZnbALjP4nrgjl5u1eDtNZR+IDLdIgoRsSeDoR7xSFeP0wl5H/lc0MZYCo9RgoQfqn8PU35ryVJ5dfkhCy1ECdvWiJdkcitvfhYiexGkWAEjxfdeQZq76rDTJlTqjGAqAWEoa+F3/CqpYVJ4PiIyjVllAqfdmKGIiVh0MOrk+3MEhEDc8AE+/PU0tmNJdGAk34XAa99K0X1kXGC6etrdYm/K6rU/+PcaHzSTu2UsiZmvvnj3Je4oATVgJJ2TunflJP13bUW97cBh1A+p8JViXXFwnef0Sn0hbStd/DQ4kSME6v7E/Cosr8xGDeI+MF3pvw1gYvMt233wV8Xp+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovgJJK/x+GuQhmNzs8QBQx1B3mtQ6GzxGi9vLGyvZ68=;
 b=IU66wGuZTNDfeKkbG3bBxJCJ9SpnOh2rrvrQXKFebKSWlorEDcam7uYXDHjDS2s5V5CSpIlYMiDjlYPXbZYXviiiDEvmzEsLOcEraDJGNeEsuD6HcnMAxqf9MGOMyIZKb8mSGIKyQLsITOlUAghYVotvcLbyAHmUcd9iQQt7wcgvB3+DWh1LBiSkj/ZNgDAyIvJUWjqYpjkYHeZpaGyoUvuxEPVrtPUVGztu1sO/pHX9DhjTVhJZrAz+zJnqge0TtTspyVwfu3FLxnGKwk+rzhiMzjnjwvpGwN9u8ZVXdQp8glhoC0w55MDbvDgDI1z/9h91m0QvCNO28x6qvjUAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovgJJK/x+GuQhmNzs8QBQx1B3mtQ6GzxGi9vLGyvZ68=;
 b=O5X5uzLdw1NohDnOw3nf0Eh2ssd+OaG6LCfJ8jnVo7kmEiiURLMGVRi2EJLnKgP9uVnBQIOqg1ARr3u/q89UTblf2Vb5X5qgSCis6/9sxa2OEXbI23YrXjUm/igcZxGwoG92leCsnrqRSio1prF0FxtIUGWZ8Jh/sMJJQxpq7t4=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:55:31 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:55:31 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH iproute2-next v2 0/3] VGT+ support
Thread-Topic: [PATCH iproute2-next v2 0/3] VGT+ support
Thread-Index: AQHVkCUmT6HVcElqckmxVbQMRpkZbw==
Date:   Thu, 31 Oct 2019 19:55:31 +0000
Message-ID: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7e5e8e43-5e1c-4fff-596c-08d75e3c48ed
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB3324C608D5E842FCF8CEAF6EBA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(71190400001)(305945005)(186003)(66556008)(6512007)(7736002)(66476007)(66446008)(66946007)(3846002)(52116002)(14454004)(6486002)(6116002)(64756008)(316002)(4720700003)(26005)(5640700003)(71200400001)(2906002)(54906003)(256004)(14444005)(66066001)(6436002)(6506007)(86362001)(2501003)(4744005)(99286004)(486006)(5660300002)(8936002)(107886003)(386003)(1730700003)(36756003)(476003)(8676002)(2616005)(2351001)(81156014)(81166006)(478600001)(50226002)(6916009)(102836004)(25786009)(4326008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/yr8oFZzGl7TEYGO8xi46L19+2+7jdB/LkLcdV9C/pw05RaBnlxyi+iA+2QVTLWJT/8UPVv1gNN33P5SUPNahKpvn5wlv0l3YdzcdfI4jdcYh41ESpDTJ61qsRJI5fZ1/RfrDTsmAB4FBCJWh3DIpEXj0jP12oTHrImtW2dyMralOaqAHiDQdhquYALKwkMoY+VtmkmgCM3jQXCS6dgNta24TxeYc1O3n+HLsIekn1/Dg9D+pA/SvVPrnc5He+bCj0wTrJiLH+5BfptiDfusmD4jJNEX74Jbn88ylAzEzht2NePwVY0JtPM1+eMicbqAinCgSFigh86q+ZHONcSeJdMp9ivddhATCk7uVSl3JcvUh0hWfzO8yRjDyTcNBF2YcBL3qENp47PNEU76CgjGJzpanCyl9741XPFI6NFHAMvZI6djAr6qKkds2VafylB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5e8e43-5e1c-4fff-596c-08d75e3c48ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:55:31.4145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIC+Pnwu77RYB0S644dmG5GSKQv8L2OF2xr++4g6l4yQw514IhlB5mUVE0lqRPr0NVca3XhrDilg94uFjBwgSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series introduces VGT+ support for SRIOV vf
devices.

VGT+ is an extention of the VGT (Virtual Guest Tagging)
where the guest is in charge of vlan tagging the packets
only with VGT+ the admin can limit the allowed vlan ids
the guest can use to a specific vlan trunk list.

The patches provide the API for admin users to set and
query these vlan trunk lists on the vfs using ip link
command.

changes from v1 to v2:
- Use a string array to translate vlan mode enum to string

Ariel Levkovich (3):
  ip: Allow query link with extended vf properties
  ip: Present the VF VLAN tagging mode
  ip: Add SR-IOV VF VGT+ support

 include/uapi/linux/if_link.h   | 34 +++++++++++++++++
 include/uapi/linux/rtnetlink.h |  1 +
 ip/ip_common.h                 |  2 +-
 ip/ipaddress.c                 | 86 ++++++++++++++++++++++++++++++++++++++=
+++-
 ip/iplink.c                    | 52 ++++++++++++++++++++++++-
 man/man8/ip-link.8.in          | 30 ++++++++++++++-
 6 files changed, 198 insertions(+), 7 deletions(-)

--=20
1.8.3.1

