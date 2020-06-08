Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9AE1F15F7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 11:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgFHJ5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 05:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbgFHJ5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 05:57:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010BCC08C5C3;
        Mon,  8 Jun 2020 02:57:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f185so15855628wmf.3;
        Mon, 08 Jun 2020 02:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ut3XaYVr0/pdTUeXNMqLLOtxnewlvYwLTTD1iBm+7XQ=;
        b=RdlctmTtfBbd8Uko+DYTxuhK1HAbvp3LGhsev90w5XdLn4pFR6m2lTBek1+49DwYdk
         VmL5CGX4YMjrmhpUY/1+uw8UpfPgX8eiMWhn2Xlz1mS0lEw6w05bjC1i9IBKsFrZP1LH
         UerrHxTT5ZilPw+4+FiDPQOWEbWRfwVIN1HBObUPF7eUVE/U0wVHR73pK1TWWAFtmLRv
         k3mwFrDKgtG+ZjPKZOlHaPSlXScavyU/xrJlJcIcE8RL9KfvqwfXbPyz13ezM8tfNQaj
         jlPIMXjUL+I1zT2WcMv9onrW4KpD5djfRWEFACtNrqvnkm8TRRLl2hDp6Bba/HgHa+Ju
         wirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ut3XaYVr0/pdTUeXNMqLLOtxnewlvYwLTTD1iBm+7XQ=;
        b=rz1rY6pOzgFS7SkpGVrRB0LadpDPBysUazLI4g4/jzA3EzOF58IibH7pnaMijeHIkQ
         ODNH8LZqw7yXm01xImymoMbRHnRPRtLt0pU/brK/5gRt5k4gdGvODN/Uyh8QXZoOIe2s
         cVHra/8ekZb6KdMm8MuAFR6l2Bg9c+uYwsztD4LZ1lmL5vtrlndc9WtgoDQ8gKS7qI0J
         R8A+e8i1IxNQton41t9TmnjTM1qCD7/A34SkerDTwZRlyVewMJHMhxNZi2rFH74nO67m
         0iVSBctfQUTHNLgTqbgYAFjKpvc5aIALC/rMJGEeyQ1QJgZt8qXvvcJIgVgZRrtkXfbd
         S1YA==
X-Gm-Message-State: AOAM530F+ggPIYG4ELoQdBVkJyShJmHWpDxO2qxysKDcawxsMKXNReOR
        HwdH7tYlD+Tq2/R+M2QB5FQ=
X-Google-Smtp-Source: ABdhPJxJZHspLs3/DHVKLx71a8WqmLy9gtnH+/lgVFgY/SGOtd7nkirOgTZxJcOMxzfUjQ7R8JH09w==
X-Received: by 2002:a7b:c385:: with SMTP id s5mr16591261wmj.121.1591610239597;
        Mon, 08 Jun 2020 02:57:19 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id d24sm21246990wmb.45.2020.06.08.02.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:57:18 -0700 (PDT)
Date:   Mon, 8 Jun 2020 10:57:16 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC v5 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200608095716.GE83191@stefanha-x1.localdomain>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-13-mst@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-13-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 10:11:49AM -0400, Michael S. Tsirkin wrote:
> A straight-forward conversion.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7eC3wACgkQnKSrs4Gr
c8jwtAf+JgEio09QmwBTCC4RhAS9zTZxiNWAHCdPtESgu4E+VLcxHjEEpkF7w+Cm
pQiZHcW0mG7Y2PKAg8VkP2GvXH0gbiNSQ/7ZTOFsExePWay5vLQdYg/u21hleZae
zQ4oI905vhOEb6L92iAvzuFr0hTpIwZ1kvc+1bUAHQwLIycKalMkym1jgoyUaD2/
eFPwvzPIPZfEuorb3mmhEq98yKTDxH5U5glFjBaZWD3E3Mg9RZN3g0Iqps80abIS
Z47zkqMzxw8heuyjScbbz26hhKj6ziP1mcs3crmThZk3H1EpPqaVIcNHUTs6AE0P
pRlUbV4l4np3xvL9u4DDOb2FGjgDlA==
=6gku
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
