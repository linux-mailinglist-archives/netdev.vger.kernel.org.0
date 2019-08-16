Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD690217
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfHPM6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:58:24 -0400
Received: from mail-wr1-f98.google.com ([209.85.221.98]:33065 "EHLO
        mail-wr1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfHPM6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:58:24 -0400
Received: by mail-wr1-f98.google.com with SMTP id u16so1479493wrr.0
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 05:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HlS4UGc8ifg0r4V8UX0rHHGS4vipLca5lHcFg5MoY3k=;
        b=FAsWes8KAWdusU7DAFh738urCzHa/li3YLpQmdpDJ3+oP8jQZFO606o7IxfpE0wPNN
         0xGjUi0V2j4WTwgcyeokCssxyy1V+uVBb/aEk+ZUKi7ZdepSWWFT3Bg7B5zRQXsV/qiw
         BslRH9owz/fZ+rc+EmwpRBvsid19PHHUo/duGwOwJdXa2lsTXxFLzwhH3PztFH+ie1EN
         FdIwDy6wcHFlVvRYbJFcukAlruql2Yg3Y7wouTkVNqUJLGOw5Tk9uCsAa115FjnpOYG/
         Devzm/yXazs5GOSZFD+NqGcyCIX+j3PycZYh8SpTtUYlPoLDo+2t6Qom0Trw8BqIHtP7
         oH9Q==
X-Gm-Message-State: APjAAAUfETcrbYWvZAw0xdhiNqJzCa9aT2/EHuOj7v77OEccvgL3qNse
        bIHes9jdjFzNQC7ZnITqTd8sTJbXTKcC+JgUWZqRhMpY6PdGxFRGEi5tM3IqvDdXng==
X-Google-Smtp-Source: APXvYqyXzO3EXKWFiHTcXkxcDRB0KCJuNFlcZvhEsCNgpjEZsSUYVb9BRiKcHkHKXwklyRYHPgAtOzNnviGp
X-Received: by 2002:adf:9050:: with SMTP id h74mr10740125wrh.191.1565960301929;
        Fri, 16 Aug 2019 05:58:21 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id h7sm94504wrv.45.2019.08.16.05.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 05:58:21 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1hyboD-0003zu-DS; Fri, 16 Aug 2019 12:58:21 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 6F9EA27430D6; Fri, 16 Aug 2019 13:58:20 +0100 (BST)
Date:   Fri, 16 Aug 2019 13:58:20 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to
 the transfer structure
Message-ID: <20190816125820.GF4039@sirena.co.uk>
References: <20190816004449.10100-1-olteanv@gmail.com>
 <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk>
 <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TU+u6i6jrDPzmlWF"
Content-Disposition: inline
In-Reply-To: <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
X-Cookie: My life is a patio of fun!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TU+u6i6jrDPzmlWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 16, 2019 at 03:35:30PM +0300, Vladimir Oltean wrote:
> On Fri, 16 Aug 2019 at 15:18, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Aug 16, 2019 at 03:44:41AM +0300, Vladimir Oltean wrote:

> > > @@ -842,6 +843,9 @@ struct spi_transfer {
> > >
> > >       u32             effective_speed_hz;
> > >
> > > +     struct ptp_system_timestamp *ptp_sts;
> > > +     unsigned int    ptp_sts_word_offset;
> > > +

> > You've not documented these fields at all so it's not clear what the
> > intended usage is.

> Thanks for looking into this.
> Indeed I didn't document them as the patch is part of a RFC and I
> thought the purpose was more clear from the context (cover letter
> etc).
> If I do ever send a patchset for submission I will document the newly
> introduced fields properly.

The issue I'm having is that I have zero idea about the PTP API so I've
got nothing to go on when thinking about if this approach makes any
sense unless I go do some research.

> So let me clarify:
> The SPI slave device driver is populating these fields to indicate to
> the controller driver that it wants word number @ptp_sts_word_offset
> from the tx buffer snapshotted. The controller driver is supposed to
> put the snapshot into the @ptp_sts field, which is a pointer to a
> memory location under the control of the SPI slave device driver.

Snapshot here basically meaning recording a timestamp?  This interface
does seem like it basically precludes DMA based controllers from using
it unless someone happened to implement some very specific stuff in
hardware which seems implausible.  I'd be inclined to just require that
users can only snapshot the first (and possibly also the last, though
DMA completions make that fun) word of a transfer, we could then pull
this out into the core a bit by providing a wrapper function drivers
should call at the appropriate moment.

> It is ok if the ptp_sts pointer is NULL (no need to check), because
> the API for taking snapshots already checks for that.
> At the moment there is yet no proposed mechanism for the SPI slave
> driver to ensure that the controller will really act upon this
> request. That would be really nice to have, since some SPI slave
> devices are time-sensitive and warning early is a good way to prevent
> unnecessary troubleshooting.

Yes, that's one of the things I was thinking about looking at the series
- we should at least be able to warn if we can't timestamp so nobody
gets confused, possibly error out if the calling code particularly
depends on it.

--TU+u6i6jrDPzmlWF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1WqGsACgkQJNaLcl1U
h9CGoAf/UIB6zifv+qd++v5V+GB33nvGyd/uZvEunEr1laYQfXDcZwBlGWdiIYHU
NrjjdvRpmKjIkj0VcTnSnY2PQRRsWuiz4qnjRchLbe2cKJLQGNp+GNH3HvdhTyqv
mXNmKeO1LXOhxViuiSeqW5XxvKH2gT6dngXb5hKbCsTYwSWB73CTJ2GyrzXJBDPU
+rKLUlFhDb0lziPkKV584IuE2ArCyxVwGwwjE2bOKqprMOknLBDiLwr811/dYDg7
4InYjtkrDfccr58d+INSrQJTXpyVxuKtD9vkNiSzXeqS7msp1wiVafPwIf31WspT
x7pIGwR6FyKgrZCqPTC/lev3JawcPw==
=fXS5
-----END PGP SIGNATURE-----

--TU+u6i6jrDPzmlWF--
