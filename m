Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876B73D9DC0
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhG2Gjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 02:39:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41816 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2Gjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 02:39:40 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1627540777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Asgvin5S1f9dEiJluCRzPv1N8ZNVLVa60pZqyczXVbM=;
        b=Lcop8+qnCibsUhX0pcxLxiheAielV6ODvbynPyoUm/pjkbLVn72RJmvP0lFXPqqGm+7A9L
        TEfjUXMj5Bnpq7Ykj+aawHgqu8Xt2/wNTay1urEmQ6dzHpmMSF8iIa4q+4rX4kLM6SpH20
        cVQEwp07AT+WGKvEbDMJU4qUDdejMOf10Qwz1x/BNE2ebgLqNTxqVx8g7nFZFmmtsdx+mj
        GUrX+gTNkvtt4xFSN6CF5IDfawnprbYXtUg3pEv966bDn1SeirrjqTyaCd8lU0hASPYyVh
        GB7gEJaIMUlU2Qt6P/OowSE8971z1yF1/peIHjNxpwYjieW7wCXSx3bBJGVWFA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1627540777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Asgvin5S1f9dEiJluCRzPv1N8ZNVLVa60pZqyczXVbM=;
        b=xBnpF0c92pjQlMiObiJd/+Kp7gjjpGvCfyZThHtwAFGb2eFGhDPpBYS/Zt4imh3JO5/c3f
        k6Sf+FA6hqjo5yDA==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
Date:   Thu, 29 Jul 2021 08:39:35 +0200
Message-ID: <87k0l9r5co.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Jul 28 2021, Heiner Kallweit wrote:
> Did we come to any conclusion?
>
> My preliminary r8169 implementation now creates the following LED
> names:

Is that implementation somewhere available?

>
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led0-0300
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led1-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led1-0300
> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led2-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led2-0300
>
> I understood that LEDs should at least be renamed to r8169-0300::link-0
> to link-2 Is this correct? Or do we have to wait with any network LED support
> for a name discussion outcome?
>
> For the different LED modes I defined private hw triggers (using trigger_type
> to make the triggers usable with r8169 LEDs only). The trigger attribute now
> looks like this:
>
> [none] link_10_100 link_1000 link_10_100_1000 link_ACT link_10_100_ACT link_1000_ACT link_10_100_1000_ACT
>
> Nice, or? Issue is just that these trigger names really should be made a
> standard for all network LEDs. I don't care about the exact naming, important
> is just that trigger names are the same, no matter whether it's about a r8169-
> or igc- or whatever network chip controlled LEDs.

Your above trigger definitions are OK for the igc as well. Except it
supports up to 2500 Mbit/s. For igc there's also more triggers available
such as filter activity, paused and spd mode.

However, what about the cross LED settings which are common to all LEDs?
The igc has one attribute to control the blink rate of all three LEDs.

>
> And I don't have a good solution for initialization yet. LED mode is whatever
> BIOS sets, but initial trigger value is "none". I would have to read the
> initial LED control register values, iterate over the triggers to find the
> matching one, and call led_trigger_set() to properly set this trigger as
> current trigger.

Yes, there needs to be a way to determine the default state.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmECTScTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwprg7D/9A0BV/ZMMH5S94YRumqEoCp1o0OZmb
Y0d3TCP14JK0fxEQgad1PRTjNImnWoz80FxGhMquL66YRiHoZfW35Sr32cJwx4ST
iPSW1lc40CiWA83x3UXZYc4zjLd4ofP9eRp6yDgrYRBllnCTjqGaeEcrj3ZeDIR5
Cv1CDMIb/MCcfAxVcRVs2N5w3gjfVI9q/vVolCqqf21ic4rtdIIhn+MaCwb9RQl4
rYw8x5eZV11z4vlNsey001fOPZqg1h7Etx/bUY+VbJHMpBd+DoakYAYmQWVaWptO
0b49xLaZIpTBMYTN2bwJOXlwwn9VctNwhmlRUA6/tIqTd6Gaz4p6YN83k83cHh4G
ECZ4gJiMyyqZmsjv8FvM6PVQHaajUbjj4G2Z9VLlRHERkQCxbrU4QyoyvwmEPU7u
+qKKgarE6NcCLIQQLW2r6h3V9wXiHophSOqsJYRNsx+d5YpMt/Bd69R6XPJXs+3V
1A0hsFs42znXIFSkfWDCDabIfauFmk7NX2oK0hTlJBRA4QPw0iXFNNvZoK7GRmCd
wT1eY3qq5HKePov0ExI2eg/ramujKUaXZbZDfoiYSQhD0r2xmQSz7KRsFbUPlKU9
NDlOuZzsVCkjrJNu5N9ekLN4QovWTjm4aQsq55kUcGUzJkjxY+K6bxp6HVEDCcxO
eDbnhOFVmoH6uw==
=cvzA
-----END PGP SIGNATURE-----
--=-=-=--
