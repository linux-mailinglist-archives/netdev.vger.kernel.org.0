Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70936C5C69
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCWB51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCWB5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:57:23 -0400
Received: from 126.com (m126.mail.126.com [220.181.12.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 532DC21A36
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=q545NseQsTRgNhozGkQ9/VJ4Dk+GCAVbo+edHCtxhgQ=; b=I
        5BrkzH/Oi7afkXva93CPsZyiMf6mjk6ApcSIVokeLjRWExUalG5eBHHRBOKXxp1A
        sxU0tpmAZ/aDnYrv0PT0E3n+dW082HsBhSVPqImFXM6YT0DxYotwS6FJ/sY7pQpy
        LUoOKdu/i+naZeWjmwUxhl38McIEFV5W0xa9Jv64Dg=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Thu, 23 Mar 2023 09:53:57 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Thu, 23 Mar 2023 09:53:57 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Horatiu Vultur" <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, david.daney@cavium.com
Subject: Re:Re: [PATCH] net: mdio: thunder: Add missing fwnode_handle_put()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 126com
In-Reply-To: <20230322085538.pn57j2b5dyxizb4o@soft-dev3-1>
References: <20230322062057.1857614-1-windhl@126.com>
 <20230322085538.pn57j2b5dyxizb4o@soft-dev3-1>
X-NTES-SC: AL_QuycC/mYuUwo4SeYbOkXnkwQhu05Ucq4u/8l1YVVP5E0uCrJ+y8fZ3hAPXbN//CiMRyWtx+2cilU5PZxeLlHRoF5n7+FDo5NbprAdqj8jxbF
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <21d42d91.1283.1870c2c39cf.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: _____wDn72M2sRtkv48AAA--.5101W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGg87F1-HarjlhQACsR
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpBdCAyMDIzLTAzLTIyIDE2OjU1OjM4LCAiSG9yYXRpdSBWdWx0dXIiIDxob3JhdGl1LnZ1bHR1
ckBtaWNyb2NoaXAuY29tPiB3cm90ZToKPlRoZSAwMy8yMi8yMDIzIDE0OjIwLCBMaWFuZyBIZSB3
cm90ZToKPj4gCj4+IEluIGRldmljZV9mb3JfZWFjaF9jaGlsZF9ub2RlKCksIHdlIHNob3VsZCBh
ZGQgZndub2RlX2hhbmRsZV9wdXQoKQo+PiB3aGVuIGJyZWFrIG91dCBvZiB0aGUgaXRlcmF0aW9u
IGRldmljZV9mb3JfZWFjaF9jaGlsZF9ub2RlKCkKPj4gYXMgaXQgd2lsbCBhdXRvbWF0aWNhbGx5
IGluY3JlYXNlIGFuZCBkZWNyZWFzZSB0aGUgcmVmY291bnRlci4KPgo+RG9uJ3QgZm9yZ2V0IHRv
IG1lbnRpb24gdGhlIHRyZWUgd2hpY2ggeW91IGFyZSB0YXJnZXRpbmcuCj5JdCBzaG91ZCBiZSBz
b21ldGhpbmcgbGlrZToKPiJbUEFUQ0ggbmV0XSBuZXQ6IG1kaW86IHRodW5kZXI6IEFkZCBtaXNz
aW5nIGZ3bm9kZV9oYW5kbGVfcHV0KCkiIGFuZAo+eW91IGNhbiBhY2hpZXZlIHRoaXMgdXNpbmcg
b3B0aW9uIC0tc3ViamVjdC1wcmVmaXggd2hlbiB5b3UgY3JlYXRlIHlvdXIKPnBhdGNoOgo+Z2l0
IGZvcm1hdC1wYXRjaCAuLi4gLS1zdWJqZWN0LXByZWZpeCAiUEFUQ0ggbmV0Igo+CgpUaGFua3Mg
Zm9yIHlvdXIgcmVwbHkgYW5kIGFkdmlzZSwgSSB3aWxsIGFkZCBpdCBpbiBteSBmdXR1cmUgcGF0
Y2hlcy4KCj4KPj4gCj4+IEZpeGVzOiAzNzlkN2FjN2NhMzEgKCJwaHk6IG1kaW8tdGh1bmRlcjog
QWRkIGRyaXZlciBmb3IgQ2F2aXVtIFRodW5kZXIgU29DIE1ESU8gYnVzZXMuIikKPj4gU2lnbmVk
LW9mZi1ieTogTGlhbmcgSGUgPHdpbmRobEAxMjYuY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvbmV0
L21kaW8vbWRpby10aHVuZGVyLmMgfCAxICsKPj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQo+PiAKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L21kaW8vbWRpby10aHVuZGVyLmMg
Yi9kcml2ZXJzL25ldC9tZGlvL21kaW8tdGh1bmRlci5jCj4+IGluZGV4IDgyMmQyY2RkMmYzNS4u
Mzk0Yjg2NGFhYTM3IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL25ldC9tZGlvL21kaW8tdGh1bmRl
ci5jCj4+ICsrKyBiL2RyaXZlcnMvbmV0L21kaW8vbWRpby10aHVuZGVyLmMKPj4gQEAgLTEwNCw2
ICsxMDQsNyBAQCBzdGF0aWMgaW50IHRodW5kZXJfbWRpb2J1c19wY2lfcHJvYmUoc3RydWN0IHBj
aV9kZXYgKnBkZXYsCj4+ICAgICAgICAgICAgICAgICBpZiAoaSA+PSBBUlJBWV9TSVpFKG5leHVz
LT5idXNlcykpCj4+ICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOwo+PiAgICAgICAgIH0K
Pj4gKyAgICAgICBmd25vZGVfaGFuZGxlX3B1dChmd24pOwo+Cj5DYW4geW91IGRlY2xhcmUgb25s
eSAxIG1kaW8gYnVzIGluIHRoZSBEVCB1bmRlciB0aGlzIHBjaSBkZXZpY2U/Cj5CZWNhdXNlIGlu
IHRoYXQgY2FzZSwgSSBkb24ndCB0aGluayB0aGlzIGlzIGNvcnJlY3QsIGJlY2F1c2UgdGhlbgo+
J2RldmljZV9mb3JfZWFjaF9jaGlsZF9ub2RlJyB3aWxsIGV4aXQgYmVmb3JlIGFsbCA0IG1kaW8g
YnVzZXMgYXJlIHByb2JlZC4KPkFuZCBhY2NvcmRpbmcgdG8gdGhlIGNvbW1lbnRzIGZvciAnZndu
b2RlX2hhbmRsZV9wdXQnIHlvdSBuZWVkIHRvIHVzZQo+d2l0aCBicmVhayBvciByZXR1cm4uCj4K
CkluIGZhY3QsIHRoZSBmd25vZGVfaGFuZGxlX3B1dChmd24pIGNvbnNpZGVyIHRoZSBOVUxMLWNo
ZWNrIG9mIGZ3biwgYW5kIAp0aGVyZSBhcmUgb25seSBicmVhaywgbm90IHJldHVybiwgc28gSSB0
aGluayBpdCBjYW4gd29yayBpbiB0aGlzIGNhc2UuCkhvd2V2ZXIsIGlmIHlvdSBwcmVmZXIgdG8g
YWRkIGZ3bm9kZV9oYW5kbGVfcHV0IGJlZm9yZSBicmVhaywgSSBjYW4Kc2VuZCBhIG5ldyBwYXRj
aC4KClRoYW5rcywKTGlhbmcKCj4+ICAgICAgICAgcmV0dXJuIDA7Cj4+IAo+PiAgZXJyX3JlbGVh
c2VfcmVnaW9uczoKPj4gLS0KPj4gMi4yNS4xCj4+IAo+Cj4tLSAKPi9Ib3JhdGl1Cg==
