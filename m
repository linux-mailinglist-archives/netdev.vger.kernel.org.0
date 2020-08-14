Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351F82445BC
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHNHPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:15:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:36696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727814AbgHNHPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 03:15:31 -0400
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 83203560D5CD59C0D5C8;
        Fri, 14 Aug 2020 15:15:29 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 14 Aug 2020 15:15:29 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Fri, 14 Aug 2020 15:15:29 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        "Yadu Kishore" <kyk.segfault@gmail.com>,
        "sowmini.varadhan@oracle.com" <sowmini.varadhan@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: add missing skb_uarg refcount increment in
 pskb_carve_inside_header()
Thread-Topic: [PATCH] net: add missing skb_uarg refcount increment in
 pskb_carve_inside_header()
Thread-Index: AdZyCOwMRQ90pG27RJqKlae5o5FvkA==
Date:   Fri, 14 Aug 2020 07:15:29 +0000
Message-ID: <e9b280b79ba444a68f5279cea77a84bf@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6
DQo+T24gVGh1LCBBdWcgMTMsIDIwMjAgYXQgMjoxNiBQTSBNaWFvaGUgTGluIDxsaW5taWFvaGVA
aHVhd2VpLmNvbT4gd3JvdGU6DQo+Pg0KPj4gSWYgdGhlIHNrYiBpcyB6Y29waWVkLCB3ZSBzaG91
bGQgaW5jcmVhc2UgdGhlIHNrYl91YXJnIHJlZmNvdW50IGJlZm9yZSANCj4+IHdlIGludm9sdmUg
c2tiX3JlbGVhc2VfZGF0YSgpLiBTZWUgcHNrYl9leHBhbmRfaGVhZCgpIGFzIGEgcmVmZXJlbmNl
Lg0KPg0KPkRpZCB5b3UgbWFuYWdlIHRvIG9ic2VydmUgYSBidWcgdGhyb3VnaCB0aGlzIGRhdGFw
YXRoIGluIHByYWN0aWNlPw0KPg0KPnBza2JfY2FydmVfaW5zaWRlX2hlYWRlciBpcyBjYWxsZWQN
Cj4gIGZyb20gcHNrYl9jYXJ2ZQ0KPiAgICBmcm9tIHBza2JfZXh0cmFjdA0KPiAgICAgIGZyb20g
cmRzX3RjcF9kYXRhX3JlY3YNCj4NCj5UaGF0IHJlY2VpdmUgcGF0aCBzaG91bGQgbm90IHNlZSBh
bnkgcGFja2V0cyB3aXRoIHplcm9jb3B5IHN0YXRlIGFzc29jaWF0ZWQuDQo+DQoNClRoaXMgd29y
a3MgZmluZSB5ZXQgYXMgaXRzIGNhbGxlciBpcyBsaW1pdGVkLiBCdXQgd2Ugc2hvdWxkIHRha2Ug
Y2FyZSBvZiB0aGUgc2tiX3VhcmcgcmVmY291bnQgZm9yIGZ1dHVyZSB1c2UuDQpPbiB0aGUgb3Ro
ZXIgaGFuZCwgYmVjYXVzZSB0aGlzIGNvZGVwYXRoIHNob3VsZCBub3Qgc2VlIGFueSBwYWNrZXRz
IHdpdGggemVyb2NvcHkgc3RhdGUgYXNzb2NpYXRlZCwgdGhlbiB3ZQ0Kc2hvdWxkIG5vdCBjYWxs
IHNrYl9vcnBoYW5fZnJhZ3MgaGVyZS4NCg0KVGhhbmtzLg0KDQo+PiBGaXhlczogNmZhMDFjY2Q4
ODMwICgic2tidWZmOiBBZGQgcHNrYl9leHRyYWN0KCkgaGVscGVyIGZ1bmN0aW9uIikNCj4+IFNp
Z25lZC1vZmYtYnk6IE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPg0K
