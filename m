Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4224D6B2AA7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCIQYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCIQYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:24:20 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1223C3580;
        Thu,  9 Mar 2023 08:15:47 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id y2so2579530pjg.3;
        Thu, 09 Mar 2023 08:15:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678378481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oerE592QWPHbjY3Z2bnGRXDZkiQxTKdoJxy35rXE2w=;
        b=M3D9ZfllNyUl9p2Y8SYOdXGKzlQIW/pYTfyUQoZo2eohYIw/7IHwxLdBV2C7bhIR+Z
         VKAZIQhSnvnUIHbvbXJTdx9IDmtWk1uw0Bmz/R5z/xdSsJ+ASQe5+eBq7HCbAxpcm9Nn
         S3acXid9iJWr97xisDQcih4cw6wQV+UVKhPAeIRXEnPvbiNHXZGA16Qd52EAS8Mv+tvr
         rcPstfT8afsvtaj/z3fK+nz/CtYZY1BJNovX2hLJN2udwpUK88QH9r/rIGt+uSZF2Hyi
         QcQBzArVE5mRivnOZRrvYl2yEMASXpzylmJ7ICN4Njlxj9xLC3VgoPmtqzWPum7e4ryV
         cfdg==
X-Gm-Message-State: AO0yUKVZpfTbr2RGVM3FbFBUl0RzmM4bkOMgHh27L3LvZ1knsD/56cP8
        LA9/0CmAR4lulikAROCU1iE3iMbhGlIExVKwXPk=
X-Google-Smtp-Source: AK7set8EkRCqggoMBiEFWEcY9hblIvVtGJgN73q81P0AfqOHMS5pQP3ZZQSDHfIKYSlkoAtrhqLQk7XcXD4p2lXPgdU=
X-Received: by 2002:a17:903:280f:b0:19e:f660:81ee with SMTP id
 kp15-20020a170903280f00b0019ef66081eemr2477765plb.2.1678378481209; Thu, 09
 Mar 2023 08:14:41 -0800 (PST)
MIME-Version: 1.0
References: <8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be>
In-Reply-To: <8a39f99fc28967134826dff141b51a5df824b034.1678349267.git.geert+renesas@glider.be>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 10 Mar 2023 01:14:29 +0900
Message-ID: <CAMZ6RqJM0x07qAFY8Zx=8QYgJ1LTMjqBPQKvdOhuQ8pL9tu-Cw@mail.gmail.com>
Subject: Re: [PATCH] can: rcar_canfd: Print mnemotechnic error codes
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 9 Mar. 2023 at 17:10, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Replace printed numerical error codes by mnemotechnic error codes, to
> improve the user experience in case of errors.
>
> While at it, drop printing of an error message in case of out-of-memory,
> as the core memory allocation code already takes care of this.
>
> Suggested-by: Vincent Mailhol <vincent.mailhol@gmail.com>
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

Can you use my other address?
Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Thanks for the patch. Same as before, I have one nitpick on the
already existing code (c.f. below). You can add my review tag in next
version:
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> This depends on "[PATCH v2] can: rcar_canfd: Add transceiver support"
> https://lore.kernel.org/r/e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 43 +++++++++++++++----------------
>  1 file changed, 21 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index 6df9a259e5e4f92c..bc75da349676d867 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1417,20 +1417,20 @@ static int rcar_canfd_open(struct net_device *ndev)
>
>         err = phy_power_on(priv->transceiver);
>         if (err) {
> -               netdev_err(ndev, "failed to power on PHY, error %d\n", err);
> +               netdev_err(ndev, "failed to power on PHY, %pe\n", ERR_PTR(err));
>                 return err;
>         }
>
>         /* Peripheral clock is already enabled in probe */
>         err = clk_prepare_enable(gpriv->can_clk);
>         if (err) {
> -               netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
> +               netdev_err(ndev, "failed to enable CAN clock, %pe\n", ERR_PTR(err));
>                 goto out_phy;
>         }
>
>         err = open_candev(ndev);
>         if (err) {
> -               netdev_err(ndev, "open_candev() failed, error %d\n", err);
> +               netdev_err(ndev, "open_candev() failed, %pe\n", ERR_PTR(err));
>                 goto out_can_clock;
>         }
>
> @@ -1731,10 +1731,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         int err = -ENODEV;
>
>         ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
> -       if (!ndev) {
> -               dev_err(dev, "alloc_candev() failed\n");
> +       if (!ndev)
>                 return -ENOMEM;
> -       }
> +
>         priv = netdev_priv(ndev);
>
>         ndev->netdev_ops = &rcar_canfd_netdev_ops;
> @@ -1777,8 +1776,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>                                        rcar_canfd_channel_err_interrupt, 0,
>                                        irq_name, priv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq CH Err(%d) failed, error %d\n",
> -                               err_irq, err);
> +                       dev_err(dev, "devm_request_irq CH Err(%d) failed, %pe\n",
                                               ^^^^
From the Linux coding style:

  Printing numbers in parentheses (%d) adds no value and should be avoided.

Ref: https://www.kernel.org/doc/html/v4.10/process/coding-style.html#printing-kernel-messages

One more time, this is already existing code, so bonus points if you
fix this as well, but I will not blame you if you feel lazy and keep
the patch as is.

> +                               err_irq, ERR_PTR(err));
>                         goto fail;
>                 }
>                 irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_trx",
> @@ -1791,8 +1790,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>                                        rcar_canfd_channel_tx_interrupt, 0,
>                                        irq_name, priv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq Tx (%d) failed, error %d\n",
> -                               tx_irq, err);
> +                       dev_err(dev, "devm_request_irq Tx (%d) failed, %pe\n",
> +                               tx_irq, ERR_PTR(err));
>                         goto fail;
>                 }
>         }
> @@ -1823,7 +1822,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         gpriv->ch[priv->channel] = priv;
>         err = register_candev(ndev);
>         if (err) {
> -               dev_err(dev, "register_candev() failed, error %d\n", err);
> +               dev_err(dev, "register_candev() failed, %pe\n", ERR_PTR(err));
>                 goto fail_candev;
>         }
>         dev_info(dev, "device registered (channel %u)\n", priv->channel);
> @@ -1967,16 +1966,16 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        rcar_canfd_channel_interrupt, 0,
>                                        "canfd.ch_int", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               ch_irq, err);
> +                       dev_err(dev, "devm_request_irq(%d) failed, %pe\n",

Same as above.

> +                               ch_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>
>                 err = devm_request_irq(dev, g_irq, rcar_canfd_global_interrupt,
>                                        0, "canfd.g_int", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_irq, err);
> +                       dev_err(dev, "devm_request_irq(%d) failed, %pe\n",

Same as above.

> +                               g_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>         } else {
> @@ -1985,8 +1984,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        "canfd.g_recc", gpriv);
>
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_recc_irq, err);
> +                       dev_err(dev, "devm_request_irq(%d) failed, %pe\n",
> +                               g_recc_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>
> @@ -1994,8 +1993,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        rcar_canfd_global_err_interrupt, 0,
>                                        "canfd.g_err", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_err_irq, err);
> +                       dev_err(dev, "devm_request_irq(%d) failed, %pe\n",

Same as above.

> +                               g_err_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>         }
> @@ -2012,14 +2011,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         /* Enable peripheral clock for register access */
>         err = clk_prepare_enable(gpriv->clkp);
>         if (err) {
> -               dev_err(dev, "failed to enable peripheral clock, error %d\n",
> -                       err);
> +               dev_err(dev, "failed to enable peripheral clock, %pe\n",
> +                       ERR_PTR(err));
>                 goto fail_reset;
>         }
>
>         err = rcar_canfd_reset_controller(gpriv);
>         if (err) {
> -               dev_err(dev, "reset controller failed\n");
> +               dev_err(dev, "reset controller failed, %pe\n", ERR_PTR(err));
>                 goto fail_clk;
>         }
>
> --
> 2.34.1
>
