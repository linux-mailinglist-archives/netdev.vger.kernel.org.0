Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E173E2D2845
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgLHJ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:56:44 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:54640 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgLHJ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1607421360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NL9hsV0TeyX60QzTD/g2rg1p69Dgs1kBooBdA4Xh/Yk=;
        b=dMXe8xj7l66jvnfkKBMdbWmk+78WOIIIctBtLnvakPh4+J0IL+AQAmFq0g8TsMJQs3q58J
        HbCrHQnCMqsdbWiSob9frIwRB8edR+1btGVrz1xrw0c8AOtyXORhd45g36NuPbKqIjjAi9
        N19dSIPbQdGNpk50jXOK/KTvgHEFRdY=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-kernel@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        davem@davemloft.net
Cc:     kuba@kernel.org, mareklindner@neomailbox.ch, sw@simonwunderlich.de,
        a@unstable.cc, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date:   Tue, 08 Dec 2020 10:55:57 +0100
Message-ID: <1863144.usQuhbGJ8B@ripper>
In-Reply-To: <ca5c17a1-dea5-83eb-f9c5-a027b4135fec@metux.net>
References: <20201202124959.29209-1-info@metux.net> <4581108.GXAFRqVoOG@sven-edge> <ca5c17a1-dea5-83eb-f9c5-a027b4135fec@metux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3265343.QJadu78ljV"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3265343.QJadu78ljV
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: linux-kernel@vger.kernel.org, "Enrico Weigelt, metux IT consult" <info@metux.net>, davem@davemloft.net
Cc: kuba@kernel.org, mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, marcel@holtmann.org, johan.hedberg@gmail.com, roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com, ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org, Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date: Tue, 08 Dec 2020 10:55:57 +0100
Message-ID: <1863144.usQuhbGJ8B@ripper>
In-Reply-To: <ca5c17a1-dea5-83eb-f9c5-a027b4135fec@metux.net>
References: <20201202124959.29209-1-info@metux.net> <4581108.GXAFRqVoOG@sven-edge> <ca5c17a1-dea5-83eb-f9c5-a027b4135fec@metux.net>

On Tuesday, 8 December 2020 08:48:56 CET Enrico Weigelt, metux IT consult wrote:
> > Is there some explanation besides an opinion? Some kind goal which you want to 
> > achieve with it maybe?
> 
> Just a cleanup. I've been under the impression that this version is just
> an relic from oot times.

There are various entities which are loving to use the distro kernel and 
replace the batman-adv module with a backport from a newer kernel version. 
Similar to what is done in OpenWrt for the wifi drivers.

> > At least for us it was an easy way to query the release cycle information via 
> > batctl. Which made it easier for us to roughly figure out what an reporter/
> > inquirer was using - independent of whether he is using the in-kernel version 
> > or a backported version.
> 
> Is the OOT scenario still valid ?

Since the backport is OOT - yes, it is still valid.

Kind regards,
	Sven
--nextPart3265343.QJadu78ljV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl/PTa0ACgkQXYcKB8Em
e0ZQVg//a3Ctdu0iWSyVCI0o4XYb/8+K+uVZDxsGud3XPMdUr5JrAgXXJrege9Br
3y3yZMg9GMAHnf4i3TjgSddqRRKdAEB7swYD6OSXQr0MIHtF8TQpIAHGzi3llUx1
dilGLIb/8xxMGD5QgeCl8wx4L8CJj9jGF/6O8lGXUZV8PFrvDXfTzQ6NUHQ5U2Z4
xXYbqsf983ze1FLVwdVEmIOjXg2ncyGm1C3kQYPIehGXHYfPDwNSnWC91yxO3J/7
7b1JILU9Tiytc0yzTlWtYIpzg+OlY0+qHgYcV37I+OPqwpqygK4//Iqh0CzSpLjb
RQ6+/iEK09Xq2aTD1nWs7OOE5p3d5AcfiSVaaMpyBM09simkt+w4zExee+VPifkC
UavwdUusybvSNJix8U6Gd0QksUPJpG46KXT1vM6RLTlps3hvMWou4xD8pfC0IkgA
+8ce8Agpex2ZvqmsQ8RBR8pgO7IuC8hQqX+nVwHVud/kUZOZiqzaz3d6fxTpQM3B
/e+s/FsYu0G4Zmj9t3GHHrb4V4a77wLmAUJ9IH9yc5pwmkEU0rWINtR7gXs53qXR
CNFi5/8JMW+L3UXVdLqNTCKewD9no/RYigh3JvMiei8RKTbwVNNOXF5uaXs7kQum
eRu83EVqnKTPAd4M7plJ5+bQD4uu9Tjq31VH9o0LlcTZNbo/Xvc=
=XSUt
-----END PGP SIGNATURE-----

--nextPart3265343.QJadu78ljV--



