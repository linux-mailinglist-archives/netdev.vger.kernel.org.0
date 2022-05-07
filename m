Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE551E92E
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 20:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381034AbiEGSY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 14:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiEGSY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 14:24:57 -0400
Received: from mxout02.lancloud.ru (mxout02.lancloud.ru [45.84.86.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBB76154;
        Sat,  7 May 2022 11:21:07 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 1A3322327E34
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 2/9] dt-bindings: net: renesas,etheravb: Document RZ/V2M
 SoC
To:     Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Biju Das <biju.das.jz@bp.renesas.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-3-phil.edworthy@renesas.com>
Organization: Open Mobile Platform
Message-ID: <d0c1800f-8826-207f-35a8-90d3a62a32fe@omp.ru>
Date:   Sat, 7 May 2022 21:21:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-3-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/4/22 5:54 PM, Phil Edworthy wrote:

> Document the Ethernet AVB IP found on RZ/V2M SoC.
> It includes the Ethernet controller (E-MAC) and Dedicated Direct memory
> access controller (DMAC) for transferring transmitted Ethernet frames
> to and received Ethernet frames from respective storage areas in the
> URAM at high speed.

   I think nobody knows what exactly URAM stands for... you better call it
just RAM. :-)

> The AVB-DMAC is compliant with IEEE 802.1BA, IEEE 802.1AS timing and
> synchronization protocol, IEEE 802.1Qav real-time transfer, and the
> IEEE 802.1Qat stream reservation protocol.
> 
> R-Car has a pair of combined interrupt lines:
>  ch22 = Line0_DiA | Line1_A | Line2_A
>  ch23 = Line0_DiB | Line1_B | Line2_B
> Line0 for descriptor interrupts.
> Line1 for error related interrupts (which we call err_a and err_b).
> Line2 for management and gPTP related interrupts (mgmt_a and mgmt_b).
> 
> RZ/V2M hardware has separate interrupt lines for each of these, but
> we keep the "ch22" name for Line0_DiA.

   Not sure I agree here...
   BTW, aren't the interrupts called "Ethernet ABV.ch<n>" (as on R-Car gen3)
in your (complete?) manual?

> We also keep the "ch24" name for the Line3 (MAC) interrupt.
> 
> It has 3 clocks; the main AXI clock, the AMBA CHI clock and a gPTP

   Could you spell out CHI like below?

> reference clock.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
[...]

MBR, Sergey
