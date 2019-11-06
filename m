Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5A2F1E71
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfKFTQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:16:17 -0500
Received: from mail-eopbgr720041.outbound.protection.outlook.com ([40.107.72.41]:7776
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727463AbfKFTQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:16:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atoUZG4er1pGNOSuJEfQmIx+oNyK3Yepc5J2G7FFjCGG7hkylEBH+ZIZt9HOBECMh4EV+WMB/ZAdIRo0o5auiI14c3+J3uGCm83+SoPPmx+r65/XmoiAKCptLhDPI445jznlnGASaEnl/EK2WlZbI4/ucsvawQiMWVO0A1yC4xl6BaLQ+7NBwHa+LasYinLgYeKTVZYA/5y1xNqF6V4YXswlzM/hzp/E//iQcHwPSmhX26uUHh/+H2FIRBtl+LJpvRnMiQNj844WNIfg7bgapiO59CYQItgOVRxlf7bc1cDZLpZhhbJnk6CNNEk1hutgMH4WZ2lNTl+r1KD1/Frxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN1TK5LhaTEFtc2gnquaMI+9e+FnrbNDCjc2nP3mftk=;
 b=n43MUlRmn0uacUoNwsWGbgS2Xj4eyD8iPC00YGeyUhxPrygvs+yAvckv+qDis1kUwSvhPQBmSercaOG5AsxrHZS9hYNlrqp3lyI23tmwAF3HdRqUO9h7QDGvAjKuORM9aH7FLl7k4wTOpAw+DzNoL3Yp25YQlcq0NKrAF3arHr7peKnwxB83l09DxNPWIiBtAZ5iecY9i4l090JyA+diogfVqhMtYb/Tu0yrJM00wApCzFToISpIpoCqdWVt8ZBknjYhbGALC60Jri6sCLSQYT4FhQ3wBJocACbsqMu+MN8lZ8F11Ip0O0qGPe9w1b++QcBEW7eKTFCRrP+OR+qwRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN1TK5LhaTEFtc2gnquaMI+9e+FnrbNDCjc2nP3mftk=;
 b=GUKmqm4LUT1/I6aNCQe9QV0tdaMj2qkJVca3ySdC1kRaGqgV0Ez691lWb31Qx8BaS01iEcBZyn2VOiBWebf6asvwxg9LpHE2YWyNf4lf1goot8aMbVwgB2Rtmas7/wdzY7tJ5Im7+bj6yuGTOjl534I6qrQBan5chCKzcZ05/Zk=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3314.namprd10.prod.outlook.com (20.179.139.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 19:16:13 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2%6]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 19:16:12 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: SIOCSIFDSTADDR for IPv6 removed ?
Thread-Topic: SIOCSIFDSTADDR for IPv6 removed ?
Thread-Index: AQHVlJYdvtZdppS9xU+N4EAZGCsgH6d+S+oAgAA4KQA=
Date:   Wed, 6 Nov 2019 19:16:12 +0000
Message-ID: <df2cf840fcf7f8c920c102bf7433d362bb9044cb.camel@infinera.com>
References: <63900c63bcb04f226fba538fd31c609c8ff6e776.camel@infinera.com>
         <038e090c-b9cb-a15d-6aea-4a5ccbc6e95c@gmail.com>
In-Reply-To: <038e090c-b9cb-a15d-6aea-4a5ccbc6e95c@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f145d373-4000-485f-93f0-08d762edc9cd
x-ms-traffictypediagnostic: BN8PR10MB3314:
x-microsoft-antispam-prvs: <BN8PR10MB33145746923648F28CE9ACD0F4790@BN8PR10MB3314.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(366004)(346002)(136003)(396003)(189003)(199004)(118296001)(14454004)(8936002)(66946007)(478600001)(81156014)(53546011)(6246003)(99286004)(71200400001)(86362001)(6436002)(6486002)(64756008)(66556008)(91956017)(66066001)(66476007)(66446008)(305945005)(476003)(2616005)(7736002)(229853002)(486006)(446003)(2906002)(11346002)(76176011)(6512007)(4744005)(81166006)(5660300002)(71190400001)(26005)(76116006)(8676002)(186003)(110136005)(3846002)(6116002)(36756003)(2501003)(256004)(102836004)(6506007)(25786009)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3314;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1GlM9heZOLWnDTHx67KsUk7J+xdWmutsja34vpW5eAxGIW6xSU0pP9BRcabBBeOeNx9nev+QKKnWAFDat3POwc78hUI069IJDRNMc7vZEq/Ip7gO4oHDRiAchX9wVpcchbytj7Lp2rZuoV10EwrlPHzeJB+pofGP6WYoNc6AHiwjjazFahvjxGI2rKWfmIQRo/MfmRY1wlYFO0V/7HiH/6Z8r1t/XVcyHpwskVTds+yaq5mFrD43QHMojyv1vUW4jslitOXEPCaNYT4JdZB2b2REABGAvtOrOa1QFDgwE03LHdvef4FUkMn/vyrDbg1yYoEoXYjbnwNjyYcQAAGCU86JbUMfl1fGsePcanHJkkt3h4TQmh0nHxfHAdfq4r3AXaye3ywiD27DgRK6DsLhmPFdmjZsm8r7xTxCF+JrOSiu0DXidUOcZLcjywxLzHXl
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F30B09658DA64498053F17AFEA32663@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f145d373-4000-485f-93f0-08d762edc9cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 19:16:12.7209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLrFjxV9KHW+Nhl7EqsuWBz6aDDEjLNxCYRh+C8F7sKrtYdiIKArRXxV0SrvVLw0Nn4J8ldA78AcFHvoCFsIwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTA2IGF0IDA4OjU1IC0wNzAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
DQo+IE9uIDExLzYvMTkgNDozNCBBTSwgSm9ha2ltIFRqZXJubHVuZCB3cm90ZToNCj4gPiBGcm9t
IHdoYXQgSSBjYW4gdGVsbCwgaXQgaXMgbm90IHBvc3NpYmxlIHRvIHNldCBEU1RBRERSIGluIElQ
djYgYW5kIEkgd29uZGVyIHdoeT8NCj4gPiANCj4gPiBUaGVyZSBpcyBhbiBleHBlY3RhdGlvbiBm
b3IgSVBWNl9TSVQgd2hpY2ggY2FuIGJ1dCBhbSB1c2luZyBwcHBvZSBhbmQgdGhlcmUgSSBjYW5u
b3QuDQo+ID4gDQo+IA0KPiBDb2RlIGlzIHN0aWxsIHByZXNlbnQgYW5kIGRvZXMgbm90IGFwcGVh
ciB0byBoYXZlIGJlZW4gY2hhbmdlZCByZWNlbnRseS4NCg0KUmlnaHQsIElQVjYgc2VlbXMgdG8g
aGF2ZSBiZWVuIGxpa2UgdGhpcyhubyBzdXBwb3J0IGZvciBEU1RBRERSKSBmb3JldmVyLCBidXQg
d2h5Pw0KSXMgaXQgYmVjYXVzZSBub25lIGhhcyBpbXBsLiBEU1RBRERSIGZvciBJUHY2IG9yIGlz
IHRoZXJlIGEgcmVhc29uPw0KV291bGQgYSBwYXRjaCBhZGRpbmcgSVB2NiBEU1RBRERSIGJlIGFj
Y2VwdGVkPw0KDQogSm9ja2UNCg0KDQo=
