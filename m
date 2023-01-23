Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690E5677D95
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjAWOGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjAWOGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:06:43 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54B44C21;
        Mon, 23 Jan 2023 06:06:41 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id E083810389FB;
        Mon, 23 Jan 2023 17:06:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru E083810389FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1674482800; bh=n7RVdhcVkO+AmN0igLFV5fU8una/MboowXmwC5E43tw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=T/cLtE14hhKne49SgCQ+nrXiUH5xP7ae0yQ/z+Jb5skLPsd2GRrOGAUiNKVYVpHEH
         ZVMJQ95Ln4puZWWLpeGtsqO6FWG1tZUiR0Gp+QfDocqeugjoSn16GncDenxNpvmp3o
         X7Yi9VxQ0jStEUMxwZuDfBxpC1Bjt/ekeI0eCi8E=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id DD3B730E0CA4;
        Mon, 23 Jan 2023 17:06:39 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Joe Perches <joe@perches.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Topic: [PATCH] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Index: AQHZLy6nPel+9vJLcUy5hm2kN75FKq6r1zSA
Date:   Mon, 23 Jan 2023 14:06:39 +0000
Message-ID: <fbc11588-ac61-4fcb-a8fa-c03dba098fba@infotecs.ru>
References: <20230123081957.1380790-1-Ilia.Gavrilov@infotecs.ru>
 <Y86Lji5prQEAxKLi@unreal>
In-Reply-To: <Y86Lji5prQEAxKLi@unreal>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC82A1241E7BBF4BB27587A873327034@infotecs.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174927 [Jan 23 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_msgid_8}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/23 12:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/23 00:37:00 #20794104
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0K0KEg0YPQstCw0LbQtdC90LjQtdC8LA0K0JjQu9GM0Y8g0JPQsNCy0YDQuNC70L7Qsg0K
0JLQtdC00YPRidC40Lkg0L/RgNC+0LPRgNCw0LzQvNC40YHRgg0K0J7RgtC00LXQuyDRgNCw0LfR
gNCw0LHQvtGC0LrQuA0K0JDQniAi0JjQvdGE0L7QotC10JrQoSIg0LIg0LMuINCh0LDQvdC60YIt
0J/QtdGC0LXRgNCx0YPRgNCzDQoxMjcyODcsINCzLiDQnNC+0YHQutCy0LAsINCh0YLQsNGA0YvQ
uSDQn9C10YLRgNC+0LLRgdC60L4t0KDQsNC30YPQvNC+0LLRgdC60LjQuSDQv9GA0L7QtdC30LQs
INC00L7QvCAxLzIzLCDRgdGC0YAuIDENClQ6ICs3IDQ5NSA3MzctNjEtOTIgKCDQtNC+0LEuIDQ5
MjEpDQrQpDogKzcgNDk1IDczNy03Mi03OA0KDQoNCklsaWEuR2F2cmlsb3ZAaW5mb3RlY3MucnUN
Cnd3dy5pbmZvdGVjcy5ydQ0KDQoNCk9uIDEvMjMvMjMgMTY6MjgsIExlb24gUm9tYW5vdnNreSB3
cm90ZToNCj4gT24gTW9uLCBKYW4gMjMsIDIwMjMgYXQgMDg6MTk6NTBBTSArMDAwMCwgR2F2cmls
b3YgSWxpYSB3cm90ZToNCj4+IFRoZSBzdGF0aWMgJ3NlcV9wcmludF9hY2N0JyBmdW5jdGlvbiBh
bHdheXMgcmV0dXJucyAwLg0KPj4NCj4+IENoYW5nZSB0aGUgcmV0dXJuIHZhbHVlIHRvICd2b2lk
JyBhbmQgcmVtb3ZlIHVubmVjZXNzYXJ5IGNoZWNrcy4NCj4+DQo+PiBGb3VuZCBieSBJbmZvVGVD
UyBvbiBiZWhhbGYgb2YgTGludXggVmVyaWZpY2F0aW9uIENlbnRlcg0KPj4gKGxpbnV4dGVzdGlu
Zy5vcmcpIHdpdGggU1ZBQ0UuDQo+Pg0KPj4gRml4ZXM6IDFjYTllNDE3NzBjYiAoIm5ldGZpbHRl
cjogUmVtb3ZlIHVzZXMgb2Ygc2VxXzxmb28+IHJldHVybiB2YWx1ZXMiKQ0KPj4gU2lnbmVkLW9m
Zi1ieTogSWxpYS5HYXZyaWxvdiA8SWxpYS5HYXZyaWxvdkBpbmZvdGVjcy5ydT4NCj4+IC0tLQ0K
Pj4gICBuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19zdGFuZGFsb25lLmMgfCAyNiArKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCsp
LCAxNiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfc3RhbmRhbG9uZS5jIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfc3RhbmRh
bG9uZS5jDQo+PiBpbmRleCAwMjUwNzI1ZTM4YTQuLmJlZTk5ZDRiY2YzNiAxMDA2NDQNCj4+IC0t
LSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3N0YW5kYWxvbmUuYw0KPj4gKysrIGIvbmV0
L25ldGZpbHRlci9uZl9jb25udHJhY2tfc3RhbmRhbG9uZS5jDQo+PiBAQCAtMjc1LDIyICsyNzUs
MTggQEAgc3RhdGljIGNvbnN0IGNoYXIqIGw0cHJvdG9fbmFtZSh1MTYgcHJvdG8pDQo+PiAgIHJl
dHVybiAidW5rbm93biI7DQo+PiAgIH0NCj4+DQo+PiAtc3RhdGljIHVuc2lnbmVkIGludA0KPj4g
K3N0YXRpYyB2b2lkDQo+PiAgIHNlcV9wcmludF9hY2N0KHN0cnVjdCBzZXFfZmlsZSAqcywgY29u
c3Qgc3RydWN0IG5mX2Nvbm4gKmN0LCBpbnQgZGlyKQ0KPj4gICB7DQo+PiAtc3RydWN0IG5mX2Nv
bm5fYWNjdCAqYWNjdDsNCj4+IC1zdHJ1Y3QgbmZfY29ubl9jb3VudGVyICpjb3VudGVyOw0KPj4g
K3N0cnVjdCBuZl9jb25uX2FjY3QgKmFjY3QgPSBuZl9jb25uX2FjY3RfZmluZChjdCk7DQo+Pg0K
Pj4gLWFjY3QgPSBuZl9jb25uX2FjY3RfZmluZChjdCk7DQo+PiAtaWYgKCFhY2N0KQ0KPj4gLXJl
dHVybiAwOw0KPj4gLQ0KPj4gLWNvdW50ZXIgPSBhY2N0LT5jb3VudGVyOw0KPj4gLXNlcV9wcmlu
dGYocywgInBhY2tldHM9JWxsdSBieXRlcz0lbGx1ICIsDQo+PiAtICAgKHVuc2lnbmVkIGxvbmcg
bG9uZylhdG9taWM2NF9yZWFkKCZjb3VudGVyW2Rpcl0ucGFja2V0cyksDQo+PiAtICAgKHVuc2ln
bmVkIGxvbmcgbG9uZylhdG9taWM2NF9yZWFkKCZjb3VudGVyW2Rpcl0uYnl0ZXMpKTsNCj4+ICtp
ZiAoYWNjdCkgew0KPj4gK3N0cnVjdCBuZl9jb25uX2NvdW50ZXIgKmNvdW50ZXIgPSBhY2N0LT5j
b3VudGVyOw0KPj4NCj4+IC1yZXR1cm4gMDsNCj4+ICtzZXFfcHJpbnRmKHMsICJwYWNrZXRzPSVs
bHUgYnl0ZXM9JWxsdSAiLA0KPj4gKyAgICh1bnNpZ25lZCBsb25nIGxvbmcpYXRvbWljNjRfcmVh
ZCgmY291bnRlcltkaXJdLnBhY2tldHMpLA0KPj4gKyAgICh1bnNpZ25lZCBsb25nIGxvbmcpYXRv
bWljNjRfcmVhZCgmY291bnRlcltkaXJdLmJ5dGVzKSk7DQo+PiArfQ0KPg0KPiBUaGUgcHJlZmVy
cmVkIGxpbnV4IGtlcm5lbCBzdHlsZSBpcyB0byBwZXJmb3JtIGlmIChjaGVja19lcnJvcikgcmV0
dXJuOw0KPiBJbiB0aGlzIGNhc2UsIHRoaXMgcGF0dGVybiBzaG91bGQgc3RheS4NCj4NCj4gYWNj
dCA9IG5mX2Nvbm5fYWNjdF9maW5kKGN0KTsNCj4gaWYgKCFhY2N0KQ0KPiAgICAgcmV0dXJuOw0K
Pg0KPiBUaGFua3MNCg0KVGhhbmsgeW91IGZvciByZXZpZXcuIEknbGwgZml4IGl0IGluIHYyLg0K
