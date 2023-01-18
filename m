Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B646724BE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjARRVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjARRVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:21:42 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56DD4A1C8;
        Wed, 18 Jan 2023 09:21:39 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30IHLDRZ004442;
        Wed, 18 Jan 2023 11:21:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674062473;
        bh=6WadCtvk8UAcJIveU7R2rxQCXinRZfK5AQ/s+qIEVrw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=uaZSGsUxBR1lBWbXccHBx+jZ+VhDJtiDyfvMFxQshGCCa0lwWBEhfuGR+fApogMmU
         7HVneSWTwUKYEa7DXLwhAUpPvKBWbYfBaS4LTCP+rfHfqwBduOFufKmUTSS7HiRDf3
         rtw0M9qIzvZqqmYYNLu5xMNNsdp/erhcbcuLFJ3E=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30IHLDmh031418
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Jan 2023 11:21:13 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 18
 Jan 2023 11:21:13 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 18 Jan 2023 11:21:13 -0600
Received: from [10.250.235.217] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30IHL7H8109811;
        Wed, 18 Jan 2023 11:21:08 -0600
Message-ID: <bb5bed0b-c68a-8e73-48d2-d949d6f90cae@ti.com>
Date:   Wed, 18 Jan 2023 22:51:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v6 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Add J721e CPSW9G support
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
 <20230104103432.1126403-2-s-vadapalli@ti.com>
 <CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com>
 <a3349dd8-6e1b-30bc-8247-5021f3733faf@linaro.org>
From:   "Raghavendra, Vignesh" <vigneshr@ti.com>
In-Reply-To: <a3349dd8-6e1b-30bc-8247-5021f3733faf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2023 10:47 PM, Krzysztof Kozlowski wrote:
> On 17/01/2023 14:45, Geert Uytterhoeven wrote:
>> Hi Siddharth,
>>
>> On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
>>> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
>>> ports) CPSW9G module and add compatible for it.
>>>
>>> Changes made:
>>>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>>>     - Extend pattern properties for new compatible.
>>>     - Change maximum number of CPSW ports to 8 for new compatible.
>>>
>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>
>> Thanks for your patch, which is now commit c85b53e32c8ecfe6
>> ("dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G
>> support") in net-next.
>>
>> You forgot to document the presence of the new optional
>> "serdes-phy" PHY.
> 
> I think we should start rejecting most of bindings without DTS, because
> submitters really like to forget to make complete bindings. Having a DTS
> with such undocumented property gives a bit bigger chance it will get an
> attention. :(
> 

Agree, bindings should have been better tested against real DTS.

But for reviewers, this been a bit of chicken-egg problem. Bindings and
driver changes have to go in first and via "subsystem" trees while DTS
patches have to go via "arch" tree. So, they get posted separately.

One may not see DTS patches (and thus user of the bindings) until
bindings reach Torvalds' tree. So, user of bindings will only appear in
the next kernel release cycle (at which time they do get flagged due to
failing make dtbs_check but its bit late). Wondering how others are
managing the same ?


Regards
Vignesh
