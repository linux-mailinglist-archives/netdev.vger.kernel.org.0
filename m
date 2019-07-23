Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0372163
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389289AbfGWVQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:16:43 -0400
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:63329
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389123AbfGWVQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 17:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK/snS0VJK6wByya9Fbf0egtRnShIrm3DZmZISwTqzniteO+OUXOKc6j4dEOuRhLJhX1e5++RVeujGQzp3QnH53t+d3vhREdt4CPglAMlA/RZsxXqFtt+CzF+9wojXecHeoZr2jaHVmZqEEKbs6Gbg9tK6b8BcfJ6dVJOz8ihIFmuYE2SCKTIrXJZ1whMX/WxA36uDgp5Y3befuGppVQo+tlMgWm09y//URCDRgqhd/tGS2yMQPovrb0zHGBdCk2eAu/6hF7FAzF/wcCVnkcORal4UxzIhg97ouekvvzrKLJjtqi8MVyVakOtL5e0NDqMIZ1nZH133mACN7PCwHKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqDqkhDK9764aJGAABgUdonP2AZ4mBQO6nv3pFKfkWs=;
 b=mfcuvxIHJjuVjQk+XM/X0Wz8tEeSh6+bvxHdzLJ6jVWGeEuIogWOiYQz70wRMLdnwgEgjv/AGMbGk1fpmyZrZeLcwhhGEtKxCVsLaTdpVVr+45fSqzRcMp9UjyY6ia+RoHxopH9yWPRw3HYPUUdoqBTGz4XykPRhLw9RF7YgUO4PpCEdhjNeL3XWDZAdOD8u0W3DWMnVp2R/GVkBt7ggn3LkvLMSz2z08r4wdOzUexcEVHuaSgUyh8sdK+Jjpbzz/20pqB+YPm8PmvgE2KaUXZZdMORQdtSC9jcuHg3tZxlhOk+U3lHa17jdV7aYw+9JNM1U6l+3nzfKzl4AmiPE1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqDqkhDK9764aJGAABgUdonP2AZ4mBQO6nv3pFKfkWs=;
 b=bb93P14KAhgtDRKRaeGK4qOX664w+Om477Hl/pem4JUGe2qfzQ1GHLH8mqR8uINXQB8IyoA635pKdHMxG4w4Z/MfREizWIQ++tE3KOy2GwZshaorLKrrGn0pU77tSildptbiDqYBhQavchG1B+umBxct1aWY6U3nRlft9rlrZTA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2791.eurprd05.prod.outlook.com (10.172.226.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 21:16:38 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 21:16:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 0/6][pull request] 1GbE Intel Wired LAN Driver Updates
 2019-07-23
Thread-Topic: [net-next 0/6][pull request] 1GbE Intel Wired LAN Driver Updates
 2019-07-23
Thread-Index: AQHVQX1C1TEV1Ry9+k+s6QcZ4h5P9abYtNcA
Date:   Tue, 23 Jul 2019 21:16:38 +0000
Message-ID: <6022331910de0ac36b9ca4f05c9b58428650ef0c.camel@mellanox.com>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8b42e14-e569-4036-cffc-08d70fb30d0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2791;
x-ms-traffictypediagnostic: DB6PR0501MB2791:
x-microsoft-antispam-prvs: <DB6PR0501MB27916C4F6787712C468EABE7BEC70@DB6PR0501MB2791.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(478600001)(4744005)(476003)(25786009)(2616005)(36756003)(446003)(99286004)(15650500001)(53936002)(2501003)(6512007)(7736002)(71200400001)(64756008)(6436002)(91956017)(76116006)(66946007)(66556008)(66446008)(66476007)(305945005)(76176011)(81166006)(3846002)(5660300002)(66066001)(71190400001)(6246003)(81156014)(6506007)(316002)(8936002)(229853002)(86362001)(54906003)(26005)(11346002)(186003)(14454004)(68736007)(58126008)(8676002)(110136005)(102836004)(6486002)(2906002)(6116002)(486006)(118296001)(256004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2791;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZajDzarhsrKAP/h4j06OdrNHRkGXaVzwpfMvBEVu8RMy3hUBjDRVZvOeSS5Vho0DTF5QJN8jmStpwY9IBTe8avSg+UtPwFxaDWllmk925ItRcyZj1Um2+iTJeqXeNYpfmAIRShFkFMfhqQ1WYHkOP1JkIkzQcYQ0ws4zMK84/5fQGatKHkoV0mpXM9pQPaYfNMfjlvN678CUd9EHGyCZPymkzGX9KIZaxl4hzsJPzTGPhmx0cD8/U0xPmh4tMISoQ0k6u61VTrH0e3JrzebDiV7HjwlLGllawYfJ8ePXlMcaIQTPTQm3oXqjNdgCNsSYDeZXPLms/v/p4YfbTsPFY4Z2simcwD+2iR1PA4xSB6qrTJmeNGDol9UPhWEuI8ntfieb9Y8I1NME+KZqc8It4MedFj457bi42QZ6l13QOag=
Content-Type: text/plain; charset="utf-8"
Content-ID: <627AF7B0FF2ABE4BAF00BA86091B3555@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b42e14-e569-4036-cffc-08d70fb30d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 21:16:38.6925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDEwOjM2IC0wNzAwLCBKZWZmIEtpcnNoZXIgd3JvdGU6DQo+
IFRoaXMgc2VyaWVzIGNvbnRhaW5zIHVwZGF0ZXMgdG8gaWdjIGFuZCBlMTAwMGUgY2xpZW50IGRy
aXZlcnMgb25seS4NCj4gDQo+IFNhc2hhIHByb3ZpZGVzIGEgY291cGxlIG9mIGNsZWFudXBzIHRv
IHJlbW92ZSBjb2RlIHRoYXQgaXMgbm90IG5lZWRlZA0KPiBhbmQgcmVkdWNlIHN0cnVjdHVyZSBz
aXplcy4gIFVwZGF0ZWQgdGhlIE1BQyByZXNldCBmbG93IHRvIHVzZSB0aGUNCj4gZGV2aWNlIHJl
c2V0IGZsb3cgaW5zdGVhZCBvZiBhIHBvcnQgcmVzZXQgZmxvdy4gIEFkZGVkIGFkZGl0aW9uDQo+
IGRldmljZQ0KPiBpZCdzIHRoYXQgd2lsbCBiZSBzdXBwb3J0ZWQuDQo+IA0KPiBLYWktSGVuZyBG
ZW5nIHByb3ZpZGVzIGEgd29ya2Fyb3VuZCBmb3IgYSBwb3NzaWJsZSBzdGFsbGVkIHBhY2tldA0K
PiBpc3N1ZQ0KPiBpbiBvdXIgSUNIIGRldmljZXMgZHVlIHRvIGEgY2xvY2sgcmVjb3ZlcnkgZnJv
bSB0aGUgUENIIGJlaW5nIHRvbw0KPiBzbG93Lg0KPiBBbHNvIHByb3ZpZGVkIGEgZml4IHdoZXJl
IHRoZSBNQUMgJiBQSFkgbWF5IGJlY29tZSBkZS1zeW5jJ2QgY2F1c2luZw0KPiBhDQo+IG1pc3Mg
ZGV0ZWN0aW9uIG9mIGxpbmsgdXAgZXZlbnRzLg0KDQpGb3Igd2hhdCBpdCdzIHdvcnRoLCBTZXJp
ZXMgTEdUTS4NCg0K
