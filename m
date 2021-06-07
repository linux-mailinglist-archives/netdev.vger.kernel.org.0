Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4388839D6CD
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFGIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGIMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:12:05 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3D0C061787
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:10:13 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id bn21so20999760ljb.1
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 01:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFm0dzV1rxyymG1x9+b3biG2kx5e317PTQKCNEoutCQ=;
        b=glHZhLz1R6c51WmXVF1XClc9Rz0NQvEeCy5xpkih86MTpEQKmhYHYXcoTLQvRKxgPX
         YLka3TIohf1coxqIz3itfoP3QmK1/ULeC6doPcLEKfqI4obE3LwuSNoJPZKGkZxd9daX
         kK65Eal65LnkYXlNg1Mwun+w2S70cNM7kQcDr+3HWp01MQwXHqH9ImRUPuHCS5d32UfO
         HEmjox+N+/3dZegYvXccl3+ejXCMGLqjrbITQIbqXWVWUSH1OOPF8eF7ebtFzHjAQe0r
         IzFJhPJ7ndvwvbTQxgIbc/UFWTsY+QRm5YIHTV81bvf73h2IYvDNn16+gXbc8XjWZcJ3
         CTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFm0dzV1rxyymG1x9+b3biG2kx5e317PTQKCNEoutCQ=;
        b=IGDLkUSLhgRdtO3RtK8/5PeiNZH4xunzVm3eXuvgj6x34Cfxy0AIsJFTBGQVD7Eghi
         +t+pbTENETxE06EjasMg+W4MRz5iqe55uIv70gy5z+bNEbtdNzkG7rbap2wIdrt6FJ0q
         hYHWsdTaDMxk2baLoO6npvg1Ztn7QB/aqz3joYXOgEE7JzNBR+gsR2vwdX7t+K1QoBKk
         7j4sZiQMvXSCIwbA4bEPW4kUGtgM7xJ/XCOvunJw9dr36hFW9FcjTaDmB+IwUSxnw/Or
         45MPJV60nVrwAJ2z8srr8/esFjVIQQqz0hsHrzqpZMcauXpPPXWvdwPKygihFCSM0EA2
         zf2A==
X-Gm-Message-State: AOAM5334Gx4nXPq12p34QtuHUEkD8lEhoBI0HK0NOXCQI63syGXyFDuJ
        FVdYrrQjnl/Od5cNhRgce5YWhiZQIqDAE2W96AZDdA==
X-Google-Smtp-Source: ABdhPJwqI1MBFpKXCoH9g8iKyng0T9Fa/009mVPR+5u5x/F4tSdgGaxIoWEB9DKXPa/kIHk6QLVHZwYWXvGJF3J0Qhw=
X-Received: by 2002:a2e:7811:: with SMTP id t17mr4349895ljc.368.1623053412251;
 Mon, 07 Jun 2021 01:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210607081145.1617593-1-yangyingliang@huawei.com>
In-Reply-To: <20210607081145.1617593-1-yangyingliang@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 7 Jun 2021 10:10:01 +0200
Message-ID: <CACRpkdbe7psaJJfwTsp9miQuDqEtWrd5TB92uso2Wp1eryyh_w@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: gemini: Use devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 10:08 AM Yang Yingliang <yangyingliang@huawei.com> wrote:

> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v3:
>   remove netdev_info(...) in gemini_ethernet_port_probe()

Nice!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
