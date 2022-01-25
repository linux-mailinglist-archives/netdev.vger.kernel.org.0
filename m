Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816ED49B1D8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356089AbiAYKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349031AbiAYKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:23:45 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770D3C061769
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:40 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r10so30783784edt.1
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLx/YZxDfavcDLwOxOrS4Rl7DmDxsfuNzODHqKOrfoo=;
        b=Cjqz4sGxayNEsd0GCR1jIVFD74VKC0x8YraruTsPgfOND0X2ETqMAY5JFiAndZytMK
         0vWmsJ53n+ZvUBJ3THnVnuegNLujOvRJ29cpo2wrGGfM8IQERsbvLPSZiYtebktMEAn5
         lP4jhdLT8I6R058mj/Du1FEwceKZtriaaoFWBjgHNetNGbwpeYOOaoejqlsvMPTluJ1s
         GXo99p08y6lcBEFNTXa1xW9tOutTgBKBPjtYtWR07W0Po1E6UtwB4+yK1qFE7VBu0zZb
         oeGW+7rDQoZJAaz1/vKmRlOwX/BY5VXWFd7/lA5BGJtxewlQ/lFI6jGJN8S3rK+UMm4E
         15FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLx/YZxDfavcDLwOxOrS4Rl7DmDxsfuNzODHqKOrfoo=;
        b=eIr8QHLtN2UWi7lymOY283LW4iKPBfEsjvSYxB/SNygyhXeUDNtqsy72IRxC/LJdpX
         CsaXGJ3ONkwekNGRCu/Igf5nieXWwZrxKVobUL3Io+sRuEZEYqk3+uUy664atg3ccNIY
         qfpIbnMWUAvRrsrnEq997/wdAjDt6hl5nsfVkRsktjQT9tSkrU0FHzw1Xmr/ZoyKm38T
         ybt2Og7hzXNM83KH6mMg5HQ5RZxCkDOQoCAb5UPP1G220jjyPHfZvmLWo4fkiMfRzj5d
         CSFeEGqJkqyPRrqoLfkPqpz8YPrj6UZ6Hla48L9TvFGi5DbXgRfeMcRiW8MKYZR89oBl
         dVDg==
X-Gm-Message-State: AOAM530TjSxr60+4z3fwgUbUP/+MDkNGZ2Zrg25+la0PYusuolTkrnrE
        o847y0Pr8w7MlY15soWw61TGEjMBNGypcKYFQrNLkw==
X-Google-Smtp-Source: ABdhPJzA60Ix8HB8puuXpcFij81WpZZ6sgSvskX6fLo4WF6+a1KQnXgq0MrdYEc7H/MvpVAOfZCSBG9y4O425dVnhbw=
X-Received: by 2002:a05:6402:1604:: with SMTP id f4mr19778138edv.352.1643106219001;
 Tue, 25 Jan 2022 02:23:39 -0800 (PST)
MIME-Version: 1.0
References: <20220120070226.1492-1-biao.huang@mediatek.com> <20220120070226.1492-5-biao.huang@mediatek.com>
In-Reply-To: <20220120070226.1492-5-biao.huang@mediatek.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 25 Jan 2022 11:23:28 +0100
Message-ID: <CAMRc=MdVKdXcK0gdBSpaaSm5fx1o5Sy_0-JJBPK0=Xp7UmQnqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/9] dt-bindings: net: mtk-star-emac: add
 support for MT8365
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        srv_heupstream@mediatek.com, Macpaul Lin <macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com> wrote:
>
> Add binding document for Ethernet on MT8365.
>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/mediatek,star-emac.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> index e6a5ff208253..87a8b25b03a6 100644
> --- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> @@ -23,6 +23,7 @@ properties:
>        - mediatek,mt8516-eth
>        - mediatek,mt8518-eth
>        - mediatek,mt8175-eth
> +      - mediatek,mt8365-eth
>
>    reg:
>      maxItems: 1
> --
> 2.25.1
>

Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
