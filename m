Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5F3CCDD0
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhGSGUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:20:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60768 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhGSGUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 02:20:38 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626675458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYYtUZmL8R9lhqnzCSgn8EVfMGUT/qGmUS9k2jVf1mI=;
        b=1BWZRibGll5H1TEcvjGkOW4vwr7IJ68FmQfv3SfpTkdEvzTyo0MtnWS4zJZzKUQBhSMuOV
        XAPSQP4Fxp90mXWngfSWmA9Cm3fvBaXfBLUmuHzG9MaMOjZIr30MYMui8dMhrj2fqvR3ac
        4UvhHa/7Esc3azBOFFwlS3NKbsate6eH+meIQ7hI/WTfqhjXeRIUxCdefYFFBEzWaShPqb
        DMR5m6zBV84zSAx45bwWuRYW0yktYtXDWMOX8X03BHYq3IWVeh4lVpwQWuUhXV+Hq78JSa
        hO1jHQpcHFYhKyIyxaWkAcA15DwtP59aEw7/ynnXOjdPMV3uhSgqBT8E2HLIaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626675458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYYtUZmL8R9lhqnzCSgn8EVfMGUT/qGmUS9k2jVf1mI=;
        b=s69+d/hyfIbsTDFcx1Err8oIqQ9cLalQMb3x0UPnZ3dlIxkEZMsirbwxYyTl2J5+uYwmcE
        KspEiIp2pxmMfDBA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <YPSsSL32QNBnx0xc@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch>
 <f42099b8-5ba3-3514-e5fa-8d1be37192b5@gmail.com>
 <YPSsSL32QNBnx0xc@lunn.ch>
Date:   Mon, 19 Jul 2021 08:17:36 +0200
Message-ID: <87sg0ahlof.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Jul 19 2021, Andrew Lunn wrote:
>> Supposedly mode refers to a 4-bit bitfield in a LED control register
>> where each value 0 .. 15 stands for a different blink mode.
>> So you would need the datasheet to know which value to set.
>
> If the brightness is being abused to represent the blink mode, this
> patch is going to get my NACK.  Unfortunately, i cannot find a
> datasheet for this chip to know what the LED control register actually
> does. So i'm waiting for a reply to my question.
>
> There is a broad agreement between the LED maintainers and the PHYLIB
> maintainers how Ethernet LEDs should be described with the hardware
> blinking the LED for different reasons. The LED trigger mechanisms
> should be used, one trigger per mode, and the trigger is then
> offloaded to the hardware.

OK. I'll look into it. Can you point me to an example maybe?

Unfortunately this patch seems to be merged already. I guess it should
be reverted.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD1GQATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpgvND/9ht6WJFPcSA2aLRHkbhhVQMFYTRx9N
qx5/+DOuY5gteigf8VFO21VJWnz7Nqftzj6AkFAIxzcotS4qqjcfJgxnvLkdiDL3
N3xaeqUsvpHD8w81CWTjPcyo6dkkBmRG1GmdZHEmoc8g80S2eg/sBF241/Hz0bap
3M/X7vdeRGgHuPgKMOVAE/7+GL20lWbAkvd1/uL+Wr498OCSemGONHSiMCO4rcna
Z4/jjPctZubjfSQSQ+cRNE0nAhtkh+GbIqGxJCrSAsi2mEMv+u2YlVjYaqCIHJWu
VBTcIBXPlxii7DrtrlweuQow8qwPiB+fuPmKoMaiwyJernKmpvlh5HscNSQr9asA
ZdW9dK4xkdhGsmorzVq/w2MsGlEuc014k66thXBfVO4RYboiX/T7q4SAk0pbcxOp
4gSpoWnUW/K5zJUHURJvlpkxTaB/CUUpNKoaSC5a6EWTe6qRsZi3U1XxrWyKalbc
KkouawZrxoEkpy9QJ9bV7fDSuKa4K6yLhIfFosQezOYTMdHqUMSqqU0SolDN5Y6V
NAotz4y94SXcR6Ax9k5LTgItj1ZV/IvjHpffJtcFtiqxdzgqBTelAoZJRDgSE5y+
B+UunIaBUIeCjl/f3NlCrgU9B0pI3YBfgRvUt1rAHUrc/xMB7EpSuhqp2ltP4Glo
QTdHYAoxXT6P0g==
=ZgOw
-----END PGP SIGNATURE-----
--=-=-=--
