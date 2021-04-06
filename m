Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0046635509E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245021AbhDFKNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:13:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:42450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhDFKNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:13:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617704005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8cflDCdCAHn/feQ6y/fdQCcOzwC5YDp8w2O6XKwpJe4=;
        b=UfIlQ/2kCAALyPW2InPw1cZUcXu9DCg2+2qzUNoFrUet79YCOSJ18+tP4TwAbAYUlTEjBs
        wpUGW0iq3kng7utitGYERqFrBtJRyiWjRjPF8TF9KOw9KRiLy9baUZGatkmaKfV3JczyHv
        9GL2LB+fNuIWsIe0bsn2bNTCgqSUlvo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E32FB13B;
        Tue,  6 Apr 2021 10:13:25 +0000 (UTC)
To:     Michal Kubecek <mkubecek@suse.cz>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>
References: <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
 <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Message-ID: <2ddff17a-8af5-0b73-4a48-859726f26df3@suse.com>
Date:   Tue, 6 Apr 2021 12:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lMgIzgBY2m4XsxOx0SCFMqoqFMMD46TbN"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lMgIzgBY2m4XsxOx0SCFMqoqFMMD46TbN
Content-Type: multipart/mixed; boundary="cWtt7YjAbD3iB9pFFWkm2Nv4hdKWc1Ad3";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Michal Kubecek <mkubecek@suse.cz>, Yunsheng Lin <linyunsheng@huawei.com>
Cc: Jiri Kosina <jikos@kernel.org>, Hillf Danton <hdanton@sina.com>,
 John Fastabend <john.fastabend@gmail.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Kehuan Feng <kehuan.feng@gmail.com>, Jike Song <albcamus@gmail.com>,
 Jonas Bonn <jonas.bonn@netrounds.com>, Michael Zhivich
 <mzhivich@akamai.com>, David Miller <davem@davemloft.net>,
 LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
 Josh Hunt <johunt@akamai.com>
Message-ID: <2ddff17a-8af5-0b73-4a48-859726f26df3@suse.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
References: <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
 <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>
In-Reply-To: <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>

--cWtt7YjAbD3iB9pFFWkm2Nv4hdKWc1Ad3
Content-Type: multipart/mixed;
 boundary="------------AC956614B9669DA052541526"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------AC956614B9669DA052541526
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 06.04.21 09:06, Michal Kubecek wrote:
> On Tue, Apr 06, 2021 at 08:55:41AM +0800, Yunsheng Lin wrote:
>>
>> Hi, Jiri
>> Do you have a reproducer that can be shared here?
>> With reproducer, I can debug and test it myself too.
>=20
> I'm afraid we are not aware of a simple reproducer. As mentioned in the=

> original discussion, the race window is extremely small and the other
> thread has to do quite a lot in the meantime which is probably why, as
> far as I know, this was never observed on real hardware, only in
> virtualization environments. NFS may also be important as, IIUC, it can=

> often issue an RPC request from a different CPU right after a data
> transfer. Perhaps you could cheat a bit and insert a random delay
> between the empty queue check and releasing q->seqlock to make it more
> likely to happen.
>=20
> Other than that, it's rather just "run this complex software in a xen V=
M
> and wait".

Being the one who has managed to reproduce the issue I can share my
setup, maybe you can setup something similar (we have seen the issue
with this kind of setup on two different machines).

I'm using a physical machine with 72 cpus and 48 GB of memory. It is
running Xen as virtualization platform.

Xen dom0 is limited to 40 vcpus and 32 GB of memory, the dom0 vcpus are
limited to run on the first 40 physical cpus (no idea whether that
matters, though).

In a guest with 16 vcpu and 8GB of memory I'm running 8 parallel
sysbench instances in a loop, those instances are prepared via

sysbench --file-test-mode=3Drndrd --test=3Dfileio prepare

and then started in a do while loop via:

sysbench --test=3Dfileio --file-test-mode=3Drndrw --rand-seed=3D0=20
--max-time=3D300 --max-requests=3D0 run

Each instance is using a dedicated NFS mount to run on. The NFS
server for the 8 mounts is running in dom0 of the same server, the
data of the NFS shares is located in a RAM disk (size is a little bit
above 16GB). The shares are mounted in the guest with:

mount -t nfs -o=20
rw,proto=3Dtcp,nolock,nfsvers=3D3,rsize=3D65536,wsize=3D65536,nosharetran=
sport=20
dom0:/ramdisk/share[1-8] /mnt[1-8]

The guests vcpus are limited to run on physical cpus 40-55, on the same
physical cpus I have 16 small guests running eating up cpu time, each of
those guests is pinned to one of the physical cpus 40-55.

That's basically it. All you need to do is to watch out for sysbench
reporting maximum latencies above one second or so (in my setup there
are latencies of several minutes at least once each hour of testing).

In case you'd like to have some more details about the setup don't
hesitate to contact me directly. I can provide you with some scripts
and config runes if you want.


Juergen

--------------AC956614B9669DA052541526
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

--------------AC956614B9669DA052541526--

--cWtt7YjAbD3iB9pFFWkm2Nv4hdKWc1Ad3--

--lMgIzgBY2m4XsxOx0SCFMqoqFMMD46TbN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBsNEMFAwAAAAAACgkQsN6d1ii/Ey8+
VQgAlGad5NUlGnOKHYJWSZnst3HyPyOZsLG2EhHCzdzIIqnnFIUfbmKqfBTSlXWdXP4jPk/FjWb8
iwwKUmRAOWi4OBMkEQV5D6aFyK03eDps29IbcYOrVaxT6iOzpNNZju17OAt2vtr3IOTbw1shBs42
3u8dUmwLmAXMTJ4LmiU1lhbgHHhCRfHrz7D5hnnaMAapkHvpo8gCr/9+allFBn50Hcu340IlQOWj
3eMLHMgmgpOjR7a3gvkgIntyWiB/0FT3+QrsHwQ+venyoMMKeaNtk5roEelBD9v93cl//wBaaA36
5tmSdAiMUnUP6uiK6v7CH2Wfm19e9Mp9KEoFokQ9kQ==
=I2QP
-----END PGP SIGNATURE-----

--lMgIzgBY2m4XsxOx0SCFMqoqFMMD46TbN--
