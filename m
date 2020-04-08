Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE11A1A07
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 04:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgDHCky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 22:40:54 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39494 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgDHCky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 22:40:54 -0400
Received: by mail-vs1-f65.google.com with SMTP id u9so3815993vsp.6;
        Tue, 07 Apr 2020 19:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/ZXELd6yqxZHW3BMVHT8QXqccYsYFJYeRQU4hncJI4=;
        b=DWTsYb57lLv4UhbmAHVIqGY1gwsmUFF/xGwTBGcOQCFF77+OitoyXkMEwJdwXhGkDx
         FhAAEQvbXqmJ0WHYXscwJFdhaq3cCsVu4saHA9ffAkEGZdvWEvTCH0WHhZfTR729yF6F
         isQ7KidVqN2l+h6kbXbnJShrtbzYs4w1YOf03qQwluWbbh5zJOWubOZwiQ/wabk+MWfq
         bzF8uhMcLIa5y9O9NiwRFMc8h3lGb4QMHW8AXfjJakqZKqjRyf8KuYCO69vQ/Ry6Biii
         XhoqQZTwDlB1c0gaUNPiLpp39WpFDaBfO+xBbKDJIxM4IsUpLjW8d1PdHuG9jgmRP1xV
         MLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/ZXELd6yqxZHW3BMVHT8QXqccYsYFJYeRQU4hncJI4=;
        b=Gl+SHguUa1C14SyB75qHKzFpUsemjfZDsnt2wW7qkC2XIi9Ri35eCK7wWJ0boHjcDc
         tUxfvar/D3Q1i7LCuWO0g/9KCKwFL/fR1vXRRcihePTVaQ6NMWzhF6Oqv8ZHGLcRHs++
         MoM/zkfAPHgnsJ9UaF5wUT6FkQA8UnOxcDPaYfPOz6hAkztu5LBXZJQJAn89TDKxZpZk
         6NlCM596JjkpfihsQZR2Y4qRw5YY0ol3ppC/FbBHETVCsaO0SlrumYmkP8kaT3xDpogG
         uPA2Uny5tpRkA0ttEw/NoNGf/LTlO3DLoOGIOdFSEEl0hJpOWonmXMaa+yKfnHACSFjK
         IAMg==
X-Gm-Message-State: AGi0PuYgFQCVa8i2WD+doENgMEp6HhUd4bhgpQfWpjOP9WYqIxeSw5cB
        B++tiZzdTsGfo0K4x0zXBJW/lloYPCs/1YY9Al8=
X-Google-Smtp-Source: APiQypIP3VAej2uId6VHVbbIUWzlpc0T8buWRSSeE/UQMn2w7lUT8WSp6+QUP6rkBP1MRFbbQdzu/A6tDvKLFRc4HmI=
X-Received: by 2002:a67:902:: with SMTP id 2mr4789025vsj.133.1586313652812;
 Tue, 07 Apr 2020 19:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200407055837.3508017-1-alistair@alistair23.me>
 <20200407055837.3508017-2-alistair@alistair23.me> <CA+E=qVdQKS9TCG7Sa4aefAZbgWO3-rgA9u13v=iB6+TN7yQe=Q@mail.gmail.com>
In-Reply-To: <CA+E=qVdQKS9TCG7Sa4aefAZbgWO3-rgA9u13v=iB6+TN7yQe=Q@mail.gmail.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 7 Apr 2020 19:40:26 -0700
Message-ID: <CAKmqyKPGtHLzyeM5optDBF79sWNvCKt=6Qn+i0sdcqgy_W3nzA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] Bluetooth: hci_h5: Add support for binding
 RTL8723BS with device tree
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Alistair Francis <alistair@alistair23.me>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 11:51 PM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> On Mon, Apr 6, 2020 at 10:58 PM Alistair Francis <alistair@alistair23.me> wrote:
> >
> > From: Vasily Khoruzhick <anarsoul@gmail.com>
> >
> > RTL8723BS is often used in ARM boards, so add ability to bind it
> > using device tree.
> >
> > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > Signed-off-by: Alistair Francis <alistair@alistair23.me>
> > ---
> >  drivers/bluetooth/hci_h5.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
> > index 106c110efe56..b0e25a7ca850 100644
> > --- a/drivers/bluetooth/hci_h5.c
> > +++ b/drivers/bluetooth/hci_h5.c
> > @@ -1019,6 +1019,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
> >         { .compatible = "realtek,rtl8822cs-bt",
> >           .data = (const void *)&rtl_vnd },
> >  #endif
> > +       { .compatible = "realtek,rtl8822bs-bt",
>
> Wrong compatible? Also you probably want to keep it over #endif.

Fixed.

Alistair

>
> > +         .data = (const void *)&rtl_vnd },
> >         { },
> >  };
> >  MODULE_DEVICE_TABLE(of, rtl_bluetooth_of_match);
> > --
> > 2.25.1
> >
