Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888F45CE0B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhKXUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKXUft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:35:49 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3270C06173E
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:32:39 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id p2so7672679uad.11
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEpweZmRyj9Dpdnw8RH+QxQQsZV+p5F4X7npRbeyWBM=;
        b=obmQBDf5bdnDDwi7sFsbzVW5D9rCnpP6MEFJKRtlEWcKdDe5UtI8eI60+nboF7Xb68
         tm/ep3uj/BmHDGjrrFXvGtYhX4Z6FNS2TmflfvKsmD05oZz/ASXdTmyyoWpjoRKmySHL
         RZKv3wiBXOmE7/CX/tz5aT19ST3rPF/jb1DEfSNS6GeI3RwnGFi9Idq/n7939Ycv0dxV
         sXlfv11B1NSOxl5onbN8dZ/ApfQDEbWSEED8Hfx3Kwbb6Pvgg6AqM5Bl0toMLvkQbE/V
         z0lgApOYOSmP/C8YX6XFucu9zrm+BD52hxm3ogBkB5HUOsNKpJUSc3kHCzNgpDtV7b9n
         ZR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEpweZmRyj9Dpdnw8RH+QxQQsZV+p5F4X7npRbeyWBM=;
        b=z8U+z5IC+PBJRHvLnLmYoVfX1UPInF3tSRMYnN9k2MH1+8XGEvJSG8s4hCvvGWWqmJ
         /VfHIuBS6rR5N/u+Ikr6Upped9fygZUWONJOgguHfjoafXJQeSjxJfoEV79KuBRQYQvq
         LjCAtClNuinAO0l1IQsc6Ugs2AjvCk9xR3RgLI3PytFaDqhu1ZE1Nd6BttPv8Qwn4cck
         OVz4iIS8jU0MjqCL0sdzKtcpbBeGYOLp3iLz59KWLT1JDw2BsROx2IJ3Y6oT49GNpYcp
         XxSpqeKEymNg/gA/egN9zGrMi8XXyybcTSdCC4q6XxWkYoIauSGFMH5meJtEI5B30R6V
         5Adw==
X-Gm-Message-State: AOAM533mm1RSCrRbOY+zVtIz9+mFfltk/6tgDOJO1zKdibGUwbFhEa8b
        nDa70+E5PNxcJ28liOs4Xq326OGlQTEyFbgvNBRXhQg5VK0uwf+JqUU=
X-Google-Smtp-Source: ABdhPJyJeMUmzG9JTw+rue1p/xnLkaRSSOEmVApftthWhjtif11uRe6PQNQ4ayz7hacq73ahhW0CIVOk5cK2YZH1tVI=
X-Received: by 2002:a67:ef4b:: with SMTP id k11mr1477241vsr.74.1637785958760;
 Wed, 24 Nov 2021 12:32:38 -0800 (PST)
MIME-Version: 1.0
References: <1637721384-70836-1-git-send-email-yang.lee@linux.alibaba.com> <1637721384-70836-2-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1637721384-70836-2-git-send-email-yang.lee@linux.alibaba.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 24 Nov 2021 21:32:27 +0100
Message-ID: <CANr-f5yDK=voAX3q6S8dEz=wPBa78QaWVrVctx+YmXFz+oV7OQ@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] tsnep: fix platform_no_drv_owner.cocci warning
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Remove .owner field if calls are used which set it automatically
>
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/engleder/tsnep_main.c:1263:3-8: No need to set
> .owner here. The core will do it.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index c48e8ea..3d0408e 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -1260,7 +1260,6 @@ static int tsnep_remove(struct platform_device *pdev)
>  static struct platform_driver tsnep_driver = {
>         .driver = {
>                 .name = TSNEP,
> -               .owner = THIS_MODULE,
>                 .of_match_table = of_match_ptr(tsnep_of_match),
>         },
>         .probe = tsnep_probe,
> --
> 1.8.3.1
>

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
