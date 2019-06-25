Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E215251A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfFYHqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:46:20 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:45096 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbfFYHqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 03:46:20 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 284B0C0104;
        Tue, 25 Jun 2019 07:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561448779; bh=pJFkI3fWSyI3YXwgN4D5zBXc+tVZ7/KLL0HehF7gVxc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=fMlug4ukuwi4ANUCTXA4WnCNEE7u2mi346Awn2P4hghOoknLGTN913DmcEhqNCd8A
         wRqVfrjiy4vqQZT5tEQbu6W0tWKfhOH6A+NhU7td1RurqQKep9Y0VDz6M1WMGj4A6w
         UEZiokOlfHgLhAjNV7m7cP5ELhUmRVHD36vrsyCBy8b6RXxOG1iS/EbPLLCJfxG1O0
         yu5uHJx8jzrwa7sVF622+INOiDxU/wKbipdHEIhgMX11d80evELAP4NWxSI3sAt0jJ
         3317bTj/VFqBZ2SJwFFNtgsL4xO4L42KF9xX74dnPKC6yg3mqBf1NsqKXJFYei8noO
         9+j8uVeIdeRSQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 02F9DA0067;
        Tue, 25 Jun 2019 07:46:15 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 25 Jun 2019 00:46:14 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 25 Jun 2019 09:46:12 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: stmmac regression on ASUS TinkerBoard
Thread-Topic: stmmac regression on ASUS TinkerBoard
Thread-Index: AQHVKc4Y+jzSG3DFNE6d1bJbedPjHqar/2Mg
Date:   Tue, 25 Jun 2019 07:46:12 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9D7065@DE02WEMBXB.internal.synopsys.com>
References: <8fa9ce79-6aa2-d44d-e24d-09cc1b2b70a3@katsuster.net>
In-Reply-To: <8fa9ce79-6aa2-d44d-e24d-09cc1b2b70a3@katsuster.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.16]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2F0c3VoaXJvIFN1enVraSA8a2F0c3VoaXJvQGthdHN1c3Rlci5uZXQ+DQoNCj4gSSBj
aGVja2VkIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMg
YW5kIGZvdW5kDQo+IHN0bW1hY19pbml0X3BoeSgpIGlzIGdvaW5nIHRvIGZhaWwgaWYgZXRoZXJu
ZXQgZGV2aWNlIG5vZGUgZG9lcyBub3QNCj4gaGF2ZSBmb2xsb3dpbmcgcHJvcGVydHk6DQo+ICAg
IC0gcGh5LWhhbmRsZQ0KPiAgICAtIHBoeQ0KPiAgICAtIHBoeS1kZXZpY2UNCj4gDQo+IFRoaXMg
Y29tbWl0IGJyb2tlIHRoZSBkZXZpY2UtdHJlZXMgc3VjaCBhcyBUaW5rZXJCb2FyZC4gVGhlIG1k
aW8NCj4gc3Vibm9kZSBjcmVhdGluZyBhIG1kaW8gYnVzIGlzIGNoYW5nZWQgdG8gcmVxdWlyZWQg
b3Igc3RpbGwgb3B0aW9uYWw/DQoNClllYWgsIHdpdGggUEhZTElOSyB0aGUgUEhZIGJpbmRpbmcg
aXMgYWx3YXlzIHJlcXVpcmVkIC4uLg0KDQpIb3cgZG8geW91IHdhbnQgdG8gcHJvY2VlZCA/IEkg
dGhpbmsgRFQgYmluZGluZ3MgY2FuIG5ldmVyIGJyZWFrIGJldHdlZW4gDQpyZWxlYXNlcyBzbyBJ
IHdpbGwgcHJvYmFibHkgbmVlZCB0byBjb29rIGEgcGF0Y2ggZm9yIHN0bW1hYy4NCg0KVGhhbmtz
LA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
