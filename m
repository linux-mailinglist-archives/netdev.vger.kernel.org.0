Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1674B2F0C8E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbhAKFhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAKFhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:37:17 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4825BC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 21:36:37 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s26so35984291lfc.8
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 21:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUitB2s/P2Q+oLa/PQ0Pns3QMzw5mq8PivopfAU6BAM=;
        b=USW4pOwkhvViVdmuAqHSnJn+t5NUWRsNcELLqv6iwmTx79p/b6/TtV6hmaOUclzSbb
         vVbkV4BCKmCmgJVVRjwQtovkdC5Cbix7L9Jy5Mo3ZNQFgA9cwZyQSiwZmhI2m3cGRGGs
         FCq+5YDbaFeoCR3OYcet2Z0oS9J6ygl+ytDZXQEULnXQkkX3JNN355aer+OP+WSjESQG
         r5sLomYf1gfr5zMhgg9KKHMmT2lT93WmbMTIf+8rDukgWvTiRPbt8VZBKSZJp4wuq5d/
         DgAg/9QYEdwcJ6Tz9flHPyBjGskRgalPRD+D/kpdiGp6CKbF8u+Fe7xj9hkyKU7d+yTQ
         OJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUitB2s/P2Q+oLa/PQ0Pns3QMzw5mq8PivopfAU6BAM=;
        b=pZ5xK2bqK0D0Zb5Ta9GIya6YVX35TsyENij0qID3eIIdQAi3pwD1/EOVHR5J7A/6YB
         Byvof+rMezum8lAQYu5fAVxxcdEPRKIKVSSaakJs9TwliZsNfyRnSUSOOiFdKUxpNZ97
         ptUkn9e70+FqSSdq+mwyxmqwcQkvsr4QmW8PXjKwQNwa1w8L1/y7n4QLRE9RwoplY357
         vcCNHjb+yCBx3ZCJZFl8ejKMzJpfbzQvHZz0I890EtJ9EZ9L3FEG3Fciz5yG1J0GD9jg
         /Wmuo3FLWBymVT639trWcJCO6qXJ0lEwhVCyP4rIo4x8vgK/5X7//k5mExLAs2qmv9eS
         jOkw==
X-Gm-Message-State: AOAM532PLjAOAg4SF7nSeSrCkrXNVjULq5jyJQTfK+yaqHodtqqUmYoE
        iIzC/uu06TzuXYP0svhl9AzdCJkSKGKCTs3pfPU=
X-Google-Smtp-Source: ABdhPJw86kdB4+MSolVrk4iLc3lZNP7RHXIRsfIiqJyZgayET2zhWeE0Amt2OSmsMJEepfXzYltXH+9rGaAEfbXbDck=
X-Received: by 2002:ac2:5979:: with SMTP id h25mr6463656lfp.57.1610343395825;
 Sun, 10 Jan 2021 21:36:35 -0800 (PST)
MIME-Version: 1.0
References: <20210111052759.2144758-1-kuba@kernel.org> <20210111052759.2144758-2-kuba@kernel.org>
In-Reply-To: <20210111052759.2144758-2-kuba@kernel.org>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Sun, 10 Jan 2021 21:36:24 -0800
Message-ID: <CAMXMK6uWAmghRw-G3P=315iZyQO+HaELUB_hQ1E6rVLGfVG6Hw@mail.gmail.com>
Subject: Re: [PATCH net 1/9] MAINTAINERS: altx: move Jay Cliburn to CREDITS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, corbet@lwn.net,
        Jay Cliburn <jcliburn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 9:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Jay was not active in recent years and does not have plans
> to return to work on ATLX drivers.
>
> Subsystem ATLX ETHERNET DRIVERS
>   Changes 20 / 116 (17%)
>   Last activity: 2020-02-24
>   Jay Cliburn <jcliburn@gmail.com>:
>   Chris Snook <chris.snook@gmail.com>:
>     Tags ea973742140b 2020-02-24 00:00:00 1
>   Top reviewers:
>     [4]: andrew@lunn.ch
>     [2]: kuba@kernel.org
>     [2]: o.rempel@pengutronix.de
>   INACTIVE MAINTAINER Jay Cliburn <jcliburn@gmail.com>
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Jay Cliburn <jcliburn@gmail.com>
> CC: Chris Snook <chris.snook@gmail.com>
> ---

I'm overdue to be moved to CREDITS as well. I never had alx hardware,
I no longer have atl1c or atl1e hardware, and I haven't powered on my
atl1 or atl2 hardware in years.

- Chris

>  CREDITS     | 4 ++++
>  MAINTAINERS | 1 -
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/CREDITS b/CREDITS
> index 090ed4b004a5..59a704a45170 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -710,6 +710,10 @@ S: Las Cuevas 2385 - Bo Guemes
>  S: Las Heras, Mendoza CP 5539
>  S: Argentina
>
> +N: Jay Cliburn
> +E: jcliburn@gmail.com
> +D: ATLX Ethernet drivers
> +
>  N: Steven P. Cole
>  E: scole@lanl.gov
>  E: elenstev@mesatop.com
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b15514a770e3..57e17762d411 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2942,7 +2942,6 @@ S:        Maintained
>  F:     drivers/hwmon/asus_atk0110.c
>
>  ATLX ETHERNET DRIVERS
> -M:     Jay Cliburn <jcliburn@gmail.com>
>  M:     Chris Snook <chris.snook@gmail.com>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
> --
> 2.26.2
>
