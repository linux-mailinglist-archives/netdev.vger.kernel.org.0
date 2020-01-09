Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6682F135F6B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgAIRfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:35:32 -0500
Received: from mout.gmx.net ([212.227.17.20]:39517 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgAIRfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578591326;
        bh=YYogd/ik3Yxg8c6JEW/ncbd8/RuiB3h1mbQ9yuul/VU=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=j/7+oBBu9FgD3AhXFHWJRdGnJhzUJS8LhMHA3VdMyDQQoN6DxbsZ6bGvBxYpE+dol
         kwA2UjxkF5lBljKNM1ujjpTynUiurjZwcqpAG5wBVjTi6Aa1cp87YlRpgIL3TP1Ic3
         ZEznTj8XKc31pJwC4PZVfjr/uKiUPy3fj9piihAM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.112.120] ([95.81.25.209]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MvK0X-1jgCOy2Ai1-00rFqs; Thu, 09
 Jan 2020 18:35:25 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
Date:   Thu, 9 Jan 2020 17:35:23 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200109155809.GQ25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:KX5B4UCr6huEOP9V+HKjQOU1NMVZwJ+QGx8Xoky5/ZYay21GrKE
 oT/Vq+5OVWX2BnkwDUIggTCGdIpRbW2X46XbGlTSYcI2yKCKwFYVkJwcj211IUmwCwyVVvU
 hdqshFYpimeI+aw1m5D6+X4ErvIiVfXLdEl0xmaHWQd6sxZ/slsrsUDe3qQtkFn8YOUMEDz
 U7JRQCcP3fduKPpD8u1Ag==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZpSyU8EFvJ8=:03++0DPEWJ7JJU1yxV0Nhk
 0iPJPV/keeSfnsu3KI8u9X90LMfKuGnaMctr7OIEQKgL4OqpjzUSQvDHAWGGlhs7URj1P6sq7
 9GCsCYPmaVpsFWo0Ww1YhftYu7UwnkW4lX4k82OyMGjn2AFCOfl0vKQGILpQuEjuQOGxWCKJc
 Cd0L+fgzVLO+JOkW0ZSNuVUD/D7Gr6d4HuYgibtyNvS4sECYd3nwSdslc2BfCTrDwCmlhFaRU
 aVwYpOcNl0IbhqUlpTQDV1GAVXRM/pUUsAy9E1Yn7HmsggXE5CXnhr1w9M+8qdtBJZp5vRtOO
 WMk93EAo/kQxf95mn2fAHR00HQs2KzRpECb4dvyAtmeXXUeGC4Jbchlt86zD/EiQAuhHqgiY2
 Uzn/esiF3GQjRXrwh2/ZKiZA5t+gXSDwwausT2OU/CmefFMwYtHmfHHglTqb6AdTEdrlDCpY4
 M+DkyrvRe8GxSeMpZP53ipsE+dzmL7K3Rm0yCAzuRJd320Tvr/7tBQxFVa5H5BVqmMkxjsw4y
 HPzAnBdrjPputDASJQq8HF9tgdFoy8UhWe1TOx7jUan37aH3NrLaZd/LFQChHqY4lHMhNxYc/
 YzaYGBjesHL2q5yUi7g3G6yXnXevSAE/jhxRWKq7xpvc9ZR5S8cMNEzl9BRAb/JPGRgM4vPCG
 SQL/8T72WbloMMOOH3cwYnW1xSxs2nsTmtIjWCQLxyxuxquQ+rdPPFVudDqOf6xzZSi9iGCtd
 W9alE3b9oap+scNcIVjx78WYWK6ExHdc0jK4gBYuv8uggKyTCQyIDUtYmTPMwUiaZqx6REDv7
 wynoLtm31eJbcibUBowzt/mgVkXByqSn9xxgHgVuyoJ092hc6sVzj1oQ9HDSBjsDRD/n1H7St
 7DwEHc4E2WHQSrJyTVKYtDTyiKoaJgUM7NOSu/oiX92VbUuHBgWsKmPBQsuD9k7EFUP4l1mT2
 e+QWVWfxFcSou3zQXn2jgHSht7B/KUtjC7XxAmU+SHs0KbFzMekXS9mPMrVPFw11d8GH+UCoV
 pqGUiztpbl0CJzz5CcXnAq0yW14IfgUQxZFT/4K7WsdX01PoZIAeqsXaxMw1V7OJnfWZikBgh
 K1maQAIc5zsid5Vq/p95EjMY+yCHaRmFKWe3EEL4DonTg6CA/NAlr4cPCeUifvnlIUSCd5e6I
 MkI50ISR4jG9IVABLCeJ2QUSBy3JF7jZ5onAxUXdfS7MccOFRTLpthNsAZFtOAYVbucIRdC5n
 tYkoaRrSeFZKWTVP9+jv6m2fusfnKu21l7T3mwQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kai Meitzner
On 09/01/2020 15:58, Russell King - ARM Linux admin wrote:
> On Thu, Jan 09, 2020 at 03:03:24PM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=
=E2=84=A0 wrote:
>> On 09/01/2020 14:41, Andrew Lunn wrote:
>>> On Thu, Jan 09, 2020 at 01:47:31PM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=
=B3=E2=84=A0 wrote:
>>>> On node with 4.19.93 and a SFP module (specs at the bottom) the foll=
owing is
>>>> intermittently observed:
>>> Please make sure Russell King is in Cc: for SFP issues.
>>>
>>> The state machine has been reworked recently. Please could you try
>>> net-next, or 5.5-rc5.
>>>
>>> Thanks
>>> 	Andrew
>> Unfortunately testing those branches is not feasible since the router =
(see
>> architecture below) that host the SFP module deploys the OpenWrt downs=
tream
>> distro with LTS kernels - in their Master development branch 4.19.93 b=
eing
>> the most recent on offer.
> I don't think the rework will make any difference in this case, and
> I don't think there's anything failing in the software here.  The
> reported problem seems to be this:
>
>   sfp sfp: module transmit fault indicated
>   sfp sfp: module transmit fault recovered
>   sfp sfp: module transmit fault indicated
>   sfp sfp: module persistently indicates fault, disabling
>
> which occurs if the module asserts the TX_FAULT signal.  The SFP MSA
> defines that this indicates a problem with the laser safety circuitry,
> and defines a way to reset the fault (by pulsing TX_DISABLE and going
> through another initialisation).
>
> When TX_FAULT is asserted for the first time, "module transmit fault
> indicated" is printed, and we start the process of recovery.  If we
> successfully recover, then "module transmit fault recovered" will be
> printed.
>
> We try several times to recover the fault, and once we're out of
> retries, "module persistently indicates fault, disabling" will be
> printed; at that point, we've declared the module to be dead, and
> we won't do anything further with it.
>
> This is by design; if the module is saying that the laser safety
> circuitry is faulty, then endlessly resetting the module to recover
> from that fault is not sane.
>
> However, there's some modules (particularly GPON modules) that do
> things quite differently from what the SFP MSA says, which is
> extremely annoying and frustrating for those of us who are trying to
> implement the host support.  There are some which seem to assert
> TX_FAULT for unknown reasons.
>
> In your original post (which you need to have sent to me, I don't
> read netdev) you've provided "SFP module specs" - not really, you
> provided the ethtool output, which is not the same as the module
> specs.  Many modules have misleading EEPROM information, sometimes
> to work around what people call "vendor lockin" or maybe to get
> their module to work in some specific equipment.  In any case,
> EEPROM information is not a specification.
>
> For example, your module claims to be a 1000BASE-SX module.  If
> I lookup "allnet ALL4781", I find that it's a VDSL2 module.  That
> isn't a 1000BASE-SX module - 1000BASE-SX is an IEEE 802.3 defined
> term to mean 1000BASE-X over fiber using a short-wavelength laser.
>
> So, given that it doesn't have a laser, why is it raising TX_FAULT.
> No idea; these modules are a law to themselves.
>
> I think the only thing we could do is to implement a workaround to
> ignore TX_FAULT for this module... great, more quirks. :(
>

Thank you for the extensive feedback and explanation.

Pardon for having mixed up the semantics on module specifications vs.=20
EEPROM dump...

The module (chipset) been designed by Metanoia, not sure who is the=20
actual manufacturer, and probably just been branded Allnet.
The designer provides some proprietary management software (called EBM)=20
to their wholesale buyers only

Trough EBM (got hold of something called DSLmonitor Lite) t reports as:

- board type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 AURORA
- Mode / Operation mode=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 RT / VD=
SL

If it would be any help I could provide what the EBM software calls a=20
"SoC dump".

I opened a support ticket with Allnet a few days back their response is=20
yet to arrive.

