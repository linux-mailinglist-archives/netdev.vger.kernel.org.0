Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8F2543BD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgH0K3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgH0K3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:29:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968DC061264;
        Thu, 27 Aug 2020 03:29:13 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598524150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ylDEcuXb8kBIJ352QnMfKDeXNRHGJSmhAa9T1jd3480=;
        b=koMVclXN+CAiq+v5k56S/JPdQbfFLcL25OOQmXkP5zHH06QnPXgpD5GzU7hgX86h8zgl71
        c10Oja++upjYNLX37RQZU6XAHxM1RSc737u92340+4t/O82WxYZEuNtMlZofSvK9h+fcm2
        Cnc/iXE61RrL7AV9+Gkr5TmQtk/hFImmGvqJwlNZYzAIt0F1ci1qTXT03ksU80SVVuGkgh
        KVhR0KaQuNuK0n4oNA53w3bpHMUdLhWj+/DPw3PYCmGa9TacgcPyoUgEVKwe059U0ZTXHL
        rxyynZVrzKEhav6/kkMapikhQALGwc6+kJHz9jMlUJ+7SKGaRnVoqbmog4PCgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598524150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ylDEcuXb8kBIJ352QnMfKDeXNRHGJSmhAa9T1jd3480=;
        b=QiWdsakVvLqWoVqXoiIoNOW0OTyAj0qiQTL31YIKMHvACzmbh5qboHSG99hRmC4KBmBG3H
        QjWTFDChvj5GxBBw==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <87h7sqzsr0.fsf@kurt>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-3-kurt@linutronix.de> <20200824224450.GK2403519@lunn.ch> <87eenv14bt.fsf@kurt> <20200825135615.GR2588906@lunn.ch> <87h7sqzsr0.fsf@kurt>
Date:   Thu, 27 Aug 2020 12:29:09 +0200
Message-ID: <87v9h4crgq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

On Tue Aug 25 2020, Kurt Kanzenbach wrote:
> On Tue Aug 25 2020, Andrew Lunn wrote:
>> I agree with the check here. The question is about the compatible
>> string. Should there be a more specific compatible string as well as
>> the generic one?
>>
>> There have been a few discussions about how the Marvell DSA driver
>> does its compatible string. The compatible string tells you where to
>> find the ID register, not what value to expect in the ID register. The
>> ID register can currently be in one of three different locations. Do
>> all current and future Hellcreak devices have the same value for
>> HR_MODID_C?  If not, now is a good time to add a more specific
>> compatible string to tell you where to find the ID register.
>>
>>> My plan was to extend this when I have access to other
>>> revisions. There will be a SPI variant as well. But, I didn't want to
>>> implement it without the ability to test it.
>>
>> Does the SPI variant use the same value for HR_MODID_C?  Maybe you
>> need a different compatible, maybe not, depending on how the driver is
>> structured.
>>
>> The compatible string is part of the ABI. So thinking about it a bit
>> now can make things easier later. I just want to make sure you have
>> thought about this.
>
> I totally agree. The Marvell solution seems to work. For all current
> devices the module ID is located at 0x00. Depending on the chip ID the
> different properties can be configured later. The SPI variant will have
> a different module ID. Anyhow, I'll ask how this will be handled for
> future devices and in general.

After further discussion, we cannot use the Marvell solution.

So, the module id doesn't help us in determining anything about the
hardware. The module id can be arbitrarily chosen. A lot of the features
of the switch IP core are compile time options and cannot be read back
via registers. The hardware integrator can chose which features are
used, the precision of the get of the day for the ptp clock, the module
id, the port speed, additional debug options and so on.

All of this depends on how the IP core is integrated into the hardware
most likely an FPGA. My suggestion for now is to use different
compatible strings. Currently two variants exists:

 * An evaluation platform based on a Cyclone V based DE1 board from
   Terasic
 * The kairos chip (via SPI) which I mentioned in the cover letter

More variants are about to come with more ports, etc.

So, we would need different strings to distinguish between them. Proposal:

 * "hirschmann,hellcreek-de1soc-r1"
 * "hirschmann,hellcreek-ksp-rbrb-trsrr-r208"

And create some form of platform_data with:

 * module id
 * amount of ports
 * port speed
 * qbv support
 * ...

Any thoughts on this?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9HivUACgkQeSpbgcuY
8KZDoRAAn8U0YLdMeQYNQ9v+H2lycyG7o1HFy0msUWMLnDspR7j7KnPymgy6Y6y4
kdYNL6rtrER7YE30uNoJ7qKJNcni7nfgFbGJExfDRSQMKllYffIchrUub97gQ9bY
4ow/08ccFu1hARsowMSpIQrOAq3hhdkzjdlFoZx/OL0KDm4Yfdoef2Bx7Xbpu5rf
KO7I1LilT3uaqjCDAW7a2QZ9tK1pCKPgv5J78s0S1P12u706ty1PFfUlmg8ADLi9
HIhbnRa47RrK9bW83XtNDwKxXUywCf5beu5THm/FNJo71/O0pdgHPAVhj+HDIP8x
L5Q0uy4e3L1EwueCjb7dKM63U+0b2sVFnXOSmcdaajy96RrGAG6DiXNWD+9CDeDF
KP4fB8QoAQo9jRJ4ip5+86zj+qCwBk528iHQnKzJLkcTv82qdA/x1xiJ6c2VXdNN
Hz2iF8/NJonF2qtGmDuP5pvFC8KUcDvxLRrqKAeTSu4XjqFX6+EMdQKewIr9Qfcr
Kgfr3/z87f4htgC/9BXQNd+aGuiknb2XKVAFlmMghqA+JLVUT+gKYN4PEg4fiHQd
JJvPn8PxFMAaPLCh/yJ3dTDpyYQ0AX8wmxksv+r0xoOskXSCvXwdbFKXdThqAWfT
6Z30N9ta93i/o1oR9YlQmgL0APh0BaOJkHzNUvlbgeq0vYKhLMU=
=KkKb
-----END PGP SIGNATURE-----
--=-=-=--
