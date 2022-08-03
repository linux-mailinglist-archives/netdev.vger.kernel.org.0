Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD943588AB2
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiHCKlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 06:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiHCKlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 06:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1521EC4A;
        Wed,  3 Aug 2022 03:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41BD8B82230;
        Wed,  3 Aug 2022 10:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F289C433D6;
        Wed,  3 Aug 2022 10:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659523279;
        bh=pZI1U0FPD8bdBXqWxXEXyQIrU/XYGuzEeKFaHUXpZVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNtcwmpooEAF5XSFoBUMlIUIg3AhNt9Zv383HegtlBczWGW6kz5BXkB/KDo5kT54h
         0WznEinybK8Ybw1DP5/KLbjfYaLrE0x8f6MfXx9TeMl5gaJQxfV1I1Qd9knR42ZFMO
         zD7CYcpRa3k/g09EeZgTj++z+JexSwdK+4ED2foWNc5Ja47iJARk6Kcpgcrs2QE70M
         pEdhl8tQX2G5f7vJV7iaarq13+xHjJgBSp5u3uumAbsvtIczzpE8o6R9N8GqI3LJwR
         Ppnk0dVyUKrdSFO+AEcXQEBQzeLqnZv6zybSUmfwaOin/ua2PgaIm9pK9Q4HhPXJKq
         QkpnXPuE9tb5A==
Date:   Wed, 3 Aug 2022 11:41:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <YupQy7O0CmONWJOd@sirena.org.uk>
References: <20220802151932.2830110-1-broonie@kernel.org>
 <CANn89iJ0pRrHQa+c4Rq3kC80zdjT86CAOecMKchURrRuNqMzMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qv598XczHblz5oqF"
Content-Disposition: inline
In-Reply-To: <CANn89iJ0pRrHQa+c4Rq3kC80zdjT86CAOecMKchURrRuNqMzMg@mail.gmail.com>
X-Cookie: Give him an evasive answer.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qv598XczHblz5oqF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 03, 2022 at 12:42:30AM -0700, Eric Dumazet wrote:
> On Tue, Aug 2, 2022 at 8:19 AM <broonie@kernel.org> wrote:

> >                         s->ax25_dev = NULL;
> >                         if (sk->sk_socket) {
> > -                               dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
> > +                               netdev_put(ax25_dev->dev,
> >  -                                         &ax25_dev->dev_tracker);

> This part seems wrong.

> Commit d7c4c9e075f8c only changed the two spots, one in ax25_release()
> and one in ax25_bind()

It is, I fixed it up later.

--qv598XczHblz5oqF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLqUMoACgkQJNaLcl1U
h9Bwwgf/TqOVG797V/gvWnDJGQk7byOYNghpu8I2/LyBSClinF2xw/TWBsnLWOyO
g7VDWyPVfiCZVUDziztzip3b36KdnI7EMmFPF+ZvCmFaU/vguph8o0d6jAXyucPL
znzaO6Nm0+FO8C/TiD5Fx43tD+JpjxGHgW3Xp4IyJ4o+1dT4kz+GVx8RbjfYRT/o
gHYqFB0nOvJ3M0FwbaJu64KNeP4Ch/MCB0XoEpbdd1j1wYJC9as4C8xpgj997rS+
UUCyF7Sma2aul4l2Nj0gTHK1wXeaiXfnzrcBKx7Aq8J8eL7OvjEDcH7Q83TQUSWz
YqdIK1IWAv77LXYH5qLGeacdGHwgWA==
=AJRT
-----END PGP SIGNATURE-----

--qv598XczHblz5oqF--
