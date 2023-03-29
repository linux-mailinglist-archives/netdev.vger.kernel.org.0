Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD836CD203
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjC2GVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2GVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:21:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA991FE0;
        Tue, 28 Mar 2023 23:21:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 62F601FE00;
        Wed, 29 Mar 2023 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680070890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L14tD8JgCIJiHJ4SUWL9zMGaARCTrQmXrX+IJ54lWQ0=;
        b=crY9KMi+5NMuFc2oi3nW4AC6XP7Q3OR8RMh0dgGV8eNaIqu7QuAlneK0v1U8E9pjLIwWSv
        4tSx4o4bzImro2+e0a3FHZ2qa9xzJn4JvBs53CyO4bGe1FZtV1Ogo8iKTrRCDv3qeivW1G
        7ZqMclBjCoDY+QujNglSQ1ZntI1W/KA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AD86139D3;
        Wed, 29 Mar 2023 06:21:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id st79BOrYI2RMHAAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 29 Mar 2023 06:21:30 +0000
Message-ID: <e518732c-3104-9263-f484-a8b374ac604d@suse.com>
Date:   Wed, 29 Mar 2023 08:21:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 3/3] xen/netback: use same error messages for same
 errors
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230328131047.2440-1-jgross@suse.com>
 <20230328131233.2534-4-jgross@suse.com>
 <435f5ab4-e0ca-f66d-dc0d-0ed8633ed2e7@suse.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <435f5ab4-e0ca-f66d-dc0d-0ed8633ed2e7@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0MeRe4op47ysplC7AKBme1iZ"
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
--------------0MeRe4op47ysplC7AKBme1iZ
Content-Type: multipart/mixed; boundary="------------Uxsj61YPyfZ0kMT3HGUNDcQT";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Message-ID: <e518732c-3104-9263-f484-a8b374ac604d@suse.com>
Subject: Re: [PATCH v2 3/3] xen/netback: use same error messages for same
 errors
References: <20230328131047.2440-1-jgross@suse.com>
 <20230328131233.2534-4-jgross@suse.com>
 <435f5ab4-e0ca-f66d-dc0d-0ed8633ed2e7@suse.com>
In-Reply-To: <435f5ab4-e0ca-f66d-dc0d-0ed8633ed2e7@suse.com>

--------------Uxsj61YPyfZ0kMT3HGUNDcQT
Content-Type: multipart/mixed; boundary="------------dsiNCLK0cAyWKl6mSzjOKpdi"

--------------dsiNCLK0cAyWKl6mSzjOKpdi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjguMDMuMjMgMTU6MzIsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyOC4wMy4yMDIz
IDE1OjEyLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gSXNzdWUgdGhlIHNhbWUgZXJyb3Ig
bWVzc2FnZSBpbiBjYXNlIGFuIGlsbGVnYWwgcGFnZSBib3VuZGFyeSBjcm9zc2luZw0KPj4g
aGFzIGJlZW4gZGV0ZWN0ZWQgaW4gYm90aCBjYXNlcyB3aGVyZSB0aGlzIGlzIHRlc3RlZC4N
Cj4+DQo+PiBTdWdnZXN0ZWQtYnk6IEphbiBCZXVsaWNoIDxqYmV1bGljaEBzdXNlLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+
IC0tLQ0KPj4gVjI6DQo+PiAtIG5ldyBwYXRjaA0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0
L3hlbi1uZXRiYWNrL25ldGJhY2suYyB8IDYgKystLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYyBiL2RyaXZlcnMvbmV0L3hlbi1u
ZXRiYWNrL25ldGJhY2suYw0KPj4gaW5kZXggOWNhNGI2OWQzYjM5Li41ZGZkZWM0NDM1NGEg
MTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCj4+
ICsrKyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYw0KPj4gQEAgLTk5Niwx
MCArOTk2LDggQEAgc3RhdGljIHZvaWQgeGVudmlmX3R4X2J1aWxkX2dvcHMoc3RydWN0IHhl
bnZpZl9xdWV1ZSAqcXVldWUsDQo+PiAgIA0KPj4gICAJCS8qIE5vIGNyb3NzaW5nIGEgcGFn
ZSBhcyB0aGUgcGF5bG9hZCBtdXN0bid0IGZyYWdtZW50LiAqLw0KPj4gICAJCWlmICh1bmxp
a2VseSgodHhyZXEub2Zmc2V0ICsgdHhyZXEuc2l6ZSkgPiBYRU5fUEFHRV9TSVpFKSkgew0K
Pj4gLQkJCW5ldGRldl9lcnIocXVldWUtPnZpZi0+ZGV2LA0KPj4gLQkJCQkgICAidHhyZXEu
b2Zmc2V0OiAldSwgc2l6ZTogJXUsIGVuZDogJWx1XG4iLA0KPj4gLQkJCQkgICB0eHJlcS5v
ZmZzZXQsIHR4cmVxLnNpemUsDQo+PiAtCQkJCSAgICh1bnNpZ25lZCBsb25nKSh0eHJlcS5v
ZmZzZXQmflhFTl9QQUdFX01BU0spICsgdHhyZXEuc2l6ZSk7DQo+PiArCQkJbmV0ZGV2X2Vy
cihxdWV1ZS0+dmlmLT5kZXYsICJDcm9zcyBwYWdlIGJvdW5kYXJ5LCB0eHAtPm9mZnNldDog
JXUsIHNpemU6ICV1XG4iLA0KPj4gKwkJCQkgICB0eHJlcS5vZmZzZXQsIHR4cmVxLnNpemUp
Ow0KPj4gICAJCQl4ZW52aWZfZmF0YWxfdHhfZXJyKHF1ZXVlLT52aWYpOw0KPj4gICAJCQli
cmVhazsNCj4+ICAgCQl9DQo+IA0KPiBUbyBiZSBob25lc3QgSSdtIG9mIHRoZSBvcGluaW9u
IHRoYXQgdGhpcyBnb2VzIHNsaWdodGx5IHRvbyBmYXI6DQo+IE1ha2luZyB0aGUgdHdvIG1l
c3NhZ2VzIG1vcmUgc2ltaWxhciBpcyBjZXJ0YWlubHkgaGVscGZ1bC4gQnV0IGluDQo+IGNh
c2Ugb2YgcHJvYmxlbXMgSSB0aGluayBpdCB3b3VsZG4ndCBodXJ0IGlmIHRoZXkncmUgc3Rp
bGwNCj4gZGlzdGluZ3Vpc2hhYmxlIC0gd2hlbiB0aGUgb25lIGhlcmUgdHJpZ2dlcnMgaXQg
bWF5IGUuZyBhbHNvIG1lYW4NCj4gdGhhdCB0aGUgY2FsY3VsYXRpb24gb2YgdGhlIHJlc2lk
dWFsIHNpemUgaXMgY2F1c2luZyBhbiBpc3N1ZS4gU28NCj4gbWF5YmUgc3RpY2sgdG8gdHhy
ZXEub2Zmc2V0IGluIHRoZSBtZXNzYWdlIHRleHQsIHdpdGggZXZlcnl0aGluZw0KPiBlbHNl
IGxlZnQgYXMgeW91IGhhdmUgaXQ/DQoNCkZpbmUgd2l0aCBtZS4NCg0KDQpKdWVyZ2VuDQoN
Cg==
--------------dsiNCLK0cAyWKl6mSzjOKpdi
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------dsiNCLK0cAyWKl6mSzjOKpdi--

--------------Uxsj61YPyfZ0kMT3HGUNDcQT--

--------------0MeRe4op47ysplC7AKBme1iZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmQj2OkFAwAAAAAACgkQsN6d1ii/Ey9j
Xwf/SAh05L2mpANQIHipHjodS5ge3aJwDAHjaDBrP2JOOsZk89jAloRwQ0uUiPuB7OIiVlZt9hrj
hbFTPwJEDfvXirfZRtLqCaVA41jP/HqdPcJ/og8R/ZtYK0kaARds6PIgbbSX17x8epKwGFygVhOu
3ZlAyVC3GcEz06+vBGmdxKwJLdKyoUn6mERplLhquP9qgnx0DFhC1w9zzZNkFZGQkAxZueRutkoR
yRtbVG4UHM+t40uHWXGZYfiITG0fbWor/bZ3A3DKuv55xnX5m3gAVfAjFLFolCv3nihCQilJY73b
l6NK9FzmqgsP9erKV4WiBRSZjRnOOZJAozFv8GhRTw==
=bePB
-----END PGP SIGNATURE-----

--------------0MeRe4op47ysplC7AKBme1iZ--
