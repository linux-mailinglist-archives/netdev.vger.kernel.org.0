Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B272AD763
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgKJNVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbgKJNVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 08:21:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C536C0613CF;
        Tue, 10 Nov 2020 05:21:04 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605014462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AzMhSL6JfZYLoAxLQNqOinsWfodG6w3sgRNE+je62BU=;
        b=iNMXQPuDLaAAymCV8YNdZjYIfSNJ9dV3mI3KTjBFmGTy4lF2j74igpHBSibhkxwDRGf9CX
        eG2eRV+hbF5GW//fUgx4HgvZHd5Lp7Bs8YR2qRBuKgRgjOD92qNdT46fqVrh7BrkwQKERO
        jUdkTNGBxbtjqpQ2rAcOamnCqi0acF2da7QMuP3lD7/tj0iVol8K1uGNPLzut4quKGgLRX
        O9G279PsNkfe6IZJ0DrwYYwVoUdXjSArBFrmkVZOc+gbT/WmX3RrCJV+rixpoqtNCzjZnI
        dx02872vu64JOHz7YGp228x44FVX0bNuAq3RBRfB5NMyrB4hdLTckC3tuRvsCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605014462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AzMhSL6JfZYLoAxLQNqOinsWfodG6w3sgRNE+je62BU=;
        b=5EStyjC2JN90PchQKFpE0zsLVrZxmq5m2ghA9RKQoPUfACMG6TqzaKsW8CEqikYZP7iKfd
        cClD7ShI6ogSV2CA==
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer\:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list\:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
In-Reply-To: <20201110033113.31090-11-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com> <20201110033113.31090-11-f.fainelli@gmail.com>
Date:   Tue, 10 Nov 2020 14:21:01 +0100
Message-ID: <871rh18i0y.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Nov 09 2020, Florian Fainelli wrote:
> From: Kurt Kanzenbach <kurt@kmk-computers.de>
>
> Convert the b53 DSA device tree bindings to YAML in order to allow
> for automatic checking and such.
>
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
>  .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++

Maybe it should be renamed to brcm,b53.yaml to be consistent with the
ksz and hellcreek bindings.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+qk70ACgkQeSpbgcuY
8KaoAg/+KXo2Fr8lqgfG4Ih8O7QQ5lBso9BL80dO6Iavyio2ueysGXAs5RtGxSWW
BQCVARWEWevf7xVkyRTkvz5GNEnL+KMCkZqjfUHuhnHEuISDm2idGk2iD5U1V+op
GZrK7dH8A9HsA8z/vGxuuOnMGQibSHC4R55XBYZKXuHGQGlqGlYaoCtXlBChxMIl
rsOjWMRCuY6Deg6UmJYmaREDNJLZRdzGIfj8hiVFswRXSwA/+Nku4HRRegxoPqKE
UYFtiY6ljH1eXxq78SlJu6zslB5OsfV1wFWUG1IM0bB7utauT4NdTkSj91asCUCK
atnNIuXIBlGS41dUljCcSN/UdNDCWSuA2cyBItY8frgk7HNbtdH1rvvMn1uio9T6
CZd9Y/mKK3XOT5KZI9FS1hzZIBiuHvw2nvpPUoEZDeIZRPYCDed1nNsKQI/armU2
bc6kaIqv427yXAT99AaCWdsunkNAhMo7gHC+y0/6Hp/ySS51G3uDLUI18+R/iRxf
trPJRca7pAsrXHuRMhDWRLp8o8FYAo2tTa113ZSATrUsHwq2IQ0H7MXxKVdOhOAV
7R/utQ4EZ65vjqZN0tOcyk4MkiE5it3LVDVjw3OH1hkTBp2aUrR8JCPObFmNfCaX
FO9kS/riUlTMUDCbl5WUt0dO+X2cOZKtpZLgzrO5bB5u2PZtK2k=
=xhiF
-----END PGP SIGNATURE-----
--=-=-=--
