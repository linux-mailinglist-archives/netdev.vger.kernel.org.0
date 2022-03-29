Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75554EB434
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiC2TqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiC2TqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:46:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA72C419A8
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 12:44:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8DFCD2195D;
        Tue, 29 Mar 2022 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648583076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mmh02qAkZbabEY4gQRuYH6c6h+TVOI9mXLkwl6A/LyE=;
        b=QDlovQb2IHcRrhRjkL6vDCv3QCv/sc1yChPPPHFKCVtPfZ8CbFaNxkE/OKUuuYklkbUy/w
        qT+SkEZ0sqXUfvDS8bjLUC5wCuUXtzy0pOhoHq2qzgDboKj0geL+Z+6qSnY6ckahBIcHxK
        0dtFknjb2t46Y4sG+1aeBoUcEKzNtxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648583076;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mmh02qAkZbabEY4gQRuYH6c6h+TVOI9mXLkwl6A/LyE=;
        b=/uotfqLjQxlgUKicfODDqm3VQEYsGC3Y0IeGFiFTPBJyfd20bYC51Lo7MBscH3P+f3GrPr
        kboVqp3c4tW9BnCQ==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 43E29A3B82;
        Tue, 29 Mar 2022 19:44:36 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9F21B602F9; Tue, 29 Mar 2022 21:44:30 +0200 (CEST)
Date:   Tue, 29 Mar 2022 21:44:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, linyunsheng@huawei.com,
        salil.mehta@huawei.com, chenhao288@hisilicon.com
Subject: Re: [RFCv3 PATCH net-next 2/2] net-next: hn3: add tx push support in
 hns3 ring param process
Message-ID: <20220329194430.udh5i77kkrgun7b7@lion.mk-sys.cz>
References: <20220329091913.17869-1-wangjie125@huawei.com>
 <20220329091913.17869-3-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wjpq7q4l7sfoaiqi"
Content-Disposition: inline
In-Reply-To: <20220329091913.17869-3-wangjie125@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wjpq7q4l7sfoaiqi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29, 2022 at 05:19:13PM +0800, Jie Wang wrote:
> This patch adds tx push param to hns3 ring param and adapts the set and g=
et
> API of ring params. So users can set it by cmd ethtool -G and get it by c=
md
> ethtool -g.
>=20
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> ---
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 ++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers=
/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 6469238ae090..5bc509f90d2a 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -664,6 +664,8 @@ static void hns3_get_ringparam(struct net_device *net=
dev,
>  	param->tx_pending =3D priv->ring[0].desc_num;
>  	param->rx_pending =3D priv->ring[rx_queue_index].desc_num;
>  	kernel_param->rx_buf_len =3D priv->ring[rx_queue_index].buf_size;
> +	kernel_param->tx_push =3D test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE,
> +					 &priv->state);
>  }
> =20
>  static void hns3_get_pauseparam(struct net_device *netdev,
> @@ -1114,6 +1116,30 @@ static int hns3_change_rx_buf_len(struct net_devic=
e *ndev, u32 rx_buf_len)
>  	return 0;
>  }
> =20
> +static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
> +{
> +	struct hns3_nic_priv *priv =3D netdev_priv(netdev);
> +	struct hnae3_handle *h =3D hns3_get_handle(netdev);
> +	struct hnae3_ae_dev *ae_dev =3D pci_get_drvdata(h->pdev);
> +	u32 old_state =3D test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
> +
> +	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps) && tx_push)
> +		return -EOPNOTSUPP;
> +
> +	if (tx_push =3D=3D old_state)
> +		return 0;
> +
> +	netdev_info(netdev, "Changing tx push from %s to %s\n",
> +		    old_state ? "on" : "off", tx_push ? "on" : "off");

A nitpick: do we really want an unconditional log message for each
change? If someone wants to monitor them, that's what the netlink
notifications were created for.

Michal

> +
> +	if (tx_push)
> +		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
> +	else
> +		clear_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
> +
> +	return 0;
> +}
> +
>  static int hns3_set_ringparam(struct net_device *ndev,
>  			      struct ethtool_ringparam *param,
>  			      struct kernel_ethtool_ringparam *kernel_param,

--wjpq7q4l7sfoaiqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmJDYZkACgkQ538sG/LR
dpUB/wgAuOl9V7qs7T9g73k1SrgOs8wYeyeSWiORk3IarkF9HFJ1qrvRhTjAsL2w
pISDqrhOfXq48+JDp4c7xCIblCO/dPJTdiFLlk7sTPbYPGEgk5pBM7zHw/geHVuD
VmMUVZMu9OTaCnjCZs1FcmINSQY8Sv2LawQpy5LthOM7Tw5o2Sv8ppen6YA+Yfgl
2BQmi40OTG5inp3gaOj/NlgIpCh27Nd2GCY/Xac8Ms4XHy09ecVvcLQ6+SstrO2u
ftep/KC8rvFggycqWMf5Nb7BaJ9X4p8DYYVR5q995nbiPTT+qdVRtuOmBnXESk2j
3uAOIKcwHdLlV0SfcPlRdd6DgG5wpQ==
=aNga
-----END PGP SIGNATURE-----

--wjpq7q4l7sfoaiqi--
