Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812B8559AA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfFYVHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:07:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54138 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561496840; x=1593032840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tBB6w+G8m0sSc5s+hGPKYC7Tyu/VmOxUi4VptS7D7eI=;
  b=d1ocJ4vStEUE+9wod69mV0lP9MJ/ThXy6qmGuFWdJ+bLqWdT3HziLXiY
   os4wPRJWLwrCQkqzGo2RWE20lFEfLP0c7SR+Upcn6dzNySbU0NvUD/qf+
   LHIVWU7zm7grKvPwurNjHlcF7vCTA4FydhvCxLGn6ws6nQI64YnX2P7Xh
   U=;
X-IronPort-AV: E=Sophos;i="5.62,417,1554768000"; 
   d="scan'208";a="807678369"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jun 2019 21:07:18 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 4EE5214161C;
        Tue, 25 Jun 2019 21:07:16 +0000 (UTC)
Received: from EX13D11EUB002.ant.amazon.com (10.43.166.13) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 25 Jun 2019 21:07:16 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D11EUB002.ant.amazon.com (10.43.166.13) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 25 Jun 2019 21:07:15 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Tue, 25 Jun 2019 21:07:15 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>
Subject: Re: [PATCH net-next] Revert "net: ena: ethtool: add extra properties
 retrieval via get_priv_flags"
Thread-Topic: [PATCH net-next] Revert "net: ena: ethtool: add extra properties
 retrieval via get_priv_flags"
Thread-Index: AQHVK3eRzgw8n63hg0msHcAEzSRcYKas1kqA//+RW4A=
Date:   Tue, 25 Jun 2019 21:07:15 +0000
Message-ID: <678E43DE-A5F5-4110-852F-1A8062A5FEC6@amazon.com>
References: <20190625165956.19278-1-jakub.kicinski@netronome.com>
 <20190625.134315.561835619337464509.davem@davemloft.net>
In-Reply-To: <20190625.134315.561835619337464509.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32EE2DC8B7FE044A157AF7A1E377B9B@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgd2UgYWdyZWVkIGR1cmluZyBOZXRjb25mIGRpc2N1c3Npb24gd2UnbGwgbG9vayBpbnRvIG90
aGVyIGFsdGVybmF0aXZlIC0gIHRoZSBkZXZsaW5rIHRvb2wgdGhhdCBzaG91bGQgcG90ZW50aWFs
bHkgYW5zd2VyIG91ciBuZWVkcy4gDQoNCu+7v09uIDYvMjUvMTksIDE6NDMgUE0sICJEYXZpZCBN
aWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PiB3cm90ZToNCg0KICAgIEZyb206IEpha3ViIEtp
Y2luc2tpIDxqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUuY29tPg0KICAgIERhdGU6IFR1ZSwgMjUg
SnVuIDIwMTkgMDk6NTk6NTYgLTA3MDANCiAgICANCiAgICA+IFRoaXMgcmV2ZXJ0cyBjb21taXQg
MzE1YzI4ZDJiNzE0ICgibmV0OiBlbmE6IGV0aHRvb2w6IGFkZCBleHRyYSBwcm9wZXJ0aWVzIHJl
dHJpZXZhbCB2aWEgZ2V0X3ByaXZfZmxhZ3MiKS4NCiAgICA+IA0KICAgID4gQXMgZGlzY3Vzc2Vk
IGF0IG5ldGNvbmYgYW5kIG9uIHRoZSBtYWlsaW5nIGxpc3Qgd2UgY2FuJ3QgYWxsb3cNCiAgICA+
IGZvciB0aGUgdGhlIGFidXNlIG9mIHByaXZhdGUgZmxhZ3MgZm9yIGV4cG9zaW5nIGFyYml0cmFy
eSBkZXZpY2UNCiAgICA+IGxhYmVscy4NCiAgICA+IA0KICAgID4gU2lnbmVkLW9mZi1ieTogSmFr
dWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQogICAgDQogICAgQW1h
em9uIGZvbGtzIEkgdGhpbmsgdGhpcyBpcyBlbnRpcmVseSByZWFzb25hYmxlLCBwbGVhc2UgQUNL
Lg0KICAgIA0KICAgIFRoYW5rcy4NCiAgICANCg0K
