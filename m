Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FAE3073C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 11:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhA1KaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 05:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhA1KaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 05:30:08 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597E3C061573;
        Thu, 28 Jan 2021 02:29:27 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id s18so5675012ljg.7;
        Thu, 28 Jan 2021 02:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMLTIPyc/LiQ2bi7uEqiU4NDimPedT3k+buADRHwdTU=;
        b=QFePxmMTPUq6l/K2kvKuT5EUpnlXD+oMUphHFUWQphUh154VEiEKNgki2GaMRiCFPh
         2u1v1nC9swFExYJhcS/GzSu+SaQ38wE8qPaQKanwn6GfSKrX9bd2MeC+F0GnXxHipsOM
         Ldvv3CnWjpXEA0XLRAWLaDCYyK+zdYztlgb9fZOEEE6W9RisUGHLpd10PBfdlBNEjoLV
         y9fLucwUqTi9/kniAJHWUyd3Ak1dJ99kaWkPknEHlxiav4ya8ZAfMSau8rN4eETsEC4Y
         vWvWPpN1PwDkteAGMB5YRZ4f9YKLEgAThZPP+13eR+cNnJP/Vba/7lOcqpBTBvDBjCEZ
         JdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMLTIPyc/LiQ2bi7uEqiU4NDimPedT3k+buADRHwdTU=;
        b=RE7xD47nKA5UyYh3CXVBYeS+j9Mc2TJQ6HuCjnU/dTdpxzL8Ti0Lzgv5ksPnMQ78+I
         V32b5uQG9vsyM/7sh0pHWDpyfKa8ksK82hZHvXn9VAZv1o7AZ11/Xx6DijcfZ9uHaDT1
         /cTrGuKvO6CIfmVm/LrxxHk9dv2FtJkxMKHGyn6I2Jdz7/u5N2Je2pqT0jDHHsWhz7wK
         VXiq7Ywrh53XR7141RUguWma04B4FYq2Ix587PeatDpvkvP892nCCtevds/F9LXn+ANv
         R4G5V3WWaQ30oDBknK6Fxp+ezI7prR+dw8tAGsNHfBJNXFSeJtjmHVXNFL/mH4xMpNhX
         hheQ==
X-Gm-Message-State: AOAM531kpGIJm5/SYmlBTVk/4qIQmUTtuBjg6QhR45mWiWQfL10BoAhF
        WOarxVhS7wx7YH5u7f5SsG40s3dGyBJAGIK81yvfdJwSoLw=
X-Google-Smtp-Source: ABdhPJz1AmHnLn2KLgRF4r4Hmx5P13kWS8+cqvl6PWUGuwWzFvBAPV3paGe7pBeKMz9IdzvJVas6y7g+gElcNSvmvcY=
X-Received: by 2002:a2e:9b57:: with SMTP id o23mr8388781ljj.314.1611829765892;
 Thu, 28 Jan 2021 02:29:25 -0800 (PST)
MIME-Version: 1.0
References: <1611823636-18377-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611823636-18377-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 28 Jan 2021 21:29:14 +1100
Message-ID: <CAGRGNgWM=dQx4suXZJX+u6m0i4=Qx3hZFZWdWJ8VO+FG_edH2w@mail.gmail.com>
Subject: Re: [PATCH] b43: Remove redundant code
To:     Abaci Team <abaci-bugfix@linux.alibaba.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        b43-dev <b43-dev@lists.infradead.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ..... <insert name here>,

(No proper name in the from field or signed-off-by, as you're already aware)

On Thu, Jan 28, 2021 at 7:53 PM Abaci Team
<abaci-bugfix@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./drivers/net/wireless/broadcom/b43/phy_n.c:4640:2-4: WARNING: possible
> condition with no effect (if == else).
>
> ./drivers/net/wireless/broadcom/b43/phy_n.c:4606:2-4: WARNING: possible
> condition with no effect (if == else).
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Suggested-by: Jiapeng Zhong <oswb@linux.alibaba.com>
> Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 16 ----------------
>  1 file changed, 16 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index b669dff..39a335f 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -4601,16 +4601,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
>         if (nphy->hang_avoid)
>                 b43_nphy_stay_in_carrier_search(dev, 1);
>
> -       if (nphy->gband_spurwar_en) {
> -               /* TODO: N PHY Adjust Analog Pfbw (7) */
> -               if (channel == 11 && b43_is_40mhz(dev)) {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
> -               } else {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
> -               }
> -               /* TODO: N PHY Adjust CRS Min Power (0x1E) */
> -       }

I'm not sure how useful this patch is, even though it is technically correct.

The b43 driver was almost entirely reverse engineered from various
sources so there's still a lot of places, like this, where placeholder
comments were written until the actual code that would have been here
was ready / reverse engineered.

That said, I believe the driver works well enough for all it's users
and has not seen any significant changes in a long time.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

On Thu, Jan 28, 2021 at 7:53 PM Abaci Team
<abaci-bugfix@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./drivers/net/wireless/broadcom/b43/phy_n.c:4640:2-4: WARNING: possible
> condition with no effect (if == else).
>
> ./drivers/net/wireless/broadcom/b43/phy_n.c:4606:2-4: WARNING: possible
> condition with no effect (if == else).
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Suggested-by: Jiapeng Zhong <oswb@linux.alibaba.com>
> Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 16 ----------------
>  1 file changed, 16 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index b669dff..39a335f 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -4601,16 +4601,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
>         if (nphy->hang_avoid)
>                 b43_nphy_stay_in_carrier_search(dev, 1);
>
> -       if (nphy->gband_spurwar_en) {
> -               /* TODO: N PHY Adjust Analog Pfbw (7) */
> -               if (channel == 11 && b43_is_40mhz(dev)) {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
> -               } else {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
> -               }
> -               /* TODO: N PHY Adjust CRS Min Power (0x1E) */
> -       }
> -
>         if (nphy->aband_spurwar_en) {
>                 if (channel == 54) {
>                         tone[0] = 0x20;
> @@ -4636,12 +4626,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
>                         tone[0] = 0;
>                         noise[0] = 0;
>                 }
> -
> -               if (!tone[0] && !noise[0]) {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(1, tone, noise)*/
> -               } else {
> -                       ; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
> -               }
>         }
>
>         if (nphy->hang_avoid)
> --
> 1.8.3.1
>


-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
