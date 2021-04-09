Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F4B35948C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 07:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhDIFbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 01:31:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:44124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhDIFbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 01:31:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617946267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dUyZP7P4xA+xPzX2ba0l8kT9zCH9NJ6E9eFzEIksaXQ=;
        b=QlH7AvwABeg+r4h+GIi/sUzv+gfX5X1Ye35qtMKCLXqeNhnf4kMPyCap2FTjWVdnVX50Nz
        SxpRHir+TKZjOill5k2vhP9mUm60SSNoUTwyFhr/X69sKYL/V7ayyiG9gWbs1S5FK41Br6
        /JJX5+Ej++b148S8PdcfYqHEf7xE90Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7376B01C;
        Fri,  9 Apr 2021 05:31:06 +0000 (UTC)
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
Message-ID: <eb0e44fe-bbe0-75ba-fd16-cbf4638e1c0d@suse.com>
Date:   Fri, 9 Apr 2021 07:31:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KNfSBDESab9zDoXGXKJSsQrdHG9FC4fMd"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KNfSBDESab9zDoXGXKJSsQrdHG9FC4fMd
Content-Type: multipart/mixed; boundary="LSz7PCDIMfnx6xL5FBKNaZUVKlHLEdp1Z";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org
Cc: olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
 edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
 ap420073@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@openeuler.org, mkl@pengutronix.de, linux-can@vger.kernel.org,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
 jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
 johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
 a.fatoum@pengutronix.de, atenart@kernel.org, alexander.duyck@gmail.com,
 Jiri Kosina <JKosina@suse.com>
Message-ID: <eb0e44fe-bbe0-75ba-fd16-cbf4638e1c0d@suse.com>
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>

--LSz7PCDIMfnx6xL5FBKNaZUVKlHLEdp1Z
Content-Type: multipart/mixed;
 boundary="------------CDB4D2BA5B7A94706A1D1B2A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CDB4D2BA5B7A94706A1D1B2A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 25.03.21 04:13, Yunsheng Lin wrote:
> Lockless qdisc has below concurrent problem:
>      cpu0                 cpu1
>       .                     .
> q->enqueue                 .
>       .                     .
> qdisc_run_begin()          .
>       .                     .
> dequeue_skb()              .
>       .                     .
> sch_direct_xmit()          .
>       .                     .
>       .                q->enqueue
>       .             qdisc_run_begin()
>       .            return and do nothing
>       .                     .
> qdisc_run_end()            .
>=20
> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
> has not released the lock yet and spin_trylock() return false
> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
> enqueue the skb after cpu0 calling dequeue_skb() and before
> cpu0 calling qdisc_run_end().
>=20
> Lockless qdisc has below another concurrent problem when
> tx_action is involved:
>=20
> cpu0(serving tx_action)     cpu1             cpu2
>            .                   .                .
>            .              q->enqueue            .
>            .            qdisc_run_begin()       .
>            .              dequeue_skb()         .
>            .                   .            q->enqueue
>            .                   .                .
>            .             sch_direct_xmit()      .
>            .                   .         qdisc_run_begin()
>            .                   .       return and do nothing
>            .                   .                .
>   clear __QDISC_STATE_SCHED    .                .
>   qdisc_run_begin()            .                .
>   return and do nothing        .                .
>            .                   .                .
>            .            qdisc_run_end()         .
>=20
> This patch fixes the above data race by:
> 1. Get the flag before doing spin_trylock().
> 2. If the first spin_trylock() return false and the flag is not
>     set before the first spin_trylock(), Set the flag and retry
>     another spin_trylock() in case other CPU may not see the new
>     flag after it releases the lock.
> 3. reschedule if the flags is set after the lock is released
>     at the end of qdisc_run_end().
>=20
> For tx_action case, the flags is also set when cpu1 is at the
> end if qdisc_run_end(), so tx_action will be rescheduled
> again to dequeue the skb enqueued by cpu2.
>=20
> Only clear the flag before retrying a dequeuing when dequeuing
> returns NULL in order to reduce the overhead of the above double
> spin_trylock() and __netif_schedule() calling.
>=20
> The performance impact of this patch, tested using pktgen and
> dummy netdev with pfifo_fast qdisc attached:
>=20
>   threads  without+this_patch   with+this_patch      delta
>      1        2.61Mpps            2.60Mpps           -0.3%
>      2        3.97Mpps            3.82Mpps           -3.7%
>      4        5.62Mpps            5.59Mpps           -0.5%
>      8        2.78Mpps            2.77Mpps           -0.3%
>     16        2.22Mpps            2.22Mpps           -0.0%
>=20
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

I have a setup which is able to reproduce the issue quite reliably:

In a Xen guest I'm mounting 8 NFS shares and run sysbench fileio on
each of them. The average latency reported by sysbench is well below
1 msec, but at least once per hour I get latencies in the minute
range.

With this patch I don't see these high latencies any longer (test
is running for more than 20 hours now).

So you can add my:

Tested-by: Juergen Gross <jgross@suse.com>


Juergen

--------------CDB4D2BA5B7A94706A1D1B2A
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

--------------CDB4D2BA5B7A94706A1D1B2A--

--LSz7PCDIMfnx6xL5FBKNaZUVKlHLEdp1Z--

--KNfSBDESab9zDoXGXKJSsQrdHG9FC4fMd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBv5pcFAwAAAAAACgkQsN6d1ii/Ey+U
WQf/dvUZrKhZVIiZyvAc888M6ZYmJE5fOb/Cm0XkTJe0TiBSy6Q3HejzXgO+yFIWWKlb8VJ2s48N
Ei0XoRMl9wi1ORkrAc/NBi6GqvPRVP0rdCgZ8JbjyP11XSWSrii/H+VAgxLHckSmizh9Inf5SvLl
eWwcQ/cCOLicSNSEkbUAq+VVontel2FA9M4sVeSOyjkb9f3+Y8E8BkfPsTtuugTjtebQL4p3kFjz
fBCIdP9CFVzHbRTw6XH9Xp9mRv5TDcNyp811nVFy9kgYv9oAbJXzd1WCbMSCrIGLC4drvUxoYswq
RnSTgsBV72NTulgyo4T19cwWD1HDYS+D+R7mLLCr9w==
=Pnqx
-----END PGP SIGNATURE-----

--KNfSBDESab9zDoXGXKJSsQrdHG9FC4fMd--
