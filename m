Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9608645906
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiLGL3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiLGL3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:29:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFE24840F;
        Wed,  7 Dec 2022 03:29:39 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BBF3921C89;
        Wed,  7 Dec 2022 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670412577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B6/MUL8+YhqEtagH9ry1Ud9uwkf4BBWke+fEs0I52tk=;
        b=npIma8zKH4E2Md4vP8d/1R/IKdIPtiWRpFxZt2oIrVFutvGkkOh/Fb55s248aQ2Z5YWhbO
        8C5nxzVmlCg5qSA5gbHvccxZm975AnSD5KfJsghz/jj324uxD5CT1Htc9HQOvafkxm2Fdh
        5dCxqxIObPXe81PVc31cAgFjkR7/KKg=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6B96F136B4;
        Wed,  7 Dec 2022 11:29:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id l7DXGCF5kGOELQAAGKfGzw
        (envelope-from <jgross@suse.com>); Wed, 07 Dec 2022 11:29:37 +0000
Message-ID: <681773dd-6264-63ac-a3b5-a9182b9e0cc1@suse.com>
Date:   Wed, 7 Dec 2022 12:29:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>
References: <20221207072349.28608-1-jgross@suse.com>
 <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>
 <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
 <0074a007-23a7-f2ff-0b85-47e4263c4d3f@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/netback: fix build warning
In-Reply-To: <0074a007-23a7-f2ff-0b85-47e4263c4d3f@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Crfd7rMN0I0V5EpI2yrGWOsW"
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Crfd7rMN0I0V5EpI2yrGWOsW
Content-Type: multipart/mixed; boundary="------------wJMfhOjf2rSnSxwjhZfb96d6";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <681773dd-6264-63ac-a3b5-a9182b9e0cc1@suse.com>
Subject: Re: [PATCH] xen/netback: fix build warning
References: <20221207072349.28608-1-jgross@suse.com>
 <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>
 <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
 <0074a007-23a7-f2ff-0b85-47e4263c4d3f@suse.com>
In-Reply-To: <0074a007-23a7-f2ff-0b85-47e4263c4d3f@suse.com>

--------------wJMfhOjf2rSnSxwjhZfb96d6
Content-Type: multipart/mixed; boundary="------------dyRWZUoS1gz9002x4H40BYgb"

--------------dyRWZUoS1gz9002x4H40BYgb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMTIuMjIgMTE6MjYsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAwNy4xMi4yMDIy
IDExOjE4LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMDcuMTIuMjIgMTA6MjUsIEph
biBCZXVsaWNoIHdyb3RlOg0KPj4+IE9uIDA3LjEyLjIwMjIgMDg6MjMsIEp1ZXJnZW4gR3Jv
c3Mgd3JvdGU6DQo+Pj4+IENvbW1pdCBhZDdmNDAyYWU0ZjQgKCJ4ZW4vbmV0YmFjazogRW5z
dXJlIHByb3RvY29sIGhlYWRlcnMgZG9uJ3QgZmFsbCBpbg0KPj4+PiB0aGUgbm9uLWxpbmVh
ciBhcmVhIikgaW50cm9kdWNlZCBhICh2YWxpZCkgYnVpbGQgd2FybmluZy4NCj4+Pj4NCj4+
Pj4gRml4IGl0Lg0KPj4+Pg0KPj4+PiBGaXhlczogYWQ3ZjQwMmFlNGY0ICgieGVuL25ldGJh
Y2s6IEVuc3VyZSBwcm90b2NvbCBoZWFkZXJzIGRvbid0IGZhbGwgaW4gdGhlIG5vbi1saW5l
YXIgYXJlYSIpDQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0Bz
dXNlLmNvbT4NCj4+Pg0KPj4+IFJldmlld2VkLWJ5OiBKYW4gQmV1bGljaCA8amJldWxpY2hA
c3VzZS5jb20+DQo+Pj4NCj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0
YmFjay5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYw0K
Pj4+PiBAQCAtNTMwLDcgKzUzMCw3IEBAIHN0YXRpYyBpbnQgeGVudmlmX3R4X2NoZWNrX2dv
cChzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSwNCj4+Pj4gICAgCWNvbnN0IGJvb2wgc2hh
cmVkc2xvdCA9IG5yX2ZyYWdzICYmDQo+Pj4+ICAgIAkJCQlmcmFnX2dldF9wZW5kaW5nX2lk
eCgmc2hpbmZvLT5mcmFnc1swXSkgPT0NCj4+Pj4gICAgCQkJCSAgICBjb3B5X3BlbmRpbmdf
aWR4KHNrYiwgY29weV9jb3VudChza2IpIC0gMSk7DQo+Pj4+IC0JaW50IGksIGVycjsNCj4+
Pj4gKwlpbnQgaSwgZXJyID0gMDsNCj4+Pj4gICAgDQo+Pj4+ICAgIAlmb3IgKGkgPSAwOyBp
IDwgY29weV9jb3VudChza2IpOyBpKyspIHsNCj4+Pj4gICAgCQlpbnQgbmV3ZXJyOw0KPj4+
DQo+Pj4gSSdtIGFmcmFpZCBvdGhlciBsb2dpYyAoYmVsb3cgaGVyZSkgaXMgbm93IHNsaWdo
dGx5IHdyb25nIGFzIHdlbGwsIGluDQo+Pj4gcGFydGljdWxhcg0KPj4+DQo+Pj4gCQkJCS8q
IElmIHRoZSBtYXBwaW5nIG9mIHRoZSBmaXJzdCBmcmFnIHdhcyBPSywgYnV0DQo+Pj4gCQkJ
CSAqIHRoZSBoZWFkZXIncyBjb3B5IGZhaWxlZCwgYW5kIHRoZXkgYXJlDQo+Pj4gCQkJCSAq
IHNoYXJpbmcgYSBzbG90LCBzZW5kIGFuIGVycm9yDQo+Pj4gCQkJCSAqLw0KPj4+IAkJCQlp
ZiAoaSA9PSAwICYmICFmaXJzdF9zaGluZm8gJiYgc2hhcmVkc2xvdCkNCj4+PiAJCQkJCXhl
bnZpZl9pZHhfcmVsZWFzZShxdWV1ZSwgcGVuZGluZ19pZHgsDQo+Pj4gCQkJCQkJCSAgIFhF
Tl9ORVRJRl9SU1BfRVJST1IpOw0KPj4+IAkJCQllbHNlDQo+Pj4gCQkJCQl4ZW52aWZfaWR4
X3JlbGVhc2UocXVldWUsIHBlbmRpbmdfaWR4LA0KPj4+IAkJCQkJCQkgICBYRU5fTkVUSUZf
UlNQX09LQVkpOw0KPj4+DQo+Pj4gd2hpY2ggbG9va3MgdG8gYmUgaW50ZW5kZWQgdG8gZGVh
bCB3aXRoIF9vbmx5XyBmYWlsdXJlIG9mIHRoZSBvbmUgc2hhcmVkDQo+Pj4gcGFydCBvZiB0
aGUgaGVhZGVyLCB3aGVyZWFzICJlcnIiIG5vdyBjYW4gaW5kaWNhdGUgYW4gZXJyb3Igb24g
YW55IGVhcmxpZXINCj4+PiBwYXJ0IGFzIHdlbGwuDQo+Pg0KPj4gVGhlIGNvbW1lbnQgYXQg
dGhlIGVuZCBvZiB0aGF0IGxvb3Agc2VlbXMgdG8gaW1wbHkgdGhpcyBpcyB0aGUgZGVzaXJl
ZA0KPj4gYmVoYXZpb3I6DQo+Pg0KPj4gCQkvKiBSZW1lbWJlciB0aGUgZXJyb3I6IGludmFs
aWRhdGUgYWxsIHN1YnNlcXVlbnQgZnJhZ21lbnRzLiAqLw0KPj4gCQllcnIgPSBuZXdlcnI7
DQo+PiAJfQ0KPiANCj4gVGhpcyBzYXlzICJzdWJzZXF1ZW50Iiwgd2hlcmVhcyBJIHdhcyBk
ZXNjcmliaW5nIGEgc2l0dWF0aW9uIHdoZXJlIGUuZy4NCj4gdGhlIGZpcnN0IHBpZWNlIG9m
IGhlYWRlciBjb3B5aW5nIGZhaWxlZCwgdGhlIDJuZCAoc2hhcmVkIHBhcnQpIHN1Y2NlZWRl
ZCwNCj4gYW5kIHRoZSBtYXBwaW5nIG9mIHRoZSByZXN0IG9mIHRoZSBzaGFyZWQgcGFydCBh
bHNvIHN1Y2NlZWRlZC4gQXQgdGhlDQo+IHZlcnkgbGVhc3QgdGhlIGNvbW1lbnQgaW4gdGhl
IGNvZGUgZnJhZ21lbnQgSSBkaWQgcXVvdGUgdGhlbiBoYXMgYmVjb21lDQo+IHN0YWxlLiBG
dXJ0aGVybW9yZSwgaWYgImFsbCBzdWJzZXF1ZW50IiByZWFsbHkgbWVhbnQgYWxsLCB0aGVu
IGluIHRoZQ0KPiBuZXcgZmlyc3QgbG9vcCB0aGlzIGlzbid0IGZvbGxvd2VkIGVpdGhlciAt
IGFuIGVycm9yIHJlc3BvbnNlIGlzIHNlbnQNCj4gb25seSBmb3IgdGhlIHBpZWNlcyB3aGVy
ZSBjb3B5aW5nIGZhaWxlZC4NCg0KSGF2aW5nIHN0YXJlZCBhdCB0aGUgY29kZSBmb3IgcXVp
dGUgc29tZSB0aW1lIG5vdywgSSB0aGluayB0aGVyZSBpcyBzb21lDQpyb29tIGZvciBjb25m
dXNpb246ICJpbnZhbGlkYXRpbmciIHRoZSBmcmFncyBzZWVtcyBub3QgdG8gYmUgdGhlIHNh
bWUgYXMNCnNldHRpbmcgdGhlIHJlbGF0ZWQgaWR4IHRvIGhhdmUgYW4gZXJyb3IuDQoNClhF
Tl9ORVRJRl9SU1BfRVJST1Igc2VlbXMgdG8gYmUgc2V0IG9ubHkgZm9yIHRoZSBpZHggd2hp
Y2ggcmVhbGx5IGhhZCBhbg0KZXJyb3IsIHdoaWxlIGlmIGFueSBvZiB0aGVtIGhhZCBvbmUs
IGFsbCBpZHgtZXMgbXVzdCBiZSB1bm1hcHBlZCwgaGF2ZSBhDQpzdGF0dXMgc2V0LCBhbmQg
cmV0dXJuZWQgdG8gdGhlIGZyb250ZW5kLg0KDQpBbmQgSSB0aGluayB0aGUgY29kZSBpcyBk
b2luZyB0aGlzIHF1aXRlIGZpbmUuDQoNClRoZSBjb21tZW50cyBfY291bGRfIG5lZWQgc29t
ZSBpbXByb3ZlbWVudHMsIHRob3VnaC4NCg0KQW5kIHNvbWUgbW9yZSByZXN0cnVjdHVyaW5n
IGNvdWxkIGhlbHAsIHRvbyAoYXQgbGVhc3QgSSB0aGluayB0aGF0IHRoZQ0KImdvdG8gY2hl
Y2tfZnJhZ3MiIGlzIGEgcmF0aGVyIGNsdW1zeSBjb25zdHJ1Y3QgLSBJJ2QgcHJlZmVyIHNw
bGl0dGluZw0KeGVudmlmX3R4X2NoZWNrX2dvcCgpIGludG8gc29tZSBoZWxwZXIgZnVuY3Rp
b25zIGFuZCBhIHJhdGhlciBzbWFsbA0KYm9keSBjYWxsaW5nIHRob3NlIHdpdGggZS5nLiBk
aWZmZXJlbnQgc2hpbmZvIHZhbHVlcykuDQoNCg0KSnVlcmdlbg0K
--------------dyRWZUoS1gz9002x4H40BYgb
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

--------------dyRWZUoS1gz9002x4H40BYgb--

--------------wJMfhOjf2rSnSxwjhZfb96d6--

--------------Crfd7rMN0I0V5EpI2yrGWOsW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmOQeSEFAwAAAAAACgkQsN6d1ii/Ey+5
tQf/VDHM9RBbhSuy0Ou4XEL6aO/x242Oj+kdt7wbSNVnE+xF77onHAgxX5Rl1cFf6q3myM6X8Tbe
jIV1bkIVRGwGeOL9qsbXSLFC6JOlSUmM8N7HP9ArXp4iDKR4OXT7rJD9SdxaRuivHH5Km+cP51wM
gaCf02oOUysLd9jL+7AdZMyw/Y9Ub4kwVHpLWyZkeT9Ao5gphPBollAs3TC74DwoZeAUnAf46ru0
gPqaQ4xB5A3OBxnB0GYeOVhifLa050xRKz6aw1QjqfVQ1SlaAY0aRuPK7p3VL0SoKFlHZNeJBxJq
IOf8m2B3ztXlzDf7Xj7YpaRLxpBoHmuRqgx03AVB3g==
=B3Lv
-----END PGP SIGNATURE-----

--------------Crfd7rMN0I0V5EpI2yrGWOsW--
