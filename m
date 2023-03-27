Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F5A6CAA76
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjC0QWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjC0QWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:22:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A939010CF;
        Mon, 27 Mar 2023 09:22:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 63FD31FDC2;
        Mon, 27 Mar 2023 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679934133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UcDPc/tgrynPUn5Yb3kFJbY/0rSBTe/WWm+ukByYBNM=;
        b=TGkHjJu7sMYfpPegpiMz6r/zjinvf3kc+DGbnTIIXrwRnjZy4qwzqzzJVbsuwY/njyAZTN
        Sq3EXI32nlHMl94cM5qFS5uvakOzeyFnyP/ErYr9k6tlZ4i/F5prP2PWPGmeLC9Cb/0PEI
        Pd1jLl14rSQY2G/6Jp5pfwJF0nIIxoE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0935B13482;
        Mon, 27 Mar 2023 16:22:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QMiBALXCIWTKUgAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 27 Mar 2023 16:22:13 +0000
Message-ID: <f94dbfe9-f690-8c3e-c251-b0d5f93d32f9@suse.com>
Date:   Mon, 27 Mar 2023 18:22:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
 <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
 <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
 <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
In-Reply-To: <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------KOZ7ZtvRb62jdp8pvjMndc9b"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------KOZ7ZtvRb62jdp8pvjMndc9b
Content-Type: multipart/mixed; boundary="------------0kqG5uzLZQlxMAQNhuEVe4xN";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <f94dbfe9-f690-8c3e-c251-b0d5f93d32f9@suse.com>
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
 <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
 <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
 <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>
In-Reply-To: <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>

--------------0kqG5uzLZQlxMAQNhuEVe4xN
Content-Type: multipart/mixed; boundary="------------AK01Xsixlkeb0Sq0830RmZ1R"

--------------AK01Xsixlkeb0Sq0830RmZ1R
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjcuMDMuMjMgMTc6MzgsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNy4wMy4yMDIz
IDEyOjA3LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMjcuMDMuMjMgMTE6NDksIEph
biBCZXVsaWNoIHdyb3RlOg0KPj4+IE9uIDI3LjAzLjIwMjMgMTA6MzYsIEp1ZXJnZW4gR3Jv
c3Mgd3JvdGU6DQo+Pj4+IEBAIC00MTMsNiArNDE4LDEzIEBAIHN0YXRpYyB2b2lkIHhlbnZp
Zl9nZXRfcmVxdWVzdHMoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsDQo+Pj4+ICAgIAkJ
Y29wLT5kZXN0LnUuZ21mbiA9IHZpcnRfdG9fZ2ZuKHNrYi0+ZGF0YSArIHNrYl9oZWFkbGVu
KHNrYikNCj4+Pj4gICAgCQkJCSAgICAgICAgICAgICAgIC0gZGF0YV9sZW4pOw0KPj4+PiAg
ICANCj4+Pj4gKwkJLyogRG9uJ3QgY3Jvc3MgbG9jYWwgcGFnZSBib3VuZGFyeSEgKi8NCj4+
Pj4gKwkJaWYgKGNvcC0+ZGVzdC5vZmZzZXQgKyBhbW91bnQgPiBYRU5fUEFHRV9TSVpFKSB7
DQo+Pj4+ICsJCQlhbW91bnQgPSBYRU5fUEFHRV9TSVpFIC0gY29wLT5kZXN0Lm9mZnNldDsN
Cj4+Pj4gKwkJCVhFTlZJRl9UWF9DQihza2IpLT5zcGxpdF9tYXNrIHw9IDFVIDw8IGNvcHlf
Y291bnQoc2tiKTsNCj4+Pg0KPj4+IE1heWJlIHdvcnRod2hpbGUgdG8gYWRkIGEgQlVJTERf
QlVHX09OKCkgc29tZXdoZXJlIHRvIG1ha2Ugc3VyZSB0aGlzDQo+Pj4gc2hpZnQgd29uJ3Qg
Z3JvdyB0b28gbGFyZ2UgYSBzaGlmdCBjb3VudC4gVGhlIG51bWJlciBvZiBzbG90cyBhY2Nl
cHRlZA0KPj4+IGNvdWxkIGNvbmNlaXZhYmx5IGJlIGdyb3duIHBhc3QgWEVOX05FVEJLX0xF
R0FDWV9TTE9UU19NQVggKGkuZS4NCj4+PiBYRU5fTkVUSUZfTlJfU0xPVFNfTUlOKSBhdCBz
b21lIHBvaW50Lg0KPj4NCj4+IFRoaXMgaXMgYmFzaWNhbGx5IGltcG9zc2libGUgZHVlIHRv
IHRoZSBzaXplIHJlc3RyaWN0aW9uIG9mIHN0cnVjdA0KPj4geGVudmlmX3R4X2NiLg0KPiAN
Cj4gSWYgaXRzIHNpemUgYmVjYW1lIGEgcHJvYmxlbSwgaXQgbWlnaHQgc2ltcGx5IHRha2Ug
YSBsZXZlbCBvZiBpbmRpcmVjdGlvbg0KPiB0byBvdmVyY29tZSB0aGUgbGltaXRhdGlvbi4N
Cg0KTWF5YmUuDQoNCk9UT0ggdGhpcyB3b3VsZCByZXF1aXJlIHNvbWUgcmV3b3JrLCB3aGlj
aCBzaG91bGQgdGFrZSBzdWNoIHByb2JsZW1zIGludG8NCmNvbnNpZGVyYXRpb24uDQoNCklu
IHRoZSBlbmQgSSdkIGJlIGZpbmUgdG8gYWRkIHN1Y2ggYSBCVUlMRF9CVUdfT04oKSwgYXMg
dGhlIGNvZGUgaXMNCmNvbXBsaWNhdGVkIGVub3VnaCBhbHJlYWR5Lg0KDQo+IA0KPj4+PiBA
QCAtNDIwLDcgKzQzMiw4IEBAIHN0YXRpYyB2b2lkIHhlbnZpZl9nZXRfcmVxdWVzdHMoc3Ry
dWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsDQo+Pj4+ICAgIAkJcGVuZGluZ19pZHggPSBxdWV1
ZS0+cGVuZGluZ19yaW5nW2luZGV4XTsNCj4+Pj4gICAgCQljYWxsYmFja19wYXJhbShxdWV1
ZSwgcGVuZGluZ19pZHgpLmN0eCA9IE5VTEw7DQo+Pj4+ICAgIAkJY29weV9wZW5kaW5nX2lk
eChza2IsIGNvcHlfY291bnQoc2tiKSkgPSBwZW5kaW5nX2lkeDsNCj4+Pj4gLQkJY29weV9j
b3VudChza2IpKys7DQo+Pj4+ICsJCWlmICghc3BsaXQpDQo+Pj4+ICsJCQljb3B5X2NvdW50
KHNrYikrKzsNCj4+Pj4gICAgDQo+Pj4+ICAgIAkJY29wKys7DQo+Pj4+ICAgIAkJZGF0YV9s
ZW4gLT0gYW1vdW50Ow0KPj4+PiBAQCAtNDQxLDcgKzQ1NCw4IEBAIHN0YXRpYyB2b2lkIHhl
bnZpZl9nZXRfcmVxdWVzdHMoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsDQo+Pj4+ICAg
IAkJCW5yX3Nsb3RzLS07DQo+Pj4+ICAgIAkJfSBlbHNlIHsNCj4+Pj4gICAgCQkJLyogVGhl
IGNvcHkgb3AgcGFydGlhbGx5IGNvdmVyZWQgdGhlIHR4X3JlcXVlc3QuDQo+Pj4+IC0JCQkg
KiBUaGUgcmVtYWluZGVyIHdpbGwgYmUgbWFwcGVkLg0KPj4+PiArCQkJICogVGhlIHJlbWFp
bmRlciB3aWxsIGJlIG1hcHBlZCBvciBjb3BpZWQgaW4gdGhlIG5leHQNCj4+Pj4gKwkJCSAq
IGl0ZXJhdGlvbi4NCj4+Pj4gICAgCQkJICovDQo+Pj4+ICAgIAkJCXR4cC0+b2Zmc2V0ICs9
IGFtb3VudDsNCj4+Pj4gICAgCQkJdHhwLT5zaXplIC09IGFtb3VudDsNCj4+Pj4gQEAgLTUz
OSw2ICs1NTMsMTMgQEAgc3RhdGljIGludCB4ZW52aWZfdHhfY2hlY2tfZ29wKHN0cnVjdCB4
ZW52aWZfcXVldWUgKnF1ZXVlLA0KPj4+PiAgICAJCXBlbmRpbmdfaWR4ID0gY29weV9wZW5k
aW5nX2lkeChza2IsIGkpOw0KPj4+PiAgICANCj4+Pj4gICAgCQluZXdlcnIgPSAoKmdvcHBf
Y29weSktPnN0YXR1czsNCj4+Pj4gKw0KPj4+PiArCQkvKiBTcGxpdCBjb3BpZXMgbmVlZCB0
byBiZSBoYW5kbGVkIHRvZ2V0aGVyLiAqLw0KPj4+PiArCQlpZiAoWEVOVklGX1RYX0NCKHNr
YiktPnNwbGl0X21hc2sgJiAoMVUgPDwgaSkpIHsNCj4+Pj4gKwkJCSgqZ29wcF9jb3B5KSsr
Ow0KPj4+PiArCQkJaWYgKCFuZXdlcnIpDQo+Pj4+ICsJCQkJbmV3ZXJyID0gKCpnb3BwX2Nv
cHkpLT5zdGF0dXM7DQo+Pj4+ICsJCX0NCj4+Pg0KPj4+IEl0IGlzbid0IGd1YXJhbnRlZWQg
dGhhdCBhIHNsb3QgbWF5IGJlIHNwbGl0IG9ubHkgb25jZSwgaXMgaXQ/IEFzc3VtaW5nIGEN
Cj4+DQo+PiBJIHRoaW5rIGl0IGlzIGd1YXJhbnRlZWQuDQo+Pg0KPj4gTm8gc2xvdCBjYW4g
Y292ZXIgbW9yZSB0aGFuIFhFTl9QQUdFX1NJWkUgYnl0ZXMgZHVlIHRvIHRoZSBncmFudHMg
YmVpbmcNCj4+IHJlc3RyaWN0ZWQgdG8gdGhhdCBzaXplLiBUaGVyZSBpcyBubyB3YXkgaG93
IHN1Y2ggYSBkYXRhIHBhY2tldCBjb3VsZCBjcm9zcw0KPj4gMiBwYWdlIGJvdW5kYXJpZXMu
DQo+Pg0KPj4gSW4gdGhlIGVuZCB0aGUgcHJvYmxlbSBpc24ndCB0aGUgY29waWVzIGZvciB0
aGUgbGluZWFyIGFyZWEgbm90IGNyb3NzaW5nDQo+PiBtdWx0aXBsZSBwYWdlIGJvdW5kYXJp
ZXMsIGJ1dCB0aGUgY29waWVzIGZvciBhIHNpbmdsZSByZXF1ZXN0IHNsb3Qgbm90DQo+PiBk
b2luZyBzby4gQW5kIHRoaXMgY2FuJ3QgaGFwcGVuIElNTy4NCj4gDQo+IFlvdSdyZSB0aGlu
a2luZyBvZiBvbmx5IHdlbGwtZm9ybWVkIHJlcXVlc3RzLiBXaGF0IGFib3V0IHNhaWQgcmVx
dWVzdA0KPiBwcm92aWRpbmcgYSBsYXJnZSBzaXplIHdpdGggb25seSB0aW55IGZyYWdtZW50
cz8geGVudmlmX2dldF9yZXF1ZXN0cygpDQo+IHdpbGwgaGFwcGlseSBwcm9jZXNzIHN1Y2gs
IGNyZWF0aW5nIGJvZ3VzIGdyYW50LWNvcHkgb3BzLiBCdXQgdGhlbSBmYWlsaW5nDQo+IG9u
Y2Ugc3VibWl0dGVkIHRvIFhlbiB3aWxsIGJlIG9ubHkgYWZ0ZXIgZGFtYWdlIG1heSBhbHJl
YWR5IGhhdmUgb2NjdXJyZWQNCj4gKGZyb20gYm9ndXMgdXBkYXRlcyBvZiBpbnRlcm5hbCBz
dGF0ZTsgdGhlIGxvZ2ljIGFsdG9nZXRoZXIgaXMgdG9vDQo+IGludm9sdmVkIGZvciBtZSB0
byBiZSBjb252aW5jZWQgdGhhdCBub3RoaW5nIGJhZCBjYW4gaGFwcGVuKS4NCg0KVGhlcmUg
YXJlIHNhbml0eSBjaGVja3MgYWZ0ZXIgZWFjaCByZWxldmFudCBSSU5HX0NPUFlfUkVRVUVT
VCgpIGNhbGwsIHdoaWNoDQp3aWxsIGJhaWwgb3V0IGlmICIodHhwLT5vZmZzZXQgKyB0eHAt
PnNpemUpID4gWEVOX1BBR0VfU0laRSIgKHRoZSBmaXJzdCBvbmUNCmlzIGFmdGVyIHRoZSBj
YWxsIG9mIHhlbnZpZl9jb3VudF9yZXF1ZXN0cygpLCBhcyB0aGlzIGNhbGwgd2lsbCBkZWNy
ZWFzZSB0aGUNCnNpemUgb2YgdGhlIHJlcXVlc3QsIHRoZSBvdGhlciBjaGVjayBpcyBpbiB4
ZW52aWZfY291bnRfcmVxdWVzdHMoKSkuDQoNCj4gSW50ZXJlc3RpbmdseSAoYXMgSSByZWFs
aXplIG5vdykgdGhlIHNoaWZ0cyB5b3UgYWRkIGFyZSBub3QgYmUgYXQgcmlzayBvZg0KPiB0
dXJuaW5nIFVCIGluIHRoaXMgY2FzZSwgYXMgdGhlIHNoaWZ0IGNvdW50IHdvbid0IGdvIGJl
eW9uZCAxNi4NCj4gDQo+Pj4gbmVhci02NGsgcGFja2V0IHdpdGggYWxsIHRpbnkgbm9uLXBy
aW1hcnkgc2xvdHMsIHRoYXQnbGwgY2F1c2UgdGhvc2UgdGlueQ0KPj4+IHNsb3RzIHRvIGFs
bCBiZSBtYXBwZWQsIGJ1dCBkdWUgdG8NCj4+Pg0KPj4+IAkJaWYgKHJldCA+PSBYRU5fTkVU
QktfTEVHQUNZX1NMT1RTX01BWCAtIDEgJiYgZGF0YV9sZW4gPCB0eHJlcS5zaXplKQ0KPj4+
IAkJCWRhdGFfbGVuID0gdHhyZXEuc2l6ZTsNCj4+Pg0KPj4+IHdpbGwsIGFmYWljdCwgY2F1
c2UgYSBsb3Qgb2YgY29weWluZyBmb3IgdGhlIHByaW1hcnkgc2xvdC4gVGhlcmVmb3JlIEkN
Cj4+PiB0aGluayB5b3UgbmVlZCBhIGxvb3AgaGVyZSwgbm90IGp1c3QgYW4gaWYoKS4gUGx1
cyB0eF9jb3B5X29wc1tdJ2VzDQo+Pj4gZGltZW5zaW9uIGFsc28gbG9va3MgdG8gbmVlZCBm
dXJ0aGVyIGdyb3dpbmcgdG8gYWNjb21tb2RhdGUgdGhpcy4gT3INCj4+PiBtYXliZSBub3Qg
LSBhdCBsZWFzdCB0aGUgZXh0cmVtZSBleGFtcGxlIGdpdmVuIHdvdWxkIHN0aWxsIGJlIGZp
bmU7IG1vcmUNCj4+PiBnZW5lcmFsbHkgcGFja2V0cyBiZWluZyBsaW1pdGVkIHRvIGJlbG93
IDY0ayBtZWFucyAyKjE2IHNsb3RzIHdvdWxkDQo+Pj4gc3VmZmljZSBhdCBvbmUgZW5kIG9m
IHRoZSBzY2FsZSwgd2hpbGUgMipNQVhfUEVORElOR19SRVFTIHdvdWxkIGF0IHRoZQ0KPj4+
IG90aGVyIGVuZCAoYWxsIHRpbnksIGluY2x1ZGluZyB0aGUgcHJpbWFyeSBzbG90KS4gV2hh
dCBJIGhhdmVuJ3QgZnVsbHkNCj4+PiBjb252aW5jZWQgbXlzZWxmIG9mIGlzIHdoZXRoZXIg
dGhlcmUgbWlnaHQgYmUgY2FzZXMgaW4gdGhlIG1pZGRsZSB3aGljaA0KPj4+IGFyZSB5ZXQg
d29yc2UuDQo+Pg0KPj4gU2VlIGFib3ZlIHJlYXNvbmluZy4gSSB0aGluayBpdCBpcyBva2F5
LCBidXQgbWF5YmUgSSdtIG1pc3Npbmcgc29tZXRoaW5nLg0KPiANCj4gV2VsbCwgdGhlIG1h
aW4gdGhpbmcgSSdtIG1pc3NpbmcgaXMgYSAicHJpbWFyeSByZXF1ZXN0IGZpdHMgaW4gYSBw
YWdlIg0KPiBjaGVjaywgZXZlbiBtb3JlIHNvIHdpdGggdGhlIG5ldyBjb3B5aW5nIGxvZ2lj
IHRoYXQgdGhlIGNvbW1pdCByZWZlcmVuY2VkDQo+IGJ5IEZpeGVzOiBpbnRyb2R1Y2VkIGlu
dG8geGVudmlmX2dldF9yZXF1ZXN0cygpLg0KDQpXaGVuIHhlbnZpZl9nZXRfcmVxdWVzdHMo
KSBnZXRzIGNhbGxlZCwgYWxsIHJlcXVlc3RzIGFyZSBzYW5pdHkgY2hlY2tlZA0KYWxyZWFk
eSAobm90ZSB0aGF0IHhlbnZpZl9nZXRfcmVxdWVzdHMoKSBpcyB3b3JraW5nIG9uIHRoZSBs
b2NhbCBjb3BpZXMgb2YNCnRoZSByZXF1ZXN0cykuDQoNCg0KSnVlcmdlbg0K
--------------AK01Xsixlkeb0Sq0830RmZ1R
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------AK01Xsixlkeb0Sq0830RmZ1R--

--------------0kqG5uzLZQlxMAQNhuEVe4xN--

--------------KOZ7ZtvRb62jdp8pvjMndc9b
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmQhwrQFAwAAAAAACgkQsN6d1ii/Ey8o
7Qf/UNv6jyUJtB5UZE4sBvosfP6HG1LYaUFg5CY7KhDu74n8270KFyOj3G8TYc7aaobr3u8MvWOS
5V6fKu+/6VtBTtaoNKeqyTSstlwYjr6Cmp3B3cPQph5Mtfmrq4qrcKuHtGM5knaYCHvQisRybCYf
CnJ0CUGqns4XgqpJHLe0fNnp0CheYTkMujuVG/xhAlPiJnYcgwxYiTyQL4FqUFlRz5q11oYOR/iY
vEThuwSI4Q5saiXCJLuHgU6hSJd0arwDiajoP+joFPI8XLBtL2VDZrirj6voPawPVeLIoUm6bypi
YiK8rfr9H7qj1NGEwYZx40N4XLVflSnYot4A+MzmxA==
=idtz
-----END PGP SIGNATURE-----

--------------KOZ7ZtvRb62jdp8pvjMndc9b--
