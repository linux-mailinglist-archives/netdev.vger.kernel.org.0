Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157763F7F30
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhHZAB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHZAB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:01:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7A3C061757;
        Wed, 25 Aug 2021 17:01:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so5537520wmd.3;
        Wed, 25 Aug 2021 17:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/RzyCakaISvVaIpcE9wknRJe3FwsnSoIGamM17ynWLg=;
        b=Ozu7NMFt62SFVd65cJkZz7byjr1ipAlq6WMP6UoV/xv/UhZTtznQGgZpBmvU2la+A8
         wFdE353S5d0qbRG/TrEsUrLTRYhzP4mH1J8uooh20PyAhxynpViRHNis2fL0Zkxrve2C
         8GIoReuc3uW5bpG6F0/iFhMkIMhhAxYH+DWKJ+YFYLcysNeFihnu4xaVMHpX/VeR60be
         NwPycpSTIyxCFBaxBq/c8fb4HqMeQvagalswtvYqPbKtCIXRF83qmFK1OFMk5miAqW9Z
         fU8yiJk+bjir/RCubYssOnmuEmahL4lIOcus282s52hTzSvDIdlVbSED2/dGbW+puL+j
         j41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/RzyCakaISvVaIpcE9wknRJe3FwsnSoIGamM17ynWLg=;
        b=GGkSV5gJUr1uD9b0b46plxyY14G9T4ftzyYm1JI+1J0qc36Faj4KMtf5z/mGAk3D9r
         hYt0rqcNqpFjIV9I4KO51PjcuZOlPZrLLOe00nd209uCxhVwgkn32v/o5NJB5vklq0GE
         1pCKm6pv/748hihgi80wN6Z36u0hTv1pCWYhWLOtb1TRNTO17om6Dr7pt0YKuPBhfj09
         YjACBDwMH36cYhTeIoTZ6j0Vbod2UWlqfaIcCkynlMB6yW0GlAKY0jiyGl48NJFdKiv7
         jX5xHARa8ssycVZJx59dsXipU8i4TXk9IH/Pkq35/RbuyG95YJpcDlpK6SvS8aFFCKiY
         0YuQ==
X-Gm-Message-State: AOAM532NrsOHIFKAJUFrFaLvD0ICt0yhQEb27hxwBOPuep7GjZRtF+xI
        03CVHCudrbHvyBgpmF9PKLEZmFPLBjWv+tsmjdALPAh59wk=
X-Google-Smtp-Source: ABdhPJz6UMPbUOOKhsoGhc+av7j9m/O8a9LT65BiMnSng4U6TDtEiXEes4ZQcu2JK/R3nBTviRDfHkYZGYfRBYP6rpM=
X-Received: by 2002:a1c:4e11:: with SMTP id g17mr11696116wmh.2.1629936069093;
 Wed, 25 Aug 2021 17:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <1619660934-30910-1-git-send-email-si-wei.liu@oracle.com> <1619660934-30910-2-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1619660934-30910-2-git-send-email-si-wei.liu@oracle.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Wed, 25 Aug 2021 17:00:56 -0700
Message-ID: <CAPWQSg1LLgxJYciTF1OatnFS-y058A94CsAg-67t94-2Dz7TKA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] vdpa/mlx5: fix feature negotiation across device reset
To:     mst@redhat.com
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

This patch already got reviewed, though not sure why it was not picked
yet. We've been running into this issue quite a lot recently, the
typical symptom of which is that invalid checksum on TCP or UDP header
sent by vdpa is causing silent packet drops on the peer host. Only
ICMP traffic can get through. Would you please merge it at your
earliest convenience?

Thanks,
-Siwei

On Wed, Apr 28, 2021 at 6:51 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
> The mlx_features denotes the capability for which
> set of virtio features is supported by device. In
> principle, this field needs not be cleared during
> virtio device reset, as this capability is static
> and does not change across reset.
>
> In fact, the current code seems to wrongly assume
> that mlx_features can be reloaded or updated on
> device reset thru the .get_features op. However,
> the userspace VMM may save a copy of previously
> advertised backend feature capability and won't
> need to get it again on reset. In that event, all
> virtio features reset to zero thus getting disabled
> upon device reset. This ends up with guest holding
> a mismatched view of available features with the
> VMM/host's. For instance, the guest may assume
> the presence of tx checksum offload feature across
> reboot, however, since the feature is left disabled
> on reset, frames with bogus partial checksum are
> transmitted on the wire.
>
> The fix is to retain the features capability on
> reset, and get it only once from firmware on the
> vdpa_dev_add path.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Acked-by: Eli Cohen <elic@nvidia.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 25533db..624f521 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1492,16 +1492,8 @@ static u64 mlx_to_vritio_features(u16 dev_features)
>  static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>  {
>         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> -       struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -       u16 dev_features;
>
> -       dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> -       ndev->mvdev.mlx_features = mlx_to_vritio_features(dev_features);
> -       if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> -               ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> -       ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> -       print_features(mvdev, ndev->mvdev.mlx_features, false);
> -       return ndev->mvdev.mlx_features;
> +       return mvdev->mlx_features;
>  }
>
>  static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> @@ -1783,7 +1775,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>                 teardown_driver(ndev);
>                 mlx5_vdpa_destroy_mr(&ndev->mvdev);
>                 ndev->mvdev.status = 0;
> -               ndev->mvdev.mlx_features = 0;
>                 ++mvdev->generation;
>                 return;
>         }
> @@ -1902,6 +1893,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
>         .free = mlx5_vdpa_free,
>  };
>
> +static void query_virtio_features(struct mlx5_vdpa_net *ndev)
> +{
> +       struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
> +       u16 dev_features;
> +
> +       dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> +       mvdev->mlx_features = mlx_to_vritio_features(dev_features);
> +       if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> +               mvdev->mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> +       mvdev->mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> +       print_features(mvdev, mvdev->mlx_features, false);
> +}
> +
>  static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
>  {
>         u16 hw_mtu;
> @@ -2009,6 +2013,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
>         init_mvqs(ndev);
>         mutex_init(&ndev->reslock);
>         config = &ndev->config;
> +       query_virtio_features(ndev);
>         err = query_mtu(mdev, &ndev->mtu);
>         if (err)
>                 goto err_mtu;
> --
> 1.8.3.1
>
