Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477B6313490
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhBHOIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:08:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:60716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhBHN7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 08:59:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612792694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcBhSfP94VTv7FXTnn4DMhRjG+4pRpXkNW2nr2ZTzIA=;
        b=mOmky49dpItLnisu1ssDflSKufMzx7HOIXR0mmEqtiD6+ovsjz9zEQWL9Di0nUCfcSIwKe
        KMpQpWzNVeaPBLHAEX3MAXqTf0aDST9hFkhv2mFs+s9RCm+Kg590Q/tW7llRsHv1B89fJT
        W0Oj70T1zfvL+y8yU8rguhesfOa8qGk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A9FEACF4;
        Mon,  8 Feb 2021 13:58:14 +0000 (UTC)
To:     Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206104932.29064-1-jgross@suse.com>
 <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
 <eeb62129-d9fc-2155-0e0f-aff1fbb33fbc@suse.com>
 <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
 <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
 <6f547bb5-777a-6fc2-eba2-cccb4adfca87@xen.org>
 <0d623c98-a714-1639-cc53-f58ba3f08212@suse.com>
 <28399fd1-9fe8-f31a-6ee8-e78de567155b@xen.org>
 <1831964f-185e-31bb-2446-778f2c18d71b@suse.com>
 <e8c46e36-cf9e-fb30-21b5-fa662834a01a@xen.org>
 <199b76fd-630b-a0c6-926b-3e662103ec42@suse.com>
 <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
Message-ID: <4279cab9-9b36-e83d-bd7a-ff7cd2832054@suse.com>
Date:   Mon, 8 Feb 2021 14:58:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aeHBsCzabkbZQTGoGyDZ3tNfjnz3rrSmx"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aeHBsCzabkbZQTGoGyDZ3tNfjnz3rrSmx
Content-Type: multipart/mixed; boundary="ykmiwzPoeTGee2Ilphs7XRwDJ8uG5zBLk";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
 Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
 Paul Durrant <paul@xen.org>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>
Message-ID: <4279cab9-9b36-e83d-bd7a-ff7cd2832054@suse.com>
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
References: <20210206104932.29064-1-jgross@suse.com>
 <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
 <eeb62129-d9fc-2155-0e0f-aff1fbb33fbc@suse.com>
 <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
 <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
 <6f547bb5-777a-6fc2-eba2-cccb4adfca87@xen.org>
 <0d623c98-a714-1639-cc53-f58ba3f08212@suse.com>
 <28399fd1-9fe8-f31a-6ee8-e78de567155b@xen.org>
 <1831964f-185e-31bb-2446-778f2c18d71b@suse.com>
 <e8c46e36-cf9e-fb30-21b5-fa662834a01a@xen.org>
 <199b76fd-630b-a0c6-926b-3e662103ec42@suse.com>
 <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>
In-Reply-To: <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>

--ykmiwzPoeTGee2Ilphs7XRwDJ8uG5zBLk
Content-Type: multipart/mixed;
 boundary="------------41703FFA3099386D19AA195D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------41703FFA3099386D19AA195D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.02.21 14:09, Julien Grall wrote:
> Hi Juergen,
>=20
> On 08/02/2021 12:31, J=C3=BCrgen Gro=C3=9F wrote:
>> On 08.02.21 13:16, Julien Grall wrote:
>>>
>>>
>>> On 08/02/2021 12:14, J=C3=BCrgen Gro=C3=9F wrote:
>>>> On 08.02.21 11:40, Julien Grall wrote:
>>>>> Hi Juergen,
>>>>>
>>>>> On 08/02/2021 10:22, J=C3=BCrgen Gro=C3=9F wrote:
>>>>>> On 08.02.21 10:54, Julien Grall wrote:
>>>>>>> ... I don't really see how the difference matter here. The idea=20
>>>>>>> is to re-use what's already existing rather than trying to=20
>>>>>>> re-invent the wheel with an extra lock (or whatever we can come u=
p).
>>>>>>
>>>>>> The difference is that the race is occurring _before_ any IRQ is
>>>>>> involved. So I don't see how modification of IRQ handling would he=
lp.
>>>>>
>>>>> Roughly our current IRQ handling flow (handle_eoi_irq()) looks like=
:
>>>>>
>>>>> if ( irq in progress )
>>>>> {
>>>>> =C2=A0=C2=A0 set IRQS_PENDING
>>>>> =C2=A0=C2=A0 return;
>>>>> }
>>>>>
>>>>> do
>>>>> {
>>>>> =C2=A0=C2=A0 clear IRQS_PENDING
>>>>> =C2=A0=C2=A0 handle_irq()
>>>>> } while (IRQS_PENDING is set)
>>>>>
>>>>> IRQ handling flow like handle_fasteoi_irq() looks like:
>>>>>
>>>>> if ( irq in progress )
>>>>> =C2=A0=C2=A0 return;
>>>>>
>>>>> handle_irq()
>>>>>
>>>>> The latter flow would catch "spurious" interrupt and ignore them.=20
>>>>> So it would handle nicely the race when changing the event affinity=
=2E
>>>>
>>>> Sure? Isn't "irq in progress" being reset way before our "lateeoi" i=
s
>>>> issued, thus having the same problem again?=20
>>>
>>> Sorry I can't parse this.
>>
>> handle_fasteoi_irq() will do nothing "if ( irq in progress )". When is=

>> this condition being reset again in order to be able to process anothe=
r
>> IRQ?
> It is reset after the handler has been called. See handle_irq_event().

Right. And for us this is too early, as we want the next IRQ being
handled only after we have called xen_irq_lateeoi().

>=20
>> I believe this will be the case before our "lateeoi" handling is
>> becoming active (more precise: when our IRQ handler is returning to
>> handle_fasteoi_irq()), resulting in the possibility of the same race w=
e
>> are experiencing now.
>=20
> I am a bit confused what you mean by "lateeoi" handling is becoming=20
> active. Can you clarify?

See above: the next call of the handler should be allowed only after
xen_irq_lateeoi() for the IRQ has been called.

If the handler is being called earlier we have the race resulting
in the WARN() splats.

> Note that are are other IRQ flows existing. We should have a look at=20
> them before trying to fix thing ourself.

Fine with me, but it either needs to fit all use cases (interdomain,
IPI, real interrupts) or we need to have a per-type IRQ flow.

I think we should fix the issue locally first, then we can start to do
a thorough rework planning. Its not as if the needed changes with the
current flow would be so huge, and I'd really like to have a solution
rather sooner than later. Changing the IRQ flow might have other side
effects which need to be excluded by thorough testing.

> Although, the other issue I can see so far is handle_irq_for_port() wil=
l=20
> update info->{eoi_cpu, irq_epoch, eoi_time} without any locking. But it=
=20
> is not clear this is what you mean by "becoming active".

As long as a single event can't be handled on multiple cpus at the same
time, there is no locking needed.


Juergen

--------------41703FFA3099386D19AA195D
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
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

--------------41703FFA3099386D19AA195D--

--ykmiwzPoeTGee2Ilphs7XRwDJ8uG5zBLk--

--aeHBsCzabkbZQTGoGyDZ3tNfjnz3rrSmx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAhQ3MFAwAAAAAACgkQsN6d1ii/Ey//
nwf/WR1HuxI4mP/eoTooYvlrvMdLQwJz76FzY7shxiHf/hlxC/tgI33fNMpt3wtQb4WhGDvccmUX
oZ37H1af/nUkBChVqXHSlBtBrTJYMUj1gKCWouzG8fQCDLSXmVHncw4RAmbXbR+1+Xy2qYv6SxNN
AWL0Tyg3rRb8SJo2fGKdW7/HMzfVxPfokE72KwrHAtaUMOldU73EOAh5U0fsYeJcOIsjjTptUBqc
8gv7pwpwgLXZ7/fg9LnfNJEFXtXh9wDUt4OVPsJl80+pNdgKyfN6uU9CV/O1RNpEMice/LMU66fu
P4TfgwDldPKZmjD3Z95wujkJ/7s83pFv4Cu6SM63vw==
=/+rS
-----END PGP SIGNATURE-----

--aeHBsCzabkbZQTGoGyDZ3tNfjnz3rrSmx--
