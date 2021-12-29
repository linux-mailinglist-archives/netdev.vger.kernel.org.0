Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E448137C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhL2N1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 08:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhL2N1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 08:27:15 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CF4C061574;
        Wed, 29 Dec 2021 05:27:14 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id o1so37346301uap.4;
        Wed, 29 Dec 2021 05:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plwfn4HhkfSwAkDA5+Rxr/qc89l/R2Q9DQJ1rySeql0=;
        b=qSW/MLu5sL3pEjuOO0+udEqY7mYB2Evl01/KaQhZHYJdyfFHTOJjrfhqSzEiUksnil
         OwWSOjI7nMMBbXUgyV5EelPtb03+g2RWjcrV12puToJazk9jBw3h9aurSyTi6ZQ0VCbF
         g2Woe7hg19CPX3IEaQ0dmJiDoZ5AHNAiHE5n3C5Ug9LbYS/xWvQP68BbxC2FY5JaQTg3
         VJrznu27/yu8cUqTtGdmPb4dyKoHOeGi4WmZX8gFF8KdPlum9/OS+IEVBqU17V6LyCWx
         FDjbLaqFwDFQGqqOkljzNeH2VQp8lrXyrQb6MlhcAdK93+4cv+FhYprlEdvVuFU+VLLf
         o+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plwfn4HhkfSwAkDA5+Rxr/qc89l/R2Q9DQJ1rySeql0=;
        b=INNl2vfJBz7mXPX/bYOCO4eYklNXR5x5gsL4tF8zTafpFwQxsN2LEf+w6lrhiH4FdA
         M6K7L5p9Eo25ZgZaeuAPa4Wkdv8VaquJU7OisHE8s1SX/WMdWI/FdlFyDerFtpO9xdi6
         ouaSG1FY9ChsoU/x/YfVV1apayTNYecBGfSDukSMZGi2746QPrKcrgnP2arCyxQXustq
         Xo5u5dDAc5Bsbs949nqnrdV69no0e3Coij5gN9j93IaMztjBFIT2TCO3J8nqyzEEirY5
         d/DC494J7R+3z/Fxii2ouAz23vBBFOyJesUFqKO2RUC8Yk6b8VGaMuOV3bne6I2AWg6U
         F91Q==
X-Gm-Message-State: AOAM532sx1/vNvP+IiYeGxVKNT70Q13cIcEy2pMKAsYrH1xgxJYVkPd9
        STZ/3eid/mkNO21/5qPhyBwUu9d5Z9AGQznVwhVGxIQm4b/qCQ==
X-Google-Smtp-Source: ABdhPJzj18eeNH9o9aBSuGhvghPzH57Q+tegpFCEIDaFZ4uk54yphI7ZmE7XaOvxwB6yl5tGYvrJpK0uZV6ZLqfriEM=
X-Received: by 2002:a05:6102:5113:: with SMTP id bm19mr7924637vsb.10.1640784434072;
 Wed, 29 Dec 2021 05:27:14 -0800 (PST)
MIME-Version: 1.0
References: <20211229125730.6779-1-sys.arch.adam@gmail.com> <YcxfJjpTBm6Gbiwb@kroah.com>
In-Reply-To: <YcxfJjpTBm6Gbiwb@kroah.com>
From:   Adam Kandur <sys.arch.adam@gmail.com>
Date:   Wed, 29 Dec 2021 16:27:03 +0300
Message-ID: <CAE28pkNsuEEPt5B-a7iqhcQftxRH15P-GKJfAEZUbEcYYMWWZQ@mail.gmail.com>
Subject: Re: [PATCH] net/usb: remove goto in ax88772_reset()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.
I thought, there is no reason to have out label. Because it has only
one return statement and there is return 0 before. So it seemed to me
that "goto out;" could be replaced with the "return ret;" line. Which
seems more readable to me.

thanks,

adam k.

On Wed, Dec 29, 2021 at 4:14 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 29, 2021 at 03:57:30PM +0300, Adam Kandur wrote:
> > goto statements in ax88772_reset() in net/usb/asix_devices.c are used
> > to return ret variable. As function by default returns 0 if ret
> > variable >= 0 and "out:" only returns ret, I assume goto might be
> > removed.
> >
> > Signed-off-by: Adam Kandur <sys.arch.adam@gmail.com>
> >
> > ---
> >  drivers/net/usb/asix_devices.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> > index 4514d35ef..9de5fc53f 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -332,23 +332,20 @@ static int ax88772_reset(struct usbnet *dev)
> >       ret = asix_write_cmd(dev, AX_CMD_WRITE_NODE_ID, 0, 0,
> >                            ETH_ALEN, data->mac_addr, 0);
> >       if (ret < 0)
> > -             goto out;
> > +             return ret;
> >
> >       /* Set RX_CTL to default values with 2k buffer, and enable cactus */
> >       ret = asix_write_rx_ctl(dev, AX_DEFAULT_RX_CTL, 0);
> >       if (ret < 0)
> > -             goto out;
> > +             return ret;
> >
> >       ret = asix_write_medium_mode(dev, AX88772_MEDIUM_DEFAULT, 0);
> >       if (ret < 0)
> > -             goto out;
> > +             return ret;
> >
> >       phy_start(priv->phydev);
> >
> >       return 0;
> > -
> > -out:
> > -     return ret;
> >  }
>
> There is nothing wrong with the goto here, it's the common error path
> style for the kernel.  Why should it be removed?  What is the benefit
> here?
>
> thanks,
>
> greg k-h
