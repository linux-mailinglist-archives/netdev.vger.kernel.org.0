Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76E68B2AF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 00:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBEXJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 18:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBEXJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 18:09:07 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1062F17CF5;
        Sun,  5 Feb 2023 15:09:05 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P94p10kzhz4x1f;
        Mon,  6 Feb 2023 10:08:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675638543;
        bh=pNXUawnaU3qfDTxBKpmXsJPpQ4kMgE5LZAjUfYaVNaQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnYADCx5yiYMn3pkGOedm0t/sNMIjkMYLf/dBTxabGoodLOZTSPJETPuFDge/Cde4
         aIRPsac6jVpl6zYzM5s0sf9qZ8PH7w9zSC17MHdHR3/1Prai5iUUUHvsKOEj2nhHO3
         Cblnv6/K2AhBj4YkTU2WIyVtn11Iyu9muX3ILcAHxEldyx9xBhSO4GKxKXmaTccHeU
         yYw5esGxcNGOWPs8dnxojmNjd9fFKZA9h2nPmfY09YsEtc/xrY2g/H5zDiLVhBoJXQ
         OF2qL+X7Qm4pEDL2kEKjgtpjAAAz7yUq4t9yOAfwzn4aDqbJ6ZpjiHa3qtmhjT39nt
         0JnygHWxXhFVw==
Date:   Mon, 6 Feb 2023 10:08:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: remove arch/sh
Message-ID: <20230206100856.603a0f8f@canb.auug.org.au>
In-Reply-To: <20230203083037.GA30738@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
        <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
        <20230116071306.GA15848@lst.de>
        <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
        <20230203071423.GA24833@lst.de>
        <afd056a95d21944db1dc0c9708f692dd1f7bb757.camel@physik.fu-berlin.de>
        <20230203083037.GA30738@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9=gZIOzZKIZz.T3XwOWz_99";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9=gZIOzZKIZz.T3XwOWz_99
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 3 Feb 2023 09:30:37 +0100 Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Feb 03, 2023 at 09:24:46AM +0100, John Paul Adrian Glaubitz wrote:
> > Since this is my very first time stepping up as a kernel maintainer, I =
was hoping
> > to get some pointers on what to do to make this happen.
> >=20
> > So far, we have set up a new kernel tree and I have set up a local deve=
lopment and
> > test environment for SH kernels using my SH7785LCR board as the target =
platform.
> >=20
> > Do I just need to send a patch asking to change the corresponding entry=
 in the
> > MAINTAINERS file? =20
>=20
> I'm not sure a there is a document, but:
>=20
>  - add the MAINTAINERS change to your tree
>  - ask Stephen to get your tree included in linux-next

And by "Stephen", Christoph means me.  When you are ready, please send
me a request to include your tree/branch in linux-next (usually the
branch is called something like "for-next" or just "next") telling me
the git URL, and the contacts I should send email to if there are
conflicts/build issues with the branch.  I will then fetch the branch
every time I create a new linux-next release (most work days), so all
you need to do is update that branch each time you are ready to publish
more commits.

--=20
Cheers,
Stephen Rothwell

--Sig_/9=gZIOzZKIZz.T3XwOWz_99
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPgNwgACgkQAVBC80lX
0GzQVAgAjy+Ruo0rndMBlq3LUsn3e3WM6k7+dwjW7y5KrWBUtO9yrheMEypNr12O
byLw07yy1/H56vz7bZJN3IaFDMrx7kFxU2Rfi4K2lkrd5y7hRGFHFbyG9KACdTVo
d4yMastrzpa4sqz6druszU7GDQnWEFS8+bdy18sKOXOIF2A4/bCfyPcwbu6WcX9U
PWBzYOIqYThwk1BW+po7wuq+KMZW0337iVEob5zS9qRotE98YCs2zc5AjSg1XQx3
SWMIA+zrNKOlxUJ9BUoeDAQUoe6UJjekpz9o0j9q/w1DDNKl9mXQ5q+JvpuzrtGj
5u71j4opYj+PidkCy3HMoXj2z0tlFw==
=TRVa
-----END PGP SIGNATURE-----

--Sig_/9=gZIOzZKIZz.T3XwOWz_99--
