Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328858B4F2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfHMKE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:04:27 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59318 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbfHMKE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N3X7S/TMjYcDlOn8m4BtFQhRuMuJtv8B6vGoa7omq0c=; b=uuY53V+WPTmRNEGtwJniRlY6sS
        aFNBkJkotkZ3gfPWxl8VU7Jdr704TlvfnOvRIov6l46dqJI7+TGVsnjnV255oxk0Ek1jKgEhqQnVE
        JUQc301KioPUISKTV7UWUiOe5vx+4DYwOEF67OsNclohjs91Us9RisksvULwbH2LD9BNeYz5MRLik
        bsaEm5/sH7/VcbrEnaCfG4APVMIMLbvtIwJMBGvfhioUj7M3sM5Y19g53CLi/2uyx4ulGNIRJhsNp
        ZrtD3hNHGDBNIU7op/9LcJIYaIrndagGE1/kOUvuNe3LH8k9I5li723X5Vymk8kUgwTUmjF/DCLeH
        OAA1+c5w==;
Received: from pnakotus.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:208:9bff:febe:32] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxTfE-0004Tk-Mp; Tue, 13 Aug 2019 11:04:24 +0100
Date:   Tue, 13 Aug 2019 11:04:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH net-next v1 0/8] netfilter: header compilation fixes
Message-ID: <20190813100424.GA4840@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
 <20190813095529.aisgjjwl6rzt5xeh@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20190813095529.aisgjjwl6rzt5xeh@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:208:9bff:febe:32
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-13, at 11:55:29 +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 07, 2019 at 03:16:57PM +0100, Jeremy Sowden wrote:
> > A number of netfilter header files are on the header-test blacklist
> > becuse they cannot be compiled stand-alone.   There are two main
> > reasons for this: missing inclusions of other headers, and missing
> > conditionals checking for CONFIG_* symbols.
> >
> > The first six of these patches rectify these omissions, the seventh
> > removes some unnecessary "#ifdef __KERNEL__" checks, and the last
> > removes all the NF headers from the blacklist.
> >
> > I've cc'ed Masahiro Yamada because the last patch removes 74 lines
> > from include/Kbuild and may conflict with his kbuild tree.
>
> Series applied, one comment below.
>
> > Jeremy Sowden (8):
> >   netfilter: inlined four headers files into another one.
> >   netfilter: added missing includes to a number of header-files.
> >   netfilter: added missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to
> >     header-file.
> >   netfilter: added missing IS_ENABLED(CONFIG_NF_TABLES) check to
> >     header-file.
> >   netfilter: added missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to
> >     some header-files.
> >   netfilter: added missing IS_ENABLED(CONFIG_NETFILTER) checks to some
> >     header-files.
> >   netfilter: removed "#ifdef __KERNEL__" guards from some headers.
> >   kbuild: removed all netfilter headers from header-test blacklist.
>
> Would you mind if - before pushing this out - I do this string
> replacement for the patch subject?
>
> s/added/add
> s/removed/remove
> s/inlined/inline
>
> I was told present tense is preferred for description. Otherwise, I'll
> leave them as is.

I adopted past tenses because at the point at which one is reading the
description of a commit, one is usually reading about old behaviour and
what has been done to change it.  However, I wasn't aware that there was
a preference and I am happy to switch to the present tense instead, so
by all means feel free to change them.

J.

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1SixwACgkQ0Z7UzfnX
9sOblg/+Iur3udlKhcIVICCrWhxjmexLhHBwanyk2T2TrYeoBIOKPH2PpRPZaro1
PwiRolswmOTKjCsIJg+BVo/+lfr1CzkOSiD71KKvDr6iHBlclJitinxpkn8xdG8e
jfzgnEB0GVFG/54D5XH3T1TLBQDXY+B/tfqwTiQsWyWgGlbJ6BB2qriJ89ACjNBw
/+PDNlLwfQbmH4jKWMeo0d6zb49+31kRI5R5/OhI8T757MMrZgx5fN3wnONrWgg+
vZTF/Soj9Elk9XjTW8izIf1Jm/T4cLT3MvbshLFBf8CJI+FF8OswSKDTX3tI0rZD
owMPzc1wciV4TeKGj+LQtOSeU3VEBVeUicJdNWcNQPoC4/GpjTfoq2KQgXxPneNZ
xPYZzDGLcSi/6IRekq9GEMwheqJ2nomGQTowAIoIXsVkKl4VtOx9vSgWwU1EIPED
QGCKI+BSRePzqGrN6tPv7IK5zfOVI6bycHK/nS19wFJBaAnhi9ZQK0+hEm88otL5
5YgcAOk1k77wO/FFOPDCd6qDmEkxivxBjCX+04mWxJu9NitsrIkOEzalK9X69Mj7
ifuqug2MQblfodVRLzMk5GL4Gtwrv3/b/FxOeo3k3q4zfBM4I3hoNCCn+VWTKWmi
OucURp4PiZhVMmUwLeRAXikba3ZsJTdljd635T1NkBo3z+OOHHE=
=l9bW
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
