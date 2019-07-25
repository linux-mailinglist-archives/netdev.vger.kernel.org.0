Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177FB748F4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 10:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389363AbfGYITR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 04:19:17 -0400
Received: from mail-eopbgr140132.outbound.protection.outlook.com ([40.107.14.132]:39827
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389223AbfGYITQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 04:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWjJYBDHxYMJK8trZowIRzSwHodWtNaQozUdzfUNYqw7vbg5Aibpg5O+6ugn06U5/GrsFmbtK5cgPenMC8SJ+jCt/PKUXj23jeg6jMMfTk5lJCZPfr4VLRw0MEnMMIAbcel9JMXYpDFE5hJZtM4icIDyW+8D4p/F8jyYBOt1NkvBl0fzHzH5IDwCiYzkSdOmjJ/adV2L9BIJ3W7G03P2kN+qC4K0nLyB4BnDpNxdAesPvDH893gLgWJ8meZlfKGVR0D48Nn29aSoBXpe9qztsewOK2C/otuNjY4prspU7s9NqNdhr1pTU9tjMBcn4mSpaFZD8SFqWycOTLM52JmjVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgF3eywbmuGujfd9msz6S6I0c+4b1HhocVb98olbTOY=;
 b=IAexA7KEgRhYBWKp1uXjDrbBaOfETRo7bMQEJ7J+FQyPwb9ywACNU6e1d75fHN36tB8Svf2ZDsV5MnCFXQ4KmT7bfcWSAEtl3OzXHOWSEP4hCzhaffWTS2p9ziQoVOot32+swyOaWdmKpZmld4kogZ7Ljc7FqW64N+FW+6z+IC1D1W8AqCDcQTZ1oLaVRpbjjHSZa40FZbgIiV/b8eFcNtgLaPrBY3D/MC03niOVK+GU2/11NYq/j08CzkTxLEOdmV1VJPXERj5HXX+jOlUtzY4wpVhOc40pb2171i7GrjLKT28h6P3IsuI31vIsm9VyA2xhZ9enI8D/JnFDutXvWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=victronenergy.com;dmarc=pass action=none
 header.from=victronenergy.com;dkim=pass header.d=victronenergy.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgF3eywbmuGujfd9msz6S6I0c+4b1HhocVb98olbTOY=;
 b=sy/rt4iYdx/1ZPHtDkbeRPkf/A6pqYIaVEj6gJKI9ekWKLzMagKVoQkAb1Eya0qU0ZZmQQb0E4UXp3OZiakYXtbcnl/ThztwSlU44ZyJcp3CFQcMT//XSiSLpE1hLEw+cWh/G6XTO+zkNs2NYu3uSgBIfRr4SLnXoE3lyqfiPDI=
Received: from VI1PR0702MB3661.eurprd07.prod.outlook.com (52.134.1.159) by
 VI1PR0702MB3792.eurprd07.prod.outlook.com (52.134.2.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.11; Thu, 25 Jul 2019 08:19:10 +0000
Received: from VI1PR0702MB3661.eurprd07.prod.outlook.com
 ([fe80::b168:9c5f:9e05:92c6]) by VI1PR0702MB3661.eurprd07.prod.outlook.com
 ([fe80::b168:9c5f:9e05:92c6%5]) with mapi id 15.20.2094.009; Thu, 25 Jul 2019
 08:19:10 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] can: ti_hecc: remove set but not used variable
 'mbx_mask'
Thread-Topic: [PATCH net-next] can: ti_hecc: remove set but not used variable
 'mbx_mask'
Thread-Index: AQHVQrX3K4tXCwVUyEaAVWeXlYfwBaba/dYA
Date:   Thu, 25 Jul 2019 08:19:10 +0000
Message-ID: <acefc74c-b303-64b8-4a98-6d15835f1666@victronenergy.com>
References: <20190725070044.2692-1-yuehaibing@huawei.com>
In-Reply-To: <20190725070044.2692-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [213.126.8.10]
x-clientproxiedby: AM3PR07CA0128.eurprd07.prod.outlook.com
 (2603:10a6:207:8::14) To VI1PR0702MB3661.eurprd07.prod.outlook.com
 (2603:10a6:803:3::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91743625-6566-4166-955c-08d710d8c547
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0702MB3792;
x-ms-traffictypediagnostic: VI1PR0702MB3792:
x-microsoft-antispam-prvs: <VI1PR0702MB3792DA5ABD87D775DA71A116C0C10@VI1PR0702MB3792.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(346002)(396003)(376002)(366004)(136003)(199004)(189003)(305945005)(25786009)(64126003)(36756003)(6512007)(99286004)(53936002)(86362001)(66066001)(65956001)(65806001)(256004)(14444005)(6436002)(68736007)(76176011)(31696002)(52116002)(229853002)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(6486002)(4326008)(6116002)(31686004)(6246003)(81156014)(81166006)(8936002)(5660300002)(486006)(478600001)(54906003)(14454004)(186003)(7736002)(110136005)(386003)(3846002)(446003)(6506007)(65826007)(102836004)(53546011)(11346002)(26005)(2906002)(2616005)(476003)(316002)(58126008)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0702MB3792;H:VI1PR0702MB3661.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mGeXNmqZpDTG+f8LokglsXtV7YhkEASUErvjTxISawGGu+bPBW5lX6eVZvOQJzMeR4er7g+rYVbbrA60BoUM/8GWRZsCuiPJRReu4JpNhHkvpoEn2JS685ozLie/rI0KAnoCov3LsTxsZi7b19RAKUxa8pTwdWySM/0HQ2mFeZ9bbT8gKbrjTWmiOOsnPtu4lbwb900GgNf9wHYrvLigbfR32PvZ1OD3Zd3gxXMgUVzprNdiSZbKaNQbKHk+FjVaQX1IsWBXLZLoZNl7pJW2tJTlBNGSa5j4uA1iNhBVgKh8+VSe58eYaCAmTQKzibMPZIMM+0bK7Z8BRLFgkOqy+jef9KsFbCfHsud+6HN/CPIqmGhc3RbQTOMES2SN6KyQAmTW+nmYhz0K3IEZuFnXShmz2dM26w6Yantddq4hCpo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14AF8ADE908F64449B95A2151128E550@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91743625-6566-4166-955c-08d710d8c547
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 08:19:10.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHofstee@victronenergy.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0702MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzI1LzE5IDk6MDAgQU0sIFl1ZUhhaWJpbmcgd3JvdGU6DQo+IEZpeGVzIGdjYyAnLVd1
bnVzZWQtYnV0LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4NCj4gZHJpdmVycy9uZXQvY2FuL3Rp
X2hlY2MuYzogSW4gZnVuY3Rpb24gJ3RpX2hlY2NfbWFpbGJveF9yZWFkJzoNCj4gZHJpdmVycy9u
ZXQvY2FuL3RpX2hlY2MuYzo1MzM6MTI6IHdhcm5pbmc6DQo+ICAgdmFyaWFibGUgJ21ieF9tYXNr
JyBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPg0KPiBJdCBp
cyBuZXZlciB1c2VkIHNvIGNhbiBiZSByZW1vdmVkLg0KPg0KPiBSZXBvcnRlZC1ieTogSHVsayBS
b2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1
ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvY2FuL3RpX2hlY2Mu
YyB8IDMgKy0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9u
cygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL3RpX2hlY2MuYyBiL2RyaXZl
cnMvbmV0L2Nhbi90aV9oZWNjLmMNCj4gaW5kZXggYjYyZjc1ZmEwM2YwLi5lNjNlMmY4NmMyODkg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvY2FuL3RpX2hlY2MuYw0KPiBAQCAtNTMwLDkgKzUzMCw4IEBAIHN0YXRpYyB1bnNpZ25l
ZCBpbnQgdGlfaGVjY19tYWlsYm94X3JlYWQoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZsb2Fk
LA0KPiAgIAkJCQkJIHUzMiAqdGltZXN0YW1wLCB1bnNpZ25lZCBpbnQgbWJ4bm8pDQo+ICAgew0K
PiAgIAlzdHJ1Y3QgdGlfaGVjY19wcml2ICpwcml2ID0gcnhfb2ZmbG9hZF90b19wcml2KG9mZmxv
YWQpOw0KPiAtCXUzMiBkYXRhLCBtYnhfbWFzazsNCj4gKwl1MzIgZGF0YTsNCj4gICANCj4gLQlt
YnhfbWFzayA9IEJJVChtYnhubyk7DQo+ICAgCWRhdGEgPSBoZWNjX3JlYWRfbWJ4KHByaXYsIG1i
eG5vLCBIRUNDX0NBTk1JRCk7DQo+ICAgCWlmIChkYXRhICYgSEVDQ19DQU5NSURfSURFKQ0KPiAg
IAkJY2YtPmNhbl9pZCA9IChkYXRhICYgQ0FOX0VGRl9NQVNLKSB8IENBTl9FRkZfRkxBRzsNCj4N
Cj4NCg0KSW5kZWVkLCBtYnhfbWFzayBpcyBubyBsb25nZXIgdXNlZCBhZnRlciBpbmNsdWRpbmcN
CiJjYW46IHRpX2hlY2M6IHVzZSB0aW1lc3RhbXAgYmFzZWQgcngtb2ZmbG9hZGluZyIuDQoNClJl
dmlld2VkLWJ5OiBKZXJvZW4gSG9mc3RlZSA8amhvZnN0ZWVAdmljdHJvbmVuZXJneS5jb20+DQoN
Cg==
