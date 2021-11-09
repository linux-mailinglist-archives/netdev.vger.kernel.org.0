Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3811F44A662
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 06:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhKIFhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 00:37:32 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56324 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbhKIFhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 00:37:19 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1B1F921B06;
        Tue,  9 Nov 2021 05:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636436073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25xyWJJliRTmh2VW41Gr038sYdV14J8Jet0MH+0nmRc=;
        b=YFtzPnXqG67rjcdQsp5lPWm1fNyQb9weZabWSAy9opVyfNCeSNE9TQrEJI67FA5fFtvYSk
        UjUHjg4l1zda4NZshFvs2ysrDGpnMKdhHQ/BqcBOV8MMnX1dShLwur4h16FgvC1WyeeniV
        ireRCYpnLH0OrmtKH2jjH0KtmgSwyJ0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D1F813A9D;
        Tue,  9 Nov 2021 05:34:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id spzKHGgIimGncwAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 09 Nov 2021 05:34:32 +0000
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
        pv-drivers@vmware.com
Cc:     Nadav Amit <namit@vmware.com>, Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        sdeep@vmware.com, amakhalov@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Message-ID: <05804bc2-60fb-b1f8-c0c4-ad7b1c45462a@suse.com>
Date:   Tue, 9 Nov 2021 06:34:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="al1MqEmNzTaRWgbdIcvBJCOhrC2hGsWXq"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--al1MqEmNzTaRWgbdIcvBJCOhrC2hGsWXq
Content-Type: multipart/mixed; boundary="W6JL2G1FAlQS9hzWi03hu2aIhExlEcuAp";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
 pv-drivers@vmware.com
Cc: Nadav Amit <namit@vmware.com>, Vivek Thampi <vithampi@vmware.com>,
 Vishal Bhakta <vbhakta@vmware.com>, Ronak Doshi <doshir@vmware.com>,
 linux-graphics-maintainer@vmware.com, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
 netdev@vger.kernel.org, linux-input@vger.kernel.org,
 Zack Rusin <zackr@vmware.com>, sdeep@vmware.com, amakhalov@vmware.com,
 virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
 srivatsab@vmware.com, anishs@vmware.com, linux-kernel@vger.kernel.org
Message-ID: <05804bc2-60fb-b1f8-c0c4-ad7b1c45462a@suse.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
In-Reply-To: <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>

--W6JL2G1FAlQS9hzWi03hu2aIhExlEcuAp
Content-Type: multipart/mixed;
 boundary="------------641FCF0DF0F5BF271A32D69F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------641FCF0DF0F5BF271A32D69F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.11.21 21:30, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>=20
> VMware mailing lists in the MAINTAINERS file are private lists meant
> for VMware-internal review/notification for patches to the respective
> subsystems. So, in an earlier discussion [1][2], it was recommended to
> mark them as such. Update all the remaining VMware mailing list
> references to use that format -- "L: list@address (private)".
>=20
> [1]. https://lore.kernel.org/r/YPfp0Ff6KuyPlyrc@kroah.com
> [2]. https://lore.kernel.org/r/1626861766-11115-1-git-send-email-jhanse=
n@vmware.com
>=20
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Vivek Thampi <vithampi@vmware.com>
> Cc: Vishal Bhakta <vbhakta@vmware.com>
> Cc: Ronak Doshi <doshir@vmware.com>
> Cc: pv-drivers@vmware.com
> Cc: linux-graphics-maintainer@vmware.com
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Acked-by: Zack Rusin <zackr@vmware.com>
> ---
>=20
>   MAINTAINERS |   16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 118cf8170d02..3e92176e68fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc=

>   F:	drivers/gpu/drm/vboxvideo/
>  =20
>   DRM DRIVER FOR VMWARE VIRTUAL GPU
> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
>   M:	Zack Rusin <zackr@vmware.com>
> +L:	linux-graphics-maintainer@vmware.com (private)
>   L:	dri-devel@lists.freedesktop.org
>   S:	Supported
>   T:	git git://anongit.freedesktop.org/drm/drm-misc
> @@ -20032,7 +20032,7 @@ F:	tools/testing/vsock/
>  =20
>   VMWARE BALLOON DRIVER
>   M:	Nadav Amit <namit@vmware.com>
> -M:	"VMware, Inc." <pv-drivers@vmware.com>
> +L:	pv-drivers@vmware.com (private)
>   L:	linux-kernel@vger.kernel.org
>   S:	Maintained
>   F:	drivers/misc/vmw_balloon.c
> @@ -20050,14 +20050,14 @@ F:	arch/x86/kernel/cpu/vmware.c
>  =20
>   VMWARE PVRDMA DRIVER
>   M:	Adit Ranadive <aditr@vmware.com>
> -M:	VMware PV-Drivers <pv-drivers@vmware.com>
> +L:	pv-drivers@vmware.com (private)
>   L:	linux-rdma@vger.kernel.org
>   S:	Maintained
>   F:	drivers/infiniband/hw/vmw_pvrdma/
>  =20
>   VMware PVSCSI driver
>   M:	Vishal Bhakta <vbhakta@vmware.com>
> -M:	VMware PV-Drivers <pv-drivers@vmware.com>
> +L:	pv-drivers@vmware.com (private)
>   L:	linux-scsi@vger.kernel.org
>   S:	Maintained
>   F:	drivers/scsi/vmw_pvscsi.c
> @@ -20065,7 +20065,7 @@ F:	drivers/scsi/vmw_pvscsi.h
>  =20
>   VMWARE VIRTUAL PTP CLOCK DRIVER
>   M:	Vivek Thampi <vithampi@vmware.com>
> -M:	"VMware, Inc." <pv-drivers@vmware.com>
> +L:	pv-drivers@vmware.com (private)

Maybe replace "(private)" with "(mail alias)"?

This makes it rather clear that it is a valid address to send patches
to, but there isn't public read access like to a ML.


Juergen

--------------641FCF0DF0F5BF271A32D69F
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

--------------641FCF0DF0F5BF271A32D69F--

--W6JL2G1FAlQS9hzWi03hu2aIhExlEcuAp--

--al1MqEmNzTaRWgbdIcvBJCOhrC2hGsWXq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGKCGcFAwAAAAAACgkQsN6d1ii/Ey8u
mAf9Eohn0vhRkZfBHW2PFyfa0gZy/DBnsmYZqD0AlEU0pdjXa8N6Tb/wi3M5766KlH/8jeYwhAgt
ufbWa0xahKxCM2me8vcPYnTOBnDAgQbYy2FX2wvwIeEI4+VGOFg5N6V01t0wil/Ir+PanX8qpVsk
dFszyJmdghQS1CI0gmJuPpWclILZ/Z0PqS/L0IhNj+aS/6Z7VdghUOiszYdyxQg83zTNQaJQL0eH
5CHayDfrVrHtyhkGOB2wOntPfn2mHdk/baAARc7D1cPq8jxnUBWbiIrXha1WLaQE07/yM7jjItaF
ei6KlBukKfmo5aoDnH9X1wOzB43CsDDVCAysHkGPoQ==
=Y9rQ
-----END PGP SIGNATURE-----

--al1MqEmNzTaRWgbdIcvBJCOhrC2hGsWXq--
