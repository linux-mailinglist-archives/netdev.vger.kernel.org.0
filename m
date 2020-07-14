Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2648221F3EC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgGNOXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbgGNOXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E436C061755;
        Tue, 14 Jul 2020 07:23:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so7644512pgm.11;
        Tue, 14 Jul 2020 07:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=nUwXDB9+16lCViV2ieb7OxGP/wVfhQrqzyr+DjMiurg=;
        b=ERtMDsp5uK2mv9o92K1r3JhYGecnI/SKoRHHfjayrcNjsLKiVaQs7NZyiK2Q+10Sht
         3cK/do2rdzhgu4DUcMdkDErJj5h/+EXadf6SvI/e+sFF+aX9cuggjwjOcZhhbQ1sQrf9
         i8K1yc6lVGSBdXNBWA08Q7xG+9etQdusW77oOGZJvq8/uYza7GiTPmdar/C4O/xLxVKC
         0n/ljFtxx5rvyxo7vz2W1DPareso8MxUV5Ahkoveh14+rXzODE9HcnWTUUN+BJwc2uay
         pKf1gUVDa7onWxWQc37G2GIBIr2qzsPEUjquYd7Po464u5oqynCswcmGLx31KjEVJTbB
         KRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=nUwXDB9+16lCViV2ieb7OxGP/wVfhQrqzyr+DjMiurg=;
        b=J0C2vTCFp52TrtIoJeWbXBCgDLm28Md84WlN3BP3GxlRC5OoinNZbRu7KnkoZD0/JY
         kbsBYfEYZrMZ0rC9NFLVI3KJxEtfVhrpGrmAq6bfVmdO/6htf3pZ2TO+X7v3HPr1PguN
         yLogyjuERfP65qF9j6tGn45jPjUjeHI3aTJBOr6XxYs8xARmgo+vynQ/2qin+E3SU3OH
         rJBSalnJgzUZ+y9Mel8wYNai5sFah+KJM20rZCETNMjaK3HqpaR1OERoysjh+H0yDwRG
         6TkiF1ZD8JYkNcT2OrrbMpqB6ti21FgT5xokGnM5N06Xy/+r577+sFo2orYnEF6fRdx0
         o/zg==
X-Gm-Message-State: AOAM531OXmvA2EZ097dOIjGMVG0DvWaOoL5IKR/GHa3egPcl2CetWmOQ
        RXEitQtcFYqJsotPFR7PhcM=
X-Google-Smtp-Source: ABdhPJy66sR518CbHAyLwn4IDyvtCvNiLdLIxfxVc2XMIsw/eLRosLoQPV/oDLfKANqu2pgmoVCSSQ==
X-Received: by 2002:a65:484c:: with SMTP id i12mr3739341pgs.145.1594736622688;
        Tue, 14 Jul 2020 07:23:42 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id y19sm19009750pfc.135.2020.07.14.07.23.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 07:23:41 -0700 (PDT)
Date:   Tue, 14 Jul 2020 19:53:28 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] decnet: dn_dev: Remove an unnecessary label.
Message-ID: <20200714142328.GA4630@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Remove the unnecessary label from dn_dev_ioctl() and make its error
handling simpler to read.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
Changes:
	v2: Fixed indentation of break statement.
	On Julia's Advise.

 net/decnet/dn_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 65abcf1b3210..15d42353f1a3 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -462,7 +462,9 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
 	switch (cmd) {
 	case SIOCGIFADDR:
 		*((__le16 *)sdn->sdn_nodeaddr) =3D ifa->ifa_local;
-		goto rarok;
+		if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
+			ret =3D -EFAULT;
+		break;
=20
 	case SIOCSIFADDR:
 		if (!ifa) {
@@ -485,10 +487,6 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
 	rtnl_unlock();
=20
 	return ret;
-rarok:
-	if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
-		ret =3D -EFAULT;
-	goto done;
 }
=20
 struct net_device *dn_dev_get_default(void)
--=20
2.17.1


--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8Nv98ACgkQ+gRsbIfe
744SBw//XXzvT5FeU8+f+Jc8gBRa/b/jUV4iub7AShQVkpcgrPENNYxxGRFIJUe9
Po8iUt8TiYwo2MhrbbvzLYQ8TxbV9IVNRGqaZepbb0xcNi2Gnu5ni+Lvy/R7xAYT
rGQxpRw8o/I38zozphH5+nCqMVtNlHRV6VXvWTuqmm+gEuyEnr7PGidDwqcd/2S2
Dk53cBzq1EF99SrLtRJhTlXHQgZgZqPQvgjH3xbyY/hoix2oSHwZar3h+uHnnUSR
bd2bvT/1karQCphYX3ZH/r5l0nJECAteb2kCezmb6KVj+7OEVN8jGFNf2QMj6zPb
q20WePzjcGFnjjwml8SRhTq+LRMjox4NfNQ8LWk77tudYnxww+JLdvJFqeXemXmV
Ba30Sfvu/yXHFnirAIUzvt9+7ZKyIaFNjBdQE+qdaD+SRX8uRqX/XrMzxKNZuU7M
ADKBSKWRaKIRISbXdly2exmDC1gpMx3DJLzJs+WpxFpSAGW6+ct1PdnrMPzbCJYx
pE9MvnSH2yEbll9r/91hjhN/vJR+rsrUXzIFfgs00kpSOznN4nmaOXmz7843HYUF
ciRMSB+dvZpoKxzGkFRQ2gE6WCP1OCQUh+tCO19CH9mYnu/eVikH971xfo4g/koK
emUzUBF4WozXlwI2xlZLK4J3SRU3G639DHOAbVsewJzmmMNsLX8=
=Hjwo
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
