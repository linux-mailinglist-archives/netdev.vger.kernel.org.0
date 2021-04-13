Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2D35DADD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbhDMJPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:15:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:43516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245464AbhDMJPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:15:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618305319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jn5uYFkWoDFh3oEjqkWSpS7u/1CvtvDJm+x2vbSAsW8=;
        b=M7DmGhmPRXVYUBCKjcstGFi7csISw/s99ZsH84emeMhbB4nrX4ejm7cnzpDMFI2JBr5SKi
        rLTyjSN1fwJTLmU+jCFmgVLBUQOFGWa2l2ed9b3LV9WPuAAP6x3i2od7Xlxhh/1wM6pKtW
        xzxOydpnES2eTy7Uzro4G9TMByMiVOs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFCD9ABB3;
        Tue, 13 Apr 2021 09:15:18 +0000 (UTC)
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
 <20210413022129.2203-1-hdanton@sina.com>
 <20210413032620.2259-1-hdanton@sina.com>
 <20210413071241.2325-1-hdanton@sina.com>
 <20210413083352.2424-1-hdanton@sina.com>
 <1cd37014-4b2a-b82c-0cfc-6beffb8d36de@huawei.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <70dc383f-6a10-a16b-3972-060cdd8ec2d4@suse.com>
Date:   Tue, 13 Apr 2021 11:15:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1cd37014-4b2a-b82c-0cfc-6beffb8d36de@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LIE340dJCOtul5a3dQ1E1PcZGsEBKxbpy"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LIE340dJCOtul5a3dQ1E1PcZGsEBKxbpy
Content-Type: multipart/mixed; boundary="cFvUFZLp2DA96AEv4JObaI4njxO6LrtK1";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, Hillf Danton <hdanton@sina.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jiri Kosina <JKosina@suse.com>
Message-ID: <70dc383f-6a10-a16b-3972-060cdd8ec2d4@suse.com>
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
 <20210413022129.2203-1-hdanton@sina.com>
 <20210413032620.2259-1-hdanton@sina.com>
 <20210413071241.2325-1-hdanton@sina.com>
 <20210413083352.2424-1-hdanton@sina.com>
 <1cd37014-4b2a-b82c-0cfc-6beffb8d36de@huawei.com>
In-Reply-To: <1cd37014-4b2a-b82c-0cfc-6beffb8d36de@huawei.com>

--cFvUFZLp2DA96AEv4JObaI4njxO6LrtK1
Content-Type: multipart/mixed;
 boundary="------------553E7815075B9C6D91563DCA"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------553E7815075B9C6D91563DCA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 13.04.21 11:03, Yunsheng Lin wrote:
> On 2021/4/13 16:33, Hillf Danton wrote:
>> On Tue, 13 Apr 2021 15:57:29  Yunsheng Lin wrote:
>>> On 2021/4/13 15:12, Hillf Danton wrote:
>>>> On Tue, 13 Apr 2021 11:34:27 Yunsheng Lin wrote:
>>>>> On 2021/4/13 11:26, Hillf Danton wrote:
>>>>>> On Tue, 13 Apr 2021 10:56:42 Yunsheng Lin wrote:
>>>>>>> On 2021/4/13 10:21, Hillf Danton wrote:
>>>>>>>> On Mon, 12 Apr 2021 20:00:43  Yunsheng Lin wrote:
>>>>>>>>>
>>>>>>>>> Yes, the below patch seems to fix the data race described in
>>>>>>>>> the commit log.
>>>>>>>>> Then what is the difference between my patch and your patch bel=
ow:)
>>>>>>>>
>>>>>>>> Hehe, this is one of the tough questions over a bounch of weeks.=

>>>>>>>>
>>>>>>>> If a seqcount can detect the race between skb enqueue and dequeu=
e then we
>>>>>>>> cant see any excuse for not rolling back to the point without NO=
LOCK.
>>>>>>>
>>>>>>> I am not sure I understood what you meant above.
>>>>>>>
>>>>>>> As my understanding, the below patch is essentially the same as
>>>>>>> your previous patch, the only difference I see is it uses qdisc->=
pad
>>>>>>> instead of __QDISC_STATE_NEED_RESCHEDULE.
>>>>>>>
>>>>>>> So instead of proposing another patch, it would be better if you
>>>>>>> comment on my patch, and make improvement upon that.
>>>>>>>
>>>>>> Happy to do that after you show how it helps revert NOLOCK.
>>>>>
>>>>> Actually I am not going to revert NOLOCK, but add optimization
>>>>> to it if the patch fixes the packet stuck problem.
>>>>>
>>>> Fix is not optimization, right?
>>>
>>> For this patch, it is a fix.
>>> In case you missed it, I do have a couple of idea to optimize the
>>> lockless qdisc:
>>>
>>> 1. RFC patch to add lockless qdisc bypass optimization:
>>>
>>> https://patchwork.kernel.org/project/netdevbpf/patch/1616404156-11772=
-1-git-send-email-linyunsheng@huawei.com/
>>>
>>> 2. implement lockless enqueuing for lockless qdisc using the idea
>>>    from Jason and Toke. And it has a noticable proformance increase w=
ith
>>>    1-4 threads running using the below prototype based on ptr_ring.
>>>
>>> static inline int __ptr_ring_multi_produce(struct ptr_ring *r, void *=
ptr)
>>> {
>>>
>>>         int producer, next_producer;
>>>
>>>
>>>         do {
>>>                 producer =3D READ_ONCE(r->producer);
>>>                 if (unlikely(!r->size) || r->queue[producer])
>>>                         return -ENOSPC;
>>>                 next_producer =3D producer + 1;
>>>                 if (unlikely(next_producer >=3D r->size))
>>>                         next_producer =3D 0;
>>>         } while(cmpxchg_relaxed(&r->producer, producer, next_producer=
) !=3D producer);
>>>
>>>         /* Make sure the pointer we are storing points to a valid dat=
a. */
>>>         /* Pairs with the dependency ordering in __ptr_ring_consume. =
*/
>>>         smp_wmb();
>>>
>>>         WRITE_ONCE(r->queue[producer], ptr);
>>>         return 0;
>>> }
>>>
>>> 3. Maybe it is possible to remove the netif_tx_lock for lockless qdis=
c
>>>    too, because dev_hard_start_xmit is also in the protection of
>>>    qdisc_run_begin()/qdisc_run_end()(if there is only one qdisc using=

>>>    a netdev queue, which is true for pfifo_fast, I believe).
>>>
>>> 4. Remove the qdisc->running seqcount operation for lockless qdisc, w=
hich
>>>    is mainly used to do heuristic locking on q->busylock for locked q=
disc.
>>>
>>
>> Sounds good. They can stand two months, cant they?
>>>>
>>>>> Is there any reason why you want to revert it?
>>>>>
>>>> I think you know Jiri's plan and it would be nice to wait a couple o=
f
>>>> months for it to complete.
>>>
>>> I am not sure I am aware of Jiri's plan.
>>> Is there any link referring to the plan?
>>>
>> https://lore.kernel.org/lkml/eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huaw=
ei.com/
>=20
> I think there is some misunderstanding here.
>=20
> As my understanding, Jiri and Juergen are from the same team(using
> the suse.com mail server).

Yes, we are.

> what Jiri said about "I am still planning to have Yunsheng Lin's
> (CCing) fix [1] tested in the coming days." is that Juergen has
> done the test and provide a "Tested-by" tag.

Correct. And I did this after Jiri asking me to do so.

> So if this patch fixes the packet stuck problem, Jiri is ok with
> NOLOCK qdisc too.

I think so, yes. Otherwise I don't see why he asked me to test the
patch. :-)

> Or do I misunderstand it again? Perhaps Jiri and Juergen can help to
> clarify this?

I hope I did. :-)


Juergen

--------------553E7815075B9C6D91563DCA
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

--------------553E7815075B9C6D91563DCA--

--cFvUFZLp2DA96AEv4JObaI4njxO6LrtK1--

--LIE340dJCOtul5a3dQ1E1PcZGsEBKxbpy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmB1YSUFAwAAAAAACgkQsN6d1ii/Ey+q
hAf/UsfaQmyaQcUxbmWV4ZstZFUjjLqyh7LAcTuLp27Jl+8mRja+DO7AJdfdkUwkKYJQ89PDNwbw
sYqcNcK58zQS458MfDMK+r/nQUceUFt0MSwiBrC12ycrxrbxqsY3EjMgCAWSV2tdCZSjdjMV9EFC
TF32LILvRF2MLm2YtH2yq4ZjLJKj6MFI+Up4fIL1TpU1oV9oConRQvOgHyL6yNTuydUELvyrDBPb
7+Enyp7+u57O4AF+TyZSBcSSPMw5um1Yge/A6nVcm5SYXDfezLztBux7gtKwJxqfPlrtSYzYqJJC
DRRzrmcshvHwYnp3o5hXczf4JFLabJ3cqlRn91ge3A==
=CRqc
-----END PGP SIGNATURE-----

--LIE340dJCOtul5a3dQ1E1PcZGsEBKxbpy--
