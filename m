Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7321B1C8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGJI4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:56:50 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:44584 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGJI4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594371409; x=1625907409;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=b1wYB1oF7zs2MeckQmtadzxtpNXWQqHnlTv75bX2hTI=;
  b=jnCDqKeMd5ipnXpC0Ca5RYTZOntG5mwhV4zOzXrc1okTHmDPQp1zFNhw
   oxlDm4sFw+eb0K8XSM0kJfhlO9YAlGjfF+ubJ34GTo2Kp2Au94E6XTPRW
   fnt/RxbyQSi94XUc3ySBnaWQYgZwIFZrpdRB+6U6D/GZXeW3koEAWNJUD
   Y=;
IronPort-SDR: cucsDnJhJrfWre8TMVCKFw5nNIlX3XlNJYtUjpDJBudHCQKj6rGUGkz1WwVll2181EeTtcwbtc
 BxaNXlJ17QpQ==
X-IronPort-AV: E=Sophos;i="5.75,335,1589241600"; 
   d="scan'208";a="41112615"
Subject: Re: [PATCH V1 net-next 5/8] net: ena: add support for traffic mirroring
Thread-Topic: [PATCH V1 net-next 5/8] net: ena: add support for traffic mirroring
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jul 2020 08:56:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 9335A1A15E3;
        Fri, 10 Jul 2020 08:56:46 +0000 (UTC)
Received: from EX13D10EUB002.ant.amazon.com (10.43.166.66) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 08:56:46 +0000
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13D10EUB002.ant.amazon.com (10.43.166.66) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 08:56:45 +0000
Received: from EX13D04EUB004.ant.amazon.com ([10.43.166.59]) by
 EX13D04EUB004.ant.amazon.com ([10.43.166.59]) with mapi id 15.00.1497.006;
 Fri, 10 Jul 2020 08:56:45 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWViPvbVjnPiX9SE2ujt3Eaa+oQ6j/sOsAgADS4GU=
Date:   Fri, 10 Jul 2020 08:56:44 +0000
Message-ID: <66BB8666-E728-4EF9-B139-494BF35DB98E@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-6-git-send-email-akiyano@amazon.com>,<20200709132200.60db5881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709132200.60db5881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KPiBPbiBKdWwgOSwgMjAyMCwgYXQgMTE6MjMgUE0s
IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4g77u/Q0FVVElP
TjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9u
LiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBj
b25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4gDQo+IA0K
PiANCj4+IE9uIFRodSwgOSBKdWwgMjAyMCAyMjowNTowMCArMDMwMCBha2l5YW5vQGFtYXpvbi5j
b20gd3JvdGU6DQo+PiBGcm9tOiBBcnRodXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29t
Pg0KPj4gDQo+PiBBZGQgc3VwcG9ydCBmb3IgdHJhZmZpYyBtaXJyb3JpbmcsIHdoZXJlIHRoZSBo
YXJkd2FyZSByZWFkcyB0aGUNCj4+IGJ1ZmZlciBmcm9tIHRoZSBpbnN0YW5jZSBtZW1vcnkgZGly
ZWN0bHkuDQo+PiANCj4+IFRyYWZmaWMgTWlycm9yaW5nIG5lZWRzIGFjY2VzcyB0byB0aGUgcngg
YnVmZmVycyBpbiB0aGUgaW5zdGFuY2UuDQo+PiBUbyBoYXZlIHRoaXMgYWNjZXNzLCB0aGlzIHBh
dGNoOg0KPj4gMS4gQ2hhbmdlcyB0aGUgY29kZSB0byBtYXAgYW5kIHVubWFwIHRoZSByeCBidWZm
ZXJzIGJpZGlyZWN0aW9uYWxseS4NCj4+IDIuIEVuYWJsZXMgdGhlIHJlbGV2YW50IGJpdCBpbiBk
cml2ZXJfc3VwcG9ydGVkX2ZlYXR1cmVzIHRvIGluZGljYXRlDQo+PiAgIHRvIHRoZSBGVyB0aGF0
IHRoaXMgZHJpdmVyIHN1cHBvcnRzIHRyYWZmaWMgbWlycm9yaW5nLg0KPj4gDQo+PiBTaWduZWQt
b2ZmLWJ5OiBBcnRodXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0KPiANCj4gQW55
IG1vcmUgaW5mb3JtYXRpb24/IFlvdSBtYXAgcnggYnVmZmVycyBiaWRpcmVjdGlvbmFsbHksIGRv
ZXNuJ3QgbWVhbg0KPiB0aGUgaW5zdGFuY2UgZG9lc24ndCBtb2RpZnkgdGhlIGJ1ZmZlciBjYXVz
aW5nIHRoZSBtaXJyb3IgdG8gc2VlIGENCj4gbW9kaWZpZWQgZnJhbWUuLiAgRG9lcyB0aGUgaW5z
dGFuY2Ugd2FpdCBzb21laG93IGZvciB0aGUgbWlycm9yIHRvIGJlDQo+IGRvbmUsIG9yIGlzIHRo
ZSBSWCBjb21wbGV0aW9uIG5vdCBnZW5lcmF0ZWQgdW50aWwgbWlycm9yIG9wZXJhdGlvbiBpcw0K
PiBkb25lPw0KDQpSeCBjb21wbGV0aW9uIGlzIG5vdCBnZW5lcmF0ZWQgdW50aWwgbWlycm9yaW5n
IGlzIGRvbmU=
