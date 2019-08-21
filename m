Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43425977AC
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 13:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfHULBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 07:01:32 -0400
Received: from mail-wm1-f98.google.com ([209.85.128.98]:38608 "EHLO
        mail-wm1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfHULBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 07:01:30 -0400
Received: by mail-wm1-f98.google.com with SMTP id m125so1671037wmm.3
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 04:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ygOE0XdOdPWdstYRZ3mjLhH9fBMjYel5iFCk21VzP3c=;
        b=GsOHz28hTmBzciUR7SY0gERzEb+gJWN6RNtSTqelKL9l2ZXf6qRhso2HOMoYjBgQIu
         UY6H8zoXmE98foc+QhIsrDE1XoJQkW/F8Ql0sfF9d2bp4+jLGd+MkEP4F9tZ+HamnM00
         gGIRe29EVBj50McdTxjL/vOT17kEX3CiaEj608I2MTy9yMrenSkjrX9dfvpt+XjZprTE
         A/tltUWaw+6Gu8j3uJsSftMJMzzMtiNUs1j/cHYfKwwZ2mPasgIPXJe8SXe2qTO3aNr3
         R/BH09U7EFxusHo2kpMCk+oKAmFfM3F+Hk7MhgHgb3x+f7cD6yr75cRYGCb/vIGHSPzP
         0m8Q==
X-Gm-Message-State: APjAAAVqVoBbxgiIsF8sif2Rcq7KYJKDHJCDptro6nkul6OvlOXNQql1
        AIUDJ9swq7hQk2UoCT52XzIDsvXVuo0H5wo8LicCxlEZhfXcV3p1+m5/LlHNVWurjw==
X-Google-Smtp-Source: APXvYqwYVxdvH4uezkptjrYtBRpT3usGjXm4T6embJuHsZUYhOxXgo1Pt+mCdewJHpSlqpKODkT6pVj0V7Wu
X-Received: by 2002:a7b:c8cb:: with SMTP id f11mr5457048wml.138.1566385288494;
        Wed, 21 Aug 2019 04:01:28 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id v11sm19820wmh.27.2019.08.21.04.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 04:01:28 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i0OMp-0006p2-V2; Wed, 21 Aug 2019 11:01:28 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id C9FC72742B66; Wed, 21 Aug 2019 12:01:26 +0100 (BST)
Date:   Wed, 21 Aug 2019 12:01:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 1/5] spi: Use an abbreviated pointer to
 ctlr->cur_msg in __spi_pump_messages
Message-ID: <20190821110126.GB5128@sirena.co.uk>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <20190818182600.3047-2-olteanv@gmail.com>
 <20190820182128.GH4738@sirena.co.uk>
 <CA+h21hpgi7-dJ-QoRBEQorcRyEuhqhKixpFK5fGxOnZxTHi-4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <CA+h21hpgi7-dJ-QoRBEQorcRyEuhqhKixpFK5fGxOnZxTHi-4g@mail.gmail.com>
X-Cookie: Sic transit gloria Monday!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2019 at 10:36:43PM +0300, Vladimir Oltean wrote:
> On Tue, 20 Aug 2019 at 21:21, Mark Brown <broonie@kernel.org> wrote:

> > On Sun, Aug 18, 2019 at 09:25:56PM +0300, Vladimir Oltean wrote:

> > >       /* Extract head of queue */
> > > -     ctlr->cur_msg =
> > > -             list_first_entry(&ctlr->queue, struct spi_message, queue);
> > > +     mesg = list_first_entry(&ctlr->queue, struct spi_message, queue);
> > > +     ctlr->cur_msg = mesg;

> > Why mesg when the existing code uses msg as an abbreviation here?

> Does it matter? I took from spi_finalize_current_message which also uses mesg.

It's particularly visible when it's on the same line, flags up a
question about if things are the same.  Other things not being great
doesn't preclude making this one better.

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1dJIUACgkQJNaLcl1U
h9CzMQf9HnNPDySLqccfz5BLBVZCLMOkkVcR47jnut4j/UXE9Cl0GtNlVZGOkncP
fasOSOPlkY5bjdlscjCnI/cfWyioihIVgad/3oz6yLbjjPoVShvFkYtcDnI1pF+h
9qiT8FoZH/5fSZcMSfBsVYo0pYqAwVFxAnOLhVKlx+1Hs00Z5+VqD8Hkxx8Utwju
hfUtJ5+qWzSb9FeP8shiHTqrvEjd0BCDrx1+cEpbkXPLaGtB5wrOpCba28MUxXLn
8I4KA9kmCTDHI6dEE5FbgVcaf1o3lcunvZiwWXi8xhKht0jaCsTg/3JckTOWlNPk
ScvVb5mG5SMzHea76Z89qyYb47zccw==
=Z8rS
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
