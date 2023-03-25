Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C917D6C8A3C
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjCYCYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjCYCYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:24:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D0710AA3;
        Fri, 24 Mar 2023 19:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C9A62D2F;
        Sat, 25 Mar 2023 02:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066A7C433D2;
        Sat, 25 Mar 2023 02:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679711061;
        bh=9AXZA/QaTCInErGamxaamrpYwzewXW8Q+jAbhTnDpZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YykKZJjKELjFqYn7PoeyScG06SZpvHpnGDE2d5d2mO6We8UP8ONCVpmT3y+/ewgV3
         Ccn9MYqKrCLsfb3NLbMwI1BRydITymMG3oIl5U+usaBnBNH62UYYYq1Ad1Mt37SE17
         JYtQRoJa/3RpmZJvuoJZm/oF6iSr2oOVhQuJZGbYHk8njTTdluxBlb49ajQIKlozN3
         YLruh6wojoC50DaZknX+lVg+EElfmqX0nnvlJvqD3YEnzGo5HBtORE9S9z2OpZtT4s
         VGQlLGQTIMpJM+iPdxpIy5QmC48gYxNvKjpew9pXyymRpCo6kMtAosKua07yHjDneW
         uHvNmJA5Ge0wg==
Date:   Fri, 24 Mar 2023 19:24:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
Message-ID: <20230324192419.758388e4@kernel.org>
In-Reply-To: <20230324022819.2324-5-samin.guo@starfivetech.com>
References: <20230324022819.2324-1-samin.guo@starfivetech.com>
        <20230324022819.2324-5-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 10:28:17 +0800 Samin Guo wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebc97c6c922f..5c6d53a9f62a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19905,6 +19905,12 @@ M:	Emil Renner Berthing <kernel@esmil.dk>
>  S:	Maintained
>  F:	arch/riscv/boot/dts/starfive/
>  
> +STARFIVE DWMAC GLUE LAYER
> +M:	Emil Renner Berthing <kernel@esmil.dk>
> +M:	Samin Guo <samin.guo@starfivetech.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> +
>  STARFIVE JH7110 MMC/SD/SDIO DRIVER
>  M:	William Qiu <william.qiu@starfivetech.com>
>  S:	Supported

The context is wrong here, could you regen the series on top of
net-next (and resend with [PATCH net-next v9] in the subject while
at it)?
