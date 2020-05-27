Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928B81E37A8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 07:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgE0FIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 01:08:19 -0400
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:49049
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbgE0FIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 01:08:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBpznQ7ATO61SeuWgL08dAinZp40GhfyQtsIEZ8+FwUycoZ3HDkETgOFvODguiREeJh7PLH7KrIxL1Tt9NdQAejYG8N3F573O8o4Y/0YIR000UCXYDYlHUHJrBbq24Mvlimws3u77ijgND0bX+GRN2/3YlV/I3ukU/OqVziy6G9RaV1QSi7BLfS0i2BOWNgfYotylHROyBaVkotDZaLGtoeQAk70Ud9L5joWvWdLUPiI46wwXXejPRr4XGyqT9LQ/uYQgOU4dm57B0dgkB3A/Y05fqY946Sq1SgH7UsTWeIk+HaxqVQjkobcnm4SHccDOZ7c/Gci8l0a73T/myqszA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej/D65IgJmuNvWOC3tNWjwzJ6TAmGR6UnTyCjt14h48=;
 b=jcPdJX/C1OayPsau5zEK88J6RU03JO61G44gqABuAj99CPnBiGq9bboeSf27AKDdG2D1UItqWBsnbqSDrXBc8ptXWbqrd2GOVPjZEyrtdf7UO902a1Os1YSqz65SZVY/AWUjZ6O1yxhcvv7xYxF/5gIt3GNRm048ef2OkRtTfa4Du8Kj0F4m5ZViXXaAmkQMoshQA7h+q86VuG5Ul61OWv7hipIUdZoeb/D+XzajVZC4Ax8+f6Q9LTHxVbrfwjoJhTOKCcdgXB7GrIseDFLMCIkY7Jd96u6155UL7dydx7esxAaxYujnRxLFc0chXsVlGgqhMCD6XbFASD0w8glUpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej/D65IgJmuNvWOC3tNWjwzJ6TAmGR6UnTyCjt14h48=;
 b=kfPCC4QsbucWh3w2ix5m/kLHXAmm4qDQf8ofl4GHpXZFphAT/jglFun9A7zOPMN6uOyb8hF2WZAlSWgKqAQJIx04HtO+h/52f81352puK3XKRLeF03CK9lghj3m9Nqy3ONFgleDKblnVgXKpnjKl4V1INLS7ti+QN29w+zo4RT0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6800.eurprd05.prod.outlook.com (2603:10a6:800:139::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 05:08:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 05:08:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 05/10] net/mlx5e: Introduce kconfig var for TC support
Thread-Topic: [net-next 05/10] net/mlx5e: Introduce kconfig var for TC support
Thread-Index: AQHWMJQHcjT67Gr+WkS9onSc707YWqi45WcAgAKDFAA=
Date:   Wed, 27 May 2020 05:08:15 +0000
Message-ID: <4959a29a9cb573e03018bc30af1987656d8fb3fe.camel@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
         <20200522235148.28987-6-saeedm@mellanox.com>
         <20200525144632.GD74252@localhost.localdomain>
In-Reply-To: <20200525144632.GD74252@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 39a7bc39-0a13-41a8-6a5c-08d801fbf65b
x-ms-traffictypediagnostic: VI1PR05MB6800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6800B4778C3BD71CE28FCF56BEB10@VI1PR05MB6800.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYtIrF0A+UzkCQPuRZux89vlp1UPCg8oYQ6DwL43VEeJvQ/KZMAPMTvLfQlm2jx/rNVYpMs/4vhfu7bjo+UWtcht8yMuFrX1awXVT59v1BMceytv9CU9auwObydPNvwNO41mQusHo+MVidCDXSK2VYiJKW8AW7ywnQfZgX4q91EFWFarJbJ8ZfZ6CfF16Rm2g3PibIyqgtVyeFG6lyYQVqIDdEUofqafKi4VnLQaxxTUGnuItzSPIjGgO/XLpThBvEaWmr8gumGwZPZu6HbTKOw5GrZScHZByQn5cWcvBIEkHwebfzRFWk8EtDoQ2W5EV/+EJjRUllM+LrQgn2DpaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(2616005)(478600001)(6506007)(4744005)(8676002)(66556008)(26005)(64756008)(36756003)(66476007)(66446008)(71200400001)(5660300002)(8936002)(6486002)(66946007)(6512007)(4326008)(2906002)(316002)(54906003)(86362001)(76116006)(186003)(6916009)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0dUPTsHhvlYBwxIaTAAqntSf9MttiwAkdB5U0Nj2pDThdNqW+iLCSsGIFkzAABAVgUgEyDfU2T8Rg3Sf8mp5UcRqQK4mqB1HrsxMP9r1bNZkC03tKVQshzizKqaSXliYzzF5LKqgotdwXlak98tji/8Xeeo2LGZntRTfw+h7U8QK3f7wiBO8ICPRUoZqVd9FtJ29BZq+efj56gZC09aqvTcKmyUaBqqnr43UItErBTWSDv3nc5R7CHlOldhjkA7ambn14jIDSgxiwHsqTS2u2zolcw9fwzyOfFMqTbo1jFkJ/szjq6g7olNfJ4M1HrQ6EKj2lSL7jEfoTXpEeeY6mk4GbYKLjdTbfZ5QRiEqQCs0RWJLmclwJ9ZKpgGMk3Yr0OJrC2gBC2gvQy7S6zYlqWKy+qXhTC7DuVuX4IpJeHqIO9vdinZz0sGmBcJhNtRs5DDvK9Yjk6hGZ+DYN0ftW4S7Cus94mfNVXFpKLYLE9o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7E0D13EC09A254EB5E880FF8C40A59A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a7bc39-0a13-41a8-6a5c-08d801fbf65b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 05:08:15.3081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDlQnXHvOSTOtw2OXNUhiWgt3iNj70NNvUusK8mveNm2kJRqJ1nI9IqO0HZ0uQgGiGzVYEoOtSgJpIMYGLpmEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA1LTI1IGF0IDExOjQ2IC0wMzAwLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5l
ciB3cm90ZToNCj4gPiANCj4gT24gRnJpLCBNYXkgMjIsIDIwMjAgYXQgMDQ6NTE6NDNQTSAtMDcw
MCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+IC4uLg0KPiA+ICtjb25maWcgTUxYNV9DTFNfQUNU
DQo+ID4gKwlib29sICJNTFg1IFRDIGNsYXNzaWZpZXIgYWN0aW9uIHN1cHBvcnQiDQo+ID4gKwlk
ZXBlbmRzIG9uIE1MWDVfRVNXSVRDSCAmJiBORVRfQ0xTX0FDVA0KPiA+ICsJZGVmYXVsdCB5DQo+
ID4gKwloZWxwDQo+ID4gKwkgIG1seDUgQ29ubmVjdFggb2ZmbG9hZHMgc3VwcG9ydCBmb3IgVEMg
Y2xhc3NpZmllciBhY3Rpb24NCj4gPiAoTkVUX0NMU19BQ1QpLA0KPiA+ICsJICB3b3JrcyBpbiBi
b3RoIG5hdGl2ZSBOSUMgbWRvZSBhbmQgU3dpdGNoZGV2IFNSSU9WIG1vZGUuDQo+IA0KPiBUeXBv
IGhlcmUgYnR3LCAibWRvZSIuDQo+IA0KDQpSaWdodCAhIHdpbGwgZml4LCANCg0KVGhhbmtzIQ0K
