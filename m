Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E841D84CE4
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfHGNZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:25:54 -0400
Received: from skedge04.snt-world.com ([91.208.41.69]:56654 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388268AbfHGNZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 09:25:51 -0400
Received: from sntmail10s.snt-is.com (unknown [10.203.32.183])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 6FFF967F489;
        Wed,  7 Aug 2019 15:25:49 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail10s.snt-is.com
 (10.203.32.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 7 Aug 2019
 15:25:49 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Wed, 7 Aug 2019 15:25:49 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: Allow the driver to be built for ARM64 SoCs
 such as i.MX8
Thread-Topic: [PATCH] net: fec: Allow the driver to be built for ARM64 SoCs
 such as i.MX8
Thread-Index: AQHVTRVujOeFcyg/q0+D2PWjkrvdsabveUKAgAASSwA=
Date:   Wed, 7 Aug 2019 13:25:49 +0000
Message-ID: <4041e43f-cab2-0ec9-53fa-2e36ba1220cf@kontron.de>
References: <20190807114332.13312-1-frieder.schrempf@kontron.de>
 <20190807114332.13312-2-frieder.schrempf@kontron.de>
 <CAOMZO5C61NjX5=7FJj7WpQW=cSvBRi4ADKonUp3CRXtUkSqwCQ@mail.gmail.com>
In-Reply-To: <CAOMZO5C61NjX5=7FJj7WpQW=cSvBRi4ADKonUp3CRXtUkSqwCQ@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <A44EF76706086247BA82CECAD8E4242C@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 6FFF967F489.A07A2
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: claudiu.manoil@nxp.com, davem@davemloft.net,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ruxandra.radulescu@nxp.com,
        tglx@linutronix.de, yangbo.lu@nxp.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcuMDguMTkgMTQ6MjAsIEZhYmlvIEVzdGV2YW0gd3JvdGU6DQo+IEhpIEZyaWVkZXIsDQo+
IA0KPiBPbiBXZWQsIEF1ZyA3LCAyMDE5IGF0IDk6MDQgQU0gU2NocmVtcGYgRnJpZWRlcg0KPiA8
ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPiB3cm90ZToNCj4+DQo+PiBGcm9tOiBGcmllZGVy
IFNjaHJlbXBmIDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+DQo+Pg0KPj4gVGhlIEZFQyBl
dGhlcm5ldCBjb250cm9sbGVyIGlzIHVzZWQgaW4gc29tZSBBUk02NCBTb0NzIHN1Y2ggYXMgaS5N
WDguDQo+PiBUbyBtYWtlIHVzZSBvZiBpdCwgYXBwZW5kIEFSTTY0IHRvIHRoZSBsaXN0IG9mIGRl
cGVuZGVuY2llcy4NCj4gDQo+IEFSQ0hfTVhDIGlzIGFsc28gdXNlZCBieSBpLk1YOCwgc28gdGhl
cmUgaXMgbm8gbmVlZCBmb3Igc3VjaCBjaGFuZ2UuDQoNCllvdSdyZSByaWdodCBvZiBjb3Vyc2Uu
IEkgc29tZWhvdyBtYW5hZ2VkIHRvIG1lc3MgdXAgbXkgZGVmY29uZmlnLiBJIA0Kc3RhcnRlZCBv
dmVyIHdpdGggYSBjbGVhbiBjb25maWcgZnJvbSBhcmNoL2FybTY0L2NvbmZpZ3MvZGVmY29uZmln
IGFuZCANCmV2ZXJ5dGhpbmcgc2VlbXMgZmluZSBub3cuIFNvcnJ5IGZvciB0aGUgbm9pc2UuDQoN
Cj4gDQo+IEJ5IHRoZSB3YXk6IGFyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcgaGFzIENPTkZJ
R19GRUM9eSBieSBkZWZhdWx0Lg0KPiA=
