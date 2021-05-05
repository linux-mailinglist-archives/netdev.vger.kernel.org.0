Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1443736AB
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhEEJAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhEEJAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:00:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06BCC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 01:59:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x188so1510301pfd.7
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 01:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gY4F/r0AdwO28c3xYtDSW8z1XYoPCg+2V0qeMXB9ExQ=;
        b=Xwbe2kRTOxPQNTDKsNPzdcYNUm0MHvBg9BidS+oOeXFe1HW1ge/0U/0OU4SWDmSXH2
         2z2EclXZydwFYFlTpB/dC50V8WaSgwjRglzyRR3WF978/N6yscxV+bwFuCYGm++k/k1r
         o6Su7Ru8cZPIBci9VYeSEGfAx2RzLjMTbCwS9jL8AjX8rLFjZZS2vmtATlmJluHCASkw
         VENabznQvid85s9G8HWpcOD0xRJ15IQjKgCkYGZSWAlMXy9lgb4bxbOiAsxhawF8X6Lk
         jlbUnAAg8tVdqSjyUpdsiNUbBUjB+n/5qrdAn3Ez2CJNf/FOMF5WCyyAoaGrat1nTh7V
         qavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gY4F/r0AdwO28c3xYtDSW8z1XYoPCg+2V0qeMXB9ExQ=;
        b=QfHgXTrbsCaMn78E/d+wNNFdHfBWwKt3sVCcvCtUnZY910b3JAE61avS6qq6icRESq
         /WI4cYmETcXXONgb8o4+U/0ydkmcJgg43xzu+kGwYMSuRD//H/5SQp5d+AYq/9L7JW9j
         C93IZVVz3+nlMkRROK+kTQEzSxfnxMMujadVvZi5uLImcwhUTj1h72R98KeGi2WkAlN6
         EPuftSpdrOpdUo7A2SyJLyjmqIY7UWqHRXNQrmZShJAr3kr5Py4xY2IFj7Y0AN2vyswH
         pd+Xskz9f+p4MnwQI8mhrP4wM4qPlPRy74TPgQjO1S7JdLM4H2evfqJ+89xELXooufV8
         HpKQ==
X-Gm-Message-State: AOAM532U83+cnMvJq2f57RYXjRg1oxOfOvsO/xBR8OSG6m586zb80ncJ
        tDohg/FaqYDuKCSV+wzQwfY=
X-Google-Smtp-Source: ABdhPJynJ1dGj2fbTjIk0JqMDUn02YfkkpFT8KaDmNGjv+rMWeor46GgSgD983Kb4Y5xDKaD5vJaPw==
X-Received: by 2002:a05:6a00:a86:b029:203:6bc9:3f14 with SMTP id b6-20020a056a000a86b02902036bc93f14mr28164699pfl.22.1620205192108;
        Wed, 05 May 2021 01:59:52 -0700 (PDT)
Received: from f3 ([2405:6580:97e0:3100:72f0:fef2:7302:7def])
        by smtp.gmail.com with ESMTPSA id g29sm15360285pfq.148.2021.05.05.01.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 01:59:50 -0700 (PDT)
Date:   Wed, 5 May 2021 17:59:46 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <YJJegiK9mMvAEQwU@f3>
References: <20210504131421.mijffwcruql2fupn@Rk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F0Jzq68Ii7tXulWL"
Content-Disposition: inline
In-Reply-To: <20210504131421.mijffwcruql2fupn@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--F0Jzq68Ii7tXulWL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-05-04 21:14 +0800, Coiby Xu wrote:
> Hi Benjamin,
>=20
> As you have known, I'm working on improving drivers/staging/qlge. I'm
> not sure if I correctly understand some TODO items. Since you wrote the T=
ODO
> list, could you explain some of the items or comment on the
> corresponding fix for me?
>=20
> > * while in that area, using two 8k buffers to store one 9k frame is a p=
oor
> >   choice of buffer size.
>=20
> Currently, LARGE_BUFFER_MAX_SIZE is defined as 8192. How about we simply
> changing LARGE_BUFFER_MAX_SIZE to 4096? This is what
> drivers/net/ethernet/intel/e1000 does for jumbo frame right now.

I think that frags of 4096 would be better for allocations than the
current scheme. However, I don't know if simply changing that define is
the only thing to do.

BTW, e1000 was written long ago and not updated much, so it's not the
reference I would look at generally. Sadly I don't do much kernel
development anymore so I don't know which one to recommend either :/ If
I had to guess, I'd say ixgbe is a device of a similar vintage whose
driver has seen a lot better work.

>=20
> > * in the "chain of large buffers" case, the driver uses an skb allocate=
d with
> >   head room but only puts data in the frags.
>=20
> Do you suggest implementing the copybreak feature which exists for e1000 =
for
> this driver, i.e., allocing a sk_buff and coping the header buffer into i=
t?

No. From the "chain of large buffers" quote, I think I was referring to:

\ qlge_refill_sb
	skb =3D __netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE, gfp);

\ qlge_build_rx_skb
		[...]
		/*
		 * The data is in a chain of large buffers
		[...]
			skb_fill_page_desc(skb, i,
					   lbq_desc->p.pg_chunk.page,
					   lbq_desc->p.pg_chunk.offset, size);
		[...]
		__pskb_pull_tail(skb, hlen);

So out of SMALL_BUFFER_SIZE, only hlen is used. Since SMALL_BUFFER_SIZE
is only 256, I'm not sure now if this really has any impact. In fact it
seems in line with ex. what ixgbe does (IXGBE_RX_HDR_SIZE).

However, in the same area, there is also
			skb =3D netdev_alloc_skb(qdev->ndev, length);
			[...]
			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
					   lbq_desc->p.pg_chunk.offset,
					   length);

Why is the skb allocated with "length" size? Something like
	skb =3D napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
would be better I think. The head only needs enough space for the
subsequent hlen pull.

BTW, it looks like commit f8c047be5401 ("staging: qlge: use qlge_*
prefix to avoid namespace clashes with other qlogic drivers") missed
some structures like struct rx_ring. Defines like SMALL_BUFFER_SIZE
should also have a prefix.

>=20
> > * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls=
 in
> >   qlge_set_multicast_list()).
>=20
> This issue of weird line wrapping is supposed to be all over. But I can
> only find the ql_set_routing_reg() calls in qlge_set_multicast_list have
> this problem,
>=20
> 			if (qlge_set_routing_reg
> 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
>=20
> I can't find other places where functions calls put square and arguments
> in the new line. Could you give more hints?

Here are other examples of what I would call weird line wrapping:

	status =3D qlge_validate_flash(qdev,
				     sizeof(struct flash_params_8000) /
				   sizeof(u16),
				   "8000");

	status =3D qlge_wait_reg_rdy(qdev,
				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);

[...]

I put that item towards the end of the TODO list because I think the
misshapen formatting and the ridiculous overuse of () in expressions
serve a useful purpose. They clearly point to the code that hasn't yet
been rewritten; they make it easy to know what code to audit. Because of
that, I strongly think it would be better to tackle the TODO list
(roughly) in order.

--F0Jzq68Ii7tXulWL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEkvpDtefvZykbqQVOaJBbS33YWS0FAmCSXoIACgkQaJBbS33Y
WS031w/+MRfhCowqa/U5DcH5RwPMSfkCSw53RLYIDtHN83ul7JQbz6eUckBmvV0Z
MUMAc78ea/KD9Fps5n9ZjIwjHdmplpkV4I811VKWW6lcFJUTrbCtwwrxRI3hl31v
yRsfX4A2jV7TQrqdGV+Nt29wuaaGB69q77rEooVwf8fjBvXIpUobvb9abON0bkig
Q/W6qFijExDww5yVIymVv+p8++swlG/QALUZxep3xX2n/oaVDxv/lKlsr2jpV2d9
ui71KTt1CG2zVONv35hr7yeR/lS2+mlWOE8UZFEXTw9OOWmt7tBJdez265omuog8
mS4qmqBI7AFcAGzvaNyPxR84/uFY4Bql+u9or36DQ3SBSCxQn3/BHklBYY8ITbC8
vTLRtabuIFwBlD20m2YEyKKzTBMvDgq9/eVGQcwxFYNEQb7Ux5BQXBXksNQpJMTI
k5aN88oott1M9eLZnTLe4Uz5Wt54bacmqqwkiiEs+hF4HzVRQlCv4CdxCpt3FANd
YyRDlNuNp0Pfw1koveDMQR2luMV38GqCuCjUQnVS+/88FmUMdOMUKYrCNu1U5D2Z
LnsUAri98yJ2zfm1Jdhpqb6yM2V0K/ZRxgxclxjPi9Cu9/QLIaM34JrOdyHsPAhv
YsydUgNgZ5vHwT0hpuM3VmeOdNQKm4LIgxk2NhVnX+DomB9HzzQ=
=FCdF
-----END PGP SIGNATURE-----

--F0Jzq68Ii7tXulWL--
