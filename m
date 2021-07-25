Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296F83D4DB6
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 15:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGYMrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 08:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhGYMrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 08:47:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D23C061757;
        Sun, 25 Jul 2021 06:27:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nd39so11565720ejc.5;
        Sun, 25 Jul 2021 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ug8zSMnU2kdew7XA3SZRT3wjKRPWxWw7Hd9uOpR6CJA=;
        b=gd2oUl8nbz84CXt9wnNFIsRdmnwQoogkMOycJdnORJdtf/u84hmFvhMAf/JyZ2KpLr
         g1ST/icPVs2fMUeP4eHYJjcoQDEcgdQqSLwa0yVElQVyPEcyqRxGiXWoIxE7ZtkYu2Cw
         SC9pE0qsJVHRkZAW7S1I4xicRIU4aVnriezrtG4ZPdGnQ+4qhsL9biTAr4R7c7cH9lel
         pDL88NPGJ0AInK0kXjIq3PpXVVsWlkXwX3aCPaQFHrBA0WoruBJaviydIfY/LzNnb5Uu
         7hGAMP4oW9VpbwjgKeEHAI7MGbNdx+mhxyTK++vs5tgRUetnvfHJYZ8AeXLBGh8lBv4Z
         q22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ug8zSMnU2kdew7XA3SZRT3wjKRPWxWw7Hd9uOpR6CJA=;
        b=MUkU4ojqnnvRHdcvWrKkTIQaJCNwfwtL7BDVtP9ptHVFmvKwWeEbwHQz7qgkhKxRS/
         J3nuTRyozTxOP7x/8rsGXKNFyJbFh43zsQksCqAZFwHCyYVCaOSc/5DvdF547SCLI1dg
         JR4iI+3KYLOrQJf6mv8C8dEKIBVx1aN4iTDjfUmrgvWIzlFiHVvawtAPbwbmWIrBGTy7
         jacS9KaZE1/sL52lM18E9DeAIhPXl1LdDieJTAA6KBxcxQtrM43UWzh6Iimp4fiW710V
         cFQd5tdqHYn+JHQJQITd2hUgH9yaPi8laSvyve+V3dqyo8qqb++uZO+BqZXxXMs5k9JM
         xh5A==
X-Gm-Message-State: AOAM530SoHeu1/Ya54DCXQraUAvuLXibzna8FA7RxtrMke59jx7YSLG5
        6gTRX6Xjq7y5U8fKeaQvGE4UqLSNU+6lc6pSdRA=
X-Google-Smtp-Source: ABdhPJyy5ZC9QKf9nblbrjmiCMuYBIj1PGsylZzS8j9ydD/aG3lgDrsVKxYxZmOTacQNVr33TTuypV4whMxeZ/1vTrY=
X-Received: by 2002:aa7:cfcf:: with SMTP id r15mr16001396edy.161.1627219667975;
 Sun, 25 Jul 2021 06:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210725094246.pkdpvl5aaaftur3a@pengutronix.de> <20210725103630.23864-1-paskripkin@gmail.com>
In-Reply-To: <20210725103630.23864-1-paskripkin@gmail.com>
From:   Yasushi SHOJI <yasushi.shoji@gmail.com>
Date:   Sun, 25 Jul 2021 22:27:37 +0900
Message-ID: <CAELBRWKfyOBanMBteO=LpL9R1QMp97zTYtKY689jeR2gDOa_Gw@mail.gmail.com>
Subject: Re: [PATCH] net: can: add missing urb->transfer_dma initialization
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mkl@pengutronix.de, wg@grandegger.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Yasushi SHOJI <yashi@spacecubics.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

I've tested this patch on top of v5.14-rc2.  All good.

Tested-by: Yasushi SHOJI <yashi@spacecubics.com>

Some nitpicks.

On Sun, Jul 25, 2021 at 7:36 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Yasushi reported, that his Microchip CAN Analyzer stopped working since
> commit 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb").
> The problem was in missing urb->transfer_dma initialization.
>
> In my previous patch to this driver I refactored mcba_usb_start() code to
> avoid leaking usb coherent buffers. To achive it, I passed local stack

achieve

> variable to usb_alloc_coherent() and then saved it to private array to
> correctly free all coherent buffers on ->close() call. But I forgot to
> inialize urb->transfer_dma with variable passed to usb_alloc_coherent().

initialize

> All of this was causing device to not work, since dma addr 0 is not valid
> and following log can be found on bug report page, which points exactly to
> problem described above.
>
> [   33.862175] DMAR: [DMA Write] Request device [00:14.0] PASID ffffffff fault addr 0 [fault reason 05] PTE Write access is not set
>
> Bug report: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990850
>
> Reported-by: Yasushi SHOJI <yasushi.shoji@gmail.com>
> Fixes: 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/can/usb/mcba_usb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index a45865bd7254..a1a154c08b7f 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -653,6 +653,8 @@ static int mcba_usb_start(struct mcba_priv *priv)
>                         break;
>                 }
>
> +               urb->transfer_dma = buf_dma;
> +
>                 usb_fill_bulk_urb(urb, priv->udev,
>                                   usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
>                                   buf, MCBA_USB_RX_BUFF_SIZE,
> --
> 2.32.0

Pavel, thanks again for your quick fix. :-)

Best,
--
               yashi
