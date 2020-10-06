Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C97284602
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgJFG1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgJFG1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:27:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F34C0613A7;
        Mon,  5 Oct 2020 23:27:45 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601965663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SG1hX4RpJ2cgd0+twelFInFVuEr0F5kpEMUoLXcxSFM=;
        b=HTKIpbi5M+5siFbJCoYh7ovIqLgttVuCH3/hd07/EojDYenNQv6iF4yfpMR7cFBtDpKYE0
        85dysrQ8gmaDWd9kC/q9WeS8SWiq70241NZ6p+Y5BSGqp1Fiis45mNEHrq3l8UbbBX+or3
        yA63BmZoe98eqh2ruu34eiQ8eHTUb6r1aC7FeBdIkjOyNfImmYltRV0oqsvis7tWVfYr+9
        CAEUW02z2st8u2ffz5DMxY1S8M90HgNeQ5v1hyPN8d3HyZAe7FtLLTylrbnzZp1zbdG0oU
        MFK89TUUjZX95hudQTdqw37WQV82Mh4OusIJ8tZ4b7yen5tInVQN8wUT0k+vig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601965663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SG1hX4RpJ2cgd0+twelFInFVuEr0F5kpEMUoLXcxSFM=;
        b=XjgLGnKOJLTSMt+Lja6e7mLfPf6iIIYzb8lYq0ARL4r0wv4XH2mJDF2ZMftmO1Gmd4ATFG
        /45SUtm0lscx1cBg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201004143000.blb3uxq3kwr6zp3z@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-5-kurt@linutronix.de> <20201004143000.blb3uxq3kwr6zp3z@skbuf>
Date:   Tue, 06 Oct 2020 08:27:42 +0200
Message-ID: <87imbn98dd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Oct 04 2020, Vladimir Oltean wrote:
> On Sun, Oct 04, 2020 at 01:29:08PM +0200, Kurt Kanzenbach wrote:
>> +/* Enabling/disabling TX and RX HW timestamping for different PTP messages is
>> + * not available in the switch. Thus, this function only serves as a check if
>> + * the user requested what is actually available or not
>> + */
>
> Correct me if I'm wrong, but to the user it makes zero difference
> whether the hardware takes timestamps or not.

Why not? I think it makes a difference to the user b/o the precision.

> What matters is whether the skb will be delivered to the stack with a
> hardware timestamp or not, so you should definitely accept a
> hwtstamp_config with TX and RX timestamping disabled.
>

Sorry, I cannot follow you here.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98Dl4ACgkQeSpbgcuY
8KabdxAA0SgprQl2AgyD0AY/qVDLxy1XHCf0QhEZEoDKWIHX3ijEoZ0Dni1WsOwF
dXnvL/ZQb2mcdrl+uJcN5ypMlBi+m5N7leV+RBO6juLDA8dp8ychKxCrhVtC3/sF
fsj/vS7NHfXMJS1/CuBYcPX+YUpbzJpRVvDtd2E8FZYTyuKRDLrGIB8plEtltDv6
aS/WC3EfExvKz1JFrtDSyR+4W6SIB2rLUFmG86P7w5304fFnmznLfwDHIEFPFZcv
RY9zAjgv2tPLJyQ81gzCPsAlz/QUTsDgwoTc8DFsmsxcVTC9jOxNIuCpOUWnvtBD
c/2ufJBmgsU0y7e1l3Z/Us3pvpTGpYI+b1OFsuiwOWBaQPc6J5IZi6A/KrtoWWDH
mlH3yJPMyc7wRsjggS81jjgk1oNqkI+wDQ9imPrGiRi2/0Kz717uiiaJy9E2fDKw
wE2r9o591w+eb7MlK6bEBZnnYAtwxsSvEMlqRmvbgYk+ZwOO59RSuUG+1ivqJ62+
Tu99v2bd8aMgVIQOxcMaLNRwe/K5q6gjEDC/tfvtS+tol+HPKVOLPUbXOIH2PmKv
McW9qVbILMyR5GMSbFJGpsYIITTbfllBxThCgSRxyeT32ezFSaK7/8lShN16QR2a
tqmr8IkDt/VYwFzpSOtzkg38NK3ko/RUkJO578fclSNePEybXW0=
=qmWw
-----END PGP SIGNATURE-----
--=-=-=--
