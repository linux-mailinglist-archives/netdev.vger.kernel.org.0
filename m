Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267CC312BA0
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBHIX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhBHIXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 03:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECA264E82;
        Mon,  8 Feb 2021 08:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612772577;
        bh=ph9JAjFeJbrpQKPR8Q/+d3QpBrrcWlLPt+ZVQtFtsXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcrrSWiKG3DFy554yXwJ7IzWSCXbG5MNvIU3RYMXvjzhznzZkok1/tXepUws8YfEH
         UrhzLH9OcjsJQNMGX4LsMn1dxsq2h46uvvFtpOEnOrJvx576Pvt4vesUeLxMvhWu3D
         eq4nzCz10iEHRz2/nq2z5rJEEPSUTRfruEk31xfr6Q/+iPUtqD2jSR2/TUSWbNAzFJ
         ziSszselmYqkf1Z0pIJOFwv06yPhzG0ms67NBETEigmhUrp2GqxXx+HhaxWMs2PUwK
         BSHAEYXy3i2hEbB0Q+F2Cu3lqoYBcYtz+Zs/MAIx8ZX8lKZAvGxkL2sHGItE97nH72
         rWMYifZJK8Xmg==
Date:   Mon, 8 Feb 2021 09:22:53 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-drivers-2021-02-05
Message-ID: <20210208082253.GA2593@lore-desk>
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
 <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210206194325.GA134674@lore-desk>
 <87r1ls5svl.fsf@codeaurora.org>
 <CAJ0CqmUkyKN_1MxSKejp90ONBtCTrsF1HUGRdh9+xNkdEjcwPg@mail.gmail.com>
 <87mtwf562q.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <87mtwf562q.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb 08, Kalle Valo wrote:
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>=20
> >> So what's the plan? Is there going to be a followup patch? And should
> >> that also go to v5.11 or can it wait v5.12?
> >>
> >> --
> >> https://patchwork.kernel.org/project/linux-wireless/list/
> >>
> >> https://wireless.wiki.kernel.org/en/developers/documentation/submittin=
gpatches
> >>
> >
> > Hi Kalle,
> >
> > I will post two followup patches later today. I think the issues are
> > not harmful but it will be easier to post them to wireless-drivers
> > tree, agree?
>=20
> Most likely Linus releases the final v5.11 next Sunday, so we are very
> close to release. If this is not urgent I would rather wait for the
> merge window to open (on Sunday) and apply the patch for v5.12 to avoid
> a last minute rush. Would that work?

Sure, I guess it is not urgent.

Regards,
Lorenzo

>=20
> --=20
> https://patchwork.kernel.org/project/linux-wireless/list/
>=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYCD02gAKCRA6cBh0uS2t
rE5XAQDDbpxo8vGNnOUSdJvBMkWNURV4RdXkYMQqdS2aOZI0tAEAgqmkGD+PNGQc
oLGkzWINS/2kuZuKLhqi0rEYTBUJkA4=
=avh9
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
