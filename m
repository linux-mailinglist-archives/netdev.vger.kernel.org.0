Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4DF312D9F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhBHJo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:44:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:55460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231734AbhBHJl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 04:41:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612777262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fF169tx56y6mupjIvrPQt9dqN5xV/kHLsueKWM8xvUg=;
        b=MoSRipFUt6ufW8TtS8lzbiX5/FVZJzmez4YJCZRHeMBFobJx4wUaMpOEY0Ksoxlj08E0EB
        BMga+pAmqKxvJzr+h92HO0x1eYAOFojiRnJ+LvHFYMgWcOQM2yxISYYR1UJ41qM4vIXkKZ
        9dFMw0ot34fjhu/eiJLf+M+wr0MVcMQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EAB7EAE53;
        Mon,  8 Feb 2021 09:41:01 +0000 (UTC)
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
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
Message-ID: <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
Date:   Mon, 8 Feb 2021 10:41:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GMBB9RCSmiMsxNr0VEDv5TlmxZ6GktJjs"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GMBB9RCSmiMsxNr0VEDv5TlmxZ6GktJjs
Content-Type: multipart/mixed; boundary="k4gyNUY4aI5Lw9phW38uxpSLf7g9cDz0D";
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
Message-ID: <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
References: <20210206104932.29064-1-jgross@suse.com>
 <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
 <eeb62129-d9fc-2155-0e0f-aff1fbb33fbc@suse.com>
 <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
In-Reply-To: <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>

--k4gyNUY4aI5Lw9phW38uxpSLf7g9cDz0D
Content-Type: multipart/mixed;
 boundary="------------8545B5C2DC00D006FC21850E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------8545B5C2DC00D006FC21850E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.02.21 10:11, Julien Grall wrote:
> Hi Juergen,
>=20
> On 07/02/2021 12:58, J=C3=BCrgen Gro=C3=9F wrote:
>> On 06.02.21 19:46, Julien Grall wrote:
>>> Hi Juergen,
>>>
>>> On 06/02/2021 10:49, Juergen Gross wrote:
>>>> The first three patches are fixes for XSA-332. The avoid WARN splats=

>>>> and a performance issue with interdomain events.
>>>
>>> Thanks for helping to figure out the problem. Unfortunately, I still =

>>> see reliably the WARN splat with the latest Linux master=20
>>> (1e0d27fce010) + your first 3 patches.
>>>
>>> I am using Xen 4.11 (1c7d984645f9) and dom0 is forced to use the 2L=20
>>> events ABI.
>>>
>>> After some debugging, I think I have an idea what's went wrong. The=20
>>> problem happens when the event is initially bound from vCPU0 to a=20
>>> different vCPU.
>>>
>>> =C2=A0From the comment in xen_rebind_evtchn_to_cpu(), we are masking =
the=20
>>> event to prevent it being delivered on an unexpected vCPU. However, I=
=20
>>> believe the following can happen:
>>>
>>> vCPU0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | vCPU1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | Call xen_rebind_evtchn_to_cpu()
>>> receive event X=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | mask event X
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | bind to vCPU1
>>> <vCPU descheduled>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | unmask=
 event X
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | receive event X
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | handle_edge_irq(X)
>>> handle_edge_irq(X)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
-> handle_irq_event()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 -> set IRQD_IN_PROGRESS
>>> =C2=A0=C2=A0-> set IRQS_PENDING=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 -> evtchn_interrupt()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 -> clear IRQD_IN_PROGRESS
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 -> IRQS_PENDING is set
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 -> handle_irq_event()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 -> evtchn_interrupt()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 -> WARN()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>>>
>>> All the lateeoi handlers expect a ONESHOT semantic and=20
>>> evtchn_interrupt() is doesn't tolerate any deviation.
>>>
>>> I think the problem was introduced by 7f874a0447a9 ("xen/events: fix =

>>> lateeoi irq acknowledgment") because the interrupt was disabled=20
>>> previously. Therefore we wouldn't do another iteration in=20
>>> handle_edge_irq().
>>
>> I think you picked the wrong commit for blaming, as this is just
>> the last patch of the three patches you were testing.
>=20
> I actually found the right commit for blaming but I copied the=20
> information from the wrong shell :/. The bug was introduced by:
>=20
> c44b849cee8c ("xen/events: switch user event channels to lateeoi model"=
)
>=20
>>
>>> Aside the handlers, I think it may impact the defer EOI mitigation=20
>>> because in theory if a 3rd vCPU is joining the party (let say vCPU A =

>>> migrate the event from vCPU B to vCPU C). So info->{eoi_cpu,=20
>>> irq_epoch, eoi_time} could possibly get mangled?
>>>
>>> For a fix, we may want to consider to hold evtchn_rwlock with the=20
>>> write permission. Although, I am not 100% sure this is going to=20
>>> prevent everything.
>>
>> It will make things worse, as it would violate the locking hierarchy
>> (xen_rebind_evtchn_to_cpu() is called with the IRQ-desc lock held).
>=20
> Ah, right.
>=20
>>
>> On a first glance I think we'll need a 3rd masking state ("temporarily=

>> masked") in the second patch in order to avoid a race with lateeoi.
>>
>> In order to avoid the race you outlined above we need an "event is bei=
ng
>> handled" indicator checked via test_and_set() semantics in
>> handle_irq_for_port() and reset only when calling clear_evtchn().
>=20
> It feels like we are trying to workaround the IRQ flow we are using=20
> (i.e. handle_edge_irq()).

I'm not really sure this is the main problem here. According to your
analysis the main problem is occurring when handling the event, not when
handling the IRQ: the event is being received on two vcpus.

Our problem isn't due to the IRQ still being pending, but due it being
raised again, which should happen for a one shot IRQ the same way.

But maybe I'm misunderstanding your idea.


Juergen

--------------8545B5C2DC00D006FC21850E
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

--------------8545B5C2DC00D006FC21850E--

--k4gyNUY4aI5Lw9phW38uxpSLf7g9cDz0D--

--GMBB9RCSmiMsxNr0VEDv5TlmxZ6GktJjs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAhBywFAwAAAAAACgkQsN6d1ii/Ey+X
7Qf+OnrlhZHoEZMFLJ8YuxArgwY/dc0hT9fYNejZag9l2vEAND4Z36Oqpy4lMt9l1wsocKvxEhhF
pSpzfvQWh9qFvJbNZtU3gSfVM6z8XQ+FXWlr2vfGOqMmYTZKKcZrMtTmL0spDeb4EDwM1G86mtZ4
88bV0RVAoliWwy5CUk5MyZyHwYOC3YeH3VP7K3kBLy4F1gopdOrTWHvI50FFrTBavw1ZnCRTzlgj
qYWYHD2ztYmPtDEtlSsfcyxj2+xur511a16/B/RfP0f+g1maWYySmaxhVFNQa+icHKzu8VgfenHR
sXi1Zu4uQNMf/zQXInigQg8IPawMiI2GTHjN+tovog==
=fwXt
-----END PGP SIGNATURE-----

--GMBB9RCSmiMsxNr0VEDv5TlmxZ6GktJjs--
