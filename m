Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B2F12C31C
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 16:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfL2PVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 10:21:54 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:60591 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfL2PVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 10:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577632913; x=1609168913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eByfHb4h6w802Ivr0ZpiXkOWLx4+alvaDzYckZ0drHY=;
  b=ci0063RUm9cPJJoWN233TRyW3bRPemGPUXbxJwf8VDz5FOaShfY5kMt4
   /4oUwst4BSH3UtTbHcl6Vvr5Vil+QaTEwSVhJ6hRYrhRJrzqhY+XA6wWM
   cQMbIfdASDLWGwSPwHOMlpqjN/y/PIA6ISCzG2NbHH4x4pjay5Zr9wKam
   Q=;
IronPort-SDR: 9uArL40VCC3UyzJL470wwBxmevRUKWAbr9m3V0QPyw11dbKsgmJq+NBgmyDYTssfuHpH9Qz9vC
 S1r0dHe6CKfg==
X-IronPort-AV: E=Sophos;i="5.69,371,1571702400"; 
   d="scan'208";a="17276655"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 29 Dec 2019 15:21:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id DD7ACA1F02;
        Sun, 29 Dec 2019 15:21:39 +0000 (UTC)
Received: from EX13D22EUA003.ant.amazon.com (10.43.165.210) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Sun, 29 Dec 2019 15:21:39 +0000
Received: from EX13D06EUA003.ant.amazon.com (10.43.165.206) by
 EX13D22EUA003.ant.amazon.com (10.43.165.210) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 29 Dec 2019 15:21:38 +0000
Received: from EX13D06EUA003.ant.amazon.com ([10.43.165.206]) by
 EX13D06EUA003.ant.amazon.com ([10.43.165.206]) with mapi id 15.00.1367.000;
 Sun, 29 Dec 2019 15:21:37 +0000
From:   "Belgazal, Netanel" <netanel@amazon.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: Re: [PATCH V1 net] MAINTAINERS: Add additional maintainers to ENA
 Ethernet driver
Thread-Topic: [PATCH V1 net] MAINTAINERS: Add additional maintainers to ENA
 Ethernet driver
Thread-Index: AQHVvllty4BNSMXu/0Kh8b8XSyw0CqfRXCaA
Date:   Sun, 29 Dec 2019 15:21:37 +0000
Message-ID: <B77B1A34-FC14-47F9-A761-7618B7462615@amazon.com>
References: <20191229150518.28771-1-netanel@amazon.com>
In-Reply-To: <20191229150518.28771-1-netanel@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.10.f.191014
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.110]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EA8401B49DC7248B2A5D5BADD7CC612@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiAxMi8yOS8xOSwgNTowNSBQTSwgIk5ldGFuZWwgQmVsZ2F6YWwiIDxuZXRhbmVsQGFt
YXpvbi5jb20+IHdyb3RlOg0KDQogICAgU2lnbmVkLW9mZi1ieTogTmV0YW5lbCBCZWxnYXphbCA8
bmV0YW5lbEBhbWF6b24uY29tPg0KICAgIC0tLQ0KICAgICBNQUlOVEFJTkVSUyB8IDIgKysNCiAg
ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KICAgIA0KICAgIGRpZmYgLS1naXQg
YS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQogICAgaW5kZXggYTA0OWFiY2NhYTI2Li5iYzM3
MzZhZGU4OGIgMTAwNjQ0DQogICAgLS0tIGEvTUFJTlRBSU5FUlMNCiAgICArKysgYi9NQUlOVEFJ
TkVSUw0KICAgIEBAIC03NzEsNiArNzcxLDggQEAgRjoJZHJpdmVycy90aGVybWFsL3RoZXJtYWxf
bW1pby5jDQogICAgIA0KICAgICBBTUFaT04gRVRIRVJORVQgRFJJVkVSUw0KICAgICBNOglOZXRh
bmVsIEJlbGdhemFsIDxuZXRhbmVsQGFtYXpvbi5jb20+DQogICAgK006CUFydGh1ciBLaXlhbm92
c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgK1I6CUd1eSBUemFsaWsgPGd0emFsaWtAYW1h
em9uLmNvbT4NCiAgICAgUjoJU2FlZWQgQmlzaGFyYSA8c2FlZWRiQGFtYXpvbi5jb20+DQogICAg
IFI6CVpvcmlrIE1hY2h1bHNreSA8em9yaWtAYW1hem9uLmNvbT4NCiAgICAgTDoJbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KICAgIC0tIA0KICAgIDIuMTcuMg0KICAgIA0KU29ycnksIHJlc2VudCBt
eSBtaXN0YWtlLg0KUGxlYXNlIGlnbm9yZS4NCiAgICANCg0K
