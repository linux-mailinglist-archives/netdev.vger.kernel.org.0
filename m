Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4763DC05
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiK3RdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiK3RdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:33:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D79C1C93B;
        Wed, 30 Nov 2022 09:33:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9B82621AFE;
        Wed, 30 Nov 2022 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669829591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqJrKfDGUCrSTIm3EAFIG0LM42u34UGdsRzLNcg5JGU=;
        b=fxz4ufv1k83T2RnvwWjCFdtXIERIxMDUVdqs8yUBzqkVPfFVH/d/Y5s89BDyEBR7fDfNln
        X8XRK36HUmBseQHgIKhBA6rUi2UCQ0rFT92mcStIFwwH45C62PMR6NkQ/k/4HdGgH7DJyY
        vRmctaUCMhv2owdxQMHnBTnxZClVdRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669829591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqJrKfDGUCrSTIm3EAFIG0LM42u34UGdsRzLNcg5JGU=;
        b=cfilR73QBmg+BUdJyYCBGSPrkP8supIImpX0vJxBvH2rslogMOwSx1a4hi6t8WNGROEADn
        h73qWpeg4a6wgDCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 758451331F;
        Wed, 30 Nov 2022 17:33:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /dFtHNeTh2MxXgAAMHmgww
        (envelope-from <afaerber@suse.de>); Wed, 30 Nov 2022 17:33:11 +0000
Message-ID: <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
Date:   Wed, 30 Nov 2022 18:33:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
In-Reply-To: <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krysztof,

Am 30.11.22 um 16:51 schrieb Krzysztof Kozlowski:
> On 28/11/2022 06:49, Chester Lin wrote:
>> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
>> Chassis.
>>
>> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
>> Signed-off-by: Chester Lin <clin@suse.com>
> 
> Thank you for your patch. There is something to discuss/improve.
> 
>> ---
>>
>> Changes in v2:
>>    - Fix schema issues.
>>    - Add minItems to clocks & clock-names.
>>    - Replace all sgmii/SGMII terms with pcs/PCS.
>>
>>   .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++++++++++++
>>   1 file changed, 135 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>> new file mode 100644
>> index 000000000000..c6839fd3df40
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
[...]
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - nxp,s32cc-dwmac
>> +
>> +  reg:
>> +    items:
>> +      - description: Main GMAC registers
>> +      - description: S32 MAC control registers
>> +
>> +  dma-coherent: true
>> +
>> +  clocks:
>> +    minItems: 5
> 
> Why only 5 clocks are required? Receive clocks don't have to be there?
> Is such system - only with clocks for transmit - usable?
> 
>> +    items:
>> +      - description: Main GMAC clock
>> +      - description: Peripheral registers clock
>> +      - description: Transmit PCS clock
>> +      - description: Transmit RGMII clock
>> +      - description: Transmit RMII clock
>> +      - description: Transmit MII clock
>> +      - description: Receive PCS clock
>> +      - description: Receive RGMII clock
>> +      - description: Receive RMII clock
>> +      - description: Receive MII clock
>> +      - description:
>> +          PTP reference clock. This clock is used for programming the
>> +          Timestamp Addend Register. If not passed then the system
>> +          clock will be used.
>> +
>> +  clock-names:
>> +    minItems: 5
>> +    items:
>> +      - const: stmmaceth
>> +      - const: pclk
>> +      - const: tx_pcs
>> +      - const: tx_rgmii
>> +      - const: tx_rmii
>> +      - const: tx_mii
>> +      - const: rx_pcs
>> +      - const: rx_rgmii
>> +      - const: rx_rmii
>> +      - const: rx_mii
>> +      - const: ptp_ref
>> +
>> +  tx-fifo-depth:
>> +    const: 20480
>> +
>> +  rx-fifo-depth:
>> +    const: 20480
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - tx-fifo-depth
>> +  - rx-fifo-depth
>> +  - clocks
>> +  - clock-names
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +    #include <dt-bindings/interrupt-controller/irq.h>
>> +
>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
> 
> Why defines? Your clock controller is not ready? If so, just use raw
> numbers.

Please compare v1: There is no Linux-driven clock controller here but 
rather a fluid SCMI firmware interface. Work towards getting clocks into 
a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
also explains the ugly examples here and for pinctrl.

Logically there are only 5 input clocks; however due to SCMI not 
supporting re-parenting today, some clocks got duplicated at SCMI level. 
Andrew appeared to approve of that approach. I still dislike it but 
don't have a better proposal that would work today. So the two values 
above indeed seem wrong and should be 11 rather than 5.

Cheers,
Andreas

>> +
>> +    soc {
>> +      #address-cells = <1>;
>> +      #size-cells = <1>;
>> +
>> +      gmac0: ethernet@4033c000 {
>> +        compatible = "nxp,s32cc-dwmac";
>> +        reg = <0x4033c000 0x2000>, /* gmac IP */
>> +              <0x4007C004 0x4>;    /* S32 CTRL_STS reg */
> 
> Lowercase hex.
> 
>> +        interrupt-parent = <&gic>;
>> +        interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
>> +        interrupt-names = "macirq";
>> +        phy-mode = "rgmii-id";
>> +        tx-fifo-depth = <20480>;
>> +        rx-fifo-depth = <20480>;
>> +        dma-coherent;
>> +        clocks = <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_PCS>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RGMII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RMII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_MII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_PCS>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RGMII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RMII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_MII>,
>> +                 <&clks S32GEN1_SCMI_CLK_GMAC0_TS>;
> 
> 
> Best regards,
> Krzysztof
> 

-- 
SUSE Software Solutions Germany GmbH
Frankenstraße 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nürnberg)
