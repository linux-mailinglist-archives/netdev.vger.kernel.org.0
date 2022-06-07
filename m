Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D522653F868
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiFGIna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiFGInX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:43:23 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A685F8DF;
        Tue,  7 Jun 2022 01:43:21 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id hf10so12123902qtb.7;
        Tue, 07 Jun 2022 01:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trIBU79MD2ZqYXz6AJVM4tpcbmd/BhR2QCKmFEHT7ZI=;
        b=vVnrsf+qmaxh1j0aAZbPCPAnMyFPkwXtNkrwo2u0qV06wpdcWrK09/aruC+01Y32yw
         Lbb9BdfUsmRVlQ8VhZVVcvoMA8GmLmvA6XiavHvgwCa019mDKxbcgR5fdyktTuNApHy4
         KnOJS0gOZAmfXxOaf/gw9Lpb2L+jLIbevFQqIDnrN4R2R3/rlWaqF1C4Lqt0MD49AEi9
         v27vYSgQTZrjkyr/r92Pcm9qESTXtaxhscy2G3gAKYbkJYgav/r/jiDR4x0RRrU8AKbv
         vK2JI0dz4ksmxosvDcmws6dLYZjOyj0pCNuz+1bQFsHh+Xo4E6yEVzq98rFRaLA+L5X7
         FEkQ==
X-Gm-Message-State: AOAM531cEWpfTbJDFLmPhSQBeyU2oU8rNmXWWJ0SV1amcpyxIEIQMT+K
        /J9PZtFxcib/0VhL29ufCLRt45c392spsw==
X-Google-Smtp-Source: ABdhPJxGN2dmQfazk+egpqsUQyK9Eyi/WXgiXZRRqrWAvcUfzkHha8aa6QX4EOhk9phjm6dKasAA1Q==
X-Received: by 2002:ac8:5d8b:0:b0:2fb:1a6:61f5 with SMTP id d11-20020ac85d8b000000b002fb01a661f5mr21692276qtx.603.1654591400852;
        Tue, 07 Jun 2022 01:43:20 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id v128-20020a37dc86000000b0069fc13ce244sm13496872qki.117.2022.06.07.01.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 01:43:20 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-30c1c9b9b6cso167429027b3.13;
        Tue, 07 Jun 2022 01:43:20 -0700 (PDT)
X-Received: by 2002:a0d:d481:0:b0:30c:44f1:2721 with SMTP id
 w123-20020a0dd481000000b0030c44f12721mr30757906ywd.283.1654591400102; Tue, 07
 Jun 2022 01:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Jun 2022 10:43:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
Message-ID: <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On Sun, Jun 5, 2022 at 12:25 AM Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> Only a few drivers rely on the CAN rx offload framework (as of the
> writing of this patch, only four: flexcan, m_can, mcp251xfd and
> ti_hecc). Give the option to the user to deselect this features during
> compilation.

Thanks for your patch!

> The drivers relying on CAN rx offload are in different sub
> folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
> so that the option is automatically enabled whenever one of those
> driver is chosen.

Great! But...

>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -102,6 +102,20 @@ config CAN_CALC_BITTIMING
>
>           If unsure, say Y.
>
> +config CAN_RX_OFFLOAD
> +       bool "CAN RX offload"
> +       default y

... then why does this default to "y"?

> +       help
> +         Framework to offload the controller's RX FIFO during one
> +         interrupt. The CAN frames of the FIFO are read and put into a skb
> +         queue during that interrupt and transmitted afterwards in a NAPI
> +         context.
> +
> +         The additional features selected by this option will be added to the
> +         can-dev module.
> +
> +         If unsure, say Y.

... and do you suggest to enable this?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
