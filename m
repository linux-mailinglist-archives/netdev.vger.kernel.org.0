Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305B8539C4C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiFAE2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiFAE2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:28:39 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD01703E2;
        Tue, 31 May 2022 21:28:38 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2514SJpU021566;
        Tue, 31 May 2022 23:28:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654057699;
        bh=KbZKDXzQGEXPk884xfQumdqLoPxcqGcV2srHXN4o3L0=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=Y/yJKyYNTWuJOl38I7Fd9WjhGOggmWNA4n0FCtzP+pMJ1U8kv13ksCB/Du9sFH/yb
         auVQq9dNrYTwbzDsURmunqii9jljrDjhSQ/rJ3+xtWC11rsXcaoXPzMkF87o8hdPsk
         LQLSr8OMD1/QdCCqfaEqdkjbZmvcewa3B+vIrI5o=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2514SJOE085085
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 23:28:19 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 23:28:19 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 23:28:19 -0500
Received: from [172.24.220.119] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2514SB9T050639;
        Tue, 31 May 2022 23:28:12 -0500
Message-ID: <1cf7ddd2-a6e0-8f00-953e-faf0e88074bf@ti.com>
Date:   Wed, 1 Jun 2022 09:58:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@kernel.org>, <grygorii.strashko@ti.com>, <vigneshr@ti.com>,
        <kishon@ti.com>, <robh+dt@kernel.org>, <afd@ti.com>,
        <andrew@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
 <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
 <a47f5d18-9ecc-a679-b407-799e4a15c6cf@linaro.org>
 <c13f79c9-ffca-d81d-8904-95c424dd19bc@ti.com>
 <ec9991e3-71b0-3671-8975-292287714f95@linaro.org>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <ec9991e3-71b0-3671-8975-292287714f95@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 31/05/22 17:31, Krzysztof Kozlowski wrote:
> On 31/05/2022 13:59, Puranjay Mohan wrote:
>> Hi Krzysztof,
>>
>> On 31/05/22 17:18, Krzysztof Kozlowski wrote:
>>> On 31/05/2022 13:27, Puranjay Mohan wrote:
>>>>>> +examples:
>>>>>> +  - |
>>>>>> +
>>>>>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>>>>>> +    pruss2_eth: pruss2_eth {
>>>>>> +            compatible = "ti,am654-icssg-prueth";
>>>>>
>>>>> Again missed Rob's comment.
>>>>
>>>> One of Rob's comment was to make the indentation as 4 which I have done.
>>>
>>> I clearly do not see indentation of 4, but there is 8 instead.
>>
>> I changed the indentation at the wrong place.
>>
>>>
>>> Let's count:
>>> +    pruss2_eth: pruss2_eth {
>> ^ here, it was 8 in v1 so, I changed it to 4
>>
>>> +            compatible = "ti,am654-icssg-prueth";
>>>      12345678^
>>>
>>
>> Compatible is the child of pruss2_eth, so, It should have 4+4 = 8?
> 
> Yes. Indentation of four means first block is indented with 4 spaces.
> The next block 4+4. The next one 4+4+4.

Thanks for clearing my misunderstanding. I will fix all this in the next
version.

Thanks,
Puranjay

> 
> Best regards,
> Krzysztof
