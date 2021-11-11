Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38F44D77A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhKKNtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:49:16 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44900 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhKKNtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:49:15 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 703431FD54;
        Thu, 11 Nov 2021 13:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636638385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NAF/yJr5v/6eyyS3wjyZwr6hNg/ZHfjNI3pJFtQctxI=;
        b=ia0CZcCp4uTBojcw+YTkCVlP/P+OA3hTIEuZOdEcpYEKaamVTRvnIOEH8ad3EdykZsuE+s
        HTPOf9CvxN0ZpLdrVEVPAAtP81m+uKvIA/jao9vlYCQXN1tBRxskK5V2s6qSn3Ysh2B2Zl
        OYvW+BcM+T+Fl40OqMCKyinu6ysXP04=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9453F13D8F;
        Thu, 11 Nov 2021 13:46:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pCUgIbAejWGINAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 11 Nov 2021 13:46:24 +0000
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
        pv-drivers@vmware.com
Cc:     Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, amakhalov@vmware.com,
        sdeep@vmware.com, virtualization@lists.linux-foundation.org,
        keerthanak@vmware.com, srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, joe@perches.com, kuba@kernel.org,
        rostedt@goodmis.org
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <1074ce5f-06a4-52da-7d2c-6c281e871f7a@suse.com>
Date:   Thu, 11 Nov 2021 14:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UU6HyAmpNKquL2EeOkjBcsuZswhHmhCPA"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UU6HyAmpNKquL2EeOkjBcsuZswhHmhCPA
Content-Type: multipart/mixed; boundary="sjjohHWLN7n6IklkiI33KpOryat72rluS";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
 pv-drivers@vmware.com
Cc: Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
 Vivek Thampi <vithampi@vmware.com>, Vishal Bhakta <vbhakta@vmware.com>,
 Ronak Doshi <doshir@vmware.com>, linux-graphics-maintainer@vmware.com,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
 linux-input@vger.kernel.org, amakhalov@vmware.com, sdeep@vmware.com,
 virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
 srivatsab@vmware.com, anishs@vmware.com, linux-kernel@vger.kernel.org,
 joe@perches.com, kuba@kernel.org, rostedt@goodmis.org
Message-ID: <1074ce5f-06a4-52da-7d2c-6c281e871f7a@suse.com>
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
In-Reply-To: <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>

--sjjohHWLN7n6IklkiI33KpOryat72rluS
Content-Type: multipart/mixed;
 boundary="------------70DE7479312B276329FA74A4"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------70DE7479312B276329FA74A4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10.11.21 21:09, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>=20
> VMware mailing lists in the MAINTAINERS file are private lists meant
> for VMware-internal review/notification for patches to the respective
> subsystems. Anyone can post to these addresses, but there is no public
> read access like open mailing lists, which makes them more like email
> aliases instead (to reach out to reviewers).
>=20
> So update all the VMware mailing list references in the MAINTAINERS
> file to mark them as such, using "R: email-alias@vmware.com".
>=20
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Acked-by: Juergen Gross <jgross@suse.com>


Juergen

--------------70DE7479312B276329FA74A4
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

--------------70DE7479312B276329FA74A4--

--sjjohHWLN7n6IklkiI33KpOryat72rluS--

--UU6HyAmpNKquL2EeOkjBcsuZswhHmhCPA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGNHq8FAwAAAAAACgkQsN6d1ii/Ey/9
dgf/Q0I7w7riRIIWsIohFJK9GXIxTsH7a0tXejDwGNNCZgkN2Fg0HPA6qKtePFrw9SSWWPxTXzpj
k2Vkx5cecHODWygm4EuqMipawRlsfDZIIXSZwKQe7im1Q/gg8Ia0/RGT9i65FQEAz54EP+nWKEWN
J889ahikfXsudz39IOXf+XjUkbmwVN/abmC35CC5mwtgsmBrXLwficnpwLBNrMwBOAwS7To+q6eA
0e596byenUg1NcS2yjPBBJ+L8JxSf4lzXbtnCkeX38MmF/veoa1/vnhqfpUUOaCuAvXzIDjqAUkT
z9pZeOg/gJztvwhNTNzoR9dPKnzXAxixTLwfgVgtQA==
=mGeS
-----END PGP SIGNATURE-----

--UU6HyAmpNKquL2EeOkjBcsuZswhHmhCPA--
