Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324EC70A7C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfGVUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:16:19 -0400
Received: from kadath.azazel.net ([81.187.231.250]:47160 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfGVUQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 16:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EyQe/t4zI+t1EzJC8edqAEOvtLVfQxxb9PHJyftE20A=; b=bvmFoHdBDCTQGzV4Jvpm+UjqiW
        msnbnQAu5l05rkgfuM+Hbsw+KA6oX37fN73wMK4T86iOq8vntvFCvsENHVZn0fY3fDKwDo1gzyQG4
        9kEDLNmMrOYAhbs2CID/wVHWRyqzhSURwpgfP74/CvTQFEhDDV3IfxWRxd8rFlkKOO3RdNGemm307
        kIJx2e7UMudvdqvdplptWsiXw96nUyWkqtkUH/EpirgaMEnAJyPPkVJG4DGMtIYU+IFDHVen/21lP
        rZwsZODHTZHsNB/vuYE5STyRbq9K9qR/RExpR73vHl8/gU2WDQb6ZK9AxBZAqc5jlSHMeho++g82G
        rCpK6P3w==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hpejI-0007av-Ux; Mon, 22 Jul 2019 21:16:17 +0100
Date:   Mon, 22 Jul 2019 21:16:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net] kbuild: add net/netfilter/nf_tables_offload.h to
 header-test blacklist.
Message-ID: <20190722201615.GE23346@azazel.net>
References: <20190719100743.2ea14575@cakuba.netronome.com>
 <20190721113105.19301-1-jeremy@azazel.net>
 <20190721182608.mmn2p6jyazqmmvix@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <20190721182608.mmn2p6jyazqmmvix@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-21, at 20:26:08 +0200, Pablo Neira Ayuso wrote:
> On Sun, Jul 21, 2019 at 12:31:05PM +0100, Jeremy Sowden wrote:
> > net/netfilter/nf_tables_offload.h includes net/netfilter/nf_tables.h
> > which is itself on the blacklist.
> >
> > Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
> Thanks, I think it would be good later on to review all of the
> netfilter headers and make them compile via this new
> CONFIG_HEADER_TEST Kconfig knob.

Definitely.  The problem in this instance is that linux/netfilter.h
wraps some struct definitions and inline functions in "#ifdef
CONFIG_NETFILTER" / "#endif", but some of these are required by code
defined in other header-files that are not so wrapped, so when
CONFIG_NETFILTER is not defined, compilation of those header-files
fails.  I only took a cursory glance over the week-end and stopped once
I found the blacklist.  I'll take a more thorough look when I have some
time, hopefully later this week.

J.

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl02GXQACgkQ0Z7UzfnX
9sMFVBAAv+j0X/Q/ZxOMV6u2bmRgiRWlMu+a2K8U9IOjzmENRIp/oqAJaDL75jmN
BBCrIWWWPvLB1cB9GeWo7ap5YKJumeOrewPj+qpdlvlk3eQknJ+7uPm1dEi8Oj/T
lZxSH184fLJN6RxV4S4M6jIz7rwmzyn3adtfX8gizHyDxI7GLbPUnAuwilh9YLGg
qrdvRT0XdxfnOuVvmA8MRzv6S8yNmefcoQr/WhgykBDxxod5AguZcTsA4z+fNXoN
8e5ht3bA/gpPgcefXeykrBApy57Tj7M9vN5CzjGZPcEGGS3F+PJL60oXsLz8morR
U4+MkDwtArDYcEn9xrVooB0Tt9swS3xjWuDtcqFj7Ya5239nRK2BYjuZzJA2nkvR
9OM2XtzM+bphwtUY+I7EbdMvarLUXxvLYYXRJAIqDMiUT8o50hekHGTrh55KSNej
DUBPAeu7xcXfJKbJEnMSlapL5nDKu37xiBb6LPrKW96g9exZsre9jKNMQdq5gSiO
caKKY/twBcUNPA67tOA3vf9KtN+pskTdaM0ms7La5EAzj6R3w4SFPF5zFPsAVrfP
cV60ADOMSoKB/y9wLNAsDvYcYr+DHh1jxVgeJDeg2dLMcQrST2Diz0gYPs/u2egM
LmqqLapUtkkReigj768IFd9zflZpP+HlGSC8s5nVlqvteA00Cso=
=thgM
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
