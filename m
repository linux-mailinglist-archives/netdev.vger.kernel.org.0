Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D84281CC3
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJBURO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJBURN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:17:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98FC0613D0;
        Fri,  2 Oct 2020 13:17:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z1so3082912wrt.3;
        Fri, 02 Oct 2020 13:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v3O9WdsNLJVkgSoGDOH52JrLXl2wjpYEbzt5PhqJt+U=;
        b=kZ2FLydQyJOeChz2+eQqxX1EvGjWsn7aK57kZBT7uLeaRvAo4YGypf08XVVgAcrIpB
         ci6XrP4OVAlNTE5eb+d/oudhPenqgsX43Hj9mv3+sjlphL5gPPYmU5x6rwlZCFYX491e
         Z8mEAKHjWR96UIqvXr4FGFPtdEJbtaR+qtS2YkQI5eKiwgx3bqoyXg54KOWkfenC2YMf
         jkw9NNdYbuiQCKW3WXaYHWB8DZMZ3uU0g4gxQAUucKsYgGMkQMJ/s+EquU+9kquaU2hc
         JOIrz6HUvJXZz27ylqSbBBxX1Syb9v8V4WPcfNGC5bTVBWQ8Z9CZTTfS1BNhH+B8e3Ac
         M5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v3O9WdsNLJVkgSoGDOH52JrLXl2wjpYEbzt5PhqJt+U=;
        b=diz3r9i4renKDRvOyNWoNhDrTVbIcXVq1E+itIyRFBzzIBs8O2/aZJh3RYHJBtGG8q
         fxrINK/H84IDzCyaVvUMWtC612xvUgZCWuSJ3AvUngIumoSuuZkY4Cc9teg7tqwW4PpJ
         IWyQebShjH2Qrpuz44EjuKvgnTlAl50teDEb4rl11iOc840WWZo/bkzY3YlNeANhELqC
         GMe9veMQFgH3+41OI96tP1krEfOyR+fLbjfE98zPzsEkmkj+JzaTEwoDxENFOuamRYdB
         GIKiAtdoSF2BtGK/7Ykhm+qDlvFxmpoFsKSTcmbwK/uokKOSvABEMeJidXvtnVx6ZYk4
         +o9A==
X-Gm-Message-State: AOAM530BF9Mxg/ef9g5u5CNSHbhaC6k0uWei7iYXZ0MAV5SMkLeL6kH+
        +5BpwbDZ4fCIcrX+c+Xiya7vjIqDqyyAZrOKn2E=
X-Google-Smtp-Source: ABdhPJxDiEQEtoaAOw9HKt+VxBNfpYEIgQgCD70lGzkeo1gpZ4TBeouF9MBOGhLTV31M695d1Ih5aVELkR7gjWFwa3Y=
X-Received: by 2002:adf:ab46:: with SMTP id r6mr5079040wrc.360.1601669832211;
 Fri, 02 Oct 2020 13:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Fri, 2 Oct 2020 13:17:00 -0700
Message-ID: <CAPWQSg1y8uvpiwxxp_ONGFs8GeuOY09q3AShfLCmhv77ePma-Q@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: should keep avail_index despite device status
To:     elic@nvidia.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Eli.

On Thu, Oct 1, 2020 at 2:02 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
> A VM with mlx5 vDPA has below warnings while being reset:
>
> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
>
> We should allow userspace emulating the virtio device be
> able to get to vq's avail_index, regardless of vDPA device
> status. Save the index that was last seen when virtq was
> stopped, so that userspace doesn't complain.
>
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 70676a6..74264e59 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1133,15 +1133,17 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>         if (!mvq->initialized)
>                 return;
>
> -       if (query_virtqueue(ndev, mvq, &attr)) {
> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> -               return;
> -       }
>         if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
>                 return;
>
>         if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> +
> +       if (query_virtqueue(ndev, mvq, &attr)) {
> +               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> +               return;
> +       }
> +       mvq->avail_idx = attr.available_index;
>  }
>
>  static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> @@ -1411,8 +1413,14 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>         struct mlx5_virtq_attr attr;
>         int err;
>
> -       if (!mvq->initialized)
> -               return -EAGAIN;
> +       /* If the virtq object was destroyed, use the value saved at
> +        * the last minute of suspend_vq. This caters for userspace
> +        * that cares about emulating the index after vq is stopped.
> +        */
> +       if (!mvq->initialized) {
> +               state->avail_index = mvq->avail_idx;
> +               return 0;
> +       }
>
>         err = query_virtqueue(ndev, mvq, &attr);
>         if (err) {
> --
> 1.8.3.1
>
