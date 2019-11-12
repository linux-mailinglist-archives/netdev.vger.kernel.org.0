Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2D7F92F6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:48:02 -0500
Received: from mail-eopbgr1410113.outbound.protection.outlook.com ([40.107.141.113]:31567
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbfKLOsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:48:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqztMA3WIlXyYO28QtirP+s7FvFXVCNiYN4sCNLvinSHNREiMLoSTihgmGHH+aZQw9mqjYWOWp2pKIWtmMnZSTeRepsT1a3zuNnlDDDRm165Ax93yKwDDJ+S1mAhi05NmwBiWmhr00gJvbrZncMjCnbywQT1hElURVve58scm0qQIC90fRWY39TtK5Cl9YaAzqqL2K/75AXxM5Pqblsf9bsWaNCOnrKYsSMih7GGZp/tJ4n5UQw0sBEkSsn0QmFnBTz1AX4U87BfHAUQqjrqvDE393VArv2dV7vV5008h40ENGB87aGygnkkTZJH4p9tPcEiRO7QQmPCS8IF7wqrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQShU9anbtQWAI+RIMuhwOejf4XK2OMReCRU7MZWAXc=;
 b=YrPcajl1jdJv5d/xcTWFITI98/T5D3Txrd6z18hiJMqEvWzylr4o2wp0BIVH8qICO19lsyqmDbR3yyYgHpyPn3RJ9pvO6nemIywSfLqBQZt1/ypVm9hkrGk50D8DkTllR6EQPQPobb1LCBj0V33ZJpCKmB3cEw18+jqP7Rc0MpNhEMWMl8DwA6zfsdUV/ww3CY9NUM7veybkhbCxXdoFRCPfcLZl8QOYC71168h3ORozRZ8wd8kHVEQlWeM8XWMHyjVEI2kEJq9Amzr9Co7O758le6cFUVCo5JiIWMsPCPpzN6bbU/G/0M5RfApYTDzaEMtWlSlWjzcRWWHk8w6pKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQShU9anbtQWAI+RIMuhwOejf4XK2OMReCRU7MZWAXc=;
 b=D0ZP3l/hOPh9TKcu1ewU+VdtZcGOyJjkMHtwhcvldxQfUnTde2MtgJcTK+w4TrqQ10QLNuN7qs+D9KA8gMieU178oQajrZePLgJwfzBhe7uUq5q9FXM8q+SvjzXZCSH+cGfGGfi2drswx8xf4KWcaINjYGSRPkMGhU+37ETsOnc=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB1681.jpnprd01.prod.outlook.com (52.134.230.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 14:47:58 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::fcbd:8130:e86:e239]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::fcbd:8130:e86:e239%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 14:47:58 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ptp: ptp_clockmatrix: Fix build error
Thread-Topic: [PATCH net-next] ptp: ptp_clockmatrix: Fix build error
Thread-Index: AQHVmWZ7u9w+kLAzBki5N1dSdleCM6eHnX6A
Date:   Tue, 12 Nov 2019 14:47:58 +0000
Message-ID: <20191112144724.GA15686@renesas.com>
References: <20191112143514.10784-1-yuehaibing@huawei.com>
In-Reply-To: <20191112143514.10784-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::31) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6071d0a8-5207-4e86-8e97-08d7677f4f0c
x-ms-traffictypediagnostic: OSAPR01MB1681:
x-microsoft-antispam-prvs: <OSAPR01MB1681C57E0FC93E44537648A0D2770@OSAPR01MB1681.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(199004)(189003)(66066001)(2906002)(99286004)(446003)(2616005)(7736002)(33656002)(476003)(11346002)(256004)(6512007)(6436002)(6486002)(229853002)(54906003)(305945005)(14444005)(316002)(14454004)(6116002)(3846002)(486006)(86362001)(6916009)(71200400001)(71190400001)(1076003)(66446008)(6506007)(36756003)(386003)(5660300002)(186003)(81166006)(4326008)(66946007)(76176011)(26005)(4744005)(52116002)(81156014)(6246003)(102836004)(64756008)(8936002)(66556008)(25786009)(478600001)(66476007)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB1681;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zBUt2zVooJFoVrU958BAfbkbGEuLiEBAwNwVxC2h6f8wwVMilgBxn60Gj7QMrXAktWDc/jCI/OecVtru77usShUmfOBssxYsznx/mTfjzuXR4qBN91kzGHkm7yAeCiSSjdl3xotkNQo4OwkmIBjH22R5x4l17r4U683jEmP32q6kNRHfBSiWSfu7J8nOCYsYf8m0t+LDRtLnRG6y7MW+yLIsvJ0GcF2UYY0X80Jo5R38e9EJgGYPKEeVzN04SJPWouTD3ddU28C61jHHDU5zh1HymnU1f2v/bMtWzSvRQoQNac50lSo5FhFUvUACFygPZbF8y5rj54ZB2JHMrQLWgPE1CmrljdxxJ6t1vwV8qC6VUiggPY8hhP4f558glgqlKiL8rqJADKoDQoFK1vSYxoLUzYRvk1QmOckUhFS+HtAx4invQG/1CSh3/CjtJTa5
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F03E41A38BC45C448CD71AD45263B081@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6071d0a8-5207-4e86-8e97-08d7677f4f0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 14:47:58.3343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B+/WfzYKcNzVopxcDeJw2e8nxTnrA8FjP6MOn6Q14fY6HTFbPVuJkHRJehygoOOx5Kk6k+7Gxv6rWWWcARu9LHqjZ/oudkAbpha5vO4OvG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1681
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBOb3YgMTIsIDIwMTkgYXQgMDk6MzU6MTRBTSBFU1QsIFl1ZUhhaWJpbmcgd3JvdGU6
DQo+V2hlbiBkbyByYW5kYnVpbGRpbmcsIHdlIGdvdCB0aGlzIHdhcm5pbmc6DQo+DQo+V0FSTklO
RzogdW5tZXQgZGlyZWN0IGRlcGVuZGVuY2llcyBkZXRlY3RlZCBmb3IgUFRQXzE1ODhfQ0xPQ0sN
Cj4gIERlcGVuZHMgb24gW25dOiBORVQgWz15XSAmJiBQT1NJWF9USU1FUlMgWz1uXQ0KPiAgU2Vs
ZWN0ZWQgYnkgW3ldOg0KPiAgLSBQVFBfMTU4OF9DTE9DS19JRFRDTSBbPXldDQo+DQo+TWFrZSBQ
VFBfMTU4OF9DTE9DS19JRFRDTSBkZXBlbmRzIG9uIFBUUF8xNTg4X0NMT0NLIHRvIGZpeCB0aGlz
Lg0KPg0KPkZpeGVzOiAzYTZiYTdkYzc3OTkgKCJwdHA6IEFkZCBhIHB0cCBjbG9jayBkcml2ZXIg
Zm9yIElEVCBDbG9ja01hdHJpeC4iKQ0KPlNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhh
aWJpbmdAaHVhd2VpLmNvbT4NCj4tLS0NCj4gZHJpdmVycy9wdHAvS2NvbmZpZyB8IDIgKy0NCj4g
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+ZGlmZiAt
LWdpdCBhL2RyaXZlcnMvcHRwL0tjb25maWcgYi9kcml2ZXJzL3B0cC9LY29uZmlnDQo+aW5kZXgg
YzQ4YWQyMy4uYjQ1ZDJiOCAxMDA2NDQNCj4tLS0gYS9kcml2ZXJzL3B0cC9LY29uZmlnDQo+Kysr
IGIvZHJpdmVycy9wdHAvS2NvbmZpZw0KPkBAIC0xMjEsNyArMTIxLDcgQEAgY29uZmlnIFBUUF8x
NTg4X0NMT0NLX0tWTQ0KPiANCj4gY29uZmlnIFBUUF8xNTg4X0NMT0NLX0lEVENNDQo+IAl0cmlz
dGF0ZSAiSURUIENMT0NLTUFUUklYIGFzIFBUUCBjbG9jayINCj4tCXNlbGVjdCBQVFBfMTU4OF9D
TE9DSw0KPisJZGVwZW5kcyBvbiBQVFBfMTU4OF9DTE9DSw0KPiAJZGVmYXVsdCBuDQo+IAloZWxw
DQo+IAkgIFRoaXMgZHJpdmVyIGFkZHMgc3VwcG9ydCBmb3IgdXNpbmcgSURUIENMT0NLTUFUUklY
KFRNKSBhcyBhIFBUUA0KPi0tIA0KDQpPb3BzLiBUaGFuay15b3UgZm9yIHRoZSBmaXguDQoNClJl
dmlld2VkLWJ5OiBWaW5jZW50IENoZW5nICA8dmluY2VudC5jaGVuZy54aEByZW5lc2FzLmNvbT4N
Cg0K
