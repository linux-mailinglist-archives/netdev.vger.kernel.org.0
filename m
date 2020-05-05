Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC271C5577
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgEEMbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:31:52 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:48547 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgEEMbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 08:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1588681910; x=1620217910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=+aBoaboZDSzKzsJKgWRVHXUqF2kluN7H0I2w2uJb6sY=;
  b=TkQZXONdGSY+9qUv37qAL9C4W0yjeYweJRdlL0KDjUBOO3wSL+XIxgVc
   XM6aou9jgi+m0JLLJJAx7axmVMJgTQ1bCf0xNCeRa0VZcHmV9ZNvkqrkN
   H+Ax29Z+K3YdNTS4pn9lmWUjX9VV8bXiJILffCePgIvHboVmAysDVyJY4
   c=;
IronPort-SDR: 3S/z+O039Ld+1qZBsRIMsaRO+VFPRtckBCFmYdvY1YRGac6bdegbytndXiZ7ENw5watfC/Qovx
 F3+UUjKav76w==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="30121958"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 May 2020 12:31:34 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id CD281A2374;
        Tue,  5 May 2020 12:31:32 +0000 (UTC)
Received: from EX13D31EUB004.ant.amazon.com (10.43.166.164) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 12:31:32 +0000
Received: from EX13D07EUB004.ant.amazon.com (10.43.166.234) by
 EX13D31EUB004.ant.amazon.com (10.43.166.164) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 12:31:30 +0000
Received: from EX13D07EUB004.ant.amazon.com ([10.43.166.234]) by
 EX13D07EUB004.ant.amazon.com ([10.43.166.234]) with mapi id 15.00.1497.006;
 Tue, 5 May 2020 12:31:30 +0000
From:   "Nuernberger, Stefan" <snu@amazon.de>
To:     "Park, Seongjae" <sjpark@amazon.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sj38.park@gmail.com" <sj38.park@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Nuernberger, Stefan" <snu@amazon.de>,
        "sjpark@amazon.de" <sjpark@amazon.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "amit@kernel.org" <amit@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Thread-Topic: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Thread-Index: AQHWItPr1xueohcHCUCHCiTQwPyVa6iZbIwA
Date:   Tue, 5 May 2020 12:31:30 +0000
Message-ID: <1588681890.1374.44.camel@amazon.de>
References: <20200505115402.25768-1-sjpark@amazon.com>
In-Reply-To: <20200505115402.25768-1-sjpark@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.194]
Content-Type: text/plain; charset="utf-8"
Content-ID: <021B6275958C024AB0D307673A446E80@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA1LTA1IGF0IDEzOjU0ICswMjAwLCBTZW9uZ0phZSBQYXJrIHdyb3RlOg0K
PiBDQy1pbmcgc3RhYmxlQHZnZXIua2VybmVsLm9yZyBhbmQgYWRkaW5nIHNvbWUgbW9yZSBleHBs
YW5hdGlvbnMuDQo+IA0KPiBPbiBUdWUsIDUgTWF5IDIwMjAgMTA6MTA6MzMgKzAyMDAgU2VvbmdK
YWUgUGFyayA8c2pwYXJrQGFtYXpvbi5jb20+DQo+IHdyb3RlOg0KPiANCj4gPiANCj4gPiBGcm9t
OiBTZW9uZ0phZSBQYXJrIDxzanBhcmtAYW1hem9uLmRlPg0KPiA+IA0KPiA+IFRoZSBjb21taXQg
NmQ3ODU1YzU0ZTFlICgic29ja2ZzOiBzd2l0Y2ggdG8gLT5mcmVlX2lub2RlKCkiKSBtYWRlDQo+
ID4gdGhlDQo+ID4gZGVhbGxvY2F0aW9uIG9mICdzb2NrZXRfYWxsb2MnIHRvIGJlIGRvbmUgYXN5
bmNocm9ub3VzbHkgdXNpbmcgUkNVLA0KPiA+IGFzDQo+ID4gc2FtZSB0byAnc29jay53cScuwqDC
oEFuZCB0aGUgZm9sbG93aW5nIGNvbW1pdCAzMzNmNzkwOWE4NTcNCj4gPiAoImNvYWxsb2NhdGUN
Cj4gPiBzb2NrZXRfc3Egd2l0aCBzb2NrZXQgaXRzZWxmIikgbWFkZSB0aG9zZSB0byBoYXZlIHNh
bWUgbGlmZSBjeWNsZS4NCj4gPiANCj4gPiBUaGUgY2hhbmdlcyBtYWRlIHRoZSBjb2RlIG11Y2gg
bW9yZSBzaW1wbGUsIGJ1dCBhbHNvIG1hZGUNCj4gPiAnc29ja2V0X2FsbG9jJw0KPiA+IGxpdmUg
bG9uZ2VyIHRoYW4gYmVmb3JlLsKgwqBGb3IgdGhlIHJlYXNvbiwgdXNlciBwcm9ncmFtcyBpbnRl
bnNpdmVseQ0KPiA+IHJlcGVhdGluZyBhbGxvY2F0aW9ucyBhbmQgZGVhbGxvY2F0aW9ucyBvZiBz
b2NrZXRzIGNvdWxkIGNhdXNlDQo+ID4gbWVtb3J5DQo+ID4gcHJlc3N1cmUgb24gcmVjZW50IGtl
cm5lbHMuDQo+IEkgZm91bmQgdGhpcyBwcm9ibGVtIG9uIGEgcHJvZHVjdGlvbiB2aXJ0dWFsIG1h
Y2hpbmUgdXRpbGl6aW5nIDRHQg0KPiBtZW1vcnkgd2hpbGUNCj4gcnVubmluZyBsZWJlbmNoWzFd
LsKgwqBUaGUgJ3BvbGwgYmlnJyB0ZXN0IG9mIGxlYmVuY2ggb3BlbnMgMTAwMA0KPiBzb2NrZXRz
LCBwb2xscw0KPiBhbmQgY2xvc2VzIHRob3NlLsKgwqBUaGlzIHRlc3QgaXMgcmVwZWF0ZWQgMTAs
MDAwIHRpbWVzLsKgwqBUaGVyZWZvcmUgaXQNCj4gc2hvdWxkDQo+IGNvbnN1bWUgb25seSAxMDAw
ICdzb2NrZXRfYWxsb2MnIG9iamVjdHMgYXQgb25jZS7CoMKgQXMgc2l6ZSBvZg0KPiBzb2NrZXRf
YWxsb2MgaXMNCj4gYWJvdXQgODAwIEJ5dGVzLCBpdCdzIG9ubHkgODAwIEtpQi7CoMKgSG93ZXZl
ciwgb24gdGhlIHJlY2VudCBrZXJuZWxzLA0KPiBpdCBjb3VsZA0KPiBjb25zdW1lIHVwIHRvIDEw
LDAwMCwwMDAgb2JqZWN0cyAoYWJvdXQgOCBHaUIpLsKgwqBPbiB0aGUgdGVzdCBtYWNoaW5lLA0K
PiBJDQo+IGNvbmZpcm1lZCBpdCBjb25zdW1pbmcgYWJvdXQgNEdCIG9mIHRoZSBzeXN0ZW0gbWVt
b3J5IGFuZCByZXN1bHRzIGluDQo+IE9PTS4NCj4gDQo+IFsxXSBodHRwczovL2dpdGh1Yi5jb20v
TGludXhQZXJmU3R1ZHkvTEVCZW5jaA0KPiANCj4gPiANCj4gPiANCj4gPiBUbyBhdm9pZCB0aGUg
cHJvYmxlbSwgdGhpcyBjb21taXQgcmV2ZXJ0cyB0aGUgY2hhbmdlcy4NCj4gSSBhbHNvIHRyaWVk
IHRvIG1ha2UgZml4dXAgcmF0aGVyIHRoYW4gcmV2ZXJ0cywgYnV0IEkgY291bGRuJ3QgZWFzaWx5
DQo+IGZpbmQNCj4gc2ltcGxlIGZpeHVwLsKgwqBBcyB0aGUgY29tbWl0cyA2ZDc4NTVjNTRlMWUg
YW5kIDMzM2Y3OTA5YTg1NyB3ZXJlIGZvcg0KPiBjb2RlDQo+IHJlZmFjdG9yaW5nIHJhdGhlciB0
aGFuIHBlcmZvcm1hbmNlIG9wdGltaXphdGlvbiwgSSB0aG91Z2h0DQo+IGludHJvZHVjaW5nIGNv
bXBsZXgNCj4gZml4dXAgZm9yIHRoaXMgcHJvYmxlbSB3b3VsZCBtYWtlIG5vIHNlbnNlLsKgwqBN
ZWFud2hpbGUsIHRoZSBtZW1vcnkNCj4gcHJlc3N1cmUNCj4gcmVncmVzc2lvbiBjb3VsZCBhZmZl
Y3QgcmVhbCBtYWNoaW5lcy7CoMKgVG8gdGhpcyBlbmQsIEkgZGVjaWRlZCB0bw0KPiBxdWlja2x5
DQo+IHJldmVydCB0aGUgY29tbWl0cyBmaXJzdCBhbmQgY29uc2lkZXIgYmV0dGVyIHJlZmFjdG9y
aW5nIGxhdGVyLg0KPiANCg0KV2hpbGUgbGViZW5jaCBtaWdodCBiZSBleGVyY2lzaW5nIGEgcmF0
aGVyIHBhdGhvbG9naWNhbCBjYXNlLCB0aGUNCmluY3JlYXNlIGluIG1lbW9yeSBwcmVzc3VyZSBp
cyByZWFsLiBJIGFtIGNvbmNlcm5lZCB0aGF0IHRoZSBPT00ga2lsbGVyDQppcyBhY3R1YWxseSBl
bmdhZ2luZyBhbmQga2lsbGluZyBvZmYgcHJvY2Vzc2VzIHdoZW4gdGhlcmUgYXJlIGxvdHMgb2YN
CnJlc291cmNlcyBhbHJlYWR5IG1hcmtlZCBmb3IgcmVsZWFzZS4gVGhpcyBtaWdodCBiZSB0cnVl
IGZvciBvdGhlcg0KbGF6eS9kZWxheWVkIHJlc291cmNlIGRlYWxsb2NhdGlvbiwgdG9vLiBUaGlz
IGhhcyBvYnZpb3VzbHkganVzdCBiZWNvbWUNCnRvbyBsYXp5IGN1cnJlbnRseS4NCg0KU28gZm9y
IGJvdGggcmV2ZXJ0czoNCg0KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBOdWVybmJlcmdlciA8c251QGFt
YXpvbi5jb20+DQoNCj4gDQo+IFRoYW5rcywNCj4gU2VvbmdKYWUgUGFyaw0KPiANCj4gPiANCj4g
PiANCj4gPiBTZW9uZ0phZSBQYXJrICgyKToNCj4gPiDCoCBSZXZlcnQgImNvYWxsb2NhdGUgc29j
a2V0X3dxIHdpdGggc29ja2V0IGl0c2VsZiINCj4gPiDCoCBSZXZlcnQgInNvY2tmczogc3dpdGNo
IHRvIC0+ZnJlZV9pbm9kZSgpIg0KPiA+IA0KPiA+IMKgZHJpdmVycy9uZXQvdGFwLmPCoMKgwqDC
oMKgwqB8wqDCoDUgKysrLS0NCj4gPiDCoGRyaXZlcnMvbmV0L3R1bi5jwqDCoMKgwqDCoMKgfMKg
wqA4ICsrKysrLS0tDQo+ID4gwqBpbmNsdWRlL2xpbnV4L2lmX3RhcC5oIHzCoMKgMSArDQo+ID4g
wqBpbmNsdWRlL2xpbnV4L25ldC5owqDCoMKgwqB8wqDCoDQgKystLQ0KPiA+IMKgaW5jbHVkZS9u
ZXQvc29jay5owqDCoMKgwqDCoHzCoMKgNCArKy0tDQo+ID4gwqBuZXQvY29yZS9zb2NrLmPCoMKg
wqDCoMKgwqDCoMKgfMKgwqAyICstDQo+ID4gwqBuZXQvc29ja2V0LmPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgfCAyMyArKysrKysrKysrKysrKysrLS0tLS0tLQ0KPiA+IMKgNyBmaWxlcyBjaGFuZ2Vk
LCAzMCBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCj4gPiAKCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdl
c2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWlu
Z2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBC
ClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

