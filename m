Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9247C3B0A66
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFVQez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFVQex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8FE6128C;
        Tue, 22 Jun 2021 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624379557;
        bh=hjyVJnOdEZqzAPfZnyXpthZyL9vLhmDK9eAX7f4SQoQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XdvjxTh/x33tgyjeSua/WxHx6CX/Z8fbmROHPvKhx6FJzP/hbtyQwKgJjIxSzjBUV
         NJGmngW1Ozfv/U/ii8r2zU5iJr4E6sEjex3wOa5BxRWyn0HacHBv1W2TlSqGfuYoUR
         IuKMGX5HfsHxZpoGY5DLVqrTuokgFC1NgZhUaVpg6JQm+816lMizq85KLE5K43UIhJ
         3M1JU0knFUuVUtuskru7QwwybaoD8LdbmnYfvVECg4kdc63XOop/P4Rxqb5STf4qk4
         T4LuKnMYwOCfTIyku+U/a/x3wHy93j7nN7ojtZiW3r+BIO/f7npiKE4vR/M9twP5oy
         PoFaI/8ZM4SSA==
Received: by mail-ed1-f43.google.com with SMTP id h2so10999891edt.3;
        Tue, 22 Jun 2021 09:32:37 -0700 (PDT)
X-Gm-Message-State: AOAM5311Xmyk3RWUB08BleCBRh+Uh8lDl7yYXKWJMZsCaJ/9yW45c2T0
        z+VxJXeupj0+XJk5SSGVlsd7mrESaTJx9TwNKQ==
X-Google-Smtp-Source: ABdhPJxxQapL8PkfmPsjO1kcuZ+0y3MTO9HP7WDJgKLpAJgU2qC//3PcHqm3+2zb0zETxf1CxhTde9KtOEmqngcdge0=
X-Received: by 2002:aa7:cac9:: with SMTP id l9mr6175791edt.373.1624379556398;
 Tue, 22 Jun 2021 09:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210622134055.3861582-1-thierry.reding@gmail.com>
In-Reply-To: <20210622134055.3861582-1-thierry.reding@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 22 Jun 2021 10:32:24 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+0M5PrRHW51pD0-ZfsC_iHe4tHVD-ccfHa3gWsFM=SOg@mail.gmail.com>
Message-ID: <CAL_Jsq+0M5PrRHW51pD0-ZfsC_iHe4tHVD-ccfHa3gWsFM=SOg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dwmac: ingenic: Drop snps,dwmac compatible
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     =?UTF-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>, devicetree@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 7:39 AM Thierry Reding <thierry.reding@gmail.com> wrote:
>
> From: Thierry Reding <treding@nvidia.com>

There's another fix already[1], but I think your commit message is better.

> The DT binding doesn't specify snps,dwmac as a valid compatible string,
> so remove it from the example to avoid validation failures.
>

Fixes: 3b8401066e5a ("dt-bindings: dwmac: Add bindings for new Ingenic SoCs.")

> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/devicetree/bindings/net/ingenic,mac.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>


[1] https://lore.kernel.org/r/1624192730-43276-2-git-send-email-zhouyanjie@wanyeetech.com
