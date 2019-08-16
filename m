Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628AC90228
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHPM7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:59:45 -0400
Received: from mail-wr1-f100.google.com ([209.85.221.100]:36884 "EHLO
        mail-wr1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHPM7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:59:45 -0400
Received: by mail-wr1-f100.google.com with SMTP id z11so1474655wrt.4
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 05:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8WjA/SkmjSW1Q7MwGAGn/uHdUZXIAVmUpNLasanPGps=;
        b=KOwnK2sKc3dtwPlMoIhlPhr7Q2d45DQP3oy4Uf7C+4eNsmoVxPKbDpyiZZVmv0KY5o
         ByJJ8EszFyWbKRg7iEtgVsDH2cPjwScDLDFAlAiIJB2XS02wbqPI8Ed0de/k0idn+Nw1
         YorDCI8DsvcqWvD3aX+Qo6RQ9jQD+Vw9p3nR9ZNM3oQHHo8f6WV3RFYNAmGS93JJdq//
         h88HPGh1wz+PUxiySw5gBu7TdtblbKWMiVU5EN26gOJlIofmUwwrZocK/95aXulR5Lbx
         1S01RnxTZKg9eI+pxprchhIIUk1EjnPFwxTCX1CWE2W7TNr5L4SWqaDG7912jKq+Gatv
         A29w==
X-Gm-Message-State: APjAAAW3/DaO90Wb0nrcse3MIea0sOaSUJu4xIXfPzvJXNv1AYO3MZPw
        sYlFo4NX4AesVmxXDjmh19xHSm97FtscfWgUR53XvhskGUoQRfzGGBBi9s5o+QGmig==
X-Google-Smtp-Source: APXvYqwCW4UxgyGEgUwqCoysCHJBelEafLxd5IhZ2aEFV3SQ5gU8ql+nM6LFXiFZW1x7Jsn2O6UYWqZpOWof
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr3583238wrs.108.1565960383159;
        Fri, 16 Aug 2019 05:59:43 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id w1sm99570wrn.59.2019.08.16.05.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 05:59:43 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1hybpW-000419-UO; Fri, 16 Aug 2019 12:59:42 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 744AE27430D6; Fri, 16 Aug 2019 13:59:42 +0100 (BST)
Date:   Fri, 16 Aug 2019 13:59:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 04/11] spi: spi-fsl-dspi: Cosmetic cleanup
Message-ID: <20190816125942.GG4039@sirena.co.uk>
References: <20190816004449.10100-1-olteanv@gmail.com>
 <20190816004449.10100-5-olteanv@gmail.com>
 <20190816122103.GE4039@sirena.co.uk>
 <CA+h21hoP3t6j2mTd2BLwizqbFap+9Z2vdxQ4ahHS3-7Vr31Lxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TdkiTnkLhLQllcMS"
Content-Disposition: inline
In-Reply-To: <CA+h21hoP3t6j2mTd2BLwizqbFap+9Z2vdxQ4ahHS3-7Vr31Lxw@mail.gmail.com>
X-Cookie: My life is a patio of fun!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TdkiTnkLhLQllcMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2019 at 03:37:46PM +0300, Vladimir Oltean wrote:
> On Fri, 16 Aug 2019 at 15:21, Mark Brown <broonie@kernel.org> wrote:

> > This is difficult to review since there's a bunch of largely unrelated
> > changes all munged into one patch.  It'd be better to split this up so
> > each change makes one kind of fix, and better to do this separately to
> > the rest of the series.  In particular having alignment changes along
> > with other changes hurts reviewability as it's less immediately clear
> > what's a like for liken substitution.

> Yes, the diff of this patch looks relatively bad. But I don't know if
> splitting it in more patches isn't in fact going to pollute the git
> history, so I can just as well drop it.

No problem with lots of patches in git history if you want to split it
up (and probably split it out of the series).  Like I say it's mainly
the alignment changes that it'd be better to pull out, the others really
should be but it's easier to cope there.

--TdkiTnkLhLQllcMS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1WqL0ACgkQJNaLcl1U
h9DF+wf7B3B4JsNBW4VWkpFnGhsr4gl+XnKkqDJ7m73tC2Dl3/3FKwqSYXVfkUWS
LbcxZOobEr61s9fmfjA0TUFu8B4JB8wp/jKmmzTj5ygRP07LF0jYuGAiRBaS0X7m
tfDkFIaBbHbxUdVcjqkWPAJ5LxJWMhgsDJR4rWC4FW8/KYABGNTGtKzKiMA89UEI
1UeQ13P7LnA+uSIqgypnD1QOmucjJyBZH2QWGR3D/ZoxF9Uc4M+uticmdK6+baNM
0xXq29jl5RjwEJ33XgAL9I6bSNPooiu4QVRr4DkhVV7Tvu6w7O8/sLnrq8e/bZWM
Uvi+kxInQPyMoTHZdyylCtohid/Grg==
=1nYD
-----END PGP SIGNATURE-----

--TdkiTnkLhLQllcMS--
