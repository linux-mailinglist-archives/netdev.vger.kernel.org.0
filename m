Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B9406A83
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhIJLLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 07:11:31 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59746 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhIJLLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 07:11:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C0DDC22417;
        Fri, 10 Sep 2021 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631272218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B85pWNIawjf+ROs1E6I9WKVnZ0AMScExck/UPNJ8eAw=;
        b=vC8AXFAeTRGGst2lp9oJ3Pu6Xvn9CuSnhGjrc03/Skt+/cJvW/w0Mry3ZRPI7tVaIR2jTS
        5UbDgi6lqtnQri4kpDUqFSifj6vl3OChQmCaIw2BGD3vIkzBc/+/hXik9rsxQ/sL8oo2SY
        keZ1cXG8nmZ/88CcLju9QDETzT7B0Vs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 70C8413D34;
        Fri, 10 Sep 2021 11:10:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id X63eGBo9O2F9KAAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 10 Sep 2021 11:10:18 +0000
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>
References: <20210824102809.26370-1-jgross@suse.com>
 <1f98d97c-1610-6a66-e269-29b2a9e41004@suse.com> <YTsxTKNlL1KgMhB3@mail-itl>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2 0/4] xen: harden netfront against malicious backends
Message-ID: <f7c2d087-fae9-00b4-c616-0a4183f2fb33@suse.com>
Date:   Fri, 10 Sep 2021 13:10:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YTsxTKNlL1KgMhB3@mail-itl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FjaKuwnjx13J0odcEUplWJ7LScrlhUZmY"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FjaKuwnjx13J0odcEUplWJ7LScrlhUZmY
Content-Type: multipart/mixed; boundary="o8OMKQYBoVm3U8xmgXWnzMvYO6ZDy3Ay3";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>
Message-ID: <f7c2d087-fae9-00b4-c616-0a4183f2fb33@suse.com>
Subject: Re: [PATCH v2 0/4] xen: harden netfront against malicious backends
References: <20210824102809.26370-1-jgross@suse.com>
 <1f98d97c-1610-6a66-e269-29b2a9e41004@suse.com> <YTsxTKNlL1KgMhB3@mail-itl>
In-Reply-To: <YTsxTKNlL1KgMhB3@mail-itl>

--o8OMKQYBoVm3U8xmgXWnzMvYO6ZDy3Ay3
Content-Type: multipart/mixed;
 boundary="------------55CE04332F4BD8EF3EA80965"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------55CE04332F4BD8EF3EA80965
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10.09.21 12:19, Marek Marczykowski-G=C3=B3recki wrote:
> On Tue, Aug 24, 2021 at 05:33:10PM +0200, Jan Beulich wrote:
>> On 24.08.2021 12:28, Juergen Gross wrote:
>>> It should be mentioned that a similar series has been posted some yea=
rs
>>> ago by Marek Marczykowski-G=C3=B3recki, but this series has not been =
applied
>>> due to a Xen header not having been available in the Xen git repo at
>>> that time. Additionally my series is fixing some more DoS cases.
>>
>> With this, wouldn't it have made sense to Cc Marek, in case he wants t=
o
>> check against his own version (which over time may have evolved and
>> hence not match the earlier submission anymore)?
>=20
> I have compared this, and the blkfront series against my patches and
> they seem to cover exactly the same set of issues. Besides one comment =
I
> made separately, I think nothing is missing. Thanks!
>=20
> BTW, shouldn't those those patches land in stable branches too? In some=

> threat models, I'd qualify them as security fixes.

Its on my todo list.

Most stable branches will need backports, so this might require some
more time to get it finished.


Juergen

--------------55CE04332F4BD8EF3EA80965
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------55CE04332F4BD8EF3EA80965--

--o8OMKQYBoVm3U8xmgXWnzMvYO6ZDy3Ay3--

--FjaKuwnjx13J0odcEUplWJ7LScrlhUZmY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE7PRkFAwAAAAAACgkQsN6d1ii/Ey+0
zAf8Dtct4+rMmXDhRPEQ40F+nWxxZ6QH2JUCITz9c+jobgeamihvzRbI32HcRFtbiNqCtzaikmaG
hd/BS+MexBuqupWl6AAs7ThD1vbvyQK7gLFgnRnHoVbyGZKGi0MtifdY4yOU4L/TJ8Dv/tGzJFCQ
Q51A+CSKLz434A16Jq09qRgDn8Hr2f7QKi+Av39ZxcS3qc2hjvssYjwvnwDBZYRnPoSOcK1KD1Nt
TDRmlCY7HcksW+hfj1hPnc3k+jE9dlOZd05+ZSmpAEfbOT5wv6nApAhqY02NKmqBCWfkmBZxPe00
ZGAbTMQJUrwUgshMn2ImAe4/ZfyjXvYQJHgG5xdGdQ==
=a9tK
-----END PGP SIGNATURE-----

--FjaKuwnjx13J0odcEUplWJ7LScrlhUZmY--
