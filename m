Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9682C6A96BE
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCCLwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCLwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:52:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE125D47B;
        Fri,  3 Mar 2023 03:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E16617A1;
        Fri,  3 Mar 2023 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E366AC433D2;
        Fri,  3 Mar 2023 11:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677844364;
        bh=dOfthFgjanTbWKs03Eh1I2lHx5A5iFcuCYKISeVUrPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j66UwYq470IS2IBw4Jw7a0QE+/mR27aaEyRAxVyWUHH4UrOpxPyi3yRWzzUStaKLB
         wqEiqh5QgyzMzLHIi/iT1TLMyXmoJVIHMranT1VvEhb25H1++rJ73CDqCvf+l8Fidi
         TxtbbW3H+P3SpeMEuC9URemmq+5XuYXg0vi0QIDYBHuieSwakhi36xTczfSEjo+Z01
         HZ/YdFbk5tKHv6fc7dFKICaq5uEuUWCrtGJdWNuYnto17Lpf3iIcvm9yErTZfs1MC3
         L3eyIb+am6CKihsSBjTz5k/Zd7RTc2XOwcCAH007nlJTiLH2zat862DR/8hhnjcqB+
         bJi2/IqAshASw==
Date:   Fri, 3 Mar 2023 11:52:36 +0000
From:   Lee Jones <lee@kernel.org>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 06/12] dt-bindings: mfd: syscon: Add StarFive JH7100
 sysmain compatible
Message-ID: <20230303115236.GH2420672@google.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-7-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230211031821.976408-7-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Feb 2023, Cristian Ciocaltea wrote:

> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> Document StarFive JH7100 SoC compatible for sysmain registers.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>  Documentation/devicetree/bindings/mfd/syscon.yaml | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks

-- 
Lee Jones [李琼斯]
