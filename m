Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1BC85071
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbfHGP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 11:57:47 -0400
Received: from kadath.azazel.net ([81.187.231.250]:47336 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388845AbfHGP5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 11:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v5zVIloYXrAgjzSglM/vYJIXdGlyZQkKT85Lzw7jskk=; b=KK39k6djGX0PZNYj8lRq7rCIWa
        6sYT/EdCjjUXAkQTf+iMG6NLkopiXONA+PGpF6WwKo4rAz28ghhEis4nH8aise5TYz8XNDLwnXExX
        fCd3/dXMfjVLdRQzTRMiJHPrCNJZW6UAaUaJtj2WAz5RBN2Xo3uVRGGIf7Rdfu34f92DwSmQCFZ+b
        2PAAOD2KFEUU1nlXOGyFjke5whhqfV6NgtTWFDTvMGCUJL1+CVKM3YD3chrovrPnwhMnAJQliII+i
        +hVWTQGFwlaagh9GKVeqtw/DbbVfGNbVkNXgftVJkpiysGVGlhgfBVXMRYuMOQGTHZTcTxaf0o0YO
        2oukRRXQ==;
Received: from pnakotus.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:208:9bff:febe:32] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvOJm-00036d-D5; Wed, 07 Aug 2019 16:57:38 +0100
Date:   Wed, 7 Aug 2019 16:57:39 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: linux-next: Tree for Aug 7
 (net/bridge/netfilter/nf_conntrack_bridge.c)
Message-ID: <20190807155738.GA9394@azazel.net>
References: <20190807183606.372ca1a4@canb.auug.org.au>
 <f54391d9-6259-d08b-8b5f-c844093071d8@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <f54391d9-6259-d08b-8b5f-c844093071d8@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:208:9bff:febe:32
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-08-07, at 08:29:44 -0700, Randy Dunlap wrote:
> On 8/7/19 1:36 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20190806:
>
> on i386:
> when CONFIG_NF_TABLES is not set/enabled:
>
>   CC      net/bridge/netfilter/nf_conntrack_bridge.o
> In file included from
> ../net/bridge/netfilter/nf_conntrack_bridge.c:21:0:
> ../include/net/netfilter/nf_tables.h: In function
> =E2=80=98nft_gencursor_next=E2=80=99:
> ../include/net/netfilter/nf_tables.h:1224:14: error: =E2=80=98const struct
> net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return net->nft.gencursor + 1 =3D=3D 1 ? 1 : 0;
>               ^~~

I've just posted a series of fixes for netfilter header compilation
failures, and I think it includes the fix for that:

  https://lore.kernel.org/netdev/20190807141705.4864-5-jeremy@azazel.net/T/=
#u

J.

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1K9OYACgkQ0Z7UzfnX
9sMfsg//XRqj8xhFqboo6HARjrVj8WIdxbhTsv5BqjVA2tLdQfADQDY1TxLk6OPP
lSE8F09tdfs0Et7m6CcJzNq0+KSRDVs4ozz0CKUCX+GOKHZZKPGo2poT0cp6rC2Z
xboTw3Txvarvq6rYa59h0lcZN0vApZeSgfRIOBWCubanlcdiD2ypT+ktlNXHanzd
PhmXQytY1XAarTWFfXrcvx5xMuIVXe/eLhpC7SfyPRf5ITB8v6jNGBDvNvLwYeB7
o3QaKqCe/9ta2euYDBMtlgjXPZOWmT8mddlP5vnnN1KYgB0b2dabzxGUI/NEultQ
qFfZl/uI6LnNC+Ld4VdoPG2qlYolhd+yh8BqwhDUNyvhtsCFQ1gBxJK9YK2ZzzSh
J9RKoTOSP520S2eCFPXr+Tock0zM2vezW8adf9Uko3VcezfYPXs8QN7fbt920+7B
Di38eJbgOLe2tTHxPrPYVmN7YBQ1faG8gqIc8+og1ZMPVni+h4Q0SkL7mLXWWhxI
V9DcC+NKDz+8YbhNy6Yl5RriOUXzJ0UMYTwmpgN4jGTwjPMxSskPvr5k+iG/Q1aN
4cevcvKGwXo2cg1VOrCY9utNI0imA7S9R7HOfyq66K2aRUiw5JToVL27CqKY1xdy
3RWpW4DvQgI72sJsvo+JgzfnoonExfnD3K+yi/dEbV16hGI5ph0=
=b1Me
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
