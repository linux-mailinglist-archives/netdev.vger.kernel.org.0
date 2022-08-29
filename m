Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15E85A4705
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiH2KUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiH2KUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:20:52 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC4337F99;
        Mon, 29 Aug 2022 03:20:49 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oSbsd-0007nX-76; Mon, 29 Aug 2022 12:20:31 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        David Wu <david.wu@rock-chips.com>,
        Anand Moon <anand@edgeble.ai>
Cc:     Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rv1126 compatible string
Date:   Mon, 29 Aug 2022 12:20:30 +0200
Message-ID: <3388378.Isy0gbHreE@diego>
In-Reply-To: <20220829065044.1736-1-anand@edgeble.ai>
References: <20220829065044.1736-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, 29. August 2022, 08:50:41 CEST schrieb Anand Moon:
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
>    required:
>      - compatible

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


