Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBC09F49C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfH0U47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:56:59 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18933 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbfH0U47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:56:59 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Tristram.Ha@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tristram.Ha@microchip.com";
  x-sender="Tristram.Ha@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tristram.Ha@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tristram.Ha@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: HkrXn+RzOzkABRStNKL4OZwYVB20AxPhoUR1ZHjoSkHE1qy7no/vfJDRf3SjwrfmzERNOcvooj
 mmzN+m/nUOsDibuP72Rn6aHvJPv0GU5kd46uxgG1EsywYma2RUL3t/3lFIFgLakDsX7OWHnatw
 yccD7AHFRh9RiKrjFzyfE+qJ/Q3m54NbJfuasgYjdUwbspvad3hbKpENVESGYInNprp4Y1POzz
 w12/lngjhJHbuR7uNL9cTurFMM8tz72lw+FK0YJWVRdGaXqyWN+fu32JXhj7fd6ZEf4UgXlOjW
 398=
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="48204357"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 13:56:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 13:56:57 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Tue, 27 Aug 2019 13:56:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPw6MkCkdMxNLRJV7CrDrkJbtV9Pker9cNjksOosGcoI636EiUKJOkjtUuuY4NYMgdpmlrOMztk2z2e5POLwitbB+xnNafsbf/y7lmXMXdvdE0kL7tEF8aX9FAYERNifm3lNsmSJ5DVHYi5iXkjyx9HD+4GrugpKYV734k4vL58eptXBksM6/KfvmkSmAFkX0VUtXL9L0zzTeHM5I0D+pPCCmSOX1yAWo+BXg7ulHDAIAHet+Rcwn7fw2QJbCSmxZi4eX5DUMLYDpKZkWhrWMGg05WYFaiJAvzU89Hq/0j7XtK7phrZYv3wJlv/4m4jAqvUCFlAyTojM6Kztqc3ACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EINxeTsFSAsrI2xAf3Ltcr2L7sW5dCbC2kweEgXCfY8=;
 b=ARFAXeJA09t0y9gtxpthI8kEj0Itcd454fW6FiCT62n8UvtPTvvslo11DCoc4iB8F7BlNzLddEvk46GkX0YMkf2xLHY4Hriz0tf1oNnK7V5zOBPeKgfHkAzQdT0qHWkoI2LbXKyzCNypilbBxcowP5++8Nrqx4eWEbtx/Uk0MxOToN+WLqSO7ZkcIq/nNSX0ex5+SH5Jf+jJvPvnz9pK+RqsikSCu7QMl72b8zMXmvngD7Tvjc88Xo2WS3Z3q+qf66OFT040GL0EEPKemfRcdsBhVl9ro7a/ioTGxSbNBX2uUXwym2OLs7dh+YZEGKGjXodKQxjyWPiaZ2VgpSRnLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EINxeTsFSAsrI2xAf3Ltcr2L7sW5dCbC2kweEgXCfY8=;
 b=hlNg2GWxdjj4mpVf/kA6DhiuDZzelGiXMf4ky9jGJSRN40grOBqvOzjRNTJqZLuZ8s9ERhLid+sXQQaX5OOG9sK97F+HjZUvi6u/C3KUglfaoeWQNTfncGRKYsFR59tk9Uo9YDIrWszyKlJM4MK7eHZwkIm6OMvkj7sbN6cfZjI=
Received: from MN2PR11MB3678.namprd11.prod.outlook.com (20.178.252.94) by
 MN2PR11MB4271.namprd11.prod.outlook.com (52.135.36.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 20:56:54 +0000
Received: from MN2PR11MB3678.namprd11.prod.outlook.com
 ([fe80::b98c:209e:ba2c:e682]) by MN2PR11MB3678.namprd11.prod.outlook.com
 ([fe80::b98c:209e:ba2c:e682%5]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 20:56:54 +0000
From:   <Tristram.Ha@microchip.com>
To:     <Razvan.Stefanescu@microchip.com>, <andrew@lunn.ch>
CC:     <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Thread-Topic: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Thread-Index: AQHVXLpYj0B6cObQwEqwl4lJrA0GLacO8tyAgAAIngCAAHuJkA==
Date:   Tue, 27 Aug 2019 20:56:54 +0000
Message-ID: <MN2PR11MB36781D752F1D07245B35FBAAECA00@MN2PR11MB3678.namprd11.prod.outlook.com>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
 <20190827093110.14957-4-razvan.stefanescu@microchip.com>
 <20190827125135.GA11471@lunn.ch>
 <f54e1c98-e2db-2c63-4bd9-d1576f94937b@microchip.com>
In-Reply-To: <f54e1c98-e2db-2c63-4bd9-d1576f94937b@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.46.67.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8efb393-b742-4833-00b3-08d72b3117a6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR11MB4271;
x-ms-traffictypediagnostic: MN2PR11MB4271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB42714635287513F7FBEE25E7ECA00@MN2PR11MB4271.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(396003)(136003)(366004)(189003)(199004)(71200400001)(4326008)(6116002)(3846002)(14454004)(25786009)(71190400001)(102836004)(5660300002)(74316002)(305945005)(53546011)(6506007)(11346002)(99286004)(9686003)(446003)(7736002)(52536014)(7696005)(76176011)(66066001)(14444005)(86362001)(55016002)(26005)(110136005)(6436002)(33656002)(53936002)(316002)(478600001)(81166006)(54906003)(256004)(486006)(66946007)(66556008)(476003)(64756008)(66476007)(76116006)(229853002)(2906002)(8936002)(8676002)(186003)(6246003)(81156014)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4271;H:MN2PR11MB3678.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b1DMtiqaR2/baoXFyeb7Cfv5zohzmEb6XMxgXSm+3e2cfwHhvuQ1ywm4BoaczMgg3AvsvAxKDhKCmjDIH2jjJAdMJUS0Tk8OBgsdXrarkt9IhK3Vgf5W21a15Lz2f/R4z4ci0PlWqM3iULnZApJ0NtvQpR+IFeZ9cvTUy39BsXEjpHD+vFAjZClN2S4yCR4zrsD94wDECDPxekeRQbpvWj/qbrAMqWEMxfroxz6n0EoH2Vi3iN82imlKnZ9jdZ/Z+2SJPYKTgDM+CShW3HZmnaytRMwl710kJGCSEjhjFzJt0FkZB4wNUcCnrCAPfOZlG6UXNRYo+XVhVM0HiMt6w17O8c+xZq+ev0XfYuLFgwgt99GVltS8CPuSSUkuUj+V7xwF0ytlR1ekpfcFndumF5Y7YkCAGL2O9hrXdYpiYW8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8efb393-b742-4833-00b3-08d72b3117a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 20:56:54.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DWNA5DMTYaPS7oDiGjhhmxMm9uCnyXF7gHR5Ub86MvsdJkzKM6/ZY9OwtS/yAXur5OL4XTQbLoaRurLyUzsJva1Q3H0qur+vqUJL6o0f+4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4271
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAyNy8wOC8yMDE5IDE1OjUxLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPg0KPiA+IE9uIFR1
ZSwgQXVnIDI3LCAyMDE5IGF0IDEyOjMxOjA5UE0gKzAzMDAsIFJhenZhbiBTdGVmYW5lc2N1IHdy
b3RlOg0KPiA+PiBHbG9iYWwgSW50ZXJydXB0IE1hc2sgUmVnaXN0ZXIgY29tcHJpc2VzIG9mIExv
b2t1cCBFbmdpbmUgKExVRSkNCj4gSW50ZXJydXB0DQo+ID4+IE1hc2sgKGJpdCAzMSkgYW5kIEdQ
SU8gUGluIE91dHB1dCBUcmlnZ2VyIGFuZCBUaW1lc3RhbXAgVW5pdCBJbnRlcnJ1cHQNCj4gPj4g
TWFzayAoYml0IDI5KS4NCj4gPj4NCj4gPj4gVGhpcyBjb3JyZWN0cyBMVUUgYml0Lg0KPiA+DQo+
ID4gSGkgUmF6dmFuDQo+ID4NCj4gPiBJcyB0aGlzIGEgZml4PyBTb21ldGhpbmcgdGhhdCBzaG91
bGQgYmUgYmFjayBwb3J0ZWQgdG8gb2xkIGtlcm5lbHM/DQo+IA0KPiBIZWxsbywNCj4gDQo+IER1
cmluZyB0ZXN0aW5nIEkgZGlkIG5vdCBvYnNlcnZlZCBhbnkgaXNzdWVzIHdpdGggdGhlIG9sZCB2
YWx1ZS4gU28gSSBhbQ0KPiBub3Qgc3VyZSBob3cgdGhlIHN3aXRjaCBpcyBhZmZlY3RlZCBieSB0
aGUgaW5jb3JyZWN0IHNldHRpbmcuDQo+IA0KPiBNYXliZSBtYWludGFpbmVycyB3aWxsIGJlIGFi
bGUgdG8gbWFrZSBhIGJldHRlciBhc3Nlc3NtZW50IGlmIHRoaXMgbmVlZHMNCj4gYmFjay1wb3J0
aW5nLiBBbmQgSSB3aWxsIGJlIGhhcHB5IHRvIGRvIGl0IGlmIGl0IGlzIG5lY2Vzc2FyeS4NCj4g
DQoNCkkgZG8gbm90IHRoaW5rIHRoZSBjaGFuZ2UgaGFzIGFueSBlZmZlY3QgYXMgdGhlIGludGVy
cnVwdCBoYW5kbGluZyBpcyBub3QgaW1wbGVtZW50ZWQgaW4gdGhlIGRyaXZlciwgdW5sZXNzIEkg
YW0gbWlzdGFrZW4gYW5kIGRvIG5vdCBrbm93IGFib3V0IHRoZSBuZXcgY29kZS4NCg0KQ3VycmVu
dGx5IHRob3NlIDMgaW50ZXJydXB0cyBkbyBub3QgZG8gYW55dGhpbmcgdGhhdCBhcmUgcmVxdWly
ZWQgaW4gbm9ybWFsIG9wZXJhdGlvbi4NCg0KVGhlIGZpcnN0IG9uZSBMVUVfSU5UIG5vdGlmaWVz
IHRoZSBkcml2ZXIgd2hlbiB0aGVyZSBhcmUgbGVhcm4vd3JpdGUgZmFpbHMgaW4gdGhlIE1BQyB0
YWJsZS4gIFRoaXMgY29uZGl0aW9uIHJhcmVseSBoYXBwZW5zIHVubGVzcyB0aGUgc3dpdGNoIGlz
IGdvaW5nIHRocm91Z2ggc3RyZXNzIHRlc3QuICBXaGVuIHRoaXMgaW50ZXJydXB0IGhhcHBlbnMg
c29mdHdhcmUgY2Fubm90IGRvIGFueXRoaW5nIHRvIHJlc29sdmUgdGhlIGlzc3VlLiAgSXQgbWF5
IGJlY29tZSBhIGRlbmlhbCBvZiBzZXJ2aWNlIGlmIHRoZSBNQUMgdGFibGUga2VlcHMgdHJpZ2dl
cmluZyBsZWFybiBmYWlsLg0KDQpUaGUgc2Vjb25kIG9uZSBpcyB1c2VkIGJ5IFBUUCBjb2RlLCB3
aGljaCBpcyBub3QgaW1wbGVtZW50ZWQuDQoNClRoZSB0aGlyZCBvbmUgaXMgdHJpZ2dlcmVkIHdo
ZW4gcmVnaXN0ZXIgYWNjZXNzIHNwYWNlIGRvZXMgbm90IGV4aXN0LiAgSXQgaXMgdXNlZnVsIGR1
cmluZyBkZXZlbG9wbWVudCBzbyBkcml2ZXIga25vd3MgaXQgaXMgYWNjZXNzaW5nIHRoZSB3cm9u
ZyByZWdpc3Rlci4gIEl0IGNhbiBhbHNvIGJlY29tZSBhIGRlbmlhbCBvZiBzZXJ2aWNlIGlmIHNv
bWVvbmUga2VlcHMgYWNjZXNzaW5nIHdyb25nIHJlZ2lzdGVycy4gIEJ1dCB0aGVuIHRoYXQgcGVy
c29uIGNhbiBkbyBhbnl0aGluZyB3aXRoIHRoZSBjaGlwLg0KDQo=
