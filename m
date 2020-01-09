Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B32B136149
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgAITmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:42:31 -0500
Received: from mout.gmx.net ([212.227.15.18]:40623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgAITmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578598947;
        bh=IyC0rvUgmhtgQMim64qJtNLHuXiIT/7S3HN5+xHDVe0=;
        h=X-UI-Sender-Class:Reply-To:Subject:From:To:Cc:References:Date:
         In-Reply-To;
        b=ihiLG+u8Vd7rlYRJAeT25z4OCsL5C9mrWpLzMNGx02xrFbOMyc4rLrMNpVpCzwuF1
         dAczoUgEEjptFDoIcHiccI+5OlQDtpN7Bd7hHfQ1PsfyY/khNXBObQiy9xZIGYs1Ci
         ZESoNfHssdYmZgvL8A6U89npGHgL8DWmsoFKzBD0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([95.81.25.209]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M9FnZ-1ijKqK1Vdn-006RSi; Thu, 09
 Jan 2020 20:42:27 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
Message-ID: <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
Date:   Thu, 9 Jan 2020 19:42:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:MPvSpxp1EHUkO35+yhb1Maq8kmCaOVAnXr4EticMR8G5cs52w8o
 Ne8x7RoTBKtH70nWpIBIyn1DSHR0hkRbH8UmHctT1RpgwsIekinFa0QMcZWTDT4oOxCUJlh
 GXyszC1/NHFqbvqAZz9pnayA5mmUR3Y0Q/iDiY2jnLEJes0+NPH+rI7z4/ycUKot774hj55
 yICY1TyOFGCfHaAxywqGA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0Dd8HncLj64=:g79unTjya/KoQQKxuiP3E/
 MyVcvV4joSqYq1cf4c8SiDy5Zr/IDSXKJkCDvq4pvNTgW1B+qPeSphnQMkglYE2JGZCIIhp3Y
 cQ+vC/MqrTltxCoxQbjwtZCTtAtv/RF6xIQgwU/d0GkA5simFZdpH15lX+dPV23WmZEuD/joF
 xNhaJPq9YS1vE63Y+ZxaZuQa056K2bo/bSIkmZmrZIu9WpgNvum4W5ZbRSJnmuD2sGyyh3NZi
 H5LrU4U93KcxY1DGLyGSuR+tOPQiOclKdMkbzRSAmyPKPMeAoiRON34pnn54sLTisv/C+rI/t
 rf7pbGYiAfUvzLuCZyC1cnNuZ1z7tiDjG13w5lIq3b/8PVfN6Zwep3TOnTcgMdUR3E+Mk9IUQ
 hG9TO88zlXRVOKBUqg/tzjWu/glhGZHYBmQ+z+ByfJ6E9Fwxv9tQrEN3RLOpYnLNRR31d+9sq
 AeLcZa0SAbp1tL7CnycFixk35kZfOnAbZX0GGHEQOIxaM3SRy/pp7p5ggaC3lFrlyQtvHgAMl
 QCc1FsmrFbCZ43CCPcMfPzCGji9TZMYDOYoBxSC4Uv/18Nluj6m8OH4YQk8MPn3h38Js2U2nF
 MXjsmRbbqCU90TiNhTCDJAFIDqwGDQb5cfaGZ8k07PH1UeRZv0IyGcyAgpv2hBgCSNx3bQub9
 2xbdyNZHHivjLu92S1Fk8jE3SD7cHZFsD1O5wPz+9H1i14FfyVkxLcqTvnuFdnSp4VDzKpbUC
 XSMQrCpgufoEmMHvK2uMGtaEaXWTJ8EbgVwG7G2ezzfEnRi18AsbRWcZReBVWHJM5944D9wZg
 Ie/BOTyS87ZAMxow/DPhhps5C7/TpOQEn8MFLixAjF8OXJ6WJEOJqdVwb0LcHCp2TSL4iC2us
 7xr5IsO0J+tR/e7Mq0qoY5hgs2c5WQTGiDfEDM72QxfLAGd4ibgm/dzQ3I3e9lVIK2BbMWhjW
 x/0afknVaFxdY1c41+fAYZ++y36vq26wMGjIgV0E88FcQFwaZl0e6BMhlVW0ji+KphxCqpU40
 PFY6vqr4FxETEZ5xyJNX022kzQdkTuGl+MlxIERTUQBRbwK5anxP0VC3837wJdOHhIRLZtMPn
 wE+Xf93DLN8eQxu7YprGQnIns1/k72FLA4wAaGVt5YEOTfUWp+NLX9aUqcb8se9zLEaIhbfug
 a/NhwIkp6WcQgJv0tcwhcevfJYhQJhJNzRj/nBedo/vsi2W2xtcXmhByx/j9TKdZbSCZbBOIU
 tgHFTwgssCTUTCPmquzeSdwRemEM4eHNdQhvX9A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2020 19:01, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 wrote:
> On 09/01/2020 17:43, Russell King - ARM Linux admin wrote:
>> On Thu, Jan 09, 2020 at 05:35:23PM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=
=E2=84=A0 wrote:
>>> Thank you for the extensive feedback and explanation.
>>>
>>> Pardon for having mixed up the semantics on module specifications=20
>>> vs. EEPROM
>>> dump...
>>>
>>> The module (chipset) been designed by Metanoia, not sure who is the=20
>>> actual
>>> manufacturer, and probably just been branded Allnet.
>>> The designer provides some proprietary management software (called=20
>>> EBM) to
>>> their wholesale buyers only
>> I have one of their early MT-V5311 modules, but it has no accessible
>> EEPROM, and even if it did, it would be of no use to me being
>> unapproved for connection to the BT Openreach network.=C2=A0 (BT SIN 4=
98
>> specifies non-standard power profile to avoid crosstalk issues with
>> existing ADSL infrastructure, and I believe they regularly check the
>> connected modem type and firmware versions against an approved list.)
>>
>> I haven't noticed the module I have asserting its TX_FAULT signal,
>> but then its RJ45 has never been connected to anything.
>>
>
> The curious (and sort of inexplicable) thing is that the module in=20
> general works, i.e. at some point it must pass the sm checks or=20
> connectivity would be failing constantly and thus the module being=20
> generally unusable.
>
> The reported issues however are intermittent, usually reliably=20
> reproducible with
>
> ifdown <iface> && ifup <iface>
>
> or rebooting the router that hosts the module.
>
> If some times passes, not sure but seems in excess of 3 minutes,=20
> between ifdown and ifup the sm checks mostly are not failing.
> It somehow "feels" that the module is storing some link signal=20
> information in a register which does not suit the sm check routine and =

> only when that register clears the sm check routine passes and=20
> connectivity is restored.
> ____
>
> Since there are probably other such SFP modules, xDSL and g.fast, out=20
> there that do not provide laser safety circuitry by design (since not=20
> providing connectivity over fibre) would it perhaps not make sense to=20
> try checking for the existence of laser safety circuitry first prior=20
> getting to the sm checks?
> ____
>

I am wondering whether this mentioned in=20
https://gitlab.labs.nic.cz/turris/turris-build/issues/89 is the cause of =

the issue perhaps:

Even when/after the SFP module is recognized and the link mode it set=20
for the NIC to the proper value there can still be the link-up signal=20
mismatch that we have seen on many non-ethernet SFPs. The thing is that=20
one of the SFP pins is called LOS (loss of signal) and when the pin is=20
in active state it is being interpreted by the Linux kernel as "link is=20
down", turn off the NIC. Unfortunatelly we have seen chicken-and-egg=20
problem with some GPON and DSL SFPs - the SFP does not come up and=20
deassert LOS unless there is SGMII link from NIC and NIC is not coming=20
up unless LOS is deasserted.




