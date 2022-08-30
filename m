Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9F5A6019
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiH3KDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiH3KCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:02:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35EAB423
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:00:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i188-20020a1c3bc5000000b003a7b6ae4eb2so4644032wma.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0b21QXH6O+BTSjJFC+3rM4trmoZDQJp1tN7KcWJ7AWo=;
        b=bj2skJMvdzjz078Ov7MeI6BrC+N8Z5RAt9LSxeTNWaAnfcX8+MsUHuhMzu6Zr43jXl
         5eYhsEw9px1Nr+tnrxEsaTOoR2yVUPieVwxjNScLwOhaMlJWU4hQBD6dhxYJMR8uOcor
         vVG1GtsCq7uf6ByVQ9ZNo6fepvO8/Ok3rtJfuXaSI2CHFZZn/04ojSlQQRVWucmrnauV
         2Htia78+PAK8OqN2EiI+gwGHBBnlaQ4BKEz1X6+7kjG725Bx1m5INH+w9BABmX2/EPhK
         1nv5lhnddkrwyEQHNAgxL4HnwjXIAiHaayAilECTJYlSW+2n2Ts92WPKc85Tb4391coD
         suTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0b21QXH6O+BTSjJFC+3rM4trmoZDQJp1tN7KcWJ7AWo=;
        b=UcnYzXSDp7U9lc2Aub4/V/by+O329qbQFdRB6bSjTRMvvygzTyX+NCHGo5FPhxb9IB
         M+Vfz1CVyA5Au9pDrMq6SH+wjE0z0e1l+ZdsKp6lC5KxOkcoB45wvtYAPmzoECxue7FE
         ebrBi7EG6hE07Q4UgA47pgr4NxphSgo88zwbMdV9zbFKs+WWQb2tkY87we9TTfNXxWLy
         ScqzTetsgDkveLLSu9ofqMmOMB4QLb5zhdwJ4+iIEd/u1srLizRYLMOiDLXzHdQtJbjF
         734v5j6Vs2evj1VP9KG6yM2dd3pe6gQM2+CfKN7d+dLphaWj3xOIgFNljM3Zwp6YoL9f
         Khrg==
X-Gm-Message-State: ACgBeo0NcOXB9bilXg9PH55PRWmXcdGxMGVGa2WodSBFqSKvjJkUXmCJ
        1hv524bUZtAPOKZSK5g4sOI01uJeGG3WFVF1Oaziig==
X-Google-Smtp-Source: AA6agR6aNmu8tqzPRfJhzC1q15Zhh3XEe9S9CQ3NvFq+tQCjwhaY+BTSAAxNwSJGvY+m7hbap1HrnznQheLiT4TU10o=
X-Received: by 2002:a05:600c:1550:b0:3a6:1d8c:247e with SMTP id
 f16-20020a05600c155000b003a61d8c247emr9133266wmg.63.1661853630619; Tue, 30
 Aug 2022 03:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220829065044.1736-1-anand@edgeble.ai>
In-Reply-To: <20220829065044.1736-1-anand@edgeble.ai>
From:   Jagan Teki <jagan@edgeble.ai>
Date:   Tue, 30 Aug 2022 15:30:19 +0530
Message-ID: <CA+VMnFwF4UVah9rbdhwjbuTuYFXwNFuDD==x0oYDxYiO+V-c-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rv1126
 compatible string
To:     Anand Moon <anand@edgeble.ai>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022 at 12:23, Anand Moon <anand@edgeble.ai> wrote:
>
> Add compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> ---
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> index 083623c8d718..346e248a6ba5 100644
> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> @@ -26,6 +26,7 @@ select:
>            - rockchip,rk3399-gmac
>            - rockchip,rk3568-gmac
>            - rockchip,rv1108-gmac
> +          - rockchip,rv1126-gmac

it needs to be in the properties menu as well.
