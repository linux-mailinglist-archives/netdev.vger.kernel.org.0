Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120C945A6F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfFNKbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:31:41 -0400
Received: from kadath.azazel.net ([81.187.231.250]:42652 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfFNKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FMJdQq+Ospa58PkHQIDNo7EmL0bNRV40xnbXTu76c0I=; b=RtDpFjPHCCDfmgpm3cbRwdg2VC
        JeduyMIa68WAoA/nfB4BEjj2B55vzACoKiEwAPj+liudPILZEHBTbP6lLtUVxj7ZEmmjZLM5f2mP1
        1mraXbtc53aSBnur3DwfyUVBIS9641oaDzJ3+UrR8VGAG72AmRS6OpIBtVLZBfLsCrS6VOzEpLkrp
        sMSQbD8GdWBF1wE+lUzmCDrLQZImbcSQwmpsVjx9AZDBbDZ5StWYr/dnFIb4+Q134OsaCUedgwb5z
        C5a4/Kt092i1QR/719mThD/VwIMiCv4Wp0DK/qiNAsmIs5m6EAzuYrhg4YuMsLvLQl7gbbr66V++D
        M7TwqHvA==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hbjUe-0007v1-Vv; Fri, 14 Jun 2019 11:31:37 +0100
Date:   Fri, 14 Jun 2019 11:31:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] af_key: Fix memory leak in key_notify_policy.
Message-ID: <20190614103135.lo4u25brtbrnalnm@azazel.net>
References: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
 <20190614085346.GN17989@gauss3.secunet.de>
 <20190614095922.k5yzeyew2zhrfp7e@azazel.net>
 <20190614101338.hia635sctr6qjmd2@azazel.net>
 <20190614101708.GP17989@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bgjwmnq2q5cnnrb3"
Content-Disposition: inline
In-Reply-To: <20190614101708.GP17989@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bgjwmnq2q5cnnrb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-06-14, at 12:17:08 +0200, Steffen Klassert wrote:
> On Fri, Jun 14, 2019 at 11:13:38AM +0100, Jeremy Sowden wrote:
> > That reminds me.  Stephen Rothwell reported a problem with the
> > "Fixes:" tag:
> >
> > On 2019-05-29, at 07:48:12 +1000, Stephen Rothwell wrote:
> > > In commit
> > >
> > >   7c80eb1c7e2b ("af_key: fix leaks in key_pol_get_resp and dump_sp.")
> > >
> > > Fixes tag
> > >
> > >   Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
> > >
> > > has these problem(s):
> > >
> > >   - Subject does not match target commit subject
> > >     Just use
> > > 	git log -1 --format='Fixes: %h ("%s")'
> >
> > What's the procedure for fixing this sort of thing?  Do you need me
> > to do anything?
>
> No, that patch is already commited. We can't change the commit message
> anymore. Just keep it in mind for next time.

Will do.  I've already made a note of that git-log invocation.  Useful
to know.

J.

--bgjwmnq2q5cnnrb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0Dd4cACgkQ0Z7UzfnX
9sPsgRAAvUGKQ8yy/cR34m0qES3ujJOUUaIABbVp6Rxng6z3fHLVsPE+tcPadJcJ
cOAo1udx4X3p0kuJWISjpL2eq8f1MWcSH+eKYKNY8/9V2n01GzFHD+e+s5bd0lZa
8/88jsJxz2wJMWmcmtlctt9TC9n5/wwGeRWD1hlu/B7hN0AwyvrQZ00QbFSH9C38
ecvZGQW16J3VavI2av8J1hMe+SiNjmCpauAD5fEwNhrVwlhfSZB5EUvITvX+QoKO
964wDas9QDf8suhYcLCLyratzdfoFlXQKo8/HQQqs/t22bTL6/C163jxSfSYEw3n
aoKJ1Vk0H2o4k547lf8D/fAAANJH+hzmzIUu/WaUL01KfGEuVwWFgTx57m/zVsUr
j/ttjAuyYvV8m3bRmxXCqERvyQ/SBkY8gHN/I4W95s+moHqueWCYJUpFcP/5r6A3
afbZVVd1c/WBy3kx66WEloDEG58uODa78Qo08tPM9zffCAMwaURqpfVkNtic6ksB
HRkWt86uvqd0qwraa4Cw8FQFQaxo067SYHMkHPN7iy+Jwz0Xj8ilSVEmNHzeclG9
RHXiM8i5X5/r4zHFBb5rv0+kgFy+O5hAGopsFu2YlXTJ69WGKZBw+wjH0q70dc0d
FAjr/w/V4j3esfDhUT3OvlrlTpiFPccbPZuLyaWDSFZc6nSwm5A=
=7+Wl
-----END PGP SIGNATURE-----

--bgjwmnq2q5cnnrb3--
