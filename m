Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19EF1270BB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfLSWep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:34:45 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:35222 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSWep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:34:45 -0500
Received: by mail-ua1-f66.google.com with SMTP id y23so2571868ual.2
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 14:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpboOSsAlEGLRQwjGYSM66BWhiuHg2YpYtx8W6AcQ7c=;
        b=v0Ee1MglQDxW/nV3ZAPV6ZkzzbCsYZIV0nkQgFwwyZqft+qKhyc3A1q60nRn2Z7v+v
         +95B1KXIZF/2xtIBsQ1tOTE7GRzYr/4TrZfiBdXZ5zB8gy66p+tgSf+4XUKrOzgjH6v/
         ooHr0OAn9QOrksN6K9LeN9e6zABJ2f9YqlzMemt6jRXPdZXZ+/p0PJMcPA8uZrsSf//G
         xGxQ00uYLa5+95NU76wVLr/ur4etzWC8MW6URrtdk26vGqrykglS4mGoSpjJpf3Xwl+H
         4IzyQzh27Z7ZUZI5K4msC5UqeOBLzLY56vfxIe5XMXM/tslMW5iRqK1vi+NlUnbfqAQL
         Fzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpboOSsAlEGLRQwjGYSM66BWhiuHg2YpYtx8W6AcQ7c=;
        b=BK5hOdeWHbl268RsvHkK6k82ZM19c7G4BXsQqftBskX8XAFw1ijxUajRE9jmCExiER
         j3ALfZcmRIPt8kFs82NSWo9eHTt11KiKKzqoy6HEvuSIx3cy0wH22A3CcvB90fRNbHXp
         bRR6UOu1MXOWE38oFCe8X6L7taljHEzIq7mCs/BCBWELShzlMzJ108Hw6sNRojC0frGR
         miaiVE4dYDGLYdhwOV91MWQVBay+VNUfzDWvlOR2snCDP5nCxcRvUXhM9rmddK7h2fW1
         I6uDSOrCoo4QNaFMKPfjijCuxFvO0SkXcSHKiv48YuXFwvuvslZs68cdMTiSxvvctuE1
         vLCg==
X-Gm-Message-State: APjAAAXKvLcXxXnyT+u3Nf9XUIwHMX3CXkpgdzv+lNIaRlBkBqpsGxRR
        hmObNhd7qv6DUAxfXIRYy4Thx9YKb4lKQBSE8uAgLQ==
X-Google-Smtp-Source: APXvYqwK+EshQqhWAuEP+FIGWSdW4fSf4XVcb1H0wkkA0gtNccGHWZPwmpTELUU72DjKZh9h2rxmwDp4F1Myi6CEF/g=
X-Received: by 2002:ab0:e16:: with SMTP id g22mr7016060uak.129.1576794884226;
 Thu, 19 Dec 2019 14:34:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576606020.git.hns@goldelico.com>
In-Reply-To: <cover.1576606020.git.hns@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 19 Dec 2019 23:34:08 +0100
Message-ID: <CAPDyKFoRe1Nzu74BACNMCZDVoS4Dd3w0Bk3K-Mstw4WAvMtiLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] wl1251: remove ti,power-gpio for sdio mode
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 at 19:07, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> * use just "wl1251: " as title prefix - by Kalle Valo <kvalo@codeaurora.org>
> * fix error handling: we still have to check for wl->irq returning -EPROBE_DEFER
>
> PATCH V1 2019-11-24 11:35:48:
> The driver has been updated to use the mmc/sdio core
> which does full power control. So we do no longer need
> the power control gipo.
>
> Note that it is still needed for the SPI based interface
> (N900).
>
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz
>
> H. Nikolaus Schaller (2):
>   DTS: bindings: wl1251: mark ti,power-gpio as optional
>   wl1251: remove ti,power-gpio for SDIO mode
>
>  .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
>  drivers/net/wireless/ti/wl1251/sdio.c         | 32 ++-----------------
>  2 files changed, 4 insertions(+), 31 deletions(-)
>
> --
> 2.23.0
>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe
