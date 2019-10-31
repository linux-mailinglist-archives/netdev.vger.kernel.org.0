Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7EEB9A1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfJaWVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:21:00 -0400
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:14105
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387418AbfJaWVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:21:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCr2NY/x5PVbYJH3DF84jgLR6MfEelGOta8WbQn8dN78Wd790oiWIqBa9wrxsde395y5KFgXDR0d/uJGnov37NJN+hzh3+EJcMtYrh9cP86bl908cTB+7gNCt2xjNm6vWH9BCLGnlvAMXUCtLvBTVii5o9L3T161FrS8Cyk/5J/iYi4KeoTO+j1KPbJlNM+Nv/+D5t4XK873ux/+Y2XqdHnRoJcE5TdgTlZCZhVFX4IWiIy/w6LZrqFLjPEswfm/PEAcOSefopLeUg+WQm4w22F92KoNmu6w2dlrM3/Bp2ED8HsMudwKERdYddWxlQKtQ+Osu8oD2htiSt+ld6SP5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nspoXQyDI3oXKYDyzl+wGF3v9Kf7/I6El2ercbI85g=;
 b=l+PeKgE4m+0Sq1v0dBxCqXi6eln4dU6Vhtubp4SEpnGZ1o9tljKfxDr+TZWwOF/hUyPSsI+aHzKVs4G3o+WBzYKmNH5VBus+a61vXNj5fLW03ywPYLCUi8kINc07nMwva5EB5mLErvT7RHpCu2ZwWJsUUY8Rn+EtKWWCR2Gwrsa9oE+cuJxaDK+LftNBhCem3jEXWC8a8U9eb1rmbOgpyLNWRZWrpOs1PM8MJ+IGGOtlJo19ABKVpT9eOEdJTKMroL6/1czAgQb6I+Xl0o7iCX6W+V1NWAC4icg/+pxPlBcTLv6xPzLsfoZydzS2K47kkyAdTvisWeQJPK7Hk5PaOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nspoXQyDI3oXKYDyzl+wGF3v9Kf7/I6El2ercbI85g=;
 b=plTbR25S/sjM+1F5xOLgzkgvVk3vj7ePAtfqTIcq/Az8TD4mbYhbh2iYpWx8wY94U6Z6PgK2WYv+PBswwbDRopms1k6PUruXLSfIuGIqIU7MCS7+YpwAd2WPuta+MQpH/q2v1xq23Zy2EK3LO1yvw07q4WfFPAA94M+irdQu1kw=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3378.eurprd05.prod.outlook.com (10.171.191.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 31 Oct 2019 22:20:55 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.024; Thu, 31 Oct 2019
 22:20:55 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1M/EA///bpAA=
Date:   Thu, 31 Oct 2019 22:20:55 +0000
Message-ID: <74DE7158-E844-4CCD-9827-D0A5C59F8B32@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
 <20191031.133102.2235634960268789909.davem@davemloft.net>
In-Reply-To: <20191031.133102.2235634960268789909.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-originating-ip: [2604:2000:1342:488:5549:ddc9:9d51:983]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4246806b-8622-470d-63c1-08d75e509921
x-ms-traffictypediagnostic: AM4PR05MB3378:|AM4PR05MB3378:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB337857D5229F3DECC452A85ABA630@AM4PR05MB3378.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(199004)(189003)(36756003)(229853002)(316002)(305945005)(6512007)(54906003)(2906002)(8936002)(558084003)(6436002)(7736002)(102836004)(6486002)(6506007)(81166006)(81156014)(76176011)(8676002)(256004)(186003)(99286004)(478600001)(5660300002)(86362001)(33656002)(71200400001)(71190400001)(486006)(446003)(2616005)(11346002)(476003)(14454004)(46003)(6916009)(4326008)(66946007)(66446008)(64756008)(66476007)(6246003)(6116002)(25786009)(76116006)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3378;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZeEMXj0sustx7c3X0NFXMQYmrTUC7pwUSN2rpeHWBkAu/Z2JtZPbQFOHQTWpGbHLQMExeT09tJk75q1PCOiB5V3gAVTcSCdGVMrjH4gVsmvEzVabw+PnvOfmjIlb0bhm+GNaKB4fKRra+FA0cFu8hjv1JD4YQU5lTJyrB09MnwWjAMsWbSPCaQ2LiWzkEIABanxvviaqD+R7JCJNcQcqdZLsR9+a4UVY08Bns07Zd5YjLr8HaS0cKLPA317EviVIcD8HGn3CaC7EideaJvutzNK6/l8m9XoUVcckUT2efh6txWbtl2ZB3dcpS//TvO3G6smDLkS11Ljxs6Lq9VhHuGGlDhcALH2pjaCF6YVgOcqLpVdNfbUcjZ3AFUuauTEFSbSXyJ/ghb0tUtd7g2NE9NMVXDKdJVTe5WKzJWEqDeLz3dWftL5gveEVdwK7KuTn
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC053A5C88113A46B1A8D2013F848A40@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4246806b-8622-470d-63c1-08d75e509921
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 22:20:55.4911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3FmARGDx1yEkSGahGiG6K/DuAGjr1IiO0EeETOg/yjmmpi3h7l+XhawFB07cnSigVl3Hzio/HokllCUI15tVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzMxLzE5LCA0OjMxIFBNLCAiRGF2aWQgTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD4gd3JvdGU6DQoNCiAgICANCj4gICAgVGhlIHByZXZpb3VzIHBvc3RlZCB2ZXJzaW9u
IHdhcyBhbHNvIHYyLCB3aGF0IGFyZSB5b3UgZG9pbmc/DQoNCkkgcmVzdGFydGVkIHRoaXMgc2Vy
aWVzIHNpbmNlIG15IGZpcnN0IHN1Ym1pc3Npb24gaGFkIGEgbWlzdGFrZSBpbiB0aGUgc3ViamVj
dCBwcmVmaXguDQpUaGlzIGlzIHRoZSAybmQgdmVyc2lvbiBvZiB0aGF0IG5ldyBzdWJtaXNzaW9u
IHdoaWxlIHByZXZpb3VzIGhhcyBhIGRpZmZlcmVudCBzdWJqZWN0DQphbmQgY2FuIGJlIGlnbm9y
ZWQuICANCg0KDQogICAgDQoNCg==
