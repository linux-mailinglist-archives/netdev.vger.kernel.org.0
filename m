Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E63E39C901
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFEOTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 10:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEOTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 10:19:16 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C1C061766;
        Sat,  5 Jun 2021 07:17:28 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Fy1tD668yzQk1V;
        Sat,  5 Jun 2021 16:17:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1622902643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T5A6PKIL2PVwdklkRvnBj/U/2j12EK3HupF6+XrUvBA=;
        b=QHjOsbXXvMnHlMBexE4IIjX55IGZPYlE+dFKH2huOKGgTHoueTVp5d6lC34UE5xQ2U8BnZ
        79w+zdxu795avMXrPT5BthRYBVXg4QUvTqLHRlEgWQklNH5C8CqkM1urEkYcRBBhvDOqbS
        DAS/Hzqz2M2WVzfiE3DR/TUnhDvNCYlwg0tKtQMnvXOdAUIe0kAHhXbFXVfca/ElPOlh9L
        DTHsgdatrrpxWcXZEflRBB2MJyDUOfA4sthJjytXibHZ2QjYb3L1uuI711FmxaRyo/vN84
        NsIltbntXTue8t9WN0Smf2M3V9HUFfuujvHGaG6zI9xLFxHoNp4QyEoUzGcNFg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id W64FR_LFhQ4B; Sat,  5 Jun 2021 16:17:21 +0200 (CEST)
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
References: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
 <20210605125004.v6njqob6prb7k75k@pali>
 <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
 <20210605133113.j4gyjo4pnmxpxbqe@pali>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: What is inside GPON SFP module?
Message-ID: <989d0e8c-b9d4-0362-5aef-0d8dafd5d7f1@hauke-m.de>
Date:   Sat, 5 Jun 2021 16:17:14 +0200
MIME-Version: 1.0
In-Reply-To: <20210605133113.j4gyjo4pnmxpxbqe@pali>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xEh0q0rTGrw7zZ8ks7xCJHbVDTc5kqXO9"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.42 / 15.00 / 15.00
X-Rspamd-Queue-Id: 974BD1824
X-Rspamd-UID: 49f07b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xEh0q0rTGrw7zZ8ks7xCJHbVDTc5kqXO9
Content-Type: multipart/mixed; boundary="4QwVE8WIm833tpQjX607anZknlIRVWohO";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc: Vladimir Oltean <olteanv@gmail.com>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Madalin Bucur <madalin.bucur@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
 Igal Liberman <Igal.Liberman@freescale.com>,
 Shruti Kanetkar <Shruti@freescale.com>,
 Emil Medve <Emilian.Medve@freescale.com>, Scott Wood <oss@buserror.net>,
 Rob Herring <robh+dt@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Message-ID: <989d0e8c-b9d4-0362-5aef-0d8dafd5d7f1@hauke-m.de>
Subject: Re: What is inside GPON SFP module?
References: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
 <20210605125004.v6njqob6prb7k75k@pali>
 <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
 <20210605133113.j4gyjo4pnmxpxbqe@pali>
In-Reply-To: <20210605133113.j4gyjo4pnmxpxbqe@pali>

--4QwVE8WIm833tpQjX607anZknlIRVWohO
Content-Type: multipart/mixed;
 boundary="------------2309AF1BBF35146E73ED144F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------2309AF1BBF35146E73ED144F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/5/21 3:31 PM, Pali Roh=C3=A1r wrote:
> On Saturday 05 June 2021 15:04:55 Hauke Mehrtens wrote:
>> On 6/5/21 2:50 PM, Pali Roh=C3=A1r wrote:
>>> On Saturday 05 June 2021 15:26:39 Vladimir Oltean wrote:
>>>> On Sat, Jun 05, 2021 at 01:33:07AM +0100, Russell King (Oracle) wrot=
e:
>>>>> It started out as described - literally, 1000base-X multiplied by 2=
=2E5x.
>>>>> There are setups where that is known to work - namely GPON SFPs tha=
t
>>>>> support 2500base-X. What that means is that we know the GPON SFP
>>>>> module negotiates in-band AN with 2500base-X. However, we don't kno=
w
>>>>> whether the module will work if we disable in-band AN.
>>>>
>>>> Pardon my ignorance, but what is inside a GPON ONT module? Just a la=
ser
>>>> and some amplifiers? So it would still be the MAC PCS negotiating fl=
ow
>>>> control with the remote link partner? That's a different use case
>>>> from
>> a
>>>> PHY transmitting the negotiated link modes to the MAC.
>>>
>>> Hello Vladimir! All GPON ONU/ONT SFP modules which I have tested, are=

>>> fully featured mini computers. It is some SoC with powerful CPU, fibe=
r
>>> part, at least two NICs and then two phys, one for fiber part and one=

>>> for "SFP"-part (in most cases 1000base-x or 2500base-x). On SoC insid=
e
>>> is running fully featured operating system, in most cases Linux kerne=
l
>>> 2.6.3x and tons of userspace applications which implements "applicati=
on"
>>> layer of GPON protocol -- the most important part. If OEM vendor of G=
PON
>>> SFP stick did not locked it, you can connect to this "computer" via
>>> telnet or web browser and configure some settings, including GPON stu=
ff
>>> and also how GPON network is connected to SFP part -- e.g. it can be
>>> fully featured IPv4 router with NAT or just plain bridge mode where
>>> "ethernet data packets" (those which are not part of ISP configuratio=
n
>>> protocol) are pass-throw to SFP phy 1000base-x to host CPU. GPON is n=
ot
>>> ethernet, it is some incompatible and heavily layered extension on AT=
M.
>>> Originally I thought that ATM is long ago dead (as I saw it in used l=
ast
>>> time in ADSL2) but it is still alive and cause issues... I think it d=
oes
>>> not use 8b/10b encoding and therefore cannot be directly mapped to
>>> 1000base-x. Also GPON uses different wavelengths for inbound and
>>> outbound traffic. And to make it even more complicated it uses totall=
y
>>> nonstandard asynchronous speeds, inbound is 2488.32Mbit/s, outbound i=
s
>>> 1244.16Mbit/s. So I guess CPU/SoC with GPON support (something which =
is
>>> inside that GPON ONU/ONT stick) must use totally different modes for
>>> which we do not have any option in DTS yet.
>>>
>>> So once mainline kernel will support these "computers" with GPON supp=
ort
>>> it would be required to define new kind of phy modes... But I do not
>>> think it happens and all OEM vendors are using 2.6.3x kernels their
>>> userspace GPON implementation is closed has tons of secrets.
>>>
>>
>> Hi,
>>
>> This description of the GPON SFP sticks is correct, but it misses some=20
of
>> the complexity. ;-) GPON is also a shared medium like DOCSIS, you can =
not
>> always send, but you have to wait till you get your time slice over PL=
OAM.
>=20
> Hello!
>=20
> I think same applies also for 1000BASE-PX or 10GBASE-PR GEPON passive
> ethernet networks (Beware GPON !=3D GEPON).

There is one family standardized by the ITU (GPON, XGPON, XGSPON,=20
NGPON2) and an other family standardized by the IEEE (EPON, GEPON). They =

solve more or less the same problem, just in a different way.

> But I think this is not an issue. There are also other "shared medium"
> technologies (e.g. mobile network; or WiFi on DFS channels) for which
> exists hardware supported by mainline kernel (3G/LTE modems).

Yes, then you just need a MAC which can handle it. It is more complex=20
than a normal Ethernet MAC.

>> In addition the GPON SFP stick also have to talk the OMCI protocol whi=
ch
>> allows to operator to configure all sorts of layer 2 things. They can =
also
>> login to your SFP stick. ;-)
>=20
> Yes, I just described it as "application" layer. It is complicated and
> basically something which is not suppose to be implemented in kernel.
> Plus GPON vendors extends (standardized) OMCI protocol with their own
> extension which means that without their implementation on client side
> it is impossible to fully establish connection to "server" OLT part.

You can use one software stack without (many) vendor OLT specific=20
workarounds which works with multiple of the big OLT vendors. The OMCI=20
protocol definition is also publicly available and there are no vendor=20
extensions needed for normal operations nowadays. The specification=20
leaves room for interpretation in some parts and some OMCI ONU stacks=20
are "optimized" for a specific OLT vendor.

>> There are also some passive GPON SFP sticks which just translate betwe=
en
>> electrical and optical signals, but to operate them you need a GPON MA=
C and
>> managed layer on your host.
>=20
> Interesting... Do you know where to buy or test such passive GPON SFP s=
ticks?

Most of the 10=E2=82=AC GPON OLT sticks are such passive sticks, but the =

wavelengths are in the wrong order.

I do not know where exactly to buy them, but there are multiple vendors=20
building such sticks. To operate them on a GPON fiber you still need the =

GPON MAC.

> And is there some documentation how these sticks works? And what kind o=
f
> phy mode they are using over SerDes? Because due to different inbound
> and outbound speeds it cannot be neither 1000base-x nor 2500base-x.

I do not know.

>> Adding GPON support properly into Linux is not an easy task, Linux wou=
ld
>> probably need a subsystem with a complexity compared to cfg80211 + hos=
tapd.
>=20
> Yea... But maybe it could be easier to implement just "client part"
> (ONU/ONT) without "server part" (OLT).

Yes, the ONU and OLT part are pretty different on the Management layer=20
anyway.

>> Is there a list of things these GPON sticks running Linux should do be=
tter
>> in the future? For example what to avoid in the EEPROM emulation handl=
ing?
>=20
> Well... If you think that it is possible to address these issues
> directly to GPON vendors and they will fix them in next version of GPON=

> SFP sticks, I could try to find some time and prepare list of lot of
> issues...

I can not promise that, but I can try.
There are some constrains like the EEPROM is only available after the=20
Linux booted up, so it takes some time after it got power.

Hauke

--------------2309AF1BBF35146E73ED144F
Content-Type: application/pgp-keys;
 name="OpenPGP_0x93DD20630910B515.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0x93DD20630910B515.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFtLdKcBEADFOTNUys8TnhpEdE5e1wO1vC+a62dPtuZgxYG83+9iVpsAyaSrCGGz5tmuB=
gkE
MZVK9YogfMyVHFEcy0RqfO7gIYBYvFp0z32btJhjkjBm9hZ6eonjFnG9XmqDKg/aZI+ud9KGU=
h0D
eaHT9FY96qdUsxIsdCodowf1eTNTJn+hdCudjLWjDf9FlBV0XKTN+ETY3pbPL2yih8Uem7tC3=
pmU
7oN7Z0OpKev5E2hLhhx+Lpcro4ikeclxdAg7g3XZWQLqfvKsjiOJsCWNXpy7hhru9PQE8oNFg=
SNz
zx2tMouhmXIlzEX4xFnJghprn+8EA/sCaczhdna+LVjICHxTO36ytOv7L3q6xDxIkdF6vyeEt=
Vm1
OfRzfGSgKdrvxc+FRJjp3TIRPFqvYUADDPh5Az7xa1LRy3YcvKYxpsDDKpJ8nCxNaYs6hqTbz=
4lo
Hpv1hQLrPXFVpoFUApfvH/q7bb+eXVjRW1m2Ahvp7QipLEAKGbiV7uvALuIjnlVtfBZSxI+Xg=
7SB
ETxgK1YHxV7PhlzMdTIKY9GL0Rtl6CMir/zMFJkxTMeO1P8wzt+WOvpxF9TixOhUtmfv0X7ay=
93H
WOdddAzov7eCKp4Ju1ZQj8QqROqsc/Ba87OH8cnG/QX9pHXpO9efHcZYIIwx1nquXnXyjJ/sM=
dS7
jGiEOfGlp6N9IwARAQABzSFIYXVrZSBNZWhydGVucyA8aGF1a2VAaGF1a2UtbS5kZT7CwZQEE=
wEI
AD4CGwEFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCX=
r/2
hwUJBcXE4AAKCRCT3SBjCRC1FX1BEACXkrQyF2DJuoWQ9up7LKEHjnQ3CjL06kNWH3FtvdOjd=
e/H
7ACo2gEAPz3mWYGocdH8NjpmlnneX+3SzDspkW9dOJP/xjq9IlttJi3WeQqrBpe/01285IUDf=
OYi
+DasdqGFEzAYGznGmptL9X7hcAdu7fWUbxjZgPtJKw2pshRu9cCrPJqqlKkRFVlthFc+mkcLF=
xeP
l7SvLY+ANwvviQBblXJ2WXTSTX+Kqx8ywrKPwsJlTGysqvNRKScDMr2u+aROaOC9rvU3bucmW=
NSu
igtXJLSA1PbU7khRCHRb1q5q3AN+PCM3SXYwV7DL/4pCkEYdrQPztJ57jnsnJVjKR5TCkBwUa=
PIX
jFmOk15/BNuZWAfAZqYHkcbVjwo4Dr1XnJJon4vQncnVE4Igqlt2jujTRlB/AomuzLWy61mqk=
wUQ
l+uM1tNmeg0yC/b8bM6PqPca6tKfvkvseFzcVK6kKRfeO5zbVLoLQ3hQzRWTS2qOeiHDJyX7i=
KW/
jmR7YpLcx/Srqayb5YO207yo8NHkztyuSqFoAKBElEYIKtpJwZ8mnMJizijs5wjQ0VqDpGbRQ=
anU
x025D4lN8PrHNEnDbx/e7MSZGye2oK73GZYcExXpEC4QkJwu7AVoVir9lZUclC7Lz0QZS08ap=
VSY
u81UzhmlEprdOEPPGEXOtC1zs6y9O8LBlAQTAQgAPgIbAQULCQgHAgYVCAkKCwIEFgIDAQIeA=
QIX
gBYhBLj78/CrVk7oT3+x05PdIGMJELUVBQJdBNjNBQkDmpemAAoJEJPdIGMJELUVPpwP/2APQ=
K0A
8SUrCE0bNn8o1Avf35DgY5cMA7HI/v3uB6DLKS9qpT+nQw4p3HwXYMckIaWuQFaqIS1hQBGdQ=
k6B
+2hMtqWJ3ASnp6Jkz0SqKfmtFHoHk0hhQiMcCnGM8dKZ/CzmmdoF0jo1Xy3lGk5MA0iUF8/pt=
MES
lUZsLQHC8EVp0ai9wouucA1ni8vnrODTKRGiC0Pyt6g28ms0MrtcKsLZLQRhwYPlxe54lul/o=
lFy
6widiMyb+DaxEIfhxCz9U6OPcLrqw0Qy+9l0oTFmCH/2X1GZbRfrLsDRIO1HcA9hYYjBXRuFN=
La6
y44ABlC8WFz6J1IbRisepGI5OdbE6deQUVo52Z+T315Zqqlc4iDEevpalWuiZUj7ApZU0Re6Y=
t1s
QC/LW/EK2loZCm6fmZFx6zkYHaWRnNGOb3S5L0+BYHUhiPV6FF66PSOaSlqfRd0SHAWNDf4p/=
LNf
tiC3SBvO+IZu1IHazUyHScB22j1F0hiLeAItCHdpu3CTrOqwdEGnUgePI2rrSexRK17ijX6ZE=
GgH
oju5OTGok+bKfCmYChpiQ3YxE7wLU7T1h3gfcCAUZkFemhVumHxDuETfdj1SsSV+IOy92Pj4l=
W7W
x088YVa2mOl7kt6hfMsA0BsnZP5jrxSC2w0UJtIqNexEmUsgdHXIdBurZV1QOaxRlpFswsGOB=
BMB
CAA4AhsBBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFA=
ltL
fU8ACgkQk90gYwkQtRUXrRAAlmgonnRA/mOmabOSEBPY6dWAmqkABAu/LI+AC3lOJHWd+Tm3v=
fbs
kNKv77z5ZxYoJKe8ngQz/sDxx3Otd/zjZGs/r10iLc+aBwreqNkLnpQ1/HCgg+M3sZoj38rCQ=
8E3
MJoPKD53zKpqG//e5dSKE535IFj2I34449glJFyCU2Mdd6umxxWEPBQbq/D0VjLfsTpWSN9x7=
EAj
I3PmpHQP1C3JaWrg+uJ2C/2tJGpFIL/cIGdGhE/vlTqQT0EH738ySRSrARFpmXbTKpfF4Ms04=
iFL
vaB9wqizQoHQd73pGD8N5bVdzMb1LQgrGTMwKYnTsiZwnNwSRJX94O4FdVuuzZ6hpuFPCo9Lq=
BuD
B4f2dK2qn6zVa28Cj1Q3i5AYJHQ7nfU7kx9+WnU2Dx0BBmqH+c6jiZNIzmWAtA+UwirBnkZwk=
kfl
kWCy74nzUIcmi5kxgNXcNxVILCo3u8nUT9MqTJziaS2BUUoJLptfAu3gX4JPSkalxYJSK4e4d=
m68
lBMr0eK+IAAYveurlNk53xjmWqQx28IBCv9ne/4sS9fQfL2ZbwTUHaSmtsjvRKv6Hg1fL2c1a=
/Q4
cKQRHAMO17GlwH7x93jLbYj+gyRlc47tG1lA7tF6qOD4SZWJuK5qO2wJeRE4QFLbXFCc9a7ku=
3JO
ls57hcKnd54mF9PNEstq5bbOwE0EW0t7AwEIAOA7WMwe9wVGMTGlNoGxU6z8F7g22vjYC6Whf=
NDz
1yV2nHWKCpJVcg9t705Ob8NQLzGHt9mNeqoC5Jq/Pm0vSpS5qYDZ+azFszqiq/zfptgxu3plg=
IN5
FY0UZCRDbNWkGaFCBSRQcZVWdjrlEmB71ro3o9dQixZMUKPRH2t+UABHosxBrY4YxHeDlE+Yj=
7sc
a+ckP+yAffKE09e1AbOtmwyMohvA4brPrRvCWQLz74faTDAIHFn/gbLuANNK/l8qI6tOqZwTG=
u+P
HpVdQaOPAYNKRFZ3BckPWEhIi7XYMJ6ulvBNNJAExlaTdX2n78RkS1T30G36yk4k5AttdC+57=
9sA
EQEAAcLBfAQYAQgAJgIbDBYhBLj78/CrVk7oT3+x05PdIGMJELUVBQJev/bJBQkFxb7GAAoJE=
JPd
IGMJELUV0e8QALOYmuyRwi5rIONihFqDCFyNj/FPiuJTemMgcEldk/ZBVrbKBq+iAO4UnTRy3=
4G/
gUp77KqiXgzEkfWfg8yZRZh6F+zb/WWN+MViLa3jXEphVQtw+Yey12V+YDoMshhR8j2E52BRl=
0G3
hD7C0/iwPqQAswwXg5ZcRyVWMkmytVBIHKOlKA5yFowOhoQlV+tdq/OBIn+K0XZFbqxxVjEWC=
/cr
VaOQb5j9Ibkfzr3QW04SMFBZ9jHBv2fXx8WaM+kUkl7brQO2G/RXaS2waMGUnuwKxlMadyXjm=
KUY
JW+eopWP6I0ksv4EjwZECUaOndp1muGAmR9TecIkNCzeC96eDeLR4lc57WoFLN6kWgz5Mt0ej=
gww
zMc+nrUUyFGMrkbL73ZOi9q1a5tftTQmeIOmnlunkjbAFzwxfgPKEuqBhJNdGuoJsmy5qyMQb=
AZu
RHbj8mdZBAN63DGifpnI2hAtpM1U1vA6XXTjEB3/ey0Mf4gSz+5PGpsdAZ9E9j3qkO1XU+LtL=
wIX
wOE6opKJJ1gTxEtxi3Y//BI8vVqpPIW50SrXgopHGm25vt992akGpUtgB6cQjlee0wH7AOev7=
Zip
gQa3Qe3x1Or4umo5MJRhxE5H7REmAMhLnbTlJ0HcWSeQatWS8x6wnybc/2XPcIcW1xEDMcFR3=
koN
GyK62hwOj6q9wsF8BBgBCAAmAhsMFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFAl0E2QUFCQOak=
YIA
CgkQk90gYwkQtRUEfQ//SxFjktcASBIl8TZO9a5CcCKtwO3EvyS667D6S1bg3dFonqILXoMGJ=
LM0
z4kQa6VsVhtw2JGOIwbMnDeHtxuxLkxYvcPP6+GwQMkQmOsU0g8iT7EldKvjlW2ESaIVQFKAm=
XS8
re36eQqj73Ap5lzbsZ6thw1gK9ZcMr1Ft1Eigw02ckkY+BFetR5XGO4GaSBhRBYY7y4Xy0WuZ=
Cen
Y7Ev58tZr72DZJVd1Gi4YjavmCUHBaTv9lLPBS84C3fObxy5OvNFmKRg1NARMLqjoQeqLBwBF=
OUP
cL9xr0//Yv5+p1SLDoEyVBhS0M9KSM0n9RcOiCeHVwadsmfo8sFXnfDy6tWSpGi0rUPzh9xSh=
5bU
7htRKsGNCv1N4mUmpKroPLKjUsfHqytT4VGwdTDFS5E+2/ls2xi4Nj23MRh6vvocIxotJ6uNH=
X1k
Yu+1iOvsIjty700P3IveQoXxjQ0dfvq3Ud/Sl/5bUelft21g4Qwqp+cJGy34fSWD4PzOCEe6U=
gmZ
eKzd/w78+tWPvzrTXNLatbb2OpYV8gpoaeNcLlO2DHg3tRbe/3nHoU8//OciZ0Aqjs97Wq0Za=
C6C
dq82QNw1dZixSEWAcwBw0ej3Ujdh7TUAl6tx5AcVxEAmzkgDEuoJBI4vyA1eSgMwdqpdFJW2V=
9Lb
gjg52H6vOq/ZDai29hjCwXYEGAEIACAWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCW0t7AwIbD=
AAK
CRCT3SBjCRC1FdQPD/9mUbTho+I+5Fdy55KC40R2W9ShTsRA95C3r37uBnA37T6Mf8X28efeH=
c7R
RQX4eRpKMmoNMM0geW1oQ5rhqX9umAJkdSO/rKrpZ2+Oy6HohehcKm1cRYoLw49rllZFzMhoa=
lNj
jITCRiLTBMy8Vgg7VY9poCpRYjunrdeoigLmrRgHwQtjHBVa6R7OlTD66bG6/P+SyTQkcCx9e=
NMy
dgcZio7K77mB1lyXsdz4ikOeN5O7uPAwlNRYT/e6bIyROudLHmXT+Fkijsg7mZyJiJun1oAaG=
kYB
6Z0uk6AVjy1Cd7/aTGBU/4+CnOnzYs55UNJ4deMdFLyuGdTxa7vR8YLvnYunALN2xLnexRF+h=
8B5
cTDwDoJtzDWKASLbWs6LdUh4LHAOiejNVAzyF0FbmN8mbCfn3w/Qw8RJLHdnUxDeie6ik1yey=
v0u
7a3lsU3bz2fsAz1RUa+uWg38UozJHMKVFUWxzUpEXBVoc0tjDyOXBOVHy2BnhA1RiPRAOuh/8=
i11
lnQpyaadJgoAKOrBsq6IJRqdpUkOJvJOtCaLS/DP/Q/IgBaxoXilBnvx1HADQH+MR7BjdEMDU=
E7L
fl2f2Ab6qvR9uRhj1hlgWKTWn89g4EWfRr/y0Wnx4+xkZAC4t0AA1wl2iLJ4ZR6OS2xYc7DDg=
LBU
m92DF40ru3IjdrOags7ATQRbS3txAQgA5mqcJOegV5MWglTaYd0QwCGx+HtfjBM8VHLjw7vTL=
g8U
OCKeDAROryeO8AEwMaM377TQXxxnjkc00Hl5QoNxb1sGbGu0Ir4XTI+7l/L7Qzg22jDc/Icw0=
i05
Ygp3/8RrM4qK4dquFzp/U6ASsxKF7/2tOaVOirHBWZ+ceLVorrC9VtOI2AbK37YWADoFAigKG=
Q8Y
1DqmBXlCUIRa/Ft7KKhs5IDHV2Kux+iAnBxO+wJT9BpO58Aj1A7x2d7pIqynnPnzKKBY/AOc4=
X8u
9Dbp4OtgeOeTuRW4FUhaMqWmIBDTSF8tTu/BAfSidx8HkdP98vVvbjrWGbBfF5X6MTNCSQARA=
QAB
wsKyBBgBCAAmAhsCFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFAl6/9soFCQXFvlgBQMB0IAQZA=
QgA
HRYhBMs9P7gHHficF5sLQ/G3Z4WcsuvHBQJbS3txAAoJEPG3Z4WcsuvHdVoH/A2m8fbyqNbrG=
4Ax
5eC2c6yYX0ZtiN/ieRU26CybBXvI6UTXH+nhiaRi3lt7P8KlnfHGLC7W8yWtc56M9xMD4R2iB=
5sF
8OE4GJvjVbtgpvXYNmizUI/IWjXzj4SBqq+bp74Z5cK2xvmI5dHq9rAHQec15SMfISIx6HzCS=
KFu
Mge/U+HmbHhcq8APjniOqSU4ENXWl5TqYdumRrpTMvvqb4iD/wG+ezyfNfw00j1l6phHu9py1=
uY1
il3h20zGh/SlTXcSQiJfGWYKuMzdprJ6ZYifhKDVYBjoCokXJHhpZFrXHs0NCK+cgWgAZFVWQ=
ksn
WHxE0ie06xcGNcEMMghXC+8JEJPdIGMJELUVMJYP/395wAMaYBsT+cW/jXPnOl9Q5FlBYwVbj=
BCe
ssGBp2/k1sd7b9ZivD535u5qfzpwy4Fbj3aRVP2wcp94tGyut3CXA03lyjTaRjpy2utPm8MVq=
cD0
beAcdRsIpdXd25turPJkHbWNkMhpjvy/MGwwaTxW6oKJgR4/aYmuznk1sbHSAUCcYEvZMN4kh=
9OO
c+8QGaWkG8njx/SUfx7CUaLIQYKbMpWhDY4d1XHm5RQN7m/ohWae0z4M4NmHN9JjIwxtE6Iro=
rGo
YF0fJAPvQIJG173zNiFvst11hXYAszYa2zmMrfI/aJdW+28nvOBDphgTvqQYLIIXFkqiPbr3Q=
tnb
e+IXhdL1snfkwunUCeQJehfF647O6whNwrHn0lzOZYNZvZNTAbc0SUxShesFVrGhKD/Ik7yOb=
8JN
10uvvOrh7erTa4xUhIT7styuFvQADWxUdRk29iwf6Swl2sLJzOZkqNyelnXHNMiAIlMQimmA7=
ygZ
mjqr1KNktLQojqEwtpjBGr8s81nIOYx3x9VW+auaXJpximRDgU0W6pqZck7tnyFtMHVaCVEJ0=
w1t
WL4v19raAnWlPfgtwpE/9qp2odHRK9zgHXu9fOGSaeN92nhI7nAYYyHPucHUkjsKMJFF/4efI=
XOF
/FRW+k1kJirXyIoUHOKVk0ouOH2yXLj4OsIJSnZywsKyBBgBCAAmAhsCFiEEuPvz8KtWTuhPf=
7HT
k90gYwkQtRUFAl0E2QUFCQOakRQBQMB0IAQZAQgAHRYhBMs9P7gHHficF5sLQ/G3Z4WcsuvHB=
QJb
S3txAAoJEPG3Z4WcsuvHdVoH/A2m8fbyqNbrG4Ax5eC2c6yYX0ZtiN/ieRU26CybBXvI6UTXH=
+nh
iaRi3lt7P8KlnfHGLC7W8yWtc56M9xMD4R2iB5sF8OE4GJvjVbtgpvXYNmizUI/IWjXzj4SBq=
q+b
p74Z5cK2xvmI5dHq9rAHQec15SMfISIx6HzCSKFuMge/U+HmbHhcq8APjniOqSU4ENXWl5TqY=
dum
RrpTMvvqb4iD/wG+ezyfNfw00j1l6phHu9py1uY1il3h20zGh/SlTXcSQiJfGWYKuMzdprJ6Z=
Yif
hKDVYBjoCokXJHhpZFrXHs0NCK+cgWgAZFVWQksnWHxE0ie06xcGNcEMMghXC+8JEJPdIGMJE=
LUV
kVwP/18ljntddAENT0iipPFe+vpPReM+Dtqdg1MLLDdpcJb8yscBXb8wAr1bbFtdaYzK+GJ3N=
0Ye
DzRXd4m5zhe9C2u8rceMPGHtmkX2NRVDf2Mo1hGDaUeDrWDFg3fFz8nvcPDyS6d6y9lLZ8cfM=
bUe
uPaha/fFRuH6+9HUrJql3mF7xHTuve+YbuIJCiM1gGt9UPdmB6cSZsaz18zWH6fU75iFY6DE9=
dbJ
8gwh/tZM55jSKfgIOrbKAl9ZpKfoWB3gX9RVmNEZfQlNH9PATlLbLKvVD/y9SpQ7zCGAJ26aa=
kLz
khNm+Ajwg5YzKQ/4dlKipQrJuwWWtfur3fKSRY1kpyTtTsYV7/EKJrG/HI+Du8C4wsM7KSo1n=
XAl
jOhCRrWQmLpGYEWkNBSDv789LqUIWgSmlant5RJI0+bxUVuPBrUPcyBLf5VIo4yYVYZEJj31t=
aeX
Zl3aN90ROYEU1cD3iaDY3a8j9MeO7v27V1H2DOmMftHeOY++kRzZYJTm4l9pWgASqH2QjYPs2=
VAI
bzRSRcMcaZygcGeyIRkaPObnNg5iKeNNR6jLcXTxpNn57+yP6vhVM5QH9vSPL4k+fGfbcWS0Y=
hid
D6UuwCSZxtwPAKinhXn3B5HZ6rAGp501FRfk5M/3eVQiGtEjLdxlP8Dmc1xR4JhFLxsJEUqtA=
oSf
3ZEWwsKsBBgBCAAgFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFAltLe3ECGwIBQAkQk90gYwkQt=
RXA
dCAEGQEIAB0WIQTLPT+4Bx34nBebC0Pxt2eFnLLrxwUCW0t7cQAKCRDxt2eFnLLrx3VaB/wNp=
vH2
8qjW6xuAMeXgtnOsmF9GbYjf4nkVNugsmwV7yOlE1x/p4YmkYt5bez/CpZ3xxiwu1vMlrXOej=
PcT
A+EdogebBfDhOBib41W7YKb12DZos1CPyFo184+Egaqvm6e+GeXCtsb5iOXR6vawB0HnNeUjH=
yEi
Meh8wkihbjIHv1Ph5mx4XKvAD454jqklOBDV1peU6mHbpka6UzL76m+Ig/8Bvns8nzX8NNI9Z=
eqY
R7vactbmNYpd4dtMxof0pU13EkIiXxlmCrjM3aayemWIn4Sg1WAY6AqJFyR4aWRa1x7NDQivn=
IFo
AGRVVkJLJ1h8RNIntOsXBjXBDDIIVwvvwjsP/1QDdPUYl5sX1AbOit/DUBxZmsRu/aSvTWZN2=
ZzD
rkp3oE3wanA9yYxg2VhC9QIWw6agD0eJ/b3Z9RjWXWzRphXIEXBpk1uRyeJdjzRfSMgSaZVol=
yL8
82unkZGDdbjHsNcWxQqLbJQJeTljtgINx7ZwmGoD6ZD6eoMS+Ogu+gkVRoIMi8L4EE/0OCOsn=
Wz+
tgBJiK1KyeSg2YCu3a6YAnxU5j7tDZKxV+XO5cqeaOceRdG6HyyvHLNyT9r0SiZtpK99GlXYr=
SeY
Hyp1c3Epa1ZPQ3/sps6U+SqRkoEBlKBNcEQuqGaLtKBQNzgXycTBHdGeNlGx6Xx+XJCgivmqn=
YpY
nhu4r1zk6KNhGG83yMWnD+zvPuYz03c+cdCrI5wgrWPqWoxCML+SZEqk37ROtozPyVfxMj102=
3L9
cW5W31j1i/W99IUdkRipZB9EUBhIgD+i8FvsJEGjxJ3idsuTvP7tD+07VnL9dL5QanCAG1DJ/=
RZM
LZYNIr+CZPAWFa9rj7X0oa6pbhN4NqIq1qSL82sfAIfdo5bHTGvGPhWvapUQ71CSyT7hFm3ZA=
tf0
8KWYMNlH8qCcAYhVodzDo6efTaRrv5X1zwNwmNCkPojKwjSvhTQsJQx123CpoOT/QtHwzf4uF=
DvT
6RZEIBjRAJlrmkJT0rY/b6fPuKziwXWE1Vqv
=3D2yDv
-----END PGP PUBLIC KEY BLOCK-----

--------------2309AF1BBF35146E73ED144F--

--4QwVE8WIm833tpQjX607anZknlIRVWohO--

--xEh0q0rTGrw7zZ8ks7xCJHbVDTc5kqXO9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAmC7h2oACgkQ8bdnhZyy
68fh+AgA1iMc3Ohkp5Ma3/V6pYNEZA2c1ZI5g19VOYrnR28Koijc6eC/IPWy0/sZ
oJ3B1ZxLWgvjKEfXGc62G8REtDQw9eQhF01wofqBhqahEIglTLxr5Mh0H4olvUJM
Xlv+NdPAwdqZURxhHkZM85JoDhCVtn6MTwzfyKxaVTM3MYSNlte5UlJJFneSG7RF
ZBdy54IjSxfK5FqbXTsSTdrLdKJms2ZyUpv0NDwICG0PqGNUVk1kSPIZTAWzhNyY
8Ba8qvHP6NtTXpik8Pba01ypVzZKa5epHCdCDMCpaHFd6sKmArxxV+n7jLjOCCxH
0FotN6ifl4rrGtl44aKwuVdxfBcAdQ==
=/h3T
-----END PGP SIGNATURE-----

--xEh0q0rTGrw7zZ8ks7xCJHbVDTc5kqXO9--
