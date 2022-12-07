Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0964576A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLGKTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLGKTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:19:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BF12AA;
        Wed,  7 Dec 2022 02:19:00 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 01F8721CBC;
        Wed,  7 Dec 2022 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670408339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VTns5mAfIBsPHe6SwxUnoyr3mxRi46aBRRYfefLkl8I=;
        b=SsswVE3VQg2fo2LdE5t48/DI4b2sVSHmk4iFjwNAK3DrOo/9zZAehgjYaSQfxtS4vCJXAG
        vUptvu4qSuxoLyf1fT1sUhRbOmkaDJ66NUC+Hq6/bnJuVtItjrw6YlgTeIU2SgS0QU03js
        qvDa6CQRrqFiLhFJBi/9ZMfTCghw1f8=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id A702B136B4;
        Wed,  7 Dec 2022 10:18:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id /KslJ5JokGMVCAAAGKfGzw
        (envelope-from <jgross@suse.com>); Wed, 07 Dec 2022 10:18:58 +0000
Message-ID: <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
Date:   Wed, 7 Dec 2022 11:18:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] xen/netback: fix build warning
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
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------X9s9CczSxgpT0DRZthLtv02v"
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------X9s9CczSxgpT0DRZthLtv02v
Content-Type: multipart/mixed; boundary="------------PO1myFOge2RPMAYvTrRVDX0K";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
Subject: Re: [PATCH] xen/netback: fix build warning
References: <20221207072349.28608-1-jgross@suse.com>
 <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>
In-Reply-To: <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>

--------------PO1myFOge2RPMAYvTrRVDX0K
Content-Type: multipart/mixed; boundary="------------sIQofQieghq4Lzrazwt0fPcm"

--------------sIQofQieghq4Lzrazwt0fPcm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMTIuMjIgMTA6MjUsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAwNy4xMi4yMDIy
IDA4OjIzLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gQ29tbWl0IGFkN2Y0MDJhZTRmNCAo
Inhlbi9uZXRiYWNrOiBFbnN1cmUgcHJvdG9jb2wgaGVhZGVycyBkb24ndCBmYWxsIGluDQo+
PiB0aGUgbm9uLWxpbmVhciBhcmVhIikgaW50cm9kdWNlZCBhICh2YWxpZCkgYnVpbGQgd2Fy
bmluZy4NCj4+DQo+PiBGaXggaXQuDQo+Pg0KPj4gRml4ZXM6IGFkN2Y0MDJhZTRmNCAoInhl
bi9uZXRiYWNrOiBFbnN1cmUgcHJvdG9jb2wgaGVhZGVycyBkb24ndCBmYWxsIGluIHRoZSBu
b24tbGluZWFyIGFyZWEiKQ0KPj4gU2lnbmVkLW9mZi1ieTogSnVlcmdlbiBHcm9zcyA8amdy
b3NzQHN1c2UuY29tPg0KPiANCj4gUmV2aWV3ZWQtYnk6IEphbiBCZXVsaWNoIDxqYmV1bGlj
aEBzdXNlLmNvbT4NCj4gDQo+PiAtLS0gYS9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRi
YWNrLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYw0KPj4g
QEAgLTUzMCw3ICs1MzAsNyBAQCBzdGF0aWMgaW50IHhlbnZpZl90eF9jaGVja19nb3Aoc3Ry
dWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsDQo+PiAgIAljb25zdCBib29sIHNoYXJlZHNsb3Qg
PSBucl9mcmFncyAmJg0KPj4gICAJCQkJZnJhZ19nZXRfcGVuZGluZ19pZHgoJnNoaW5mby0+
ZnJhZ3NbMF0pID09DQo+PiAgIAkJCQkgICAgY29weV9wZW5kaW5nX2lkeChza2IsIGNvcHlf
Y291bnQoc2tiKSAtIDEpOw0KPj4gLQlpbnQgaSwgZXJyOw0KPj4gKwlpbnQgaSwgZXJyID0g
MDsNCj4+ICAgDQo+PiAgIAlmb3IgKGkgPSAwOyBpIDwgY29weV9jb3VudChza2IpOyBpKysp
IHsNCj4+ICAgCQlpbnQgbmV3ZXJyOw0KPiANCj4gSSdtIGFmcmFpZCBvdGhlciBsb2dpYyAo
YmVsb3cgaGVyZSkgaXMgbm93IHNsaWdodGx5IHdyb25nIGFzIHdlbGwsIGluDQo+IHBhcnRp
Y3VsYXINCj4gDQo+IAkJCQkvKiBJZiB0aGUgbWFwcGluZyBvZiB0aGUgZmlyc3QgZnJhZyB3
YXMgT0ssIGJ1dA0KPiAJCQkJICogdGhlIGhlYWRlcidzIGNvcHkgZmFpbGVkLCBhbmQgdGhl
eSBhcmUNCj4gCQkJCSAqIHNoYXJpbmcgYSBzbG90LCBzZW5kIGFuIGVycm9yDQo+IAkJCQkg
Ki8NCj4gCQkJCWlmIChpID09IDAgJiYgIWZpcnN0X3NoaW5mbyAmJiBzaGFyZWRzbG90KQ0K
PiAJCQkJCXhlbnZpZl9pZHhfcmVsZWFzZShxdWV1ZSwgcGVuZGluZ19pZHgsDQo+IAkJCQkJ
CQkgICBYRU5fTkVUSUZfUlNQX0VSUk9SKTsNCj4gCQkJCWVsc2UNCj4gCQkJCQl4ZW52aWZf
aWR4X3JlbGVhc2UocXVldWUsIHBlbmRpbmdfaWR4LA0KPiAJCQkJCQkJICAgWEVOX05FVElG
X1JTUF9PS0FZKTsNCj4gDQo+IHdoaWNoIGxvb2tzIHRvIGJlIGludGVuZGVkIHRvIGRlYWwg
d2l0aCBfb25seV8gZmFpbHVyZSBvZiB0aGUgb25lIHNoYXJlZA0KPiBwYXJ0IG9mIHRoZSBo
ZWFkZXIsIHdoZXJlYXMgImVyciIgbm93IGNhbiBpbmRpY2F0ZSBhbiBlcnJvciBvbiBhbnkg
ZWFybGllcg0KPiBwYXJ0IGFzIHdlbGwuDQoNClRoZSBjb21tZW50IGF0IHRoZSBlbmQgb2Yg
dGhhdCBsb29wIHNlZW1zIHRvIGltcGx5IHRoaXMgaXMgdGhlIGRlc2lyZWQNCmJlaGF2aW9y
Og0KDQoJCS8qIFJlbWVtYmVyIHRoZSBlcnJvcjogaW52YWxpZGF0ZSBhbGwgc3Vic2VxdWVu
dCBmcmFnbWVudHMuICovDQoJCWVyciA9IG5ld2VycjsNCgl9DQoNCg0KSnVlcmdlbg0KDQo=

--------------sIQofQieghq4Lzrazwt0fPcm
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

--------------sIQofQieghq4Lzrazwt0fPcm--

--------------PO1myFOge2RPMAYvTrRVDX0K--

--------------X9s9CczSxgpT0DRZthLtv02v
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmOQaJIFAwAAAAAACgkQsN6d1ii/Ey9B
Hwf/eK8jqoi004SJmfl+VLO0L9yoLn6D1oGCXg/IAzUD3MVa1x574MEBdFt/8icScTQcU9bsrZOy
WOA/nkMeO+dZe/oETnke+y8mOm+49i+DUF23bxTEemXzvPtkS592p81P7Zd9P+HiO+DZ2sYI5j23
096TlPbJgMZXM3pesCqafkexbnnQrFZ9KNnLZT9ghpSl6R1zE5fj1X+BjG8Ueal9HyzvNMJXdFsm
jjjP+/TxQ3pmP+mPSNYzt3A3eXtcJCUcQ9aQLBukTA3lWKURy382a7841ZnFh4mlqPz5dSIiY0JJ
5Qre3TCA06kkWwlfqSj1I41yINd2KDEoTQSSLM5+Ew==
=wD3C
-----END PGP SIGNATURE-----

--------------X9s9CczSxgpT0DRZthLtv02v--
