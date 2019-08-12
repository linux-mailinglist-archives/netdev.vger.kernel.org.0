Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF96E89978
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfHLJJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:09:05 -0400
Received: from mail-eopbgr690059.outbound.protection.outlook.com ([40.107.69.59]:51550
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfHLJJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 05:09:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ay7u6b9MletrAMoUMclpvOzkT/1RiR0esnqsTN08e8LygOXMm30DMhbcA0LkQkCFAF8/yw2gHEGkfW+5YVbB3V/RHXB8sFKwX+Xmhgj0Ykijhw/xd/J8vp2ISGDeGo9kJsvWN5EaBjMEyvx2a8Me2Tl4QB8X+IWAecEVgBQi/iAuTVo2kZEiB8/WTqAf7zt9D2LULBdmbBZLGoPph38fspxKHry7lUHOaACNeDQFTlQLY5bL8UONX+BJcsjzZNBd0y1xotEX7Fxc409XToGpUeRXWGkT9uKqAfXVrkdH6mJM+Z9zDZajl4MWweJDHIvdhOZasUuRZml+vlru8kLCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiK13efeEm3dlZeHqPRjqCDNvU9HxRAs9HcHrtRxLhY=;
 b=Ficay3cfLvAwT2zL3w0TvZSFKyYjhR0PgOfCUX28o2S1+FHmxxTKt6b+eWF7V+PeKDpRFB/VHdVU8bTwUQEnMOiYeX1qScFbLsT+8uAGosYshBPX7jb3s0dOrSt4zCPYJ9wsVW6JDoIlPM2RP/qT4nT1w9W+wZuoGPDBpJQxTCOT2qmHulVD98D3gWw2uKcHb8AvPNkuYY1SyNUnJ3BjtTF3uwasypFOc7TIBk+lFHseOL/bvNS+mapaUaiCR5Y/Q3rnn+IQnEfJNaiHCO0hQ4O8Oz9P7e/sz+MOV8PzZD/wpnYQ7vE2H5FvBMufj/k1rolfw48JVSDstdgYJRt5rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiK13efeEm3dlZeHqPRjqCDNvU9HxRAs9HcHrtRxLhY=;
 b=kypAAZs4Ayh+PFCzyaLCoPbXB1J9tDZp6lif3/YrDNrPLvij5H3O5XlJeCc67lyaFvUnIhAFsm6HNSDr2xqvZI/8hN+quTudOcwQegTL8ZCgMkbsAsdvE9DtUHt7tbJJNlm7BlaUTUh4RF3KOqugJnsh0+npLOOcO7TnBTQL/I0=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.175.209) by
 MN2PR02MB6159.namprd02.prod.outlook.com (52.132.173.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Mon, 12 Aug 2019 09:09:00 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::51c3:4e3a:8313:28e7]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::51c3:4e3a:8313:28e7%7]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 09:09:00 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] can: xilinx_can: Bug fixes
Thread-Topic: [PATCH 0/5] can: xilinx_can: Bug fixes
Thread-Index: AQHVUN+Ueujr2fKcnUmbqsrZYQu7V6b3OIQAgAAAlIA=
Date:   Mon, 12 Aug 2019 09:09:00 +0000
Message-ID: <MN2PR02MB640099F65EBB5A6805B94F9ADCD30@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
 <7ecaa7df-3202-21d8-de93-5f6af3582964@pengutronix.de>
In-Reply-To: <7ecaa7df-3202-21d8-de93-5f6af3582964@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c55f5c00-c0e4-4bd2-3977-08d71f04b6e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR02MB6159;
x-ms-traffictypediagnostic: MN2PR02MB6159:
x-ms-exchange-purlcount: 1
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB61594F5DDB69DB7C83E792EBDCD30@MN2PR02MB6159.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(189003)(51914003)(6116002)(7736002)(74316002)(305945005)(186003)(229853002)(26005)(25786009)(3846002)(966005)(71200400001)(6246003)(52536014)(71190400001)(66066001)(6636002)(53386004)(99286004)(6306002)(316002)(8676002)(9686003)(5660300002)(7696005)(2906002)(81156014)(110136005)(76176011)(54906003)(55016002)(4326008)(102836004)(53936002)(2201001)(81166006)(8936002)(86362001)(6506007)(53546011)(478600001)(6436002)(14454004)(486006)(446003)(11346002)(66446008)(476003)(76116006)(64756008)(66556008)(66476007)(66946007)(2501003)(256004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6159;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rCcyrkyu7LXBt6BBKGeZbYQpPK7k/erKzFBFz/HfPgOYN1CiRLpg5VipaySZ5oSuok/uKtPTrTgILw48L4Jq23+8YF3b2biHrOWYrQYLFfhSJKnrFcN+Iwmo3sbZ9OzTtYNQnfEATuZR8HcAhisSsHZl79ROavjbAushAEg5b2lqFMLiB76aL6fM07P8FPoCdwkaln+ZhQD4iW7S4thSaiLa8RXLx1oz35fhads6AtmNm7hhXQeouJHcPUUyXhHYrYhqnmAZfVtFzO2GcQCwkfrq4QNVSxwiVER6P/hm6LmbZZC75BizRSLo/T+fKhSzAGY6ABppRE2eQMc5PqXokAQoSLpT9eBvyhVhxgt4YfeGFaV7+/nCvXyVxNJHbUVA7FrtPNXoU++DLvQ2y4ECBigjh4xEy9IsrS1VJ/ncMqk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c55f5c00-c0e4-4bd2-3977-08d71f04b6e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 09:09:00.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jzcp1GjVXRZhCycnJtU8KaXjVBfCyyYpVDU+8AbCnmabUoL93FpIOqaLQ8z1hxNCHBVrYhN9i8ZLdiXz+8e1hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQo8U25pcD4gDQo+IE9uIDgvMTIv
MTkgOToyOCBBTSwgQXBwYW5hIER1cmdhIEtlZGFyZXN3YXJhIHJhbyB3cm90ZToNCj4gPiBUaGlz
IHBhdGNoIHNlcmllcyBmaXhlcyBiZWxvdyBpc3N1ZXMNCj4gPiAtLT4gQnVncyBpbiB0aGUgZHJp
dmVyIHcuci50byBDQU5GRCAyLjAgSVAgc3VwcG9ydCBEZWZlciB0aGUgcHJvYmUgaWYNCj4gPiAt
LT4gY2xvY2sgaXMgbm90IGZvdW5kDQo+ID4NCj4gPiBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEg
cmFvICgzKToNCj4gPiAgIGNhbjogeGlsaW54X2NhbjogRml4IEZTUiByZWdpc3RlciBoYW5kbGlu
ZyBpbiB0aGUgcnggcGF0aA0KPiA+ICAgY2FuOiB4aWxpbnhfY2FuOiBGaXggdGhlIGRhdGEgdXBk
YXRpb24gbG9naWMgZm9yIENBTkZEIEZEIGZyYW1lcw0KPiA+ICAgY2FuOiB4aWxpbnhfY2FuOiBG
aXggRlNSIHJlZ2lzdGVyIEZMIGFuZCBSSSBtYXNrIHZhbHVlcyBmb3IgY2FuZmQNCj4gPiAyLjAN
Cj4gPg0KPiA+IFNyaW5pdmFzIE5lZWxpICgxKToNCj4gPiAgIGNhbjogeGlsaW54X2NhbjogRml4
IHRoZSBkYXRhIHBoYXNlIGJ0cjEgY2FsY3VsYXRpb24NCj4gPg0KPiA+IFZlbmthdGVzaCBZYWRh
diBBYmJhcmFwdSAoMSk6DQo+ID4gICBjYW46IHhpbGlueF9jYW46IGRlZmVyIHRoZSBwcm9iZSBp
ZiBjbG9jayBpcyBub3QgZm91bmQNCj4gDQo+IFBsZWFzZSBhZGQgeW91ciBTLW8tYiB0byBwYXRj
aGVzIDQrNS4NCj4gDQo+IEFzIHRoZXNlIGFsbCBhcmUgYnVnZml4ZXMgcGxlYXNlIGFkZCBhIHJl
ZmVyZW5jZSB0byB0aGUgY29tbWl0IGl0IGZpeGVzOg0KPiANCj4gICAgIEZpeGVzOiBjb21taXRp
c2ggKCJkZXNjcmlwdGlvbiIpDQoNClN1cmUgd2lsbCBmaXggaW4gdjIuLi4gDQoNClJlZ2FyZHMs
DQpLZWRhci4gDQoNCj4gDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAg
ICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEluZHVzdHJp
YWwgTGludXggU29sdXRpb25zICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8
DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAgICAgICAgICB8IEZheDogICArNDktNTEyMS0y
MDY5MTctNTU1NSB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2ICB8IGh0dHA6
Ly93d3cucGVuZ3V0cm9uaXguZGUgICB8DQoNCg==
