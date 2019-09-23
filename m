Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F171BB1CF
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407416AbfIWKAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 06:00:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34425 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407398AbfIWKAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 06:00:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id a11so13255987wrx.1;
        Mon, 23 Sep 2019 03:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j8tRv5LN5cGDlR+BGYeNpnRdghT5fZ7v0qVCMJuIcis=;
        b=ttOl6rD9skAH4cQ3fJ9akjVeiLUbk/tfINW3DnR5B/OcDRCLdWvYeK0kfZW+9GKRKS
         sKwxFDfErlYyIVzj3xEftliiitOCvyi+5dfirtUETGx5taBGjGZgKr70q8lsrcwkeYRH
         ZLtLj1G5KmR98mUdCiH4gQ8u8LtX4PX0KpL2lY0R9XkuuEocKJfep1GhpbA5YYcV5tSb
         Xh6yl0OwbPQPzmhEqUEtF5+U1rBNDh+ouO5CO88GXFLFGbKjvI93Dn54PYCMogQfHSgK
         EBOwOmgQtaOh28yjT07BTSkovhE1i2WhnrkfKFGjwbPnZark1jvlh8dMrC0qDaabzqUS
         UFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j8tRv5LN5cGDlR+BGYeNpnRdghT5fZ7v0qVCMJuIcis=;
        b=QJyBkEk7DnV07quUWLwCKv/6iXzXNrU7dCDkPAFLzWk79CKv1AOD5EsOxInL1wq+RZ
         slg+ek1wbQtOh4dYmtm5T5lCr6JkxeIZRWvySfHJzLZ2nfGM7XbVVkqP/bPpqIOJB2Ld
         TmjjxvIJdsPiAxAeAosDH2v6mNLhu9qW6aEne4a4+Ds7MFe6A0/GIU8+43TD2jE2gzD8
         2sWI22tvTxyN3MPfA/iy8lnbkjayzcQ/Ev0noOtC5lWO006wkwSlK5ucSX4ayIduVmfE
         9L+UYl+d+OXKXngtL3WZ/Yil2HEem1FBwjiJzQ92tlsbjG0MClQ93+OU0pWOMBAl/sOh
         VBDg==
X-Gm-Message-State: APjAAAVDwh1gJjrdcf9yM4tnVDIXu/Gg7ifCQAaYdLrLXhT+sGnHEKnP
        agtMk05NBM8TCQmicYjQcn2k5auz
X-Google-Smtp-Source: APXvYqwc1wSjOi0WAiGt6dCS/OttrviDY2p5wA7qjCoVYfi8VRRBM0DagaZi2mj2X2qk1iyYCarEXA==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr20928599wrq.292.1569232833604;
        Mon, 23 Sep 2019 03:00:33 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id q3sm10330078wru.33.2019.09.23.03.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 03:00:32 -0700 (PDT)
Date:   Mon, 23 Sep 2019 12:00:31 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: Fix page pool size
Message-ID: <20190923100031.GB11084@ulmo>
References: <20190923095915.11588-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20190923095915.11588-1-thierry.reding@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2019 at 11:59:15AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> The size of individual pages in the page pool in given by an order. The
> order is the binary logarithm of the number of pages that make up one of
> the pages in the pool. However, the driver currently passes the number
> of pages rather than the order, so it ends up wasting quite a bit of
> memory.
>=20
> Fix this by taking the binary logarithm and passing that in the order
> field.
>=20
> Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

I fumbled the git format-patch incantation. This should've been marked
v2.

Thierry

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index ecd461207dbc..f8c90dba6db8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1550,13 +1550,15 @@ static int alloc_dma_rx_desc_resources(struct stm=
mac_priv *priv)
>  	for (queue =3D 0; queue < rx_count; queue++) {
>  		struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
>  		struct page_pool_params pp_params =3D { 0 };
> +		unsigned int num_pages;
> =20
>  		rx_q->queue_index =3D queue;
>  		rx_q->priv_data =3D priv;
> =20
>  		pp_params.flags =3D PP_FLAG_DMA_MAP;
>  		pp_params.pool_size =3D DMA_RX_SIZE;
> -		pp_params.order =3D DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> +		num_pages =3D DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> +		pp_params.order =3D ilog2(num_pages);
>  		pp_params.nid =3D dev_to_node(priv->device);
>  		pp_params.dev =3D priv->device;
>  		pp_params.dma_dir =3D DMA_FROM_DEVICE;
> --=20
> 2.23.0
>=20

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl2Il78ACgkQ3SOs138+
s6FM4Q/9Gd/rzVqwfDtVKsf1YAs1NNO2QuQZ8P5UAKyvmNHygU1fRfmPLc3GcCNj
z+Xjq6VUeFkeW1Da5m+uwayp2SnmKAz3HtzKX96lKr2401xt4voN1NbDYIGBWErD
ulusmz8Jz8LA9X7HZevXBOuozJZf0XwnePoYQ2yt3yRq7YMn/dwnasbjTgazP5uY
gc1cs1gUoUhxxeddWxeq+ODo6mN3B+S7c+f8yJpJfY6GWAPtHPCH/xiyWsMTqiIE
X9oIcOhUfo3Yyh7IammZSTbv0qItMHLdIQOtsdcfeawir7GEdQIZyWYR1TQjjDXg
x2J2p7vATq1ns4YG9b1oS+WziiCLVCjvm+5VR8oA2w84xCsJoU0VvnAv4X1G6ojZ
Bav/lLGMJFfvpOWoTzCmkPZWhrL739i6jUQbQ1QpP/zzgBueigpWpKWIQHHFCHIg
j7QpcpYVJI9S2jvmzp8bfHTHQdGRYpNdfyBrMClmFpof5vqhUKPtp6mv6FaXUMp4
fp9J1Cx4hoU25GuB2cKfS9MiDzXyjR9dlr2sdVK9B9lSx3d8QOpYTgbocuzivhkC
uroqKGwqLC8sl3Sv1TT1vLYLFd/2HbTVsRtlqOGnKLFWpe5PRMxNbiBno6B+yICw
XmxJOk1Xsm8BRcwl5D06LU+447Ai/5Z0vbaGDLYIyYG33m0zzEY=
=BgL2
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
