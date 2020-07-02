Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672242120DD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgGBKTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgGBKTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:19:41 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1EBC08C5C1;
        Thu,  2 Jul 2020 03:19:41 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id p6so1677402uaq.12;
        Thu, 02 Jul 2020 03:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4U7pwdobnpXo2+wodK7ksalwXz6Csu9FNbhdoHm2mYM=;
        b=XMx/fc3xmJqXwVmTNjgMsBz83N0C2Kq3cIcO/pJWjkhn7tOUwBn61bA4t7caSbjr5I
         dAoMZyZV68ybxMK5Dx8DFoKV3BaQ7/Ot699//UXl4XINrvz9z6/cXIcdLw+KRcorqTWK
         /APWX4fp1ugr4nQN1i3vMDdfjC4Hz+SFcGfzSNjARGAqMHNjEKTZTHGWnt3yphz2P1Js
         OeXra52huDYRiUEiIq8vbwl1W4nu9WvZ9dmApJe8I76Dl9I3sQXfCJsfh5DoJBMWchqh
         v5XwC4e1U66nUFk0IY1mNlZ870ZSYK42CMJsatPe9nEwETUpb8hcTVFFI2TdXIopVPzA
         NF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4U7pwdobnpXo2+wodK7ksalwXz6Csu9FNbhdoHm2mYM=;
        b=YakHpMNDt8curYE/qMvPrbs2JNxTmPgrM5mpg+XwEeGUhVOQy/p+LmZRONnG/k4iSf
         M5/aPIL7CywmO0d40aU6qYaFuJGasa4yIj5baQ4J/1ZF3c52KAdieNCZzmhArMzB5tjR
         IzZS2eSctkcooVVWHHB3Q/57+V0IB61wEug/98iTk0soQavHThqHcyuEVX1eQitmDoit
         B6GQFojFevneOJgKvVe33FN+E/EqWeJpxxglxnOmq48FxuxzZpHuOE1B4xE+GMZZPTLF
         SlA2zos3NJj9oeYIz+FMEYuPH0UNS8+9PbAKuBt5KhuBCaayjRrqHdu7UqyKJFRB1r+x
         43ZQ==
X-Gm-Message-State: AOAM531d0ymwmxwYbEi+Upwgr5Nr9f6e4HLRlnv5LAgWsBfj4vZQ0l6Z
        EFBpmRRe8mAMhi2qJ2AuAQxFFjMqg1Nv97HZDac=
X-Google-Smtp-Source: ABdhPJwMf/Kv5n2Q9kIIKesJRBtlUU5WcGzuyUHA2ORibg+smZ2ST2LjLE1roKk1U7HOvOfOfzx5ebAkOEZSoX7OhRQ=
X-Received: by 2002:ab0:2a46:: with SMTP id p6mr4105124uar.88.1593685180856;
 Thu, 02 Jul 2020 03:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200702091810.4999-1-weiyongjun1@huawei.com>
In-Reply-To: <20200702091810.4999-1-weiyongjun1@huawei.com>
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date:   Thu, 2 Jul 2020 15:48:01 +0530
Message-ID: <CAP+cEOM1tExZzxnkdtX9w2ZyPoFTJ+JxQw+q=ErWM1JJJc8w7Q@mail.gmail.com>
Subject: Re: [PATCH net-next] ksz884x: mark pcidev_suspend() as __maybe_unused
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        zhong jiang <zhongjiang@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Julian Wiedmann <jwi@linux.ibm.com>, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 2:38 PM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> In certain configurations without power management support, gcc report
> the following warning:
>
> drivers/net/ethernet/micrel/ksz884x.c:7182:12: warning:
>  'pcidev_suspend' defined but not used [-Wunused-function]
>  7182 | static int pcidev_suspend(struct device *dev_d)
>       |            ^~~~~~~~~~~~~~
>
> Mark pcidev_suspend() as __maybe_unused to make it clear.
>
> Fixes: 64120615d140 ("ksz884x: use generic power management")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/micrel/ksz884x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index 24901342ecc0..2ce7304d3753 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -7179,7 +7179,7 @@ static int __maybe_unused pcidev_resume(struct device *dev_d)
>         return 0;
>  }
>
> -static int pcidev_suspend(struct device *dev_d)
> +static int __maybe_unused pcidev_suspend(struct device *dev_d)
>  {
>         int i;
>         struct platform_info *info = dev_get_drvdata(dev_d);
>
This is a necessary fix. Thanks !
--Vaibhav Gupta
