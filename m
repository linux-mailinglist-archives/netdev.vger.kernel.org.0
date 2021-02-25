Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750A83252C5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhBYPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhBYPxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:53:30 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF6C061574;
        Thu, 25 Feb 2021 07:52:49 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id d5so5327124iln.6;
        Thu, 25 Feb 2021 07:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsCApT+0OPFoE3ROrRo+DSU87MH0YEGSL+XXuxp8A9c=;
        b=mgv1TpTReZh9GJn/RTX5tz9dYXg0uGIIww+Mqex2jJ+dwIler9r6R0KH0Phg5kF4W1
         1HJ3D+8NuIx8QDA9B8J7RlgErDasp+z7vrTDF22fMsWTK3ckVwNwbjeqvDFr+eEVliPv
         oFqRAfoWWvvs/WmgjY9nXfp1A20u8bZp2jdEq+4vUgSVwUsRGqaqL7zkSoMmk6i9wyH0
         qVSTvdaVzdgt/rrFm/ehS6b9yDWpzSkklmMywV2a1fMsd5p3PrJHGa1BJFCUjiPhtVQd
         +wwdsycODpqATxEMd69r9yWYl6Z9V5YGZmY+1Jlg1edo47lKhl7AgT2PmJu8wlZo/un9
         5NKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsCApT+0OPFoE3ROrRo+DSU87MH0YEGSL+XXuxp8A9c=;
        b=HjVvJguvLuFqYB8wuo3d855ttha0geneW64kFV5LEwfXPEbcSGFtblNinERY/rfBTA
         sGmGgP7alzwq137jEAmGEaVtHihNbX4okcFwI215h9TdbrTvo0qkAJqP+Zxnrgyl8MHu
         D22Y/eJOV1eqg/8gTO0ehZ5k1VbvNe33oLoIxuKERF6kXTyssTkpsIOvRjWWPygCugyh
         W27Bkw6/kEFGa0tcqI9vOJRzIYSUbyvW7AmQFSXtB39FSXROxSjhestfzm9HygM7d954
         B1a1f+bIM20EK3wcg8VsYktOsUxgXIWV440oBWVlq+LP6gKTlrrQvSEnNkAJx2pkUoCw
         8GoQ==
X-Gm-Message-State: AOAM530S0GTXmoQem3KrPYZdDIcqbXGOom7KrJS5Ktl/RuVHua3+wVAu
        zgEwnRHyIrZxVs9pObHHx7wc5ZBKws7PouTF8Ik=
X-Google-Smtp-Source: ABdhPJxy6DtwL2gnt3tnBfK+sTM7BA9g64tcMVZFI4TZdoUF+rGKdz4YyZc0+KdqS2ql0Vm3Fj4mO8BI4QmqtqPYQ1A=
X-Received: by 2002:a92:cda4:: with SMTP id g4mr3049862ild.20.1614268368748;
 Thu, 25 Feb 2021 07:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20210225143910.3964364-1-arnd@kernel.org> <20210225143910.3964364-3-arnd@kernel.org>
In-Reply-To: <20210225143910.3964364-3-arnd@kernel.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 25 Feb 2021 23:52:40 +0800
Message-ID: <CALW65jZPQm88CDa+bvkk-EJGfyV88hRV=MSOjSt1Q5UxD8xrog@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: dsa: mt7530: add GPIOLIB dependency
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Feb 25, 2021 at 10:40 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The new gpio support may be optional at runtime, but it requires
> building against gpiolib:
>
> ERROR: modpost: "gpiochip_get_data" [drivers/net/dsa/mt7530.ko] undefined!
> ERROR: modpost: "devm_gpiochip_add_data_with_key" [drivers/net/dsa/mt7530.ko] undefined!
>
> Add a Kconfig dependency to enforce this.

I think wrapping the GPIO code block with #ifdef CONFIG_GPIOLIB ...
#endif may be a better idea.

>
> Fixes: 429a0edeefd8 ("net: dsa: mt7530: MT7530 optional GPIO support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
