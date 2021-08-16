Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3783ED2D6
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhHPLDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:03:25 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:45591 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHPLDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:03:24 -0400
Received: by mail-lj1-f173.google.com with SMTP id h11so26476077ljo.12;
        Mon, 16 Aug 2021 04:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o8y1FwATQvjhneFiEErjVY4Ui2WuooaPfZa51BLYZO0=;
        b=fJ93r24rYXLFdGc8Oa0gquTh+vXcN2lEs4wCgVTfEBPU2cwi64MtD2ETkm/wrqfBfw
         2SAwmxmaVOWZ0xV71KpE8y+QFFcJb0a9WnhjXaN8MEfjLL6tjTHQB1KzGcuSylz9vyFC
         jep1xKL2T/fIHKrrGkzZ7gpoQIBq11BBjjygQR+SPYoqTb0pcB9/UjhdEZZNHIDMDEAF
         NIR9hJcopwjIdT4jCOriGnkWbzrm6OzlvQKz+X/9vXD6BawSVGof23Z8Xg7xHoPtZyYO
         6jb/GjOfgLWkdTTi1JtnM8VzGKWzOO37/KpfI2zI0jtLNK9UCUs5Z28RXmjblpnljIC8
         t/xg==
X-Gm-Message-State: AOAM532UM9IyVS18dX4nZaA0P+5gqXEFFjJ/yw7y5p4NIo7tYzoFj6hD
        Eep15JWT5qJh4Umjmvev044amCSK7zeCyXJbgLU=
X-Google-Smtp-Source: ABdhPJzM/poLE/zfjersj0U6XsB/AEL7JxKTmuPToBDn3k3q9SCrLno88Yt28+z8jROfErqDhQnUWRz+Ru04i7GwAUQ=
X-Received: by 2002:a05:651c:24a:: with SMTP id x10mr10981081ljn.60.1629111772132;
 Mon, 16 Aug 2021 04:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr> <20210814111428.2jivv6rbj5piqrto@pengutronix.de>
In-Reply-To: <20210814111428.2jivv6rbj5piqrto@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 16 Aug 2021 20:02:40 +0900
Message-ID: <CAMZ6RqLvhqJeCOyQwLsww5rAassYoPA=YnTw-Qq-UyAfTBTyqA@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I originally sent the below answer on Saturday but omitted to CC
the mailing list so only Marc received it.
Resending it for the record.

On Sat. 14 Aug 2021 at 20:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 14.08.2021 19:17:28, Vincent Mailhol wrote:
> >  include/uapi/linux/can/netlink.h |  30 +++++++-
>
> IIRC, changes of the uapi headers will be pull in regularly from the
> mainline kernel.

I see... This kind of makes sense. However, that would be less
easier to test as people will have to update the uapi headers by
hand.

For now, I will just wait and I will send a new version without
the uapi header once we agree on the kernel part.


Yours sincerely,
Vincent
