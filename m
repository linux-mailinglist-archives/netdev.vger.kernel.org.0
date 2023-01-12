Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0DE6667FC
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbjALAlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbjALAky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:40:54 -0500
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 825D31C4;
        Wed, 11 Jan 2023 16:40:52 -0800 (PST)
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 12 Jan 2023 09:40:51 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id B643B2059054;
        Thu, 12 Jan 2023 09:40:51 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Thu, 12 Jan 2023 09:40:51 +0900
Received: from [10.212.157.104] (unknown [10.212.157.104])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id D22A03D4B;
        Thu, 12 Jan 2023 09:40:50 +0900 (JST)
Message-ID: <0a4aab39-7799-d18e-f146-f946776defb3@socionext.com>
Date:   Thu, 12 Jan 2023 09:40:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] dt-bindings: net: snps,stmmac: Fix inconsistencies in
 some properties belonging to stmmac-axi-config
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marek Vasut <marex@denx.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230111022622.6779-1-hayashi.kunihiko@socionext.com>
 <7c0156a5-6520-bb3b-ae84-222ad1d1674b@linaro.org>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
In-Reply-To: <7c0156a5-6520-bb3b-ae84-222ad1d1674b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 2023/01/11 18:19, Krzysztof Kozlowski wrote:
 > On 11/01/2023 03:26, Kunihiko Hayashi wrote:
 >> The description of some properties in stmmac-axi-config don't match the
 >> behavior of the corresponding driver. Fix the inconsistencies by fixing
 >> the dt-schema.
 >>
 >> Fixes: 5361660af6d3 ("dt-bindings: net: snps,dwmac: Document
 >> stmmac-axi-config subnode")
 >> Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new
 >> platform AXI structure")
 >> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
 >
 > NAK.
 >
 > I don't understand what do you mean by "corresponding driver". Driver
 > uses existing properties in current next.

Sorry for my mistake.

I found my local repository was out of date and
the commit 61d4f140943c ("net: stmmac: fix "snps,axi-config" node property parsing")
had already solved the issue to fix the driver.

 >> ---
 >>   .../devicetree/bindings/net/snps,dwmac.yaml      | 16 ++++++++--------
 >>   1 file changed, 8 insertions(+), 8 deletions(-)
 >>
 >> In this patch the definition of the corresponding driver is applied.
 >> If applying the definition of the devicetree, we need to change the driver
 >> instead of this patch.
 >>
 >> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
 >> b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
 >> index e88a86623fce..2332bf7cfcd4 100644
 >> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
 >> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
 >> @@ -158,11 +158,11 @@ properties:
 >>           * snps,xit_frm, unlock on WoL
 >>           * snps,wr_osr_lmt, max write outstanding req. limit
 >>           * snps,rd_osr_lmt, max read outstanding req. limit
 >> -        * snps,kbbe, do not cross 1KiB boundary.
 >> +        * snps,axi_kbbe, do not cross 1KiB boundary.
 >>           * snps,blen, this is a vector of supported burst length.
 >> -        * snps,fb, fixed-burst
 >> -        * snps,mb, mixed-burst
 >> -        * snps,rb, rebuild INCRx Burst
 >> +        * snps,axi_fb, fixed-burst
 >> +        * snps,axi_mb, mixed-burst
 >> +        * snps,axi_rb, rebuild INCRx Burst
 >>
 >>     snps,mtl-rx-config:
 >>       $ref: /schemas/types.yaml#/definitions/phandle
 >> @@ -516,7 +516,7 @@ properties:
 >>           description:
 >>             max read outstanding req. limit
 >>
 >> -      snps,kbbe:
 >> +      snps,axi_kbbe:
 >
 > There is no such property. Driver parses snps,kbbe. What's more you
 > introduce invalid character - underscore - for property name.

I understand the invalid character. This issue should have been fixed
in the driver parsing and was already fixed.

Thank you,

---
Best Regards
Kunihiko Hayashi
