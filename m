Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5372BD973
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442670AbfIYIAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:00:04 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9106 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442663AbfIYIAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 04:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569398402; x=1600934402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Shfvyo0ImXjLBdc3+R5WUqFtxA+yMdf8SQNuUzdMxRA=;
  b=oP7md3jiBIeRTQJHSKVnFor+cM+g/A+jYbbt5X1RWTi94W7aQp+nZ2n2
   ztpEdTUO9ehJfbCMUotNTQZT7spxXqxk1xcyb7CCRClgYQPI1mxbqkOWQ
   O4BkyBv43p4C1T5LrbTsPIXd1/D62WJ89/tOlZ/bVa3j1MzEV0GqqVWpw
   k=;
X-IronPort-AV: E=Sophos;i="5.64,547,1559520000"; 
   d="scan'208";a="787240915"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 Sep 2019 08:00:00 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 760A0A05E7;
        Wed, 25 Sep 2019 07:59:59 +0000 (UTC)
Received: from EX13D22EUA002.ant.amazon.com (10.43.165.125) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 25 Sep 2019 07:59:58 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D22EUA002.ant.amazon.com (10.43.165.125) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 25 Sep 2019 07:59:57 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Wed, 25 Sep 2019 07:59:57 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Tal Gilboa <talgi@mellanox.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <uwe@kleine-koenig.org>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] dimlib: make DIMLIB a hidden symbol
Thread-Topic: [PATCH] dimlib: make DIMLIB a hidden symbol
Thread-Index: AQHVb7e0M+d87C6r+0SKPdjxpO2J/ac0ytMAgAdDX9A=
Date:   Wed, 25 Sep 2019 07:59:33 +0000
Deferred-Delivery: Wed, 25 Sep 2019 07:59:15 +0000
Message-ID: <228c9ba04ceb4b728c83adeb379fb564@EX13D22EUA004.ant.amazon.com>
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
 <670cc72f-fef0-a8cf-eb03-25fdb608eea8@mellanox.com>
In-Reply-To: <670cc72f-fef0-a8cf-eb03-25fdb608eea8@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.11]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUYWwgR2lsYm9hIDx0YWxnaUBt
ZWxsYW5veC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDIwLCAyMDE5IDg6MDIgUE0N
Cj4gVG86IFV3ZSBLbGVpbmUtS8O2bmlnIDx1d2VAa2xlaW5lLWtvZW5pZy5vcmc+OyBTYWVlZCBN
YWhhbWVlZA0KPiA8c2FlZWRtQG1lbGxhbm94LmNvbT47IEtpeWFub3Zza2ksIEFydGh1ciA8YWtp
eWFub0BhbWF6b24uY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBkaW1saWI6IG1ha2Ug
RElNTElCIGEgaGlkZGVuIHN5bWJvbA0KPiANCj4gT24gOS8yMC8yMDE5IDQ6MzEgUE0sIFV3ZSBL
bGVpbmUtS8O2bmlnIHdyb3RlOg0KPiA+IEFjY29yZGluZyB0byBUYWwgR2lsYm9hIHRoZSBvbmx5
IGJlbmVmaXQgZnJvbSBESU0gY29tZXMgZnJvbSBhIGRyaXZlcg0KPiA+IHRoYXQgdXNlcyBpdC4g
U28gaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIG1ha2UgdGhpcyBzeW1ib2wgdXNlciB2aXNpYmxl
LA0KPiA+IGluc3RlYWQgYWxsIGRyaXZlcnMgdGhhdCB1c2UgaXQgc2hvdWxkIHNlbGVjdCBpdCAo
YXMgaXMgYWxyZWFkeSB0aGUgY2FzZQ0KPiA+IEFGQUlDVCkuDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBVd2UgS2xlaW5lLUvDtm5pZyA8dXdlQGtsZWluZS1rb2VuaWcub3JnPg0KPiA+IC0tLQ0K
PiA+ICAgbGliL0tjb25maWcgfCAzICstLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2xpYi9LY29uZmln
IGIvbGliL0tjb25maWcNCj4gPiBpbmRleCBjYzA0MTI0ZWQ4ZjcuLjlmZThhMjFmZDE4MyAxMDA2
NDQNCj4gPiAtLS0gYS9saWIvS2NvbmZpZw0KPiA+ICsrKyBiL2xpYi9LY29uZmlnDQo+ID4gQEAg
LTU1NSw4ICs1NTUsNyBAQCBjb25maWcgU0lHTkFUVVJFDQo+ID4gICAJICBJbXBsZW1lbnRhdGlv
biBpcyBkb25lIHVzaW5nIEdudVBHIE1QSSBsaWJyYXJ5DQo+ID4NCj4gPiAgIGNvbmZpZyBESU1M
SUINCj4gPiAtCWJvb2wgIkRJTSBsaWJyYXJ5Ig0KPiA+IC0JZGVmYXVsdCB5DQo+ID4gKwlib29s
DQo+ID4gICAJaGVscA0KPiA+ICAgCSAgRHluYW1pYyBJbnRlcnJ1cHQgTW9kZXJhdGlvbiBsaWJy
YXJ5Lg0KPiA+ICAgCSAgSW1wbGVtZW50cyBhbiBhbGdvcml0aG0gZm9yIGR5bmFtaWNhbGx5IGNo
YW5nZSBDUSBtb2RlcmF0aW9uDQo+IHZhbHVlcw0KPiA+DQo+IFRoZXJlJ3MgYSBwZW5kaW5nIHNl
cmllcyB1c2luZyBESU0gd2hpY2ggZGlkbid0IGFkZCB0aGUgc2VsZWN0IGNsYXVzZQ0KPiBbMV0u
IEFydGh1ciwgRllJLiBPdGhlciB0aGFuIHRoYXQgTEdUTS4NCj4gDQo+IFsxXSBodHRwczovL3d3
dy5tYWlsLWFyY2hpdmUuY29tL25ldGRldkB2Z2VyLmtlcm5lbC5vcmcvbXNnMzE0MzA0Lmh0bWwN
Cg0KVGhhbmtzIFRhbCwgSSBtaXNzZWQgdGhhdC4NCg==
