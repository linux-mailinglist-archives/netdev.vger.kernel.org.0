Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C0D5732CF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbiGMJcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiGMJc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:32:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C13F789A;
        Wed, 13 Jul 2022 02:31:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 97AC52264F;
        Wed, 13 Jul 2022 09:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657704667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DIxquxVL5zbp2920oTPlSbhhclREtQVqn63Qo4GU0go=;
        b=X/uclUEeLzLDpRVpyUSDvgdugQY7waFRhQ+H6LpGkNcVa0vuuQIZj9Gf04dLoilykNcdAb
        1DzXNi2JkSf3QxZVzbjbQ2ly7IfXrhbZf1a9ATSV7P2JKaKY7FJyNkmdZowuCnnvDDhs2s
        J3WAyYcB9PwPDzj/MsjHUBlPVFbrPPI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4FB5013AAD;
        Wed, 13 Jul 2022 09:31:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b6YCEtuQzmJdVQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 13 Jul 2022 09:31:07 +0000
Message-ID: <b11693ec-5d08-62e7-7479-a631edd5b1ce@suse.com>
Date:   Wed, 13 Jul 2022 11:31:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220713074823.5679-1-jgross@suse.com>
 <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/netback: handle empty rx queue in
 xenvif_rx_next_skb()
In-Reply-To: <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------WdLJwO96tyF2VuhTG3qIw0Ru"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------WdLJwO96tyF2VuhTG3qIw0Ru
Content-Type: multipart/mixed; boundary="------------aDnQdL3LsHraZxZf03Wd7ZQr";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <b11693ec-5d08-62e7-7479-a631edd5b1ce@suse.com>
Subject: Re: [PATCH] xen/netback: handle empty rx queue in
 xenvif_rx_next_skb()
References: <20220713074823.5679-1-jgross@suse.com>
 <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>
In-Reply-To: <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>

--------------aDnQdL3LsHraZxZf03Wd7ZQr
Content-Type: multipart/mixed; boundary="------------YhKZd05g8gBi6510GVqI0nZj"

--------------YhKZd05g8gBi6510GVqI0nZj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTMuMDcuMjIgMDk6NTksIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAxMy4wNy4yMDIy
IDA5OjQ4LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4geGVudmlmX3J4X25leHRfc2tiKCkg
aXMgZXhwZWN0aW5nIHRoZSByeCBxdWV1ZSBub3QgYmVpbmcgZW1wdHksIGJ1dA0KPj4gaW4g
Y2FzZSB0aGUgbG9vcCBpbiB4ZW52aWZfcnhfYWN0aW9uKCkgaXMgZG9pbmcgbXVsdGlwbGUg
aXRlcmF0aW9ucywNCj4+IHRoZSBhdmFpbGFiaWxpdHkgb2YgYW5vdGhlciBza2IgaW4gdGhl
IHJ4IHF1ZXVlIGlzIG5vdCBiZWluZyBjaGVja2VkLg0KPj4NCj4+IFRoaXMgY2FuIGxlYWQg
dG8gY3Jhc2hlczoNCj4+DQo+PiBbNDAwNzIuNTM3MjYxXSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwMDgw
DQo+PiBbNDAwNzIuNTM3NDA3XSBJUDogeGVudmlmX3J4X3NrYisweDIzLzB4NTkwIFt4ZW5f
bmV0YmFja10NCj4+IFs0MDA3Mi41Mzc1MzRdIFBHRCAwIFA0RCAwDQo+PiBbNDAwNzIuNTM3
NjQ0XSBPb3BzOiAwMDAwIFsjMV0gU01QIE5PUFRJDQo+PiBbNDAwNzIuNTM3NzQ5XSBDUFU6
IDAgUElEOiAxMjUwNSBDb21tOiB2MS1jNDAyNDctcTItZ3UgTm90IHRhaW50ZWQgNC4xMi4x
NC0xMjIuMTIxLWRlZmF1bHQgIzEgU0xFMTItU1A1DQo+PiBbNDAwNzIuNTM3ODY3XSBIYXJk
d2FyZSBuYW1lOiBIUCBQcm9MaWFudCBETDU4MCBHZW45L1Byb0xpYW50IERMNTgwIEdlbjks
IEJJT1MgVTE3IDExLzIzLzIwMjENCj4+IFs0MDA3Mi41Mzc5OTldIHRhc2s6IGZmZmY4ODA0
MzNiMzgxMDAgdGFzay5zdGFjazogZmZmZmM5MDA0M2Q0MDAwMA0KPj4gWzQwMDcyLjUzODEx
Ml0gUklQOiBlMDMwOnhlbnZpZl9yeF9za2IrMHgyMy8weDU5MCBbeGVuX25ldGJhY2tdDQo+
PiBbNDAwNzIuNTM4MjE3XSBSU1A6IGUwMmI6ZmZmZmM5MDA0M2Q0M2RlMCBFRkxBR1M6IDAw
MDEwMjQ2DQo+PiBbNDAwNzIuNTM4MzE5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBm
ZmZmYzkwMDQzY2Q3Y2QwIFJDWDogMDAwMDAwMDAwMDAwMDBmNw0KPj4gWzQwMDcyLjUzODQz
MF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwNiBSREk6IGZm
ZmZjOTAwNDNkNDNkZjgNCj4+IFs0MDA3Mi41Mzg1MzFdIFJCUDogMDAwMDAwMDAwMDAwMDAz
ZiBSMDg6IDAwMDA3N2ZmODAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDA4DQo+PiBbNDAw
NzIuNTM4NjQ0XSBSMTA6IDAwMDAwMDAwMDAwMDdmZjAgUjExOiAwMDAwMDAwMDAwMDAwOGY2
IFIxMjogZmZmZmM5MDA0M2NlMjcwOA0KPj4gWzQwMDcyLjUzODc0NV0gUjEzOiAwMDAwMDAw
MDAwMDAwMDAwIFIxNDogZmZmZmM5MDA0M2Q0M2VkMCBSMTU6IGZmZmY4ODA0M2VhNzQ4YzAN
Cj4+IFs0MDA3Mi41Mzg4NjFdIEZTOiAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4
ODA0ODQ2MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPj4gWzQwMDcyLjUz
ODk4OF0gQ1M6IGUwMzMgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMz
DQo+PiBbNDAwNzIuNTM5MDg4XSBDUjI6IDAwMDAwMDAwMDAwMDAwODAgQ1IzOiAwMDAwMDAw
NDA3YWM4MDAwIENSNDogMDAwMDAwMDAwMDA0MDY2MA0KPj4gWzQwMDcyLjUzOTIxMV0gQ2Fs
bCBUcmFjZToNCj4+IFs0MDA3Mi41MzkzMTldIHhlbnZpZl9yeF9hY3Rpb24rMHg3MS8weDkw
IFt4ZW5fbmV0YmFja10NCj4+IFs0MDA3Mi41Mzk0MjldIHhlbnZpZl9rdGhyZWFkX2d1ZXN0
X3J4KzB4MTRhLzB4MjljIFt4ZW5fbmV0YmFja10NCj4+DQo+PiBGaXggdGhhdCBieSBzdG9w
cGluZyB0aGUgbG9vcCBpbiBjYXNlIHRoZSByeCBxdWV1ZSBiZWNvbWVzIGVtcHR5Lg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4g
DQo+IFJldmlld2VkLWJ5OiBKYW4gQmV1bGljaCA8amJldWxpY2hAc3VzZS5jb20+DQo+IA0K
PiBEb2VzIHRoaXMgd2FudCBhIEZpeGVzOiB0YWcgYW5kIENjOiB0byBzdGFibGVAIChub3Qg
dGhlIGxlYXN0IHNpbmNlIGFzIHBlcg0KPiBhYm92ZSB0aGUgaXNzdWUgd2FzIG5vdGljZWQg
d2l0aCA0LjEyLngpPw0KDQpIbW0sIEkgX3RoaW5rXyB0aGUgaXNzdWUgd2FzIGludHJvZHVj
ZWQgd2l0aCBlYjE3MjNhMjliOWEuIERvIHlvdSBhZ3JlZT8NCg0KPiANCj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L3hlbi1uZXRiYWNrL3J4LmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3hlbi1u
ZXRiYWNrL3J4LmMNCj4+IEBAIC00OTUsNiArNDk1LDcgQEAgdm9pZCB4ZW52aWZfcnhfYWN0
aW9uKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKQ0KPj4gICAJcXVldWUtPnJ4X2NvcHku
Y29tcGxldGVkID0gJmNvbXBsZXRlZF9za2JzOw0KPj4gICANCj4+ICAgCXdoaWxlICh4ZW52
aWZfcnhfcmluZ19zbG90c19hdmFpbGFibGUocXVldWUpICYmDQo+PiArCSAgICAgICAhc2ti
X3F1ZXVlX2VtcHR5KCZxdWV1ZS0+cnhfcXVldWUpICYmDQo+PiAgIAkgICAgICAgd29ya19k
b25lIDwgUlhfQkFUQ0hfU0laRSkgew0KPj4gICAJCXhlbnZpZl9yeF9za2IocXVldWUpOw0K
Pj4gICAJCXdvcmtfZG9uZSsrOw0KPiANCj4gSSBoYXZlIHRvIGFkbWl0IHRoYXQgSSBmaW5k
IHRoZSB0aXRsZSBhIGxpdHRsZSBtaXNsZWFkaW5nIC0geW91IGRvbid0DQo+IGRlYWwgd2l0
aCB0aGUgaXNzdWUgX2luXyB4ZW52aWZfcnhfbmV4dF9za2IoKTsgeW91IGluc3RlYWQgYXZv
aWQNCj4gZW50ZXJpbmcgdGhlIGZ1bmN0aW9uIGluIHN1Y2ggYSBjYXNlLg0KDQpJJ20gaGFu
ZGxpbmcgdGhlIGlzc3VlIHRvIGF2b2lkICJhbiBlbXB0eSByeCBxdWV1ZSBpbiB4ZW52aWZf
cnhfbmV4dF9za2IoKSIuDQoNCkkgY2FuIHJlcGhyYXNlIGl0IHRvICJhdm9pZCBlbnRlcmlu
ZyB4ZW52aWZfcnhfbmV4dF9za2IoKSB3aXRoIGFuIGVtcHR5IHJ4DQpxdWV1ZSIuDQoNCg0K
SnVlcmdlbg0K
--------------YhKZd05g8gBi6510GVqI0nZj
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

--------------YhKZd05g8gBi6510GVqI0nZj--

--------------aDnQdL3LsHraZxZf03Wd7ZQr--

--------------WdLJwO96tyF2VuhTG3qIw0Ru
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLOkNoFAwAAAAAACgkQsN6d1ii/Ey/d
mAf+JrfpoIGp8Jw5O/VmP+rJvFPQim0YMGfWTtZGuBhBeTWOPmvhPTMCdf3y3p5XmixaJ+tZKist
viAVYJAGkRjKiFU/Sul3HYMZ53AdlYFUcfC4kC5+/hWEhniCocH/wXF4yHMqe/JrT2Fcn2cyYE7o
3IR2yV5/HihSOTaR04/BPWHCcdlafXZFqelNa6Ki271zA8r2UKyqprY8KvAYA0rpwrYykDl8gTup
74SJtjkNb9Xx7J65lZzKtm3PXcqrudc3fMaAMAM6QHrF5xXO7Yo1Kq3R8BQOOU/kti0BbTS2ajgQ
k0WGn4Etf0lgU6bu4GSdVMQg/JLvCC6RwTOdh2CQnQ==
=tTz+
-----END PGP SIGNATURE-----

--------------WdLJwO96tyF2VuhTG3qIw0Ru--
