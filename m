Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0654E21BF49
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGJVfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:35:53 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34199 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJVfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594416952; x=1625952952;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=eb7p+WKU3GvwKRKMFVvy79qAplmLW53i1DcpquCkLj4=;
  b=bqbC3/RGtvjKFleEYZ2Dhk4KXm7AGR4Usz1F9lCDMViHQPjBWBUt7dbv
   EFWebEQeNmUnNvldrUKgzLs2lKZVq9d0kZvU8xYSa5rnkKbSpIIUm7Q+x
   0UBWWOqlybKXYxiH3VwZjefKniQ/534YTa2RxC0k1YeBygc6CxS+OfVGZ
   s=;
IronPort-SDR: PuwBPqOegJmzvt7qkMcVaza0eJBJfP7A6lx5rF5+/2PZIIzV/GeXvisur0q8P0rVHELkWP22iB
 t8Ott9v/nOyw==
X-IronPort-AV: E=Sophos;i="5.75,336,1589241600"; 
   d="scan'208";a="58950808"
Subject: Re: [PATCH V1 net-next 2/8] net: ena: add reserved PCI device ID
Thread-Topic: [PATCH V1 net-next 2/8] net: ena: add reserved PCI device ID
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Jul 2020 21:35:43 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id D4C7EA2412;
        Fri, 10 Jul 2020 21:35:42 +0000 (UTC)
Received: from EX13D11EUB004.ant.amazon.com (10.43.166.188) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 21:35:42 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D11EUB004.ant.amazon.com (10.43.166.188) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 21:35:41 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Fri, 10 Jul 2020 21:35:41 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWViPlvs/eIqhYlky3xR1TmPaacaj/qBcAgAE6ZIA=
Date:   Fri, 10 Jul 2020 21:35:41 +0000
Message-ID: <F0ACB577-7852-4485-99FE-2A477B10DE69@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
 <1594321503-12256-3-git-send-email-akiyano@amazon.com>
 <20200709.125024.1556154096943379616.davem@davemloft.net>
In-Reply-To: <20200709.125024.1556154096943379616.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <26D01AF5EDB4FD46A0AB24E3143D12F0@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA3LzkvMjAsIDE6MDEgUE0sICJEYXZpZCBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PiB3cm90ZToNCg0KDQogICAgRnJvbTogPGFraXlhbm9AYW1hem9uLmNvbT4NCiAgICBEYXRl
OiBUaHUsIDkgSnVsIDIwMjAgMjI6MDQ6NTcgKzAzMDANCg0KICAgID4gRnJvbTogQXJ0aHVyIEtp
eWFub3Zza2kgPGFraXlhbm9AYW1hem9uLmNvbT4NCiAgICA+DQogICAgPiBBZGQgYSByZXNlcnZl
ZCBQQ0kgZGV2aWNlIElEIHRvIHRoZSBkcml2ZXIncyB0YWJsZQ0KICAgID4NCiAgICA+IFNpZ25l
ZC1vZmYtYnk6IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQoNCiAgICBO
byBleHBsYW5hdGlvbiB3aGF0c29ldmVyIHdoYXQgdGhpcyByZXNlcnZlZCBJRCBpcywgd2hhdCBp
dCBpcyB1c2VkDQogICAgZm9yLCBhbmQgd2h5IGl0IHNob3VsZCBiZSB1c2VkIGluIHRoZSBQQ0kg
SUQgdGFibGUgdXNlZCBmb3IgcHJvYmluZw0KICAgIGFuZCBkaXNjb3Zlcnkgb2YgZGV2aWNlcy4N
Cg0KICAgIFlvdSBoYXZlIHRvIGJlIG1vcmUgdmVyYm9zZSB0aGFuIHRoaXMsIHBsZWFzZS4uLg0K
DQpXZSB1c2UgaXQgZm9yIGludGVybmFsIHRlc3RpbmcgcHVycG9zZXMuIFdpbGwgYWRkIHRoaXMg
aW5mbyB0byB0aGUgY29tbWl0IG1lc3NhZ2UuDQoNCg==
