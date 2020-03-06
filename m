Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933B417C2BF
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgCFQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 11:18:15 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40555 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCFQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 11:18:15 -0500
Received: by mail-qk1-f195.google.com with SMTP id m2so2794269qka.7;
        Fri, 06 Mar 2020 08:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wyxwn/uIvwvwuo/CHU7Bo2juetQK83mXPdvKd8qe8K8=;
        b=GlOQ0NIqwiOm7KiuNnvyD7fTW2tuSulcPgG3SsZbeGr9bylPN9ZDoKIwHHWa8Cnjyt
         Hm+hbJ+vmOAc/7hnqvl+SrIwLGggNzLO1IbLM6JamAKKoEqcArY5RR7y/G5xK2UdPt09
         RkpKX0RXkF87e/3QSKgXdGqw7ZOlrtCcSjdGdI9vkJAGCzZxoIDh/Ct71cxCtZvcxQyX
         cDI6dK+lDS+yn6B5kz+4rNx0x/VzQuAy1PvN9sGEiFlb72ofLgceUCyvqIrI/Yv7FFbo
         7r2gdVHyq2XRWAcNP1kFuBMYOtwwsLKPwciQCaH5sRKyuuokEv/sU+XtTcc/Gj/+eVaB
         wkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wyxwn/uIvwvwuo/CHU7Bo2juetQK83mXPdvKd8qe8K8=;
        b=Tz1nEZF6D2rL1cLQUMOEVGZJN4cu9+rM9TYeYU3g3VNoNsEV4lGgKtC0JsZ8oSP9e/
         FMAP7CTv8tnXIJ2jxu0UXoz5P8AXNz68wJscbBLrYCJHjlPzleJuECtLkXCKdfCqMpvY
         2abHhuDjazKvJP3ONDVswbXWUax2O8SDmlKbb+TDxpkLKC7zYOEp6EracFj0UGMj9Ip2
         7FMvKSomR5s+7YJawLhUMZd9obn5auLuzhEheASFY4oQMQBgULrsOmUhFxyCgNhtNCfI
         gCMGsjJP4hiu0KvOBwcI6tYNMl+qg9dLbmm+BX6Ct/e3UFoP5ZThRuKkLqWP5iMAQXCP
         1m2Q==
X-Gm-Message-State: ANhLgQ2kG49ZHcOriZnld/YE+BpTrS1HIml2xopSLvT1FBB/n0WuUd27
        sMrZF0yC7r4rYGLx3UaKf4hOqI6C6TSZpxpHL/E=
X-Google-Smtp-Source: ADFU+vvKiiWABJ3Vloba0QXY19bkGGVHSjFtCJH0c8cNpcKXPBZWAlxkVBdq4sU2A5urbWQaO3xSUUe5T0M4KjXbKio=
X-Received: by 2002:ae9:ef06:: with SMTP id d6mr3743182qkg.442.1583511492528;
 Fri, 06 Mar 2020 08:18:12 -0800 (PST)
MIME-Version: 1.0
References: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 6 Mar 2020 17:18:01 +0100
Message-ID: <CAGRyCJGMxMO-8b3QniJP0XVgTT4zxSd=pm_O=4T5N3f3H3aM2w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Migrate QRTR Nameservice to Kernel
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mani,

Il giorno gio 20 feb 2020 alle ore 16:15 Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> ha scritto:
>
> Hello,
>
> This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice from userspace
> to kernel under net/qrtr.
>

I saw those and the MHI driver related patches, thanks for doing them.

Are you going to submit also the controller and device (uci, netdev)
drivers for SDX55 modem?

Thanks,
Daniele

> The userspace implementation of it can be found here:
> https://github.com/andersson/qrtr/blob/master/src/ns.c
>
> This change is required for enabling the WiFi functionality of some Qualcomm
> WLAN devices using ATH11K without any dependency on a userspace daemon. Since
> the QRTR NS is not usually packed in most of the distros, users need to clone,
> build and install it to get the WiFi working. It will become a hassle when the
> user doesn't have any other source of network connectivity.
>
> The original userspace code is published under BSD3 license. For migrating it
> to Linux kernel, I have adapted Dual BSD/GPL license.
>
> This patchset has been verified on Dragonboard410c and Intel NUC with QCA6390
> WLAN device.
>
> Thanks,
> Mani
>
> Changes in v2:
>
> * Sorted the local variables in reverse XMAS tree order
>
> Manivannan Sadhasivam (2):
>   net: qrtr: Migrate nameservice to kernel from userspace
>   net: qrtr: Fix the local node ID as 1
>
>  net/qrtr/Makefile |   2 +-
>  net/qrtr/ns.c     | 751 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/qrtr/qrtr.c   |  51 +---
>  net/qrtr/qrtr.h   |   4 +
>  4 files changed, 767 insertions(+), 41 deletions(-)
>  create mode 100644 net/qrtr/ns.c
>
> --
> 2.17.1
>
