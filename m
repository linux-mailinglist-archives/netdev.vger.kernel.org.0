Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F130B681E3B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjA3WmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjA3WmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:42:01 -0500
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0004E265B4;
        Mon, 30 Jan 2023 14:42:00 -0800 (PST)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-15fe106c7c7so17140747fac.8;
        Mon, 30 Jan 2023 14:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibBkNrt7ktVHWeiGDYlTClifq+JfHHcCPsxu7WPEJgI=;
        b=ycWxk6jjEy+ZYBWcbsEU4vfQmwQAXdxGHpa0WrcE9QSwuTJfmRUSqJmG0Dnho2/IkX
         hKY8wpfvIO6oycH203ov0ZTO7jWJeg1pPb+O/tUOVWzqBmFUN9y9TEeb/uT2nEDcCuIq
         12gsWcsPjAWvWNZDFS89ZsmbzDawEgzeS0H1BZN9jJxzjuf4xichWREq3WPPF7lDznBP
         l8UqdT2NiCqst5x55J83JCNYgCP2BkVTuni/BsnRSFF7RURYnLRajyL7MlnXAqreqGsx
         t4/5/v7QZNIROXLuhXy/TVkLa66iylUI2PG6jp6hSNPvXv3d2wgQY4Vn7X/eGAUV6Ku9
         x8Gw==
X-Gm-Message-State: AO0yUKU1X7AlffDY0Q2n/Tuo9V55XGtgaG2WMDHK7dhKQTp9B9dJ7YiX
        sAALy5eE1meymb7SbMiOW+VqZx4Iag==
X-Google-Smtp-Source: AK7set+rCl3GC2Rch2Ut9nseiBwG+KaWsmi/oz+U4ugBugGIpqGyxJe1Z2h7dhnMkW+MvynQsNgGPA==
X-Received: by 2002:a05:6870:f20c:b0:163:154d:a591 with SMTP id t12-20020a056870f20c00b00163154da591mr12956079oao.4.1675118520223;
        Mon, 30 Jan 2023 14:42:00 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b4-20020a4ab484000000b004fca8a11c61sm5400769ooo.3.2023.01.30.14.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:41:59 -0800 (PST)
Received: (nullmailer pid 3658488 invoked by uid 1000);
        Mon, 30 Jan 2023 22:41:58 -0000
Date:   Mon, 30 Jan 2023 16:41:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Message-ID: <20230130224158.GA3655289-robh@kernel.org>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
 <20230130063539.3700-2-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130063539.3700-2-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 02:35:35PM +0800, Frank Sae wrote:
>  Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.

Bindings are for h/w devices, not drivers.

>  
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
> ---
>  .../bindings/net/motorcomm,yt8xxx.yaml        | 102 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   1 +
>  3 files changed, 105 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> new file mode 100644
> index 000000000000..8527576c15b3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -0,0 +1,102 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MotorComm yt8xxx Ethernet PHY
> +
> +maintainers:
> +  - frank sae <frank.sae@motor-comm.com>
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#

This schema doesn't work because there is no way to determine whether to 
apply it or not. You need a compatible for your phy.

Rob
