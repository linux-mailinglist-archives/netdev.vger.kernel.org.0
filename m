Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2423940FFA5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhIQTHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhIQTHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:07:32 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04983C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:06:09 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y144so20621155qkb.6
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qjZcue21qOctF3YISxpub/wZCs1lhX8leeYqFdj7v8g=;
        b=Ld0pCZ4k/ujOgMKf5NflrXovt8qaE6GwpUQpRIYouNYe8MwnNo20hb1uNVBeogWbuu
         WNyl3ICBi5l+4/w+/MwvlUi2tgPkEzLfDlcCF+ixQ7Gf4rlSKBJJWZ+iyQ26bGhilXkc
         rbRyaobe5AzKW+PCBdHwKfzY9sPDPppYOM4MdiIUzTWMWjlwjtvrcHtqdtcqiTgV2BYi
         NZOWe7uCLUOU5pxKQe6XgN+KcoIc2VlbN3IjxwNyLfQOooPrd/oDTbXidPDqknRLy3Wz
         xQLQ1jm8qZs3gX2POYmq8i8g8KEylBopGHxPQjDdhu9KXwLu0+Yb3YEKQsbRyx/3EiWy
         H6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qjZcue21qOctF3YISxpub/wZCs1lhX8leeYqFdj7v8g=;
        b=MDId3Fo0Qn43jZkV06DT8mNNcRpoVOYFbG14Eflh/wrx0VHVlGD+WSFgC/5L8sNLVM
         ELzg/lD4bR6pMMWAd/IBtmQcr6WozrhxGIAV9QP9ORRx8cJrYTwbIx5/iWEfXJAlbuZU
         oiQZ2FNZmR4P/M7Y1vgX4XxjRK3CYye+nkbes92IIUgNmFlKxAC6XLN8e1egCLOeKrZb
         HOBcu8rF35MN9hFInwUQzokTLe0LqIA4SQBphmEJlkNkyu0Dg7LOHbK+X5eGbu8SBO3J
         MjVtz2RMdwpc1NTVFW8/jN83A93WPo5IGdBMO2B4050BWR0qv6gNZylJro9/QrNbxRDF
         6Pww==
X-Gm-Message-State: AOAM5321+Gj5HQCfOmYlDpO6LtVFHXXuMV/GkmMyX6GD+IQZYZoJdNNd
        mgGSOdzLDw4Pot3cxh+tncRKkMhFSFrSOPtsEkzcaA==
X-Google-Smtp-Source: ABdhPJwpGZANDa4islg/6RNEgiaW/U6PR2K4bysTpk1P7oB7WbGtJipzHMMIv08sp/tsZi4EdUZngOTG6JFs9XSPeTs=
X-Received: by 2002:a25:5606:: with SMTP id k6mr15567664ybb.476.1631905568350;
 Fri, 17 Sep 2021 12:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
 <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 17 Sep 2021 21:05:55 +0200
Message-ID: <CANP3RGfPzXTMX+FAvd73EWjQnqUPyczuTD0dTQ79RMoVpjyQMg@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 8:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 17 Sep 2021 19:59:15 +0200 Maciej =C5=BBenczykowski wrote:
> > I've been browsing some usb ethernet dongle related stuff in the
> > kernel (trying to figure out which options to enable in Android 13
> > 5.~15 kernels), and I've come across the following patch (see topic,
> > full patch quoted below).
> >
> > Doesn't it entirely defeat the purpose of the patch it claims to fix
> > (and the patch that fixed)?
> > Certainly the reasoning provided (in general device drivers should not
> > be enabled by default) doesn't jive with me.
> > The device driver is CDC_ETHER and AFAICT this is just a compatibility
> > option for it.
> >
> > Shouldn't it be reverted (ie. the 'default y' line be re-added) ?
> >
> > AFAICT the logic should be:
> >   if we have CDC ETHER (aka. ECM), but we don't have R8152 then we
> > need to have R8153_ECM.
> >
> > Alternatively, maybe there shouldn't be a config option for this at all=
?
> >
> > Instead r8153_ecm should simply be part of cdc_ether.ko iff r8152=3Dn
> >
> > I'm not knowledgeable enough about Kconfig syntax to know how to
> > phrase the logic...
> > Maybe there shouldn't be a Kconfig option at all, and just some Makefil=
e if'ery.
> >
> > Something like:
> >
> > obj-$(CONFIG_USB_RTL8152) +=3D r8152.o
> > obj-$(CONFIG_USB_NET_CDCETHER) +=3D cdc_ether.o obj-
> > ifndef CONFIG_USB_RTL8152
> > obj-$(CONFIG_USB_NET_CDCETHER) +=3D r8153_ecm.o
> > endif
> >
> > Though it certainly would be nice to use 8153 devices with the
> > CDCETHER driver even with the r8152 driver enabled...
>
> Yeah.. more context here:
>
> https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.=
com/
>
> default !USB_RTL8152 would be my favorite but that probably doesn't
> compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> mark it as a sub-option of CDCETHER? It's hard to blame people for
> expecting drivers to default to n, we should make it clearer that this
> is more of a "make driver X support variation Y", 'cause now it sounds
> like a completely standalone driver from the Kconfig wording. At least
> to a lay person like myself.

I think:
        depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=3Dn)
        default y
accomplished exactly what was wanted.

USB_NET_CDCETHER is a dependency, hence:

USB_NET_CDCETHER=3Dn forces it off - as it should - it's an addon to cdceth=
er.

USB_NET_CDCETHER=3Dm disallows 'y' - module implies addon must be module.

similarly USB_RTL8152 is a dependency, so it being a module disallows 'y'.
This is desired, because if CDCETHER is builtin, so this addon could
be builtin, then RTL8152 would fail to bind it by default.
ie. CDCETHER=3Dy && RTL8152=3Dm must force RTL8153_ECM !=3D y  (this is the=
 bugfix)

basically the funky 'USB_RTL8152 || USB_RTL8152=3Dn' --> disallows 'y'
iff RTL8152=3Dm

'default y' enables it by default as 'y' if possible, as 'm' if not,
and disables it if impossible.

So I believe this had the exact right default behaviour - and allowed
all the valid options.
