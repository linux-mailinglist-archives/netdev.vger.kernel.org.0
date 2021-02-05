Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD83107C4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBEJX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBEJVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:21:04 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB07C0613D6;
        Fri,  5 Feb 2021 01:20:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d2so3438389pjs.4;
        Fri, 05 Feb 2021 01:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U6dWRiyrIbPA57yDDAstPw73ZY/dCSiR50oKzjx/H6g=;
        b=HSa2DSSMZS+e+scFXZu0NDFNcryeuP7Aes44vX2eicn4LJOzoDW4pE4magZtPxVZum
         XduPEeGVtNA0SLvbcmAkktQYYSJ6iNy9AFFRm0DCGM0qtc7RXLY6tkBBeBM4tCX9LKmS
         3hu4orweIDyaCxc42NDaPbVyQ3TZoHRHGK/PnemFRGbOO2QdjVKjq2UF0BqC1BTYW+VC
         xmPE+jZXWH6vkGgG+6WjhjacANCagFitJH4M6DKRoBnHiWOrMSvj8Z42wS2v966HMwB4
         fGvfsTR1vLFZkD9D6t2AZ0YkBu60DoKza1WUOnBrT8IHQKjCAAOqtmhdrSv0jRo1dT38
         FGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U6dWRiyrIbPA57yDDAstPw73ZY/dCSiR50oKzjx/H6g=;
        b=tQ+4xpD72F7mLLOIWSGAfXrj3gqCG890yhNeGUMKSkhm0ds5qjO5wEgNCBIo3xGXiN
         A4Jt4klhk+OK+Z9FuYjqHSmwSuNx8AJ25p/XI3oh810LRh1C7CLF15aJ0eEBgmO0wCIW
         JpHaQ+UbVIdOj1L+ELlk94tV/2FUwnit+bQrWlrSnNS2DG0k/PuIS3mbTiJXFxgWu6sC
         VbZ2bWIPbRttyGmO/i0p9X4b++Z4RVC9ta4ElKlnkMPua3vrjQ7j+tkLZAFVHjgoiGPb
         MawQSu4VNfYfQ8YGcORZNLR1wk61JNTnJD4IWYgbgqHUpt2+CxY0DFhg8TG2UjcP5T+B
         5n1Q==
X-Gm-Message-State: AOAM531q2cUh9NxBmBnAqoh6YkKcJs0Z8h0PJ952+gBxDP8tugaQkWB2
        QX1ft5py+Qy6YXNuOIO+iUMsIbz+GeDMKQeTc7g=
X-Google-Smtp-Source: ABdhPJwG1sbba1GA71Z/ZsoLV0AXeXnT/scifzyZ8m25RVsPHbBrHLFRH2dadY60zQ8rJtTGlKMxsg==
X-Received: by 2002:a17:90a:ba87:: with SMTP id t7mr3163335pjr.184.1612516844327;
        Fri, 05 Feb 2021 01:20:44 -0800 (PST)
Received: from localhost ([103.200.106.135])
        by smtp.gmail.com with ESMTPSA id f15sm7768722pja.24.2021.02.05.01.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 01:20:43 -0800 (PST)
Date:   Fri, 5 Feb 2021 14:50:32 +0530
From:   Amey Narkhede <ameynarkhede02@gmail.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge/qlge_main: Use min_t instead of min
Message-ID: <20210205092032.3cyymzvkp5nkiok3@archlinux>
References: <20210204215451.69928-1-ameynarkhede02@gmail.com>
 <20210204225844.GA431671@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ueodtozohea73jpb"
Content-Disposition: inline
In-Reply-To: <20210204225844.GA431671@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ueodtozohea73jpb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 21/02/04 03:58PM, Nathan Chancellor wrote:
> On Fri, Feb 05, 2021 at 03:24:51AM +0530, ameynarkhede02@gmail.com wrote:
> > From: Amey Narkhede <ameynarkhede02@gmail.com>
> >
> > Use min_t instead of min function in qlge/qlge_main.c
> > Fixes following checkpatch.pl warning:
> > WARNING: min() should probably be min_t(int, MAX_CPUS, num_online_cpus())
> >
> > Signed-off-by: Amey Narkhede <ameynarkhede02@gmail.com>
> > ---
> >  drivers/staging/qlge/qlge_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index 402edaeff..29606d1eb 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -3938,7 +3938,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
> >  	int i;
> >  	struct rx_ring *rx_ring;
> >  	struct tx_ring *tx_ring;
> > -	int cpu_cnt = min(MAX_CPUS, (int)num_online_cpus());
> > +	int cpu_cnt = min_t(int, MAX_CPUS, (int)num_online_cpus());
>
> You should remove the cast on num_online_cpus() like checkpatch
> suggests. min_t adds the cast to int on both of the inputs for you.
>
Thanks. Fixed in v2

Amey

--ueodtozohea73jpb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE6H5dELF7r4AXEH5hLybaax94G/8FAmAdDeAACgkQLybaax94
G//LZQ//YzFyc1n4oGkSaJGiso13StX9yKhtHGF4+kH2iRzT6Et4/eJTZwnOCuzn
XBMT0agwZFIBVlupnHi92uz8YwCPbmKmcLrWZAlO61XW65ITRjcdpw2N4GF/yOc8
uAr74KvXLMmX9CKACUvaRGkVvu1eKuy6bFAMvbKxNUgwI1NvMJzLc2h+sD8dMk5p
xPIG0wte9VXvbD9U+bWDeBdhlXKoAR8LPv/NmOy1NEzQ2Y33AXkGHenOQEPHGjGP
MmeMj3lIiBH1Tohu+NJ7Yk3VqCc3d4Rtei/WueQ8EDsAvO1dzKRhhhnzR8Edty+N
xGTNgSIL28HYOaW+3noiWhTbJHghmQp+3Nt3fdADU2avcs4l+WigfIm1gtlH/azT
sar5v1rzmRSsJE+spCOuQ6YqXOguwspcpkQij/uEhy4+ASk1Xc/BhPVhFzycgtI/
etH2+wqN591qPA3hvNqyVYfAb8ySC4iLYRYtBfxolNBZrIrLBiBiC4y4Jr+sfIlX
dMAlEcFW9T5zjmZTO66Jtcz7Iz1ZI2HDzy0dVjUJCwVJVE0h9yq9NLShHg0KNhcH
s+qS+RVbz6xPpxWKZkCkp5aLrk29t2HtTjPCy2++bGL40OskoF4QXfD/AGPhGj0G
oFCdFONyUMkMMDnoYqp8RhpSUnhwKNy1MYqvbCz2fhZv0vXAitk=
=r0ZT
-----END PGP SIGNATURE-----

--ueodtozohea73jpb--
