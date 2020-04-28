Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FED1BC20C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgD1Oz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:55:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58836 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgD1Oz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588085757; x=1619621757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3MZHNktipicg4cEO4n/1/kC9uDxKkqzTZ+Cu+s8r1wc=;
  b=ql4jS1g+WucsYlhNDnE3cVYKN5CgMcIlV61FKkME9zO1tuRq2Iy9Medw
   Htsay9IixfahArcvwgJQGMbsHXmn7NhLgTiEVpUvAGtxRG6PDEpiD6X9j
   X4bK6I83FVme222kiUszYwIofrfd99oBHm+bqaQ8qlPEv5ZPcV1Q3gMds
   I=;
IronPort-SDR: LtBqlManQCsvUv43fuj2bj3eOiHr7DJQKk7vzdvSfqUyRaVQDSiM4d7qOF231/mk08ZZzXWy+o
 ret79dK04ojw==
X-IronPort-AV: E=Sophos;i="5.73,328,1583193600"; 
   d="scan'208";a="29085930"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Apr 2020 14:55:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id C9A00A1D11;
        Tue, 28 Apr 2020 14:55:41 +0000 (UTC)
Received: from EX13D06EUC004.ant.amazon.com (10.43.164.101) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 14:55:41 +0000
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13D06EUC004.ant.amazon.com (10.43.164.101) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 14:55:40 +0000
Received: from EX13D28EUC001.ant.amazon.com ([10.43.164.4]) by
 EX13D28EUC001.ant.amazon.com ([10.43.164.4]) with mapi id 15.00.1497.006;
 Tue, 28 Apr 2020 14:55:40 +0000
From:   "Agroskin, Shay" <shayagr@amazon.com>
To:     Gavin Shan <gshan@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shan.gavin@gmail.com" <shan.gavin@gmail.com>,
        "agrosshay@gmail.com" <agrosshay@gmail.com>
Subject: Re: [PATCH v2] net/ena: Fix build warning in ena_xdp_set()
Thread-Topic: [PATCH v2] net/ena: Fix build warning in ena_xdp_set()
Thread-Index: AQHWHW0VNHFzEvmdV0OlJCS/s0Kxaw==
Date:   Tue, 28 Apr 2020 14:55:40 +0000
Message-ID: <87r1w7fymt.fsf@amazon.com>
References: <20200428044945.123511-1-gshan@redhat.com>
In-Reply-To: <20200428044945.123511-1-gshan@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.65]
Content-Type: text/plain; charset="utf-8"
Content-ID: <43391DA55B808C4FBD13B1ED09C84B85@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPiB3cml0ZXM6DQoNCj4gVGhpcyBmaXhlcyB0
aGUgZm9sbG93aW5nIGJ1aWxkIHdhcm5pbmcgaW4gZW5hX3hkcF9zZXQoKSwgd2hpY2ggaXMNCj4g
b2JzZXJ2ZWQgb24gYWFyY2g2NCB3aXRoIDY0S0IgcGFnZSBzaXplLg0KPg0KPiAgICBJbiBmaWxl
IGluY2x1ZGVkIGZyb20gLi9pbmNsdWRlL25ldC9pbmV0X3NvY2suaDoxOSwNCj4gICAgICAgZnJv
bSAuL2luY2x1ZGUvbmV0L2lwLmg6MjcsDQo+ICAgICAgIGZyb20gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmM6NDY6DQo+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jOiBJbiBmdW5jdGlvbiAgICAgICAgIFwNCj4gICAg4oCY
ZW5hX3hkcF9zZXTigJk6ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFwNCj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0
ZGV2LmM6NTU3OjY6IHdhcm5pbmc6ICAgICAgXA0KPiAgICBmb3JtYXQg4oCYJWx14oCZICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgICBl
eHBlY3RzIGFyZ3VtZW50IG9mIHR5cGUg4oCYbG9uZyB1bnNpZ25lZCBpbnTigJksIGJ1dCBhcmd1
bWVudCA0ICAgICAgXA0KPiAgICBoYXMgdHlwZSDigJhpbnTigJkgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgICBbLVdmb3JtYXQ9XSAiRmFp
bGVkIHRvIHNldCB4ZHAgcHJvZ3JhbSwgdGhlIGN1cnJlbnQgTVRVICglZCkgaXMgICBcDQo+ICAg
IGxhcmdlciB0aGFuIHRoZSBtYXhpbXVtIGFsbG93ZWQgTVRVICglbHUpIHdoaWxlIHhkcCBpcyBv
biIsDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEdhdmluIFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+DQo+
IC0tLQ0KPiB2MjogTWFrZSBFTkFfUEFHRV9TSVpFIHRvIGJlICJ1bnNpZ25lZCBsb25nIiBhbmQg
dmVyaWZ5IG9uIGFhcmNoNjQNCj4gICAgIHdpdGggNEtCIG9yIDY0S0IgcGFnZSBzaXplIGNvbmZp
Z3VyYXRpb24NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9u
ZXRkZXYuaCB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2Vu
YS9lbmFfbmV0ZGV2LmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9uZXRk
ZXYuaA0KPiBpbmRleCA5N2RmZDBjNjdlODQuLjllMTg2MGQ4MTkwOCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmgNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmgNCj4gQEAgLTY5LDcgKzY5
LDcgQEANCj4gICAqIDE2a0IuDQo+ICAgKi8NCj4gICNpZiBQQUdFX1NJWkUgPiBTWl8xNksNCj4g
LSNkZWZpbmUgRU5BX1BBR0VfU0laRSBTWl8xNksNCj4gKyNkZWZpbmUgRU5BX1BBR0VfU0laRSAo
X0FDKFNaXzE2SywgVUwpKQ0KPiAgI2Vsc2UNCj4gICNkZWZpbmUgRU5BX1BBR0VfU0laRSBQQUdF
X1NJWkUNCj4gICNlbmRpZg0KDQp0aGFua3MgZm9yIHRoaXMgZml4DQoNCkFja2VkLWJ5OiBTaGF5
IEFncm9za2luIDxzaGF5YWdyQGFtYXpvbi5jb20+
