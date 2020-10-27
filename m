Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FC129CAC9
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373424AbgJ0U4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 16:56:14 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45882 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901068AbgJ0U4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 16:56:14 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id EC99E891B1;
        Wed, 28 Oct 2020 09:56:09 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603832169;
        bh=Uy/31KPPijVTs8IBYRdL4nxNBGuQ/WeGKM8tG7/Q+GA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=bOkxmBKGee7T4qze9mhjJgtbD5h6hVVUM7DP8FyhXKphDWGgluW5NoGxdnUSaWFSI
         L3DhfcLeJ/c7pMJopkjePp/+YXyG8hHe2aFqE4lHtQ3blNmaxVedTW3B5TjuEmnU3n
         bs0MEiKbxqaQvz5CrTU+dldlNV5y+iXQks0YhDIgmOvNhqx1CLTFy0+COeEjoxnASP
         apwXucI8UODPzWkU6AdBAaQCQmBU9qm0cLFex4U/vZfG/Cqp2arJwG5pDmmLnWwp2t
         CPevHzr9ELmQ7t1lulV/HeB3lU0zTHCxxLtqIE+IiJm0epvXtdfL9Yexzf6+8VsZCe
         IlWN6dso5LSMw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f98896a0002>; Wed, 28 Oct 2020 09:56:10 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct 2020 09:56:09 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.007; Wed, 28 Oct 2020 09:56:09 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Thread-Topic: [PATCH 4/4] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Thread-Index: AQHWqBI06ed43/xsqEO3n+1up6ZkYqmk8XEAgAYrrYA=
Date:   Tue, 27 Oct 2020 20:56:09 +0000
Message-ID: <1b1d4c27-570b-8a2f-698b-d82b2ca8215d@alliedtelesis.co.nz>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
 <20201022012516.18720-5-chris.packham@alliedtelesis.co.nz>
 <20201023224216.GE745568@lunn.ch>
In-Reply-To: <20201023224216.GE745568@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC5DFC1D1417CC4B80BA87AA0A8894F5@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyNC8xMC8yMCAxMTo0MiBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+PiAraW50IG12ODhl
NjEyM19zZXJkZXNfZ2V0X3JlZ3NfbGVuKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50
IHBvcnQpDQo+PiArew0KPj4gKwlpZiAobXY4OGU2eHh4X3NlcmRlc19nZXRfbGFuZShjaGlwLCBw
b3J0KSA9PSAwKQ0KPj4gKwkJcmV0dXJuIDA7DQo+PiArDQo+PiArCXJldHVybiAyNiAqIHNpemVv
Zih1MTYpOw0KPj4gK30NCj4gSGkgQ2hyaXMNCj4NCj4gV2hlcmUgZGlkIDI2IGNvbWUgZnJvbT8N
CkluIHRoZSA4OEU2MTIzIFNlcmRlcyBSZWdpc3RlciBEZXNjcmlwdGlvbiB0aGUgaGlnaGVzdCBy
ZWdpc3RlciBhZGRyZXNzIA0Kd2FzIDI2IHNvIHRoYXQncyB3aGF0IEkgdXNlZC4gVGVjaG5pY2Fs
bHkgdGhlcmUgYXJlIDMyIHBvc3NpYmxlIA0KYWRkcmVzc2VzIGluIHRoYXQgc3BhY2Ugc28gSSBj
b3VsZCBnbyB1cCB0byAzMi4gRXF1YWxseSByZWdpc3RlcnMgOS0xNCwgDQoyMCwgMjItMjMgYXJl
ICJyZXNlcnZlZCIgc28gSSBjb3VsZCByZW1vdmUgdGhlbSBmcm9tIHRoZSB0b3RhbCBhbmQgaGF2
ZSANCm12ODhlNjEyM19zZXJkZXNfZ2V0X3JlZ3MoKSBza2lwIG92ZXIgdGhlbS4gSSdtIGd1ZXNz
aW5nIHNraXBwaW5nIHNvbWUgDQooMjctMzIpIGFuZCBub3Qgb3RoZXJzIGlzIHByb2JhYmx5IGxl
c3MgdGhhbiBpZGVhbC4=
