Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40D339C96E
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFEPTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 11:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEPTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 11:19:48 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237EC061766
        for <netdev@vger.kernel.org>; Sat,  5 Jun 2021 08:17:48 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f11so18511561lfq.4
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 08:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZnFe/YPkagTwcuo6+qZIKKsCGRjyloxniZLJsXubJw=;
        b=QchpKmlTMdYVfzB4+RCQf/u3zr/bhQ5zBYpwpBROhpQjG5sTgbJOyI/v8swbAF5Myl
         zuWsLsK1LdCr3gAYujwSbr77aQPYQYWfazK6qhC6Y/m1uzGa6WE/sRZ1zzDVW9bHaPQj
         QozKFmsjqd/jRWeEyXrday1ChQLvEJOxTGnkHkyzx8MehR0DP/1I8gS0K+m3GiR9SJaU
         x3XlXc629qCNu1MXKVVKQfVlKVu4kHH+nothQtgm2rCY8YQDwSAPTOwGYazkZLh5r3R2
         p1DfrIn6JQoGlWMxeKl/kTKLpw5arhJPY3CdKOMq+PIrgt0mUTknx98tA7BeAziN1o5A
         9k9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZnFe/YPkagTwcuo6+qZIKKsCGRjyloxniZLJsXubJw=;
        b=Z8PdzeHgu+i2i1Z9+27boajka1wlYRKAJASz2TmCTA2g8Sq+S8xMY8YRbNu0RP08KC
         S/OLCbXA9v+8DttSLbJm17gPUAuTF/6f+ovS2tRaRcNvBReYVf6Pj/hfymjUSXYzK5Pk
         Pe7CsMxmhBloF1cVhQzF9MFeNuEBU5mF/DakaRo1/+voGEOnQ3Nu3miofudRXTy7sG3y
         oKvAH+RkmTXYpKjLsiHkbvpECwN+TTaNlOBQlQZP1YciCR3AWxqqOCLmiBoisxepvHEL
         ymtieDjDa8zKq3RFy7SfTU7pZN6UqqpSMXo1+gJYtkDjShn3uvQ6T/m17YnsQ2FzvfWA
         ZSuQ==
X-Gm-Message-State: AOAM530Yc7PI8+R3kFDc4GmPNLBJukExE/n/hti0zvNg33dvGDk/f7au
        f/pBcwJ9lr+LXHKxCnlQasG8yn/MQGi4vBdBWNbkq7V/yEg=
X-Google-Smtp-Source: ABdhPJy2RU2ANSqGxvNcpJx5nyiCZ/gsiRuRmAEhi9SMJ1hnSjkVHHIGoaxD+IUsSAZ3phSXJRUMLKhwxkblqc4D8tE=
X-Received: by 2002:ac2:544f:: with SMTP id d15mr6108972lfn.465.1622906264687;
 Sat, 05 Jun 2021 08:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210605123636.2485041-1-yangyingliang@huawei.com>
In-Reply-To: <20210605123636.2485041-1-yangyingliang@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 5 Jun 2021 17:17:33 +0200
Message-ID: <CACRpkdZi-W-vnCH05C4CkQdnYtUKuD4NWoBTh8hGXmok_=Dsfw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: gemini: Use devm_platform_get_and_ioremap_resource()
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

On Sat, Jun 5, 2021 at 2:32 PM Yang Yingliang <yangyingliang@huawei.com> wrote:

> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
(...)
> -       dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);

Should you not also delete the local variables
dmares and gmacres? I doubt they are used
after this.

Yours,
Linus Walleij
