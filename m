Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6BA2EA562
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbhAEGUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 01:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbhAEGUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:20:38 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219FEC061574;
        Mon,  4 Jan 2021 22:19:58 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4D92Qx1twMz9sWT;
        Tue,  5 Jan 2021 17:19:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1609827594;
        bh=nDCX2HW9Z7M29EWUeQPgoiP8gTCsHWtWuXpbap0SK9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9IPCLaPV1y3i+yViI2X+WdKVSifdIEn8xES3D6e7W5UHDR/WllJNmEAjfQykuuoh
         guWDRDClDE3gWKfhXx1/La1bZBl4lUb/8O467sifYDOCjeRltmPUHyM24PeySk41B6
         nKDvloHSpQUsxt/nnNaJ/m+qzvyI1HXQfrX8e+/6gUzxmb0VDhChtumSbrzWX5HTIx
         gEPXQFKlv8FBi41nHRdPAF3CCPfG4lvrxryuP82o5od7up6WE2JsivDA7Y/Nn6ye6d
         rf4yIEmKBhm74B4TIGVjyJEx1wOlIAtgMlYu3WW7zlFzsl+oBFba+2H/VIA7In9y/P
         5+GZUrFTrgzXQ==
Date:   Tue, 5 Jan 2021 17:19:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Abhishek Kumar <kuabhs@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warnings after merge of the net-next tree
Message-ID: <20210105171951.0216f0f3@canb.auug.org.au>
In-Reply-To: <20201221122839.72d29127@canb.auug.org.au>
References: <20201214201025.60cee658@canb.auug.org.au>
        <20201221122839.72d29127@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5y73/z05TAB2IUywJlzhiGn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5y73/z05TAB2IUywJlzhiGn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 21 Dec 2020 12:28:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 14 Dec 2020 20:10:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the net-next tree, today's linux-next build (htmldocs)
> > produced these warnings:
> >=20
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg8=
0211_sar_chan_ranges - sar frequency ranges
> >  on line 1759 - I thought it was a doc line
> > include/net/cfg80211.h:5073: warning: Function parameter or member 'sar=
_capa' not described in 'wiphy'
> >=20
> > Introduced by commit
> >=20
> >   6bdb68cef7bf ("nl80211: add common API to configure SAR power limitat=
ions") =20
>=20
> I am now getting these warnings from Linus' tree.

I am still getting these warnings ...

--=20
Cheers,
Stephen Rothwell

--Sig_/5y73/z05TAB2IUywJlzhiGn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/0BQcACgkQAVBC80lX
0GxmvQf/eRQx/UG7oUz0cLzIPEX8ae8XnL/S2TLLoOXerz24VtzCXD97IbnELaeM
RY2PgLNXxSpvle9eH+i7JygaXnEwABsfwR3cMRAL4DJ2Nsua+aDkqhX4fHggTs6U
uNGFDrU1VFUCwmJ1oUUgKfVuyd1ea6ficp65OMkMjl2+DhdHiFH6+dau/rR897rW
POdpBDdD/k1RZVNLZG+jiAY2bFdb3Wjd71tX7ububqYkXLg4Ti7ALCEFTnhpaXTO
AKIUm1FqZiLRau/SaQyw0QIz+RJxdfboqmDAKNlpO5O2+sbB+kdMhbr6vX4C2Ssk
GS0e0Cc8H2QtsNuoXIoliXRfc1iEvQ==
=L2Du
-----END PGP SIGNATURE-----

--Sig_/5y73/z05TAB2IUywJlzhiGn--
