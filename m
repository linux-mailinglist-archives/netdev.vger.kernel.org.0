Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F62468A58
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhLEKfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 05:35:18 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57106 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbhLEKfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 05:35:17 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9B4041FD38;
        Sun,  5 Dec 2021 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638700308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K7SjtJiY99hUvKc+7aYw88KA13ESSI3BIsezmC/7IyY=;
        b=ohafv7Z6p35vo8D6RqjNwU7ojURa1cOTkJi+dJivIYoiyBnTVP2smtpL8AGkv+hHcm+OWp
        cHxyTRuCDEDMji92LoYs5I8f4KoZYj7RLwUTQRF/E7oDoVKcK3XB3xHv9Ik2toMmz+h/d3
        5k6HsZi0t+woqJbJVkd6B+89Fie9qE8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C107F1348A;
        Sun,  5 Dec 2021 10:31:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qYOyLBKVrGH8TQAAMHmgww
        (envelope-from <jgross@suse.com>); Sun, 05 Dec 2021 10:31:46 +0000
Subject: Re: [PATCH V4 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211205081815.129276-1-ltykernel@gmail.com>
 <20211205081815.129276-4-ltykernel@gmail.com>
 <a5943893-510a-3fc8-cbb7-8742369bf36b@suse.com>
 <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <ed9aa3d5-9ac8-2195-e617-85599ffd7864@suse.com>
Date:   Sun, 5 Dec 2021 11:31:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2lNGFmlfQKDxEQnMi4PlLmBojmVqlWXfg"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2lNGFmlfQKDxEQnMi4PlLmBojmVqlWXfg
Content-Type: multipart/mixed; boundary="xiSNwffzrwFZS3WSVpqneCffSxZ2oqvaj";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
 haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 sstabellini@kernel.org, boris.ostrovsky@oracle.com, joro@8bytes.org,
 will@kernel.org, davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
 martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
 m.szyprowski@samsung.com, robin.murphy@arm.com, thomas.lendacky@amd.com,
 Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
 michael.h.kelley@microsoft.com
Cc: iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org, vkuznets@redhat.com,
 brijesh.singh@amd.com, konrad.wilk@oracle.com, hch@lst.de,
 parri.andrea@gmail.com, dave.hansen@intel.com
Message-ID: <ed9aa3d5-9ac8-2195-e617-85599ffd7864@suse.com>
Subject: Re: [PATCH V4 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
References: <20211205081815.129276-1-ltykernel@gmail.com>
 <20211205081815.129276-4-ltykernel@gmail.com>
 <a5943893-510a-3fc8-cbb7-8742369bf36b@suse.com>
 <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>
In-Reply-To: <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>

--xiSNwffzrwFZS3WSVpqneCffSxZ2oqvaj
Content-Type: multipart/mixed;
 boundary="------------6DEB2D258518C218A03A410C"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6DEB2D258518C218A03A410C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 05.12.21 09:48, Tianyu Lan wrote:
>=20
>=20
> On 12/5/2021 4:34 PM, Juergen Gross wrote:
>> On 05.12.21 09:18, Tianyu Lan wrote:
>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> hyperv Isolation VM requires bounce buffer support to copy
>>> data from/to encrypted memory and so enable swiotlb force
>>> mode to use swiotlb bounce buffer for DMA transaction.
>>>
>>> In Isolation VM with AMD SEV, the bounce buffer needs to be
>>> accessed via extra address space which is above shared_gpa_boundary
>>> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.=

>>> The access physical address will be original physical address +
>>> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
>>> spec is called virtual top of memory(vTOM). Memory addresses below
>>> vTOM are automatically treated as private while memory above
>>> vTOM is treated as shared.
>>>
>>> Hyper-V initalizes swiotlb bounce buffer and default swiotlb
>>> needs to be disabled. pci_swiotlb_detect_override() and
>>> pci_swiotlb_detect_4gb() enable the default one. To override
>>> the setting, hyperv_swiotlb_detect() needs to run before
>>> these detect functions which depends on the pci_xen_swiotlb_
>>> init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
>>> _detect() to keep the order.
>>
>> Why? Does Hyper-V plan to support Xen PV guests? If not, I don't see
>> the need for adding this change.
>>
>=20
> This is to keep detect function calling order that Hyper-V detect=20
> callback needs to call before pci_swiotlb_detect_override() and=20
> pci_swiotlb_detect_4gb(). This is the same for why
> pci_swiotlb_detect_override() needs to depend on the=20
> pci_xen_swiotlb_detect(). Hyper-V also has such request and so make xen=
=20
> detect callback depends on Hyper-V one.

And does this even work without CONFIG_SWIOTLB_XEN, i.e. without
pci_xen_swiotlb_detect() being in the system?


Juergen

--------------6DEB2D258518C218A03A410C
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

--------------6DEB2D258518C218A03A410C--

--xiSNwffzrwFZS3WSVpqneCffSxZ2oqvaj--

--2lNGFmlfQKDxEQnMi4PlLmBojmVqlWXfg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGslRIFAwAAAAAACgkQsN6d1ii/Ey9y
Tgf/UCpwSO5ZoUwzIdaAOOQ5xJjsv/5TLJU+V/47jZW8b5iw54q5T19UV0gNLP/mxxuaq8lKREwG
63YPWXsyVexiOXe6rIum4MEg5cyVKCqxrtaB9iWUTTD9uAhhd79db5Vq7M8Fa6//tBtbDvbuA1WH
MfASOYJQXrrBcBPGOb/PZfLJcm91NmSv2WGPFpNfP4dNSTExkMBRp2y2KpfbWVbB0K9GEfzPNOlZ
JnXv6k+OR31oyd/0nsL9KVQ09lattw1Nmh8cMaNh81+SzqnSlnfd1j/jJ2E8djTuCJGurGTBIANr
nHiJ2MbcApZE66yH0xNQtjdZdEx4soeSG6IALNYkpA==
=f6Cb
-----END PGP SIGNATURE-----

--2lNGFmlfQKDxEQnMi4PlLmBojmVqlWXfg--
