Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EBB1640C6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgBSJtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:49:01 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60568 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBSJtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:49:01 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 01J9mnsY029951, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 01J9mnsY029951
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Feb 2020 17:48:49 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 19 Feb 2020 17:48:49 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 19 Feb 2020 17:48:48 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 19 Feb 2020 17:48:48 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        nic_swsd <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2 12/13] r8152: use new helper tcp_v6_gso_csum_prep
Thread-Topic: [PATCH net-next v2 12/13] r8152: use new helper
 tcp_v6_gso_csum_prep
Thread-Index: AQHV5phMsUMHsElpxUaoxEMxm3ymXagiRPkw
Date:   Wed, 19 Feb 2020 09:48:48 +0000
Message-ID: <42d3acd04d79422aa37715f136497369@realtek.com>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
 <1dd1668a-b3c6-d441-681d-6cbe3ab22fa4@gmail.com>
In-Reply-To: <1dd1668a-b3c6-d441-681d-6cbe3ab22fa4@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVpbmVyIEthbGx3ZWl0IFttYWlsdG86aGthbGx3ZWl0MUBnbWFpbC5jb21dDQo+IFNlbnQ6IFdl
ZG5lc2RheSwgRmVicnVhcnkgMTksIDIwMjAgNDoxMyBBTQ0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0
LW5leHQgdjIgMTIvMTNdIHI4MTUyOiB1c2UgbmV3IGhlbHBlcg0KPiB0Y3BfdjZfZ3NvX2NzdW1f
cHJlcA0KPiANCj4gVXNlIG5ldyBoZWxwZXIgdGNwX3Y2X2dzb19jc3VtX3ByZXAgaW4gYWRkaXRp
b25hbCBuZXR3b3JrIGRyaXZlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdl
aXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KDQpBY2tlZC1ieTogSGF5ZXMgV2FuZyA8aGF5ZXN3
YW5nQHJlYWx0ZWsuY29tPg0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQo=
