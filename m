Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8735C4FD
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbhDLLXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:23:39 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:44892 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbhDLLXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 07:23:36 -0400
Received: by mail-yb1-f177.google.com with SMTP id l14so8404442ybf.11;
        Mon, 12 Apr 2021 04:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAZeWmxZnRvBIOsIyb+Toh3owJVdNZMmbeBXAmpmoTg=;
        b=njRqFYTFmdoeHuvUcbpyday07+mgqdbsiialNpgep8z8XzI8fYpG47EL8HJUQp9YeL
         EnhDsYbgA550h3u0M7eccgksbmpp6cobMXx4Pwme5PNaSwYq6TQCipBniJTOAHvejF5e
         0wkv/5iCGXacoWw2KT/1+v3Vjoi/cRsP4g0sRl2gE/mJoqL7pMLTEiy4mbRMCl3sbD/B
         OHAdlSt03zgUeUZxJj4upxizo9teDA9S24y2J0mf+Jjw30M+M5vwHp3h+iygOGVnES05
         1BeIbcE5mGfDWGPfzm8tqOSXtcNhgXGQtqZO8QaB4troHI8hvJQj697QhmFMli1LRY+V
         2ZIw==
X-Gm-Message-State: AOAM530l5LkJ7CGEyOsBaSfywhmu3cisn4H3nfYHIRuP+5qTHxN8x1Em
        ycfT5VTut6D6zkhLZfT7Uq0zO/u6kYHeSYBdwV4=
X-Google-Smtp-Source: ABdhPJwovRRPheJbvtDIuRSwXz1a4oqkVzcTXBDdYe2mdhIrszZieWLwk89XRYNJ9IaYCAKa61T3VFtjZehgxrdQ6bw=
X-Received: by 2002:a25:cc84:: with SMTP id l126mr14879683ybf.487.1618226597994;
 Mon, 12 Apr 2021 04:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210410095948.233305-1-mailhol.vincent@wanadoo.fr> <20210412092001.7vp7dtbvsb6bgh2t@pengutronix.de>
In-Reply-To: <20210412092001.7vp7dtbvsb6bgh2t@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 12 Apr 2021 20:23:06 +0900
Message-ID: <CAMZ6RqLgLzMymHus5O7qcL_q=AwywXQusNb51CNL1TtHZ0XwcQ@mail.gmail.com>
Subject: Re: [PATCH v15 0/3] Introducing ETAS ES58X CAN USB interfaces
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Mon. 12 Apr 2021 at 18:20, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 10.04.2021 18:59:45, Vincent Mailhol wrote:
> > Here comes the 15th iteration of the patch. This new version addresses
> > the comments received from Marc (thanks again for the review!) and
> > simplify the device probing by using .driver_info.
>
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index 35ba8af89b2e..7222b3b6ca46 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -1096,7 +1096,7 @@ static void es58x_increment_rx_errors(struct es58x_device *es58x_dev)
>   *     be aligned.
>   *
>   * Sends the URB command to the device specific function. Manages the
> - * errors throwed back by those functions.
> + * errors thrown back by those functions.
>   */
>  static void es58x_handle_urb_cmd(struct es58x_device *es58x_dev,
>                                  const union es58x_urb_cmd *urb_cmd)
>
> I have applied to linux-can-next/testing with the above spell fix.
> Thanks for the steady work on this and all the other features.

Thanks to you too! This, together with the other features is my
very first open source contribution. I learned a lot from you,
Oliver and the others from the mailing list. It was a nice
experience.

That said, you will eventually hear from me again on the TDC
netlink interface (and probably other topics as well).


Yours sincerely,
Vincent
