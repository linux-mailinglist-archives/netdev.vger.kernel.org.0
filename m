Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4515A46FE28
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhLJJz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:55:27 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:54134 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbhLJJz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:55:26 -0500
X-Greylist: delayed 7328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2021 04:55:26 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1639129910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UoVnYVEhK6T2048vTXTUcC+ZvRTghvuGjwu5io1WJRo=;
        b=Y6tBSGEvHKL1TN3Q0I6CW2o5VHxZcp3fGTSI9tru49ke3w6HwkWfClCvRZxeFU+SVdr8ip
        UOKI0LdaYsSCcHWn9mLREvPize1JGJunAb5wv2m1qo2nV2HKZf+IfKNSP8/Zl0CUR2NAYs
        t6N3poffLYqTR2MC+fpgoB2lAaCO110=
From:   Sven Eckelmann <sven@narfation.org>
To:     cgel.zte@gmail.com
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCHv2] net/batman-adv:remove unneeded variable
Date:   Fri, 10 Dec 2021 10:51:44 +0100
Message-ID: <2776551.YYyxiJnSHr@ripper>
In-Reply-To: <20211210094206.426283-1-chi.minghao@zte.com.cn>
References: <2844186.8fJna1iEf4@ripper> <20211210094206.426283-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3204491.a8kA2qvuHL"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3204491.a8kA2qvuHL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: cgel.zte@gmail.com
Cc: a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch, netdev@vger.kernel.org, sw@simonwunderlich.de, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCHv2] net/batman-adv:remove unneeded variable
Date: Fri, 10 Dec 2021 10:51:44 +0100
Message-ID: <2776551.YYyxiJnSHr@ripper>
In-Reply-To: <20211210094206.426283-1-chi.minghao@zte.com.cn>
References: <2844186.8fJna1iEf4@ripper> <20211210094206.426283-1-chi.minghao@zte.com.cn>

On Friday, 10 December 2021 10:42:06 CET cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return status directly from function called.
> change since v1: zealci@zte.com.cm
>              v2: zealci@zte.com.cn
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---

This is wrong:

1. the patch was already applied
2. the patch history doesn't belong in the commit message
3. there is still an alignment problem
4. if you use -v in git-format-patch then it should be "PATCH v2" and not 
   "PATCHv2" (otherwise it will not be parsed correctly by patchwork)
5. The alignment problem is still there
6. the subject is also not following the normal formatting style

Kind regards,
	Sven
--nextPart3204491.a8kA2qvuHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmGzIzAACgkQXYcKB8Em
e0ZijRAAjT1ExR75ttZ02uaY/6uk/CoBLOSPAA+wkchdxBITNGmVRJhCUpVXZVYX
WfHK7wwg2xsteGyfqA9i/ohYHOMrKisNcUwkw0fxGxLQOKYQMwYTlZWdKEu7Q8kU
APu3HQ1Kd38It60FW9+nuy+8/JTq0YlTU8Th9YUiUBRr2YWGZAL3+vdKNeF3T9fx
IAUjEoJoEQwzznmiRW135R43iyu+/gNrj7JG1d4BCog/xmwO7nNDZD8qUHZh+qKt
UVZg1yPArL5m18ngg9A7RrV8ahb0beOsWjalotOD/jLB2C5kd5VKmEhd0FHEnm6V
YfKVXzjuaOu8CfS0tMjQJqbV2R0K8cNgJzhB3GlsCiAx79e+rPHja8yrpB1dbztz
oE/pOBkLbvwM/Qg7LCcFrocDVj7cE92cJQbxEU3516cT02zNZTBbUNUTLY9qPgK8
oqNel2UEgbYj3UicXINFPl2XbUdTyamI1TSywLven9PnDojg5hvgkq1aU7wVyIAs
dw2sIruF950Iv5K24IHsE4eXvtYd45KirFb6vhNqnzEiCtEaqLFf9BFqw/ecpgR4
FJA7y311KwsfoMumveAM3oFcff+35LFkoO6g+rentNRhFQWO0Xe+XUwd5oW9Lb78
jaO0qlOkssdh+pMai4cNENeU4mtdjFdtTJJy73D9iKDhBZG+ACA=
=9BtG
-----END PGP SIGNATURE-----

--nextPart3204491.a8kA2qvuHL--



