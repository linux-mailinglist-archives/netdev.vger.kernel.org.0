Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BDFEA3F0
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfJ3TRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:17:34 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:46756
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfJ3TRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:17:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+jDiciCUYGUyaD5317I04YMCmH1xS6+Ukv9O+pnb5TLcZFy0tKzqw9xoDj0NnIkWkxglvglUpVsMdlv5it6VFI2A5igx2MpUhmRPSvILRGFJ8mOjmI8C3DaxeIjxuY3WN/GyKDfBBvk28ajpPkeZ6gLL4I9RFH9wpdXa9FEPOMVD6laEirEhjCZUWaHuN90znhlfbWIFhCZAwp+9TIYPYV+ykxXLJ+JW7gDyB4j1wTMjckWgJ5cdtKHQs4gylJFdYet9Gu3eICDd0U+aWQj4Nv3a0IkLEj2WerIZ8TNnX2OeTJhpivNkJtwpmd8HA7VwVoWuvdnIAb50EfNJu4lsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liqKTM8XXtQ9B0VXwl44zDyOnL60mBUKomlX2v5yO0s=;
 b=cCTxgm9I0oCRjZVIKRO1/m4GqCf+JjrUTb9miGX0ys3xLTTWCVrIoMbY7JJNHuepvQhKxMxF1LeF93AqzfH9v9+hINoGeOSkjqKTm+9XGDaBzT/Kh6Av/3v9TtnGHLRbhb0zUnlo2H8arN8sOZdEeu0Sm/4pe+lm0mS+z5N35A9CrS9VgCT2kPhTx54fY3w0LGHmyaWltR0LZrZIjRoDnyabO8SwQQWd8VL19gF/pQmvsVOYDQ8wXsCe1NFHtFYY2jzQPvphQjKQxJWJKHuXnTDXjOluZYUjyDFB8cD5A7Au9BZy5UlBGb3pCh0H+Cq55t+h94kd6pJDXDX5nnjITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liqKTM8XXtQ9B0VXwl44zDyOnL60mBUKomlX2v5yO0s=;
 b=pYAVGQ9AuxcrqpNSZHbQ7VQ14JoHO9ePasbNdYCsMJTQ0Ra4PxRViMePmiTYfXXCo/OZtqkspUln0y8oEIJ22dyRickZNm035+mtaIaAUElfv2jkNVj21anVdL1NzBLaNwdGfMbuPJGa4jt25alpDjlIbTgV18m+28fw0vWSfOg=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 19:17:30 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:17:30 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH 0/3] VGT+ support
Thread-Topic: [PATCH 0/3] VGT+ support
Thread-Index: AQHVj1askbNLpUWQSEiQvaCsAevu2A==
Date:   Wed, 30 Oct 2019 19:17:30 +0000
Message-ID: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR02CA0072.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::49) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c8d34d1-ba80-45e3-a762-08d75d6dcf27
x-ms-traffictypediagnostic: AM4PR05MB3412:|AM4PR05MB3412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3412E4D6F5DE55E3002F6E35BA600@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(476003)(486006)(66946007)(66446008)(14444005)(66476007)(2616005)(6116002)(3846002)(2906002)(71190400001)(66556008)(71200400001)(5660300002)(4720700003)(64756008)(4744005)(256004)(8676002)(66066001)(86362001)(2501003)(81156014)(8936002)(478600001)(102836004)(6486002)(26005)(50226002)(6506007)(386003)(6436002)(52116002)(7736002)(5640700003)(186003)(1730700003)(81166006)(305945005)(25786009)(54906003)(6916009)(316002)(14454004)(4326008)(107886003)(99286004)(2351001)(6512007)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bl6AXAd9NvBUthbAvcdT/7lC/j5EU4g4x+g9SgJFK41bD3LytCdAgG6S2NrkzBfbSuyydwooyHCtvxtPcdJWVCMKoM+hl/7XUE85pCRW2B3rnexxnEVHn5XOQF/Ssk8D5vLOY0CfgZTuDjJjvIHCSUy1Md3LC06fK3UL40md4B48ZjkhS7NbkMLUm66rFcuZj9CtVs9SQ7wuy9QCxqoaJowtno64JX+Y/3T6Zky5OTOxZUnMePV/TvUe0Ch3wC2oiFlNF74FXwMp78CkTl1va428C/lQEsa1Uf7NGRlgwJzSHwrDoANYftA9r6s+Ikik1o2MRr3Cvp4/mcmb1A15/8wQcrnKFvDHtFa/QcigmsueHsiH8636lTcMLNzKrmB0/lEi/WYTVadiABZikjJGsOrikF1zrEXM+SCW4kYQOBbnii86nGalqLhBaYhIORsn
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8d34d1-ba80-45e3-a762-08d75d6dcf27
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:17:30.6804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NnkOwqRlMZWIEQ2ASyBwMdS71ORofs5cVqrARvjv/DuOUm63rnXnOYLrmQule641tk8c97yEqyzEuxJwWrinKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
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

Ariel Levkovich (3):
  ip: Allow query link with extended vf properties
  ip: Present the VF VLAN tagging mode
  ip: Add SR-IOV VF VGT+ support

 include/uapi/linux/if_link.h   | 34 ++++++++++++++++
 include/uapi/linux/rtnetlink.h |  1 +
 ip/ip_common.h                 |  2 +-
 ip/ipaddress.c                 | 89 ++++++++++++++++++++++++++++++++++++++=
+++-
 ip/iplink.c                    | 52 +++++++++++++++++++++++-
 man/man8/ip-link.8.in          | 30 +++++++++++++-
 6 files changed, 201 insertions(+), 7 deletions(-)

--=20
1.8.3.1

