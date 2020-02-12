Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4015F15A303
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgBLIOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:14:31 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:30830 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbgBLIOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581495267;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=uw1pmQHS7f3RyDkV/aP+o5WvUTjTvnxcA78I0t7OepI=;
        b=dCpxMepp3/hSlUL/kAqXltr8hGfNvBa0TyDBs5h2OcqqeJy5ktnqpCgdL7RyRXwTj9
        S6b+GDXDdrzqZLQjby7vYx2Jr7IKvgTjR+zvCzMS0vTK85DMUEbJwRyGfv/8xm0gd1Iw
        Q4QBQYD8K3khPKD8JPp9l50Bs+r1Iswpn3GC13xjARaUN0uigM312xIPxiKq4lFT7C/6
        UDP24971KNNygPT8a6jiHFBT8Cfzt8MciZQA4sIwE5bdMTFVeNo/YiJSYk2supB7TSIF
        uliSMbrpk05fhVvmpW3ZDPqvGBA4+tpuPTGLr2Q/vGnECBtgFHqUHxE1CN2eHscv5sbY
        DX0w==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlSbXAgODw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1C8Ds1dj
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 12 Feb 2020 09:13:54 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 03/14] net: davicom: dm9000: allow to pass MAC address through mac_addr module parameter
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAMuHMdX6f+aGZjQSQqVjT=npojq5xH2k2Js8qxG5=n26Z4uFBw@mail.gmail.com>
Date:   Wed, 12 Feb 2020 09:13:52 +0100
Cc:     Andrew Lunn <andrew@lunn.ch>, Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?utf-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7991495-F233-4186-82A2-43C39898C8B3@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com> <4e11dd4183da55012198824ca7b8933b1eb57e4a.1581457290.git.hns@goldelico.com> <20200211222506.GP19213@lunn.ch> <CAMuHMdX6f+aGZjQSQqVjT=npojq5xH2k2Js8qxG5=n26Z4uFBw@mail.gmail.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 12.02.2020 um 09:07 schrieb Geert Uytterhoeven =
<geert@linux-m68k.org>:
>=20
> On Tue, Feb 11, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
>> On Tue, Feb 11, 2020 at 10:41:20PM +0100, H. Nikolaus Schaller wrote:
>>> This is needed to give the MIPS Ingenic CI20 board a stable MAC =
address
>>> which can be optionally provided by vendor U-Boot.
>>>=20
>>> For get_mac_addr() we use an adapted copy of from ksz884x.c which
>>> has very similar functionality.
>>>=20
>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>=20
>> Hi Nikolaus
>>=20
>> Please split these patches by subsystem. So this one patch needs to =
go
>> via netdev.
>>=20
>>> +static char *mac_addr =3D ":";
>>> +module_param(mac_addr, charp, 0);
>>> +MODULE_PARM_DESC(mac_addr, "MAC address");
>>=20
>> Module parameters are not liked.
>>=20
>> Can it be passed via device tree? The driver already has code to get
>> it out of the device tree.
>=20
> Yep, typically U-Boot adds an appropriate "local-mac-address" property =
to the
> network device's device node, based on the "ethernet0" alias.
>=20
> However, the real clue here may be "vendor U-Boot", i.e. no support =
for the
> above?

Yes. It is a fallback solution like it is implemented for ksz884x.c to =
make it
work with existing (older) U-Boot installation.

Maybe I should better clarify this in the commit message for v2 (which =
goes
to netdev only).

BR and thanks,
Nikolaus

