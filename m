Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01A343A26
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCVHBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:01:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:47420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhCVHBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 03:01:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616396479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ikdRbjYwrh6jMOeo5QgfZnIqyWaL0H+nMzfLn9qBY+0=;
        b=i3fuAO3/9AJ6D78I8hJbTgo7/dJINVsaVaiq5rqBsLQNwwLHqBLM63NvFuspPOh6OtKms3
        JEW/vNHZP7NjQlMgSS4Z91h7zr03OQOF1wMHQsVW1O6on2indryxLVZMHx4Qq85zP/j4H8
        1oNf/90t4g4YFYaYuYQK5o40fWdf0pE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00DD3AD4A;
        Mon, 22 Mar 2021 07:01:18 +0000 (UTC)
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Hsu, Chiahao" <andyhsu@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
References: <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch> <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com> <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com> <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com> <YFgtf6NBPMjD/U89@unreal>
 <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com> <YFg9w980NkZzEHmb@unreal>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <facd5d2e-510e-4fc4-5e22-c934ea237b1b@suse.com>
Date:   Mon, 22 Mar 2021 08:01:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YFg9w980NkZzEHmb@unreal>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XNey0EOIqh5lWhHqjRdvYYllC8uxFqu6T"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XNey0EOIqh5lWhHqjRdvYYllC8uxFqu6T
Content-Type: multipart/mixed; boundary="Ov0WnZb01U1s0agqQzQ7tBpupQeAGgOZ7";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Hsu, Chiahao" <andyhsu@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
 netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
 davem@davemloft.net, kuba@kernel.org, xen-devel@lists.xenproject.org
Message-ID: <facd5d2e-510e-4fc4-5e22-c934ea237b1b@suse.com>
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
References: <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch> <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com> <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com> <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com> <YFgtf6NBPMjD/U89@unreal>
 <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com> <YFg9w980NkZzEHmb@unreal>
In-Reply-To: <YFg9w980NkZzEHmb@unreal>

--Ov0WnZb01U1s0agqQzQ7tBpupQeAGgOZ7
Content-Type: multipart/mixed;
 boundary="------------8A2B5EA9D8912C96E9D361F3"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------8A2B5EA9D8912C96E9D361F3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 22.03.21 07:48, Leon Romanovsky wrote:
> On Mon, Mar 22, 2021 at 06:58:34AM +0100, J=C3=BCrgen Gro=C3=9F wrote:
>> On 22.03.21 06:39, Leon Romanovsky wrote:
>>> On Sun, Mar 21, 2021 at 06:54:52PM +0100, Hsu, Chiahao wrote:
>>>>
>>>
>>> <...>
>>>
>>>>>> Typically there should be one VM running netback on each host,
>>>>>> and having control over what interfaces or features it exposes is =
also
>>>>>> important for stability.
>>>>>> How about we create a 'feature flags' modparam, each bits is speci=
fied for
>>>>>> different new features?
>>>>> At the end, it will be more granular module parameter that user sti=
ll
>>>>> will need to guess.
>>>> I believe users always need to know any parameter or any tool's flag=
 before
>>>> they use it.
>>>> For example, before user try to set/clear this ctrl_ring_enabled, th=
ey
>>>> should already have basic knowledge about this feature,
>>>> or else they shouldn't use it (the default value is same as before),=
 and
>>>> that's also why we use the 'ctrl_ring_enabled' as parameter name.
>>>
>>> It solves only forward migration flow. Move from machine A with no
>>> option X to machine B with option X. It doesn't work for backward
>>> flow. Move from machine B to A back will probably break.
>>>
>>> In your flow, you want that users will set all module parameters for
>>> every upgrade and keep those parameters differently per-version.
>>
>> I think the flag should be a per guest config item. Adding this item t=
o
>> the backend Xenstore nodes for netback to consume it should be rather
>> easy.
>>
>> Yes, this would need a change in Xen tools, too, but it is the most
>> flexible way to handle it. And in case of migration the information
>> would be just migrated to the new host with the guest's config data.
>=20
> Yes, it will overcome global nature of module parameters, but how does
> it solve backward compatibility concern?

When creating a guest on A the (unknown) feature will not be set to
any value in the guest's config data. A migration stream not having any
value for that feature on B should set it to "false".

When creating a guest on B it will either have the feature value set
explicitly in the guest config (either true or false), or it will get
the server's default (this value should be configurable in a global
config file, default for that global value would be "true").

So with the guest created on B with feature specified as "false" (either
for this guest only, or per global config), it will be migratable to
machine A without problem. Migrating it back to B would work the same
way as above. Trying to migrate a guest with feature set to "true" to
B would not work, but this would be the host admin's fault due to not
configuring the guest correctly.


Juergen

--------------8A2B5EA9D8912C96E9D361F3
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

--------------8A2B5EA9D8912C96E9D361F3--

--Ov0WnZb01U1s0agqQzQ7tBpupQeAGgOZ7--

--XNey0EOIqh5lWhHqjRdvYYllC8uxFqu6T
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBYQL0FAwAAAAAACgkQsN6d1ii/Ey9G
CQgAiHIxxi5KIe3wo0sRuWyXuC7W48WgTdRt0A5zxkVkfT8QCGk50L3jRKk4ykkWw5ksw4j0ttEt
ks4I5B+2FixAsKqQnv7ZqhropUQhMrn9KIr+UYXN2pCyxgVEtQbrRKr+XK5ylnAD3UwZnfjrsizT
Q2mKKQWgk83KFyCTmW5FsE0FhIcMfJl9npdxeTewaucsycTAG9vGj2Gjxk4j/v/qBxRKUPLWfY+s
cezaGKS7OuUDvnKf1ZRYgpNnfnQLltGZ6t+ESN/yEe+1xFXPjjz14Puax6hu8TDgRTZo+TXVuDG1
Y3nLga6TPeyTYbEBwTVL7EZdhNy6KZpefOqU5iYbGA==
=fEL1
-----END PGP SIGNATURE-----

--XNey0EOIqh5lWhHqjRdvYYllC8uxFqu6T--
