Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17335521D52
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345551AbiEJPDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345478AbiEJPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:03:33 -0400
Received: from mxout03.lancloud.ru (mxout03.lancloud.ru [45.84.86.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8B327775;
        Tue, 10 May 2022 07:27:21 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 5242B20EE528
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH v3 1/5] dt-bindings: net: renesas,etheravb: Document
 RZ/V2M SoC
To:     Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Biju Das <biju.das.jz@bp.renesas.com>
References: <20220510090336.14272-1-phil.edworthy@renesas.com>
 <20220510090336.14272-2-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b3ab3062-9ef9-776a-6977-0f83caac00a9@omp.ru>
Date:   Tue, 10 May 2022 17:27:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220510090336.14272-2-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/22 12:03 PM, Phil Edworthy wrote:

> Document the Ethernet AVB IP found on RZ/V2M SoC.
> It includes the Ethernet controller (E-MAC) and Dedicated Direct memory
> access controller (DMAC) for transferring transmitted Ethernet frames
> to and received Ethernet frames from respective storage areas in the
> RAM at high speed.
> The AVB-DMAC is compliant with IEEE 802.1BA, IEEE 802.1AS timing and
> synchronization protocol, IEEE 802.1Qav real-time transfer, and the
> IEEE 802.1Qat stream reservation protocol.
> 
> R-Car has a pair of combined interrupt lines:
>  ch22 = Line0_DiA | Line1_A | Line2_A
>  ch23 = Line0_DiB | Line1_B | Line2_B
> Line0 for descriptor interrupts (which we call dia and dib).
> Line1 for error related interrupts (which we call err_a and err_b).
> Line2 for management and gPTP related interrupts (mgmt_a and mgmt_b).
> 
> RZ/V2M hardware has separate interrupt lines for each of these.
> 
> It has 3 clocks; the main AXI clock, the AMBA CHI (Coherent Hub
> Interface) clock and a gPTP reference clock.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

   I'm not an expert in the DT bindings, though...

> ---
> v3:
>  - No change
> v2:
>  - Instead of reusing ch22 and ch24 interupt names, use the proper names

   Interrupt. :-)

[...]

MBR, Sergey
