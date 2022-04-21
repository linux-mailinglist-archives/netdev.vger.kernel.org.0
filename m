Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7310850A151
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388472AbiDUN61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388533AbiDUN6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:58:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9F52E0A4
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:55:33 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id y11so5873185ljh.5
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtiiuhQ+uf1bOxSrFQ/mtG2iFVrqXzgGb1Bz4ZKL3lc=;
        b=mguUkcGeDwc2lpf0CnS2qEDAkdNXH0GfqqwxotWWnAiiPRenfCokppkdIq847GGDj+
         V7/AIF2bzXyp7M37/nr7ruAruDvCrQx1DNZ/20nn57hMXvzyNEVPpwjbfiO5IJyOcC/F
         prRS94MMKCXnDtHwQZZq1g34JjUSq9tB7jAFAlO108GoNmJ4usawRQMbfrBAU3m0Uf3u
         +5Jzss2axj6u4zOZSfEBaN6N84xDmHMJvSa3TVIUb+4nxJNjohMuxfu8WAyqKR0vqMZj
         kXi1dQo/9YbVfco4LPMAoFhgU513EM1o3eLJuSFV5X8ml5aklznY/fQaxI4CixL7CY6O
         1CnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtiiuhQ+uf1bOxSrFQ/mtG2iFVrqXzgGb1Bz4ZKL3lc=;
        b=IBTX1UBLNqbzHylM90TgcQ4fg/5ZV3w7MysQkpuumvZd4kXuAeOw5Kd/rJks7iFg1e
         nAoLTbCcugyuZINlzLVE/u3rhWnA7YkZxq88DiieZAIujN39f2WY1v5el/2YKZDDVL3K
         v+U1RHajgV7XCMVc+1+IrQMeOlwKuNZEdvaGqoInNuvQYG+THumBD+L8J6roWJPkOrCY
         M9Ypenxd9mlvJ+/+AR6o4iaoXLVLc2TRikQfNauTjnRfVqaTMzcdombphBvjaIC2qoh2
         A65Gr1J29eBOATJDUP2dFPXELJEmcMPWdlZEFzM15StTlT4swa+Yth3Ynh1IjTtBwzT9
         IVvQ==
X-Gm-Message-State: AOAM533GsLGe8u82KtIm9iGHNrnaPJyfzeVionLOOMaB1gDkXkfGXQ78
        Bgto6we06ZYdhFgqWvrLkhVDGG8vDwx3eJ1X++SnmA==
X-Google-Smtp-Source: ABdhPJwE9acGnZeEaiwn2RQsXbh1pRjWU4fFb6jByKk1paGqTryrF9P0MXVVYFO4M40JGujrjUHhZHu80AcKpfsXL2M=
X-Received: by 2002:a05:651c:2114:b0:24d:bde3:297 with SMTP id
 a20-20020a05651c211400b0024dbde30297mr11074613ljq.367.1650549331811; Thu, 21
 Apr 2022 06:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220419113516.1827863-1-abel.vesa@nxp.com> <20220419113516.1827863-10-abel.vesa@nxp.com>
In-Reply-To: <20220419113516.1827863-10-abel.vesa@nxp.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 21 Apr 2022 15:54:55 +0200
Message-ID: <CAPDyKFqmUQrL98m_r2uUEjOgWGGBK79eEJaaVV8dCPZhCXJgSw@mail.gmail.com>
Subject: Re: [PATCH v8 09/13] dt-bindings: mmc: imx-esdhc: Add i.MX8DXL
 compatible string
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Apr 2022 at 13:35, Abel Vesa <abel.vesa@nxp.com> wrote:
>
> Add i.MX8DXL compatible string. It also needs "fsl,imx8qm-fec" compatible.
>
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> Acked-by: Rob Herring <robh@kernel.org>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> index 58447095f000..29339d0196ec 100644
> --- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> +++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> @@ -54,6 +54,7 @@ properties:
>            - const: fsl,imx8qxp-usdhc
>        - items:
>            - enum:
> +              - fsl,imx8dxl-usdhc
>                - fsl,imx8mm-usdhc
>                - fsl,imx8mn-usdhc
>                - fsl,imx8mp-usdhc
> --
> 2.34.1
>
