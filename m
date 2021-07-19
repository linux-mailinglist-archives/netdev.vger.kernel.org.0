Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559693CCDC6
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhGSGJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhGSGJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 02:09:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D421BC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 23:06:45 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626674803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MLQDFL0KNAO3kYYGQ9UA8yi3zKUWx05Eoi0ZWgh89ZY=;
        b=x4TFJsNYREefc+9Gre7LSzxFSYBwKetZb5LgijNr2Y8GGNFuYZ1nT8KxGb4eRpTGA/wVIc
        PBDf8FQ5HunZPLm38w9mG+4HQLsy8MGMytpn2A0KlDawuH7Llm5s2uQtyHoBu3JPR0yHsQ
        Ko/vrlJbd6giBtMfOUcyeOGLhwm/HH+corZwySvvgUMaqa87OQGlP/alBm24LXGBYaVuMP
        +f+Y8HNBthQWmSMSMU9nSdapHRa/Rgg01FGDclkAGw/2yI3S4V5NUpWAXP5nBViHTzg5QY
        3JAo0s7d9V+DUYBtLLJ0D3YaJWJ4Y1PVRIg22drQF/t6gO5XFgVGNWPiPEpdJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626674803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MLQDFL0KNAO3kYYGQ9UA8yi3zKUWx05Eoi0ZWgh89ZY=;
        b=m125o68nO6mlTWw0EOs+NpW4D1LWVf0ueipogrB+I9hyP/oWsklz9JmFOEf/Tl3adiFEgK
        vIkJF/4JUxIDl5AQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <YPIAnq6r3KgQ5ivI@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch>
Date:   Mon, 19 Jul 2021 08:06:41 +0200
Message-ID: <87y2a2hm6m.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri Jul 16 2021, Andrew Lunn wrote:
> On Fri, Jul 16, 2021 at 02:24:27PM -0700, Tony Nguyen wrote:
>> From: Kurt Kanzenbach <kurt@linutronix.de>
>>=20
>> Each i225 has three LEDs. Export them via the LED class framework.
>>=20
>> Each LED is controllable via sysfs. Example:
>>=20
>> $ cd /sys/class/leds/igc_led0
>> $ cat brightness      # Current Mode
>> $ cat max_brightness  # 15
>> $ echo 0 > brightness # Mode 0
>> $ echo 1 > brightness # Mode 1
>>=20
>> The brightness field here reflects the different LED modes ranging
>> from 0 to 15.
>
> What do you mean by mode? Do you mean blink mode? Like On means 1G
> link, and it blinks for packet TX?

There are different modes such as ON, OFF, LINK established, LINK
activity, PAUSED ... Blinking is controlled by a different register.

Are there better ways to export this?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD1FnETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwptDCD/4pk9eRSv6XP5aTdXxn3qlEILP0BHIG
/n3j6QvkfpvnCwemzTManh7bhFyh2MDWyaA5KnY+vbtIih6wwP15C6tNyKLVcKHN
NfJxi4AD8Bv/DyDy2emRFMqmHFDyxw9iBsVYOtE6JkVhTK+dJyGsGGburQf2H+Yg
nj94ZtD2ZKWT3HpthlRtjqH9J+iu3QOhm1JrNGgfovZd/vCKQ5pfrYJs9zPN2UgN
eHFZmADM6MY6ZAogGRN8wTlcSvjMDgXacmG+MpW8zh+B/liVGLLhRcLFlvjMkI4Q
m7Euh+Ge0Htm8/JO2dHKjfa8r52UKYz7zCypgeR5jpWkyghUSq2xJcxuqYjHFPp2
/CXWjXvkg0tcjovPiugsJwjgUjZJVrkhD+SbHMgeX39FJZoVcfBa3k2FJdd3MUPP
V0HMfmv4bB098VJDDLvHUt/rOtK925IWCyhGG25GQFE7HFD7qsElEInufNszY32N
c5vKnW8EjZIOrtGasND6rgVcqNrIkpTfL7VEAYaF87K0sLAoer2EgGjjHVz7FM4V
Y9V5nbE3xAHJsT5ap2wrYH/mkmkyqI8jiJOnqzpjTzWHkUSXMei0os17JZ1YueFg
PSsYUfnA71Evzdsj8cx8Lf82vs6sbvpaIiKtzoqQUgccJgtWjdGjTRKVrnq9s+Fn
J3wdUx5VdvD9Kw==
=CfuQ
-----END PGP SIGNATURE-----
--=-=-=--
