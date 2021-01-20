Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47002FC633
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbhATBAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbhATBAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 20:00:11 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEEEC061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 16:59:30 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id e15so12198652vsa.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 16:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jgmq7Hvn3atnojIZ6N7y1EiXG4zR/+0ALIOcP43kC+4=;
        b=JQ9mTU5iDrVaqGrggjSXbjCo+WhH59aQnEEEexXuj1ZAFkAuEu3bW097I5FZIrxnCa
         2DrWHlidXBJG1OihwQsxOsyFqkDCmdDza3Z0mg30jjHn/ZPW8U1tTp1JxCZK/e6majgL
         CzvJUMXLal/2Yc9jMCEJmqoa6fgXruwrn57Xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jgmq7Hvn3atnojIZ6N7y1EiXG4zR/+0ALIOcP43kC+4=;
        b=pR1n+D3J58Bj7D9iWuj6+QqzSL+zD4v1/Dh+tioYozEDYmlY2n71oirFu9fusFe13r
         YoLrGoy/8LE2CpR4LffzANSI4MgRkrp8Le4X3qUPmUenyXldMPIptuS2RhQEoZN81VRO
         j0a9b9ku+SuTY4uFos8wMR+lKuEwNs6EMqT7AkkMyrwwOFE0eCAPJIFbmPjdtP4lbWV2
         GAgcgW/ocMJkvfPDYVYzUEnDndzizTBfMa2Q6CtH+ANdMBltFjfPRFxOY0m5IHFRxGLo
         VTikf7yB/M+W4nHSmVG/m7w7sQf4L6X70He+AbubdX1ODJ/62MdGNsY4DKW99wL+UJEo
         TTjQ==
X-Gm-Message-State: AOAM531JfSxjotVVNRtsCysZNfuzELPdwMUR4QoXNufhSeYP+TgXQWCi
        qk3ZZKAq5WEQVI7D0T2SPrddFbn7ZNWmuGh82Je+sg==
X-Google-Smtp-Source: ABdhPJwH38FPRY4b2Ihj9k/ONq6GoWri6qqCjzEknY0i6i5SlJYqVpnLn5CCal+MceJED6DOfIzcAB/FJ7IuM9xKCp8=
X-Received: by 2002:a67:2a46:: with SMTP id q67mr5048918vsq.40.1611104368966;
 Tue, 19 Jan 2021 16:59:28 -0800 (PST)
MIME-Version: 1.0
References: <20210116052623.3196274-1-grundler@chromium.org>
 <20210116052623.3196274-3-grundler@chromium.org> <20210119134558.5072a1cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANEJEGsd8c1RYnKXsWOhLFDOh89EXAUtLUPMrbWf+2+yin5kHw@mail.gmail.com>
In-Reply-To: <CANEJEGsd8c1RYnKXsWOhLFDOh89EXAUtLUPMrbWf+2+yin5kHw@mail.gmail.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Wed, 20 Jan 2021 00:59:17 +0000
Message-ID: <CANEJEGvoSWDWN19PnYJB9ubKgfyEvX4g=rvi9ezEJ9n+NUevbA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
To:     Grant Grundler <grundler@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 12:55 AM Grant Grundler <grundler@chromium.org> wrote:
>
> On Tue, Jan 19, 2021 at 9:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 15 Jan 2021 21:26:23 -0800 Grant Grundler wrote:
> > > RTL8156 sends notifications about every 32ms.
> > > Only display/log notifications when something changes.
> > >
> > > This issue has been reported by others:
> > >       https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
> > >       https://lkml.org/lkml/2020/8/27/1083
> > >
> > > ...
> > > [785962.779840] usb 1-1: new high-speed USB device number 5 using xhci_hcd
> > > [785962.929944] usb 1-1: New USB device found, idVendor=0bda, idProduct=8156, bcdDevice=30.00
> > > [785962.929949] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=6
> > > [785962.929952] usb 1-1: Product: USB 10/100/1G/2.5G LAN
> > > [785962.929954] usb 1-1: Manufacturer: Realtek
> > > [785962.929956] usb 1-1: SerialNumber: 000000001
> > > [785962.991755] usbcore: registered new interface driver cdc_ether
> > > [785963.017068] cdc_ncm 1-1:2.0: MAC-Address: 00:24:27:88:08:15
> > > [785963.017072] cdc_ncm 1-1:2.0: setting rx_max = 16384
> > > [785963.017169] cdc_ncm 1-1:2.0: setting tx_max = 16384
> > > [785963.017682] cdc_ncm 1-1:2.0 usb0: register 'cdc_ncm' at usb-0000:00:14.0-1, CDC NCM, 00:24:27:88:08:15
> > > [785963.019211] usbcore: registered new interface driver cdc_ncm
> > > [785963.023856] usbcore: registered new interface driver cdc_wdm
> > > [785963.025461] usbcore: registered new interface driver cdc_mbim
> > > [785963.038824] cdc_ncm 1-1:2.0 enx002427880815: renamed from usb0
> > > [785963.089586] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> > > [785963.121673] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> > > [785963.153682] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> > > ...
> > >
> > > This is about 2KB per second and will overwrite all contents of a 1MB
> > > dmesg buffer in under 10 minutes rendering them useless for debugging
> > > many kernel problems.
> > >
> > > This is also an extra 180 MB/day in /var/logs (or 1GB per week) rendering
> > > the majority of those logs useless too.
> > >
> > > When the link is up (expected state), spew amount is >2x higher:
> > > ...
> > > [786139.600992] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> > > [786139.632997] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> > > [786139.665097] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> > > [786139.697100] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> > > [786139.729094] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> > > [786139.761108] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> > > ...
> > >
> > > Chrome OS cannot support RTL8156 until this is fixed.
> >
> > > @@ -1867,7 +1876,8 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
> > >                * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
> > >                * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
> > >                */
> > > -             usbnet_link_change(dev, !!event->wValue, 0);
> > > +             if (netif_carrier_ok(dev->net) != !!event->wValue)
> > > +                     usbnet_link_change(dev, !!event->wValue, 0);
> > >               break;
> > >
> > >       case USB_CDC_NOTIFY_SPEED_CHANGE:
> >
> > Thanks for the patch, this looks like an improvement over:
> >
> > 59b4a8fa27f5 ("CDC-NCM: remove "connected" log message")
> >
> > right? Should we bring the "network connection: connected" message back?
>
> Yes, we can revert Roland's patch. I didn't see that one.
>
> > Do you want all of these patches to be applied to 5.11 and backported?
>
> Yes to 5.11. Only the 3rd one really needs to be applied to stable kernels.

Sorry - I was thinking 5.11 was -next (and that's incorrect).

As you suggested below, only the 3rd one really needs to be applied to
5.11 and other stable kernels.

cheers,
grant

>
> > Feels to me like the last one is a fix and the rest can go into -next,
> > WDYT?
>
> Exactly.
>
> Thanks!
> grant
