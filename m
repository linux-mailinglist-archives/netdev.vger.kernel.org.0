Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A928D58097A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiGZC2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGZC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4209A25C71;
        Mon, 25 Jul 2022 19:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF182B81186;
        Tue, 26 Jul 2022 02:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CBBC385A2;
        Tue, 26 Jul 2022 02:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658802488;
        bh=Q4vE2/L+PW7EvHeBn3KHsZUnndqfmIJGspx/KfLm7oE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aMVey0+wqvfc0RReuSlkiYElRWuKVcgS80ztv6Rw9tkYcrMtrScXZtgZS/h+bTUgc
         7uXqvi7XJ+2qDKpIH3LwLOnHQ1a7zb+gakgkbSwQV3aATjBscXJMERhzviKRGfA2HQ
         DZURiWmkJ9dAkIm10yaJj+TLI5iBudKd3x62l1gtkFBYN1WsrygDXaP0vXppOJIQfa
         7JtyZ0Cz0Z9BToCjuwEjmWbmpTw3jDOfXsZsaEHki/DDJuYU/TWVRj6ND5H7wl9Wl0
         vukrbGA7B4kftYPDKycCcKpb0tiTFc51YeN6HA0bQ4MAKYT3EbxzsC33n8lSLdoHO0
         j7ENIbX0CGpZw==
Received: by mail-ua1-f41.google.com with SMTP id p8so5005933uam.12;
        Mon, 25 Jul 2022 19:28:08 -0700 (PDT)
X-Gm-Message-State: AJIora9jxiqjQyDxk9TIrLn3lqQbTrO5uB8B+5ahx+xKr8gl0evxHhRf
        JHnEas5P/qOipLFPauDSWIz7qpzecT34p+SgZg==
X-Google-Smtp-Source: AGRyM1sTz8e2KhV4XgGMG/QS5CH95wq0WVwFKdSl7HgwG8R8zv6wQxSemmba5uAHpLHfoPnK42Qdl3DPmen415U5M1c=
X-Received: by 2002:ab0:2505:0:b0:384:cc62:9a75 with SMTP id
 j5-20020ab02505000000b00384cc629a75mr96348uan.36.1658802487588; Mon, 25 Jul
 2022 19:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220725195127.49765-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220725195127.49765-1-krzysztof.kozlowski@linaro.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 25 Jul 2022 20:27:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJc7Lagqr=Mkvags1dvua5AEvEzZHcsMqmOGNbp-v_Bxg@mail.gmail.com>
Message-ID: <CAL_JsqJc7Lagqr=Mkvags1dvua5AEvEzZHcsMqmOGNbp-v_Bxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix
 for Xilinx
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 1:51 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> Use correct vendor for Xilinx versions of Cadence MACB/GEM Ethernet
> controller.  The Versal compatible was not released, so it can be
> changed.  Zynq-7xxx and Ultrascale+ has to be kept in new and deprecated
> form.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> ---
>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index 762deccd3640..77d3b73718e4 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -20,10 +20,17 @@ properties:
>
>        - items:
>            - enum:
> -              - cdns,versal-gem       # Xilinx Versal
>                - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
>                - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
>            - const: cdns,gem           # Generic
> +        description: deprecated

You meant 'deprecated: true', right? With that,

Reviewed-by: Rob Herring <robh@kernel.org>

Thanks for the quick fix.

Rob
