Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51B2F3515
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390204AbhALQKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:10:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732977AbhALQKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610467730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y6sZ4cxUNRk4fPFiMnVEXrm1dvmSU2hAiRoio1vVYTU=;
        b=TC88twoxlp32sNXcVHz0/coJF5r8iezmcM4RvI/Ho9LR6rNjwZwdpADY9yL7VACT6dO/1q
        zupIre+JYbl96PfuUdfqRbLD6p3zazr/ri59q8odH+2MEqNOsj9PKj5EelFqzb0Fi+gqyS
        Rcr6NpQySZFXmu/xPU6n9p9YzMdrJik=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-_4zv6_TdOZast91Q7OA8Bg-1; Tue, 12 Jan 2021 11:08:48 -0500
X-MC-Unique: _4zv6_TdOZast91Q7OA8Bg-1
Received: by mail-wr1-f71.google.com with SMTP id 88so1346079wrc.17
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y6sZ4cxUNRk4fPFiMnVEXrm1dvmSU2hAiRoio1vVYTU=;
        b=CDY4wWm/XScfXsnw66PEnAU1dFRkYGL84pyDwTXk3fkoxN3kPAcTs3sT3FpZkwvDR9
         uuk7g4H0wAfDMHvMchHfUSgeDsT6KAVXo0NMJXfsNGtdTBeyAtxl0kSS+W1NQ8W6lZ2g
         SmjTivM4CcI0kPgOtXJNPOS8L96bYy9biyldbFolMORf/MbYjzaoE+hwSh2Qpzl8fR4c
         eGdy83gzfExfFLtVY6TeT4g6rXD6qUrL93BojaAWGMsHmOVIxnKyX4PdXb7BJublXmRP
         LCaWSw2cttSodSq0MFQEj5Rp4VUmOqnU2scW5C/pV1LulVEINVs74NfAVsV9fZLrrRkM
         z2Sg==
X-Gm-Message-State: AOAM530RKBoCjwtURJ3EwQg6KaRZKjS8M7WYeKRJdKtXpLytN9ipWmsh
        A14O5YoqsDuLpKnwL8S9AQ5/jvgSZ8f/dL3OGTqi2oJzWyLu2W5V/ObGIIEItqmnztYl/pGd1p2
        8p91I/2Ranz0MfS12
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr22652wmb.112.1610467727238;
        Tue, 12 Jan 2021 08:08:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQnuo/64cyXR+hn5hkSXeHj8seVug91ac3zN5RDfXCqjV5E/EmalC6WVzTcXKV6L0CaoizHw==
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr22642wmb.112.1610467727086;
        Tue, 12 Jan 2021 08:08:47 -0800 (PST)
Received: from localhost ([151.66.42.92])
        by smtp.gmail.com with ESMTPSA id s133sm4625715wmf.38.2021.01.12.08.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 08:08:45 -0800 (PST)
Date:   Tue, 12 Jan 2021 17:08:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toshiaki.makita1@gmail.com
Subject: Re: [PATCH bpf-next 0/2] add xdp_build_skb_from_frame utility routine
Message-ID: <20210112160842.GC2555@lore-desk>
References: <cover.1608142960.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <cover.1608142960.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame routine=
s to
> build the skb from a xdp_frame. Respect to __xdp_build_skb_from_frame,
> xdp_build_skb_from_frame will allocate the skb object.
> Rely on __xdp_build_skb_from_frame/xdp_build_skb_from_frame in cpumap and=
 veth
> code.

Hi Daniel/Alexei,

since this series is marked as "archived" in patchwork, do I need to resubm=
it it?

Regards,
Lorenzo

>=20
> Lorenzo Bianconi (2):
>   net: xdp: introduce __xdp_build_skb_from_frame utility routine
>   net: xdp: introduce xdp_build_skb_from_frame utility routine
>=20
>  drivers/net/veth.c  | 18 +++-----------
>  include/net/xdp.h   |  5 ++++
>  kernel/bpf/cpumap.c | 45 +---------------------------------
>  net/core/xdp.c      | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 68 insertions(+), 59 deletions(-)
>=20
> --=20
> 2.29.2
>=20

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX/3JhwAKCRA6cBh0uS2t
rGYXAP0faiWViGGo03bFcPMrUOd1hFZOykCmszMKT38fk8LKLAEAlLJAtXZWuBOp
KRC4srGKp1SYGG9h13GGTGSEjFQkzAE=
=MTN8
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--

