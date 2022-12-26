Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE4D6561AB
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiLZJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLZJuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:50:22 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBF0234
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 01:50:21 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-417b63464c6so145224647b3.8
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 01:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fmF2cGQbBs6YMQ3a2rCQYqoYyMFkRZzG4KKzAOl4kLE=;
        b=bMQJ2p5T3B+1Eiwh0ozrHAFSKX35Q0vzPq3DrnZvLdIb6vM2G+ValqFymn66Om+Vhi
         28fT1dH1eW6Dty1ibjLTu6Log4QqlnXfUteW1cFNoHCdDvKwEIFMkk4v6w6tn5pzhd8R
         QOqlPlkTwcZ+vD/d9dAVA+vNDFQtgH/qlYGcjslLOYKQTxoZCo/d0HqUbVGJvXcLtKIk
         2vL7SubckkEa5dur+drIIMjALFcA6GcFWHU7e8zxoA+k5BTMS8AKwTLE8FznvyST0dMT
         RJk+3kpNSMjrF5R+pv615771wpwT+Nk+RWSJIz2y2BzdYh9DrPyJGOObh+wqYYoxp2Gk
         XuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmF2cGQbBs6YMQ3a2rCQYqoYyMFkRZzG4KKzAOl4kLE=;
        b=x14EbPVu4c8Wty8FAIoajalVQEVgSUUbCONoNYzwqSoUWAZ6o2kL0WqSIbCQCTxUT9
         p7cCf1tpT6t3vj0TAlBJPzNvR26iOBB/KWFOaHHXeIuCY2KNWUCERFXtjrJt9votvMBS
         X5Rx8i5R6YdNTswPFKtNeurh9USCh0GD42uIId4OO3f7J/77cEb3aO3Cxl8o2gxqsU5O
         gf6bhxgtEy3G4qw/JeXkYeKIbSb6GeWb0kd9yb/dNVS3A/I2VwzaNeee66ZJqdYPBcqI
         1gQMtDlOp4wqAOIf4grRyQIZdZQbM4zx7ksTPeln83ytVoNkfoFJOyQM9lSnjydtSfIK
         QEvw==
X-Gm-Message-State: AFqh2koavuwJ0P6DhFcTYR3GLN0WgFgzTCOxq65G40dpCtIE+UxuhnE4
        YlYG702qmbtte9aiLu8r2JdfbxFbIP5ltElKtpWOdg==
X-Google-Smtp-Source: AMrXdXvZTcC92hWOMbyIeK3dqSwaIggP+z9ZEXfdPvWXDfuzBL6uLz0bBSmiWglVMuUa1inps4rVFLku/JoLp2RZopU=
X-Received: by 2002:a0d:ca88:0:b0:3f5:7f7d:2d4f with SMTP id
 m130-20020a0dca88000000b003f57f7d2d4fmr2143854ywd.276.1672048220248; Mon, 26
 Dec 2022 01:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20221226063625.1913-1-anand@edgeble.ai>
In-Reply-To: <20221226063625.1913-1-anand@edgeble.ai>
From:   Jagan Teki <jagan@edgeble.ai>
Date:   Mon, 26 Dec 2022 15:20:09 +0530
Message-ID: <CA+VMnFw_aHNuPKrSeLy9P3ZngYdyHMtiyW+GxdNCEGRC0N_TmA@mail.gmail.com>
Subject: Re: [PATCHv2 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
To:     Anand Moon <anand@edgeble.ai>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Dec 2022 at 12:06, Anand Moon <anand@edgeble.ai> wrote:
>
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
>
> fix below warning
> $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
>                  compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
>
> Fixes: b36fe2f43662 ("dt-bindings: net: rockchip-dwmac: add rv1126 compatible")
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> ---

Reviewed-by: Jagan Teki <jagan@edgeble.ai>
