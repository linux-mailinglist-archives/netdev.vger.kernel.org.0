Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F5A61D956
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 11:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKEKPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 06:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKEKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 06:15:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED181F2CE;
        Sat,  5 Nov 2022 03:15:06 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z26so6571143pff.1;
        Sat, 05 Nov 2022 03:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E4wP1R2izs4uIBXJgQduhOiz6+MTExIAUrFkWEg0QTU=;
        b=Yt5EMYoHaOhhRKOablDBb44/XdxLsnqlgrb6EufMtRM9STm4WeEllj+LllqVf/Gzl7
         RCZw0tBf2MMQD7K6oRIdx3QQF49gWxgpeaspKW7S0uHVt4YervqXGf5EnM5giP5uyxzN
         evgqTkBX4G9kBbIvrzXQpLgYV8RBiWIPaAsRSw788Vc4lQdHWdA4JtmVLJHVhIy4DmM1
         6ClYV7xoilRrEoJenFSI37RdppGtjRcuVFCMJt8K6oZZd6Zt/tR7rdQyFWv2WhMsEFuI
         rI5e82gDK2DQYDj6eVg9o4Wh9PuIEhlNlI5wOd6t7HltqfGRu8nCBbU4s4C5zqKhzYle
         tV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E4wP1R2izs4uIBXJgQduhOiz6+MTExIAUrFkWEg0QTU=;
        b=P3ZJHXR9U7jtNymRa+bKC5exCC10QF0brBkHuqNjIMjrmu1LV/fXP1uIMjcLApgHtE
         OwlP3e3k1oK/MfafGoAId46km6PfASF+mnaChjQu+r2DLixaKbEZeNSQh9XwQeY9z/Wp
         yf5Nm9w/KdkeR1rM1gcx/Z7i9cTE+drnbc/c67uP7Y40R2VWzrSPf5dODj2gdkfMexlQ
         ogYVML6OeCqGTFogKeunil/JIBBGJzocKu9L0AmSKErFs92XqOzhmxwdBKxz14uCfxFL
         93T1WWxqlb9iPfSyhvT8MXAi0KP6fcB/7IVJEs/GW2c0Drb0P+JTfo2QxYjkowrmGj87
         UUAw==
X-Gm-Message-State: ACrzQf30RqHi3kg0q2rWQs+Q2gajkzXiKcPpisitTV7W9MkKyt6muedC
        quCOWtDl3mJdv43usQ/cL+A08jlTk/qAkLVTqe8=
X-Google-Smtp-Source: AMsMyM7TpGR1DTup0FkfE3NQ4HggSvrcRX90u6ShzTIV7X5d7/IEVeYiI8a4sAYtUUQN3s4oiivHFO6IfrdCWIVPVGI=
X-Received: by 2002:a65:6894:0:b0:470:76d:6f4a with SMTP id
 e20-20020a656894000000b00470076d6f4amr16056048pgt.457.1667643305969; Sat, 05
 Nov 2022 03:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com> <20221104172421.8271-3-Harald.Mommer@opensynergy.com>
In-Reply-To: <20221104172421.8271-3-Harald.Mommer@opensynergy.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 5 Nov 2022 19:14:54 +0900
Message-ID: <CAMZ6RqLUCs0W8ZP2jAUsFMUXgHTjce649Gu+jnz_S1x_0ER6YQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/2] can: virtio: Add virtio_can to MAINTAINERS file.
To:     Harald Mommer <Harald.Mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 5 Nov. 2022 at 02:29, Harald Mommer
<Harald.Mommer@opensynergy.com> wrote:
> From: Harald Mommer <harald.mommer@opensynergy.com>
>
> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> ---
>  MAINTAINERS                  | 7 +++++++
>  drivers/net/can/virtio_can.c | 6 ++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 379945f82a64..01b2738b7c16 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21692,6 +21692,13 @@ F:     drivers/vhost/scsi.c
>  F:     include/uapi/linux/virtio_blk.h
>  F:     include/uapi/linux/virtio_scsi.h
>
> +VIRTIO CAN DRIVER
> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
> +L:     linux-can@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/can/virtio_can.c
> +F:     include/uapi/linux/virtio_can.h
> +
>  VIRTIO CONSOLE DRIVER
>  M:     Amit Shah <amit@kernel.org>
>  L:     virtualization@lists.linux-foundation.org
> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
> index 43cf1c9e4afd..0e87172bbddf 100644
> --- a/drivers/net/can/virtio_can.c
> +++ b/drivers/net/can/virtio_can.c
> @@ -1,7 +1,7 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +// SPDX-License-Identifier: GPL-2.0-only

Please squash this in the previous patch.

>  /*
>   * CAN bus driver for the Virtio CAN controller
> - * Copyright (C) 2021 OpenSynergy GmbH
> + * Copyright (C) 2021-2022 OpenSynergy GmbH

Same.

>   */
>
>  #include <linux/atomic.h>
> @@ -793,8 +793,6 @@ static void virtio_can_populate_vqs(struct virtio_device *vdev)
>         unsigned int idx;
>         int ret;
>
> -       // TODO: Think again a moment if here locks already may be needed!

Same.

>         /* Fill RX queue */
>         vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>         for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
> --
> 2.17.1
>
