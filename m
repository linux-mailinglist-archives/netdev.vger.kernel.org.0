Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63BA4587FD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhKVCZ0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 21 Nov 2021 21:25:26 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:39925 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhKVCZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 21:25:26 -0500
Received: by mail-yb1-f179.google.com with SMTP id v203so9462872ybe.6;
        Sun, 21 Nov 2021 18:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KXuWi9yCqYwP/qmgNHN5Wi3z3wEZlxR5Bx0pOeYsboo=;
        b=hoaw9g0IjRcJvdA5xbODr3awE9NWQe3pFqBggWPbe7du72whUarl5WanwWf45x5uxj
         /waoyyAhtSALG+2oAaE/tjOLX9DmNDAg6bQCS44gG5ypohSEi+tCV/9kVhX9yYYp2ZWl
         6HP10QTtJRU6TEgEJWzN0GiEUx6WCqAppUY9z7FDZYEB8X8vfx7GoY2I+HMKGU3NTdbu
         hWoTy3YiNQj/Er1L8fWEKT7G0v7MJAgwE2SLvBU+rwLr1kWguwWdoSwfp435TbMArNJy
         QdVoKWQNvA6h95DAikTQsd1yegWCFSCHPeU7f8ArYu8LK7HyFy3KdHXpkHkN6/MW2np2
         rNyw==
X-Gm-Message-State: AOAM531cYrjQ0EVtPS8LkUkmsTXVgSrn4/bHWs+dUbMkR9s8YI/Up/e7
        qdUg/jDAC5v8zUKvKnzfxhkO+w1gAEYDYCGltyI=
X-Google-Smtp-Source: ABdhPJwV0kLR1vX+lJTGI3BbPiWQZEbux+o3pjDIIxisQu5JoPzJVodwXzKU0KYAiiGzlfvyB8ZX6vOE3mtyfXdVylQ=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr63615074ybg.62.1637547739720;
 Sun, 21 Nov 2021 18:22:19 -0800 (PST)
MIME-Version: 1.0
References: <20211119161850.202094-1-mailhol.vincent@wanadoo.fr> <38544770-9e5f-1b1b-1f0a-a7ff1719327d@hartkopp.net>
In-Reply-To: <38544770-9e5f-1b1b-1f0a-a7ff1719327d@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 22 Nov 2021 11:22:08 +0900
Message-ID: <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
Subject: Re: [PATCH] can: bittiming: replace CAN units with the SI metric
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le lun. 22 nov. 2021 à 03:27, Oliver Hartkopp <socketcan@hartkopp.net> a écrit :
>
>
>
> On 19.11.21 17:18, Vincent Mailhol wrote:
> > In [1], we introduced a set of units in linux/can/bittiming.h. Since
> > then, generic SI prefix were added to linux/units.h in [2]. Those new
> > prefix can perfectly replace the CAN specific units.
> >
> > This patch replaces all occurrences of the CAN units with their
> > corresponding prefix according to below table.
> >
> >   CAN units   SI metric prefix
> >   -------------------------------
> >   CAN_KBPS    KILO
> >   CAN_MBPS    MEGA
> >   CAM_MHZ     MEGA
> >
> > The macro declarations are then removed from linux/can/bittiming.h
> >
> > [1] commit 1d7750760b70 ("can: bittiming: add CAN_KBPS, CAN_MBPS and
> > CAN_MHZ macros")
> >
> > [2] commit 26471d4a6cf8 ("units: Add SI metric prefix definitions")
> >
> > Suggested-by: Jimmy Assarsson <extja@kvaser.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >   drivers/net/can/dev/bittiming.c           | 5 +++--
> >   drivers/net/can/usb/etas_es58x/es581_4.c  | 5 +++--
> >   drivers/net/can/usb/etas_es58x/es58x_fd.c | 5 +++--
> >   include/linux/can/bittiming.h             | 7 -------
> >   4 files changed, 9 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
> > index 0509625c3082..a5c9f973802a 100644
> > --- a/drivers/net/can/dev/bittiming.c
> > +++ b/drivers/net/can/dev/bittiming.c
> > @@ -4,6 +4,7 @@
> >    * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
> >    */
> >
> > +#include <linux/units.h>
> >   #include <linux/can/dev.h>
> >
> >   #ifdef CONFIG_CAN_CALC_BITTIMING
> > @@ -81,9 +82,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
> >       if (bt->sample_point) {
> >               sample_point_nominal = bt->sample_point;
> >       } else {
> > -             if (bt->bitrate > 800 * CAN_KBPS)
> > +             if (bt->bitrate > 800 * KILO)
> >                       sample_point_nominal = 750;
> > -             else if (bt->bitrate > 500 * CAN_KBPS)
> > +             else if (bt->bitrate > 500 * KILO)
> >                       sample_point_nominal = 800;
> >               else
> >                       sample_point_nominal = 875;
> > diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
> > index 14e360c9f2c9..ed340141c712 100644
> > --- a/drivers/net/can/usb/etas_es58x/es581_4.c
> > +++ b/drivers/net/can/usb/etas_es58x/es581_4.c
> > @@ -10,6 +10,7 @@
> >    */
> >
> >   #include <linux/kernel.h>
> > +#include <linux/units.h>
> >   #include <asm/unaligned.h>
> >
> >   #include "es58x_core.h"
> > @@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
> >       .bittiming_const = &es581_4_bittiming_const,
> >       .data_bittiming_const = NULL,
> >       .tdc_const = NULL,
> > -     .bitrate_max = 1 * CAN_MBPS,
> > -     .clock = {.freq = 50 * CAN_MHZ},
> > +     .bitrate_max = 1 * MEGA,
> > +     .clock = {.freq = 50 * MEGA},
>
> IMO we are losing information here.
>
> It feels you suggest to replace MHz with M.

When I introduced the CAN_{K,M}BPS and CAN_MHZ macros, my primary
intent was to avoid having to write more than five zeros in a
row (because the human brain is bad at counting those). And the
KILO/MEGA prefixes perfectly cover that intent.

You are correct to say that the information of the unit is
lost. But I assume this information to be implicit (frequencies
are in Hz, baudrate are in bits/second). So yes, I suggest
replacing MHz with M.

Do you really think that people will be confused by this change?

I am not strongly opposed to keeping it either (hey, I was the
one who introduced it in the first place). I just think that
using linux/units.h is sufficient.

> So where is the Hz information then?

It is in the comment of can_clock:freq :)

https://elixir.bootlin.com/linux/v5.15/source/include/uapi/linux/can/netlink.h#L63

> >       .ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
> >       .tx_start_of_frame = 0xAFAF,
> >       .rx_start_of_frame = 0xFAFA,
> > diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
> > index 4f0cae29f4d8..aec299bed6dc 100644
> > --- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
> > +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
> > @@ -12,6 +12,7 @@
> >    */
> >
> >   #include <linux/kernel.h>
> > +#include <linux/units.h>
> >   #include <asm/unaligned.h>
> >
> >   #include "es58x_core.h"
> > @@ -522,8 +523,8 @@ const struct es58x_parameters es58x_fd_param = {
> >        * Mbps work in an optimal environment but are not recommended
> >        * for production environment.
> >        */
> > -     .bitrate_max = 8 * CAN_MBPS,
> > -     .clock = {.freq = 80 * CAN_MHZ},
> > +     .bitrate_max = 8 * MEGA,
> > +     .clock = {.freq = 80 * MEGA},
> >       .ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
> >           CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
> >           CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
> > diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
> > index 20b50baf3a02..a81652d1c6f3 100644
> > --- a/include/linux/can/bittiming.h
> > +++ b/include/linux/can/bittiming.h
> > @@ -12,13 +12,6 @@
> >   #define CAN_SYNC_SEG 1
> >
> >
> > -/* Kilobits and Megabits per second */
> > -#define CAN_KBPS 1000UL
> > -#define CAN_MBPS 1000000UL
> > -
> > -/* Megahertz */
> > -#define CAN_MHZ 1000000UL
>
> So what about
>
> #define CAN_KBPS KILO /* kilo bits per second */
> #define CAN_MBPS MEGA /* mega bits per second */
>
> #define CAN_MHZ MEGA /* mega hertz */
>
>
> ??
>
> Regards,
> Oliver
>
>
> > -
> >   #define CAN_CTRLMODE_TDC_MASK                                       \
> >       (CAN_CTRLMODE_TDC_AUTO | CAN_CTRLMODE_TDC_MANUAL)
> >
> >
