Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1574DD2F9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 03:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiCRCPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 22:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiCRCPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 22:15:44 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763FD160C20;
        Thu, 17 Mar 2022 19:14:23 -0700 (PDT)
Received: from apollo.. (unknown [IPv6:2a02:810b:4340:43bf:4685:ff:fe12:5967])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CDB552223A;
        Fri, 18 Mar 2022 03:14:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647569661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjGNQPmkrb8JUzaM0myQifPCqXhpbLHTYcIXuersAbA=;
        b=DahUYz3A8og3n8gjP1Z9+Th1OHtBIa0rcplJIT3MVxM8y9ul6xKi/XngxXtMzYohS+gAV/
        YLFwHFGeqSqA0L+4kK1Z8qqy9IpOxlYL3zjAGLRSWpjzDkftSlJ95Q3+6t2njdP86nIXh9
        4Z0NWP3rvzpbDd4QD/0ARKgdJ7BTvtk=
From:   Michael Walle <michael@walle.cc>
To:     horatiu.vultur@microchip.com
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: lan966x: Extend with FDMA interrupt
Date:   Fri, 18 Mar 2022 03:14:13 +0100
Message-Id: <20220318021413.25810-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317185159.1661469-2-horatiu.vultur@microchip.com>
References: <20220317185159.1661469-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Extend dt-bindings for lan966x with FDMA interrupt. This is generated
> when receiving a frame or when a frame was transmitted. The interrupt
> needs to be enable for each frame.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> index 13812768b923..14e0bae5965f 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -39,6 +39,7 @@ properties:
>        - description: frame dma based extraction
>        - description: analyzer interrupt
>        - description: ptp interrupt
> +      - description: fdma interrupt
>  
>    interrupt-names:
>      minItems: 1
> @@ -47,6 +48,7 @@ properties:
>        - const: fdma
>        - const: ana
>        - const: ptp
> +      - const: fdma

This interrupt is already described (three lines above), no?

-michael
