Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9316395F45
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfHTM4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:56:00 -0400
Received: from mail-ed1-f97.google.com ([209.85.208.97]:46470 "EHLO
        mail-ed1-f97.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729677AbfHTM4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:56:00 -0400
Received: by mail-ed1-f97.google.com with SMTP id z51so6193604edz.13
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 05:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sTNITPURPb4r/eqB5oSrUPyoCIQAB00GeOT0IVjNBUQ=;
        b=bbgsdV1VaILwUb2pAROp231dwTuUQnJDlKMY+cpo2F46m1qclx/IunUe0txdhOK7PM
         3YNPL4hqvsJ9KE3HaSdExt18PCZ3ZZiWIbbmcYanZ0vLERNOZemOKLPSEkX5eIqoV8CK
         /q0VmZpMZZBEDguGiIhZuFS0USmD+ht2lcgw3isnRgoFMo1yyaPJJu8EfNDH8WzDrpq8
         SLfRUce98ukzZcso6uMIdNpeFAtgNtHoDXC8Tkw0Th3lxNrKMGHu7aEI3Lotk+ew3ZJA
         Rz8XrRNMEEhXESkmiRKTXfRduIolylD0mNgb+9AXRy+9i1X/iJsRKgP63HUpvZszW7Oc
         flug==
X-Gm-Message-State: APjAAAULXgWd/XDBIjpvIXmg1h3JwLdPVkpKCI3y/3zL64F9SXepu8k/
        AS04wRXmkGivXJHxJUMtBuPg7hvvhD/H44vUaPDzTmBmXIdxRad7+/kO4IPeibQa8g==
X-Google-Smtp-Source: APXvYqytjtPULfzeO/6Q1HzRiHGCA74gB4Fkqu7AGrV+3JIcj0woBeciNthIExcMV0YcOejFzWV2BPHfY5hA
X-Received: by 2002:a17:906:94d3:: with SMTP id d19mr26260995ejy.298.1566305758183;
        Tue, 20 Aug 2019 05:55:58 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id p15sm84519ejb.24.2019.08.20.05.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 05:55:58 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i03g5-0002EB-Sn; Tue, 20 Aug 2019 12:55:57 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 5ADFE2742ABD; Tue, 20 Aug 2019 13:55:57 +0100 (BST)
Date:   Tue, 20 Aug 2019 13:55:57 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to
 the transfer structure
Message-ID: <20190820125557.GB4738@sirena.co.uk>
References: <20190816004449.10100-1-olteanv@gmail.com>
 <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk>
 <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
 <20190816125820.GF4039@sirena.co.uk>
 <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
X-Cookie: It's the thought, if any, that counts!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2019 at 05:05:53PM +0300, Vladimir Oltean wrote:

> I'm not sure how to respond to this, because I don't know anything
> about the timing of DMA transfers.
> Maybe snapshotting DMA transfers the same way is not possible (if at
> all). Maybe they are not exactly adequate for this sort of application
> anyway. Maybe it depends.

DMA transfers generally proceed without any involvement from the CPU,
this is broadly the point of DMA.  You *may* be able to split into
multiple transactions but it's not reliable that you'd be able to do so
on byte boundaries and there will be latency getting notified of
completions.

> In other words, from a purely performance perspective, I am against
> limiting the API to just snapshotting the first and last byte. At this
> level of "zoom", if I change the offset of the byte to anything other
> than 3, the synchronization offset refuses to converge towards zero,
> because the snapshot is incurring a constant offset that the servo
> loop from userspace (phc2sys) can't compensate for.

> Maybe the SPI master driver should just report what sort of
> snapshotting capability it can offer, ranging from none (default
> unless otherwise specified), to transfer-level (DMA style) or
> byte-level.

That does then have the consequence that the majority of controllers
aren't going to be usable with the API which isn't great.

> I'm afraid more actual experimentation is needed with DMA-based
> controllers to understand what can be expected from them, and as a
> result, how the API should map around them.
> MDIO bus controllers are in a similar situation (with Hubert's patch)
> but at least there the frame size is fixed and I haven't heard of an
> MDIO controller to use DMA.

I'm not 100% clear what the problem you're trying to solve is, or if
it's a sensible problem to try to solve for that matter.

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1b7dwACgkQJNaLcl1U
h9Dwjwf/dbqcU17zGra+YlgRKo6DqR3lr7Zs78XeUA8t53b61L28+ZuDRE1j6wYZ
9OR/cjPU20FZ5KSjqpHsGbGvvJh6M0/v5az8EBm0e3vpglKcTRNGJ5dsZHLbOyPb
uEhweMwaanElatxIvhQJvnL6aicGZhl4CQeWqLglAfxvmnfxDzAluYoalAMBk5+c
pjUunBGPtX3bIDuSS/TGeoAtP1+wu/pNS8Nr6+rJ6IIclLlxrm9m3UqxxU8Gg48o
Wxlm31t+Byb5sp8BgweEStjxUzKgwFr4yrgVXCP/mPNpdUv6ViqAq5usdN0SlNsS
ph2TXu+C7V/RLrSsXeCjjbK+STc2Xg==
=wLY1
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
