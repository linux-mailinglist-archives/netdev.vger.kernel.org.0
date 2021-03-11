Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16A8337A77
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCKRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCKRGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:06:46 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8DFC061761
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:06:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ha17so3010165pjb.2
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3BaAUXKM5qmSJ7940UEU1xJ4TluyNCp4PSxxj53kDg=;
        b=ny5cwkw3g2zRRtrm+uf/wRSBPIgP4TgrjNtnWW2wany289CJ8ewDMOUzjr2ZWQ4ZRS
         YoJHoAuUk3fXX8XWSzWBRKTXB5spI9mcN/lUPohrrjb1h0qEPx8sqjdKEerm8cZXQq4/
         wfRPkhQgiGLhuJejGZjGQEbKPv46Q9OCvqIDtJ7yh/27CaWzYCUwv2EWRdYRWAEnH7BW
         SPc6p9NXeZtieBGs2C6f6p18dQvL10vgLbUWMiGivIMsng9+4UhCc6n3qZZBsg6Vfvne
         c0RCgfLOiqTyt/591cSdEDC7wNRr84dzLo7nx8fuVutP1aNWP+SPBo8L6EcOBMMTTAhz
         98xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3BaAUXKM5qmSJ7940UEU1xJ4TluyNCp4PSxxj53kDg=;
        b=OxN+hPkjvm6fZHbFBr724ZfCeB+Esc5X3HI0YJrL7bUWZ8eDMKmD6Sd/G0ntiDKUiT
         ri8H3O9iEmrCKCEz+nn/LAQlMc3ARlah9/ZGfUtCVZwvhHqtj89jHGK1V8cpFQg92oFd
         td5dv1zP9l4E6LGHN/Bxh/Q6oi5c592zP0OjQBat7Wv1ftBckF7rnIxkvAqgMF8A688n
         jM3ieQBPom+/1D90Hh1YVN8nPF5J2D4Emj40iMK/zxAv05t57i31vTAW87KmlC07/CoG
         uHyfFVShwiVnxCMQ/U2Yt5asvv6vsL1UXH52omSayUDf4wqS2uH9wNF+a0b6ztv6Bpog
         LRvA==
X-Gm-Message-State: AOAM532hMgZGQgumWA7zlWg4sbnnmWcO504aQPbXOL6EdvqofjgwtdpN
        RGyF3zaYKn/qooO7rn2xradxg4z+71KXLPAN+BeLdg==
X-Google-Smtp-Source: ABdhPJxLtJVoaCQ+Hy+PqYl1Lrz2ZKWrSXJsEVR+RomEnKh59UDPuVbbiOnU/IsIs4sZT4spP5GmtFc+imPcoiZr2k8=
X-Received: by 2002:a17:90b:4008:: with SMTP id ie8mr10220269pjb.231.1615482405656;
 Thu, 11 Mar 2021 09:06:45 -0800 (PST)
MIME-Version: 1.0
References: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org> <YEpJwsSy52HFB/IY@kroah.com>
In-Reply-To: <YEpJwsSy52HFB/IY@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 11 Mar 2021 18:14:45 +0100
Message-ID: <CAMZdPi82NpijmiAd2-Fku5ZzcrpZpDsi-8h9qgAu=Xz6VWVQhQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: Add a WWAN subsystem
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 at 17:48, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 11, 2021 at 05:39:05PM +0100, Loic Poulain wrote:
> > This change introduces initial support for a WWAN subsystem. Given the
> > complexity and heterogeneity of existing WWAN hardwares and interfaces,
> > there is no strict definition of what a WWAN device is and how it should
> > be represented. It's often a collection of multiple components/devices
> > that perform the global WWAN feature (netdev, tty, chardev, etc).
> >
> > One usual way to expose modem controls and configuration is via high
> > level protocols such as the well known AT command protocol, MBIM or
> > QMI. The USB modems started to expose that as character devices, and
> > user daemons such as ModemManager learnt how to deal with that. This
> > initial version adds the concept of WWAN port, which can be registered
> > by any driver to expose one of these protocols. The WWAN core takes
> > care of the generic part, including character device creation and lets
> > the driver implementing access (fops) to the selected protocol.
> >
> > Since the different components/devices do no necesserarly know about
> > each others, and can be created/removed in different orders, the
> > WWAN core ensures that devices being part of the same hardware are
> > also represented as a unique WWAN device, relying on the provided
> > parent device (e.g. mhi controller, USB device). It's a 'trick' I
> > copied from Johannes's earlier WWAN subsystem proposal.
> >
> > This initial version is purposely minimalist, it's essentially moving
> > the generic part of the previously proposed mhi_wwan_ctrl driver inside
> > a common WWAN framework, but the implementation is open and flexible
> > enough to allow extension for further drivers.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  drivers/net/Kconfig          |   2 +
> >  drivers/net/Makefile         |   1 +
> >  drivers/net/wwan/Kconfig     |  19 ++++++
> >  drivers/net/wwan/Makefile    |   8 +++
> >  drivers/net/wwan/wwan_core.c | 150 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/net/wwan/wwan_core.h |  20 ++++++
> >  drivers/net/wwan/wwan_port.c | 136 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/wwan.h         | 121 ++++++++++++++++++++++++++++++++++
> >  8 files changed, 457 insertions(+)
> >  create mode 100644 drivers/net/wwan/Kconfig
> >  create mode 100644 drivers/net/wwan/Makefile
> >  create mode 100644 drivers/net/wwan/wwan_core.c
> >  create mode 100644 drivers/net/wwan/wwan_core.h
> >  create mode 100644 drivers/net/wwan/wwan_port.c
> >  create mode 100644 include/linux/wwan.h
>
> What changed from the last version(s)?  That should be below the ---
> somewhere, right?
>
> v5?

Yes sorry, I've overwritten my changelog with my last format-patch,
going to address your comment and add that in the next series.

Regards,
Loic
