Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655051249FF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfLROpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:45:17 -0500
Received: from mail-eopbgr1300114.outbound.protection.outlook.com ([40.107.130.114]:31232
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbfLROpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:45:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSf8GX82JKN+dKqVgW9DJvV+GP26ssGbttZhWA9h7+Fe3nNlX4EzENRPzPsEHcFaC0M4lKS2BKh/IVdVpLwaKGcNQLBtPMWz+patkRfnvU1q6oqYhp3za/FCZMEVrhN2ojKpDaXi+zVH79R0j+Rl6AU68I2TIHq1I0s0C1SwGuEKoq77XTO7J8lOxBBqwlTMJykViXnWqoa0o1+CTlnaOesDeVw4n7lTndcSrNEMW7/SHaeUbuK9tR68a2BU0kuT1RnyJIK+oCNbYINC4htyxLPO7PgqvsinwSgv5mHR/nZaA+Z+YCXrPVcBs0pWZIbiL0lGfKKW9OLh4J3itJhg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w56rNYklMyDb4+UMqLtzXRxkVrz8NNDx10zONddieb8=;
 b=W0OO/ZwBcEKqAZrJT74ahB5tY56CmVC+0RPrOEUTqg0SzkgzV6gmfQD9E1tZpnNbIMo7wjYGBEtrLHHiozk+fMJFPa5u4XSODvCSAGdb0uOZKRTDNck8ilyx2SdRxwXQEF1V7krguKCn+orqJirdHcncuMOxZtKe6IRt+tm0gleZdk1B9/3IMy1EcfwSeoLVfV/y3GtABfK1QFN2UraKpfILDRbWJm8KLHcbUIR3XWRz3yUIN9dRhfqnxnwPZ8y0/UK5gqMfCea7NlgZ+UHK8mLPbYhWuNNrIDhsx12Bmes+LDT/95MvD2Gs7xj/bjdgMsc+Di9tRbz33/l4c6YetQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w56rNYklMyDb4+UMqLtzXRxkVrz8NNDx10zONddieb8=;
 b=Vv7tf+wzl7dR3hgKZdGnVWaxZbv2M7lqFXMIToGrAdlgytGCe39vFPVsRYManxCGkXsbpkj2BmV3Mot5TvY6YWZq1ZyjFrGYcn1RdYBXXlj+Qw8JrmrIASClJ02hUzttBMkBX1QVE8mMwazsCx5Vk0oskKasNt90EG62IlcOf4A=
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com (20.177.100.140) by
 TY2PR01MB1946.jpnprd01.prod.outlook.com (52.133.182.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 14:45:10 +0000
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::1d79:83d3:7ac:5f77]) by TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::1d79:83d3:7ac:5f77%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:45:10 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     David Miller <davem@davemloft.net>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] ptp: clockmatrix: Remove IDT references or
 replace with Renesas.
Thread-Topic: [PATCH net-next 2/3] ptp: clockmatrix: Remove IDT references or
 replace with Renesas.
Thread-Index: AQHVtJdPQLsXSAa04E+zgCKnuq8IvKe/b/IAgACKQwA=
Date:   Wed, 18 Dec 2019 14:45:09 +0000
Message-ID: <20191218144446.GA25453@renesas.com>
References: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1576558988-20837-3-git-send-email-vincent.cheng.xh@renesas.com>
 <20191217.222956.2055609890870202125.davem@davemloft.net>
In-Reply-To: <20191217.222956.2055609890870202125.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BY5PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::40) To TY2PR01MB3034.jpnprd01.prod.outlook.com
 (2603:1096:404:7c::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ae435c1-fb7b-454d-9ab3-08d783c8e17a
x-ms-traffictypediagnostic: TY2PR01MB1946:
x-microsoft-antispam-prvs: <TY2PR01MB1946DE763CCD29081FD86DD6D2530@TY2PR01MB1946.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(2906002)(1076003)(6486002)(5660300002)(478600001)(66476007)(66946007)(66446008)(54906003)(64756008)(66556008)(316002)(6506007)(86362001)(6916009)(26005)(36756003)(186003)(2616005)(52116002)(8676002)(4326008)(81156014)(81166006)(71200400001)(33656002)(6512007)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:TY2PR01MB1946;H:TY2PR01MB3034.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXhKKfiw9rCYAkqAsd/iH/lbakJO+W4ovPLYBy1BDgQJp8IC8swcKL/mvdiJESHfJT7ghzss1ZtnJ1ReTfI0fQmPQusmDnAYan8HD8/cZitrvLc8MBrLQAfjelgzQlw9ffrSoBkuetobullzG8zTlEkHxgjUosSYK8TCjJAOgJ8Au4LaDjXLvAVwsGDbFWuijclGyh7lcQVvxUuV3eE1/lXP7bggWHC8qm/pZywzC3KBC2SiQf1kzxWBvQHoRe+tcQSWKkJAONxvdx2wDhZHm4K/YFPohxC5w0Qzo1dZYIe253czdM//ygH4BMjyxjwpEsBs3Frh5WCl4p46DIRA8eBlLkLOQzp7WVEXRwBgjAJ8lw2gqcb6lfp2idiYxHI6ChZS41KtGI1Ze1uJMUjhsbyQDcBHvOX2b7xDvc7nBzq9iIZbn11JjUSiQ6nL2UkW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4FAE28E19B274439C211D2C7F8B496D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae435c1-fb7b-454d-9ab3-08d783c8e17a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:45:09.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xFi2JjbjnjqfXRqxE92ffcNXwJ4JkuQFMdt2F8BZaE4Pq8dVnpSE/SgaDw7Ipkc2uSYVt1Rnk1E+Kxg5SUVFDYDD+T5b5r7usrJYU+HmR2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB1946
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBEZWMgMTgsIDIwMTkgYXQgMDE6Mjk6NTZBTSBFU1QsIERhdmlkIE1pbGxlciB3cm90
ZToNCj5Gcm9tOiB2aW5jZW50LmNoZW5nLnhoQHJlbmVzYXMuY29tDQo+RGF0ZTogVHVlLCAxNyBE
ZWMgMjAxOSAwMDowMzowNyAtMDUwMA0KPg0KPj4gRnJvbTogVmluY2VudCBDaGVuZyA8dmluY2Vu
dC5jaGVuZy54aEByZW5lc2FzLmNvbT4NCj4+IA0KPj4gUmVuZXNhcyBFbGVjdHJvbmljcyBDb3Jw
b3JhdGlvbiBjb21wbGV0ZWQgYWNxdWlzaXRpb24gb2YgSURUIGluIDIwMTkuDQo+PiANCj4+IFRo
aXMgcGF0Y2ggcmVtb3ZlcyBJRFQgcmVmZXJlbmNlcyBvciByZXBsYWNlcyBJRFQgd2l0aCBSZW5l
c2FzLg0KPj4gUmVuYW1lZCBpZHQ4YTM0MF9yZWcuaCB0byBjbG9ja21hdHJpeF9yZWcuaC4NCj4+
IFRoZXJlIHdlcmUgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5
OiBWaW5jZW50IENoZW5nIDx2aW5jZW50LmNoZW5nLnhoQHJlbmVzYXMuY29tPg0KPg0KPlNvcnJ5
LCB3ZSBkb24ndCBkbyBzdHVmZiBsaWtlIHRoaXMuDQo+DQo+VGhlIGRyaXZlciBzaGFsbCBrZWVw
IHRoZSByZWZlcmVuY2UgdG8gaXQncyBvbGQgdmVuZG9yIG5hbWUsIGFuZA0KPnRoaXMgaXMgaG93
IHdlJ3ZlIGhhbmRsZWQgc2ltaWxhciBzaXR1YXRpb25zIGluIHRoZSBwYXN0Lg0KDQpTb3JyeSwg
d2FzIG5vdCBhd2FyZS4NCg0KPkFuZCBkbyB5b3Uga25vdyB0aGUgd29yc3QgcGFydCBhYm91dCB0
aGlzPyAgWW91IERJRCBpbiBmYWN0DQo+ZnVuY3Rpb25hbGx5IGNoYW5nZSB0aGlzIGRyaXZlcjoN
Cj4NCj4+IC0jZGVmaW5lIEZXX0ZJTEVOQU1FCSJpZHRjbS5iaW4iDQo+PiArI2RlZmluZSBGV19G
SUxFTkFNRQkiY21fdGNzLmJpbiINCj4NCj5Ob3cgZXZlcnlvbmUgd291bGQgaGF2ZSBtaXNzaW5n
IGZpcm13YXJlLg0KPg0KPlNvIG5vdCBvbmx5IGlzIHRoaXMgdW5hY2NlcHRhYmxlIG9uIHByZWNl
ZGVuY2UgZ3JvdW5kcywgYW5kIGhvdyB3ZQ0KPmFsd2F5cyBoYW5kbGUgc2l0dWF0aW9ucyBsaWtl
IHRoaXMsIGl0J3MgZnVuY3Rpb25hbGx5IHdyb25nIGFuZCB3b3VsZA0KPmJyZWFrIHRoaW5ncyBm
b3IgdXNlcnMuDQo+DQo+UGxlYXNlIHJlbW92ZSB0aGlzIHBhdGNoIGFuZCByZXN1Ym1pdCAjMSBh
bmQgIzMgYXMgYSBzZXJpZXMgZm9yDQo+cmUtcmV2aWV3Lg0KDQpXaGF0IGlzIHRoZSBwcm9wZXIg
d2F5IHRvIHJlbW92ZSBhIHBhdGNoIHN1Ym1pc3Npb24/DQoNClJlZ2FyZHMsDQpWaW5jZW50DQo=
