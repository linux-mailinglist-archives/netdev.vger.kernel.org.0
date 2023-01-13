Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7081669150
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbjAMIje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbjAMIjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:39:32 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE576B19B;
        Fri, 13 Jan 2023 00:39:30 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pGFaj-0005x6-QV; Fri, 13 Jan 2023 09:39:13 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Anand Moon <anand@edgeble.ai>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>,
        Johan Jonker <jbx6244@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
Date:   Fri, 13 Jan 2023 09:39:12 +0100
Message-ID: <4085845.mvXUDI8C0e@diego>
In-Reply-To: <20230112214712.0a32189d@kernel.org>
References: <20230111172437.5295-1-anand@edgeble.ai> <20230112214712.0a32189d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Am Freitag, 13. Januar 2023, 06:47:12 CET schrieb Jakub Kicinski:
> On Wed, 11 Jan 2023 17:24:31 +0000 Anand Moon wrote:
> > Fix compatible string for RV1126 gmac, and constrain it to
> > be compatible with Synopsys dwmac 4.20a.
> > 
> > fix below warning
> > $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> > arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> > 		 compatible: 'oneOf' conditional failed, one must be fixed:
> >         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
> >         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> > 
> > Fixes: b36fe2f43662 ("dt-bindings: net: rockchip-dwmac: add rv1126 compatible")
> > Reviewed-by: Jagan Teki <jagan@edgeble.ai>
> > Acked-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Anand Moon <anand@edgeble.ai>
> 
> I think this patch should go via net-next?
> Please let us know when it's ready to be applied, 
> 'cause we're not CCed on the entire series..

Correct, this patch should go via net-next, while I would pick up the
dts patches (2-4).

And this patch is ready to be applied.

Thanks
Heiko



