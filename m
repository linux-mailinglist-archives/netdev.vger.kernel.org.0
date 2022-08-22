Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5817659B841
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiHVENn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiHVENm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:13:42 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3463AB7D1;
        Sun, 21 Aug 2022 21:13:40 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27M4DGVa046672;
        Sun, 21 Aug 2022 23:13:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1661141596;
        bh=WU5HjxtWjXnyPJ1rD+Irph5DqOHoAcuxx5L+dEWF/QA=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=aB5cMCvUHKS26UpWNSJGSvo19vLFRkzPi03rx/GQBHa+r7BfMz1GMLiaPSVrGvtFc
         ABn+2XMDlk6Lj5Wu9DMbElv5Y2cjO1y92A/X6qD8btyZdPfee0rAiL7ARmgqHEZHOL
         3J+V/DD5Rxpf2LKoOTJi0gO+n2i9lWtL6krDDjcU=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27M4DFbj080319
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 21 Aug 2022 23:13:15 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Sun, 21
 Aug 2022 23:13:15 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Sun, 21 Aug 2022 23:13:15 -0500
Received: from [10.24.69.241] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27M4DAaL047419;
        Sun, 21 Aug 2022 23:13:11 -0500
Message-ID: <130bc5c3-176d-f6ee-276f-5a04add15cd2@ti.com>
Date:   Mon, 22 Aug 2022 09:43:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>
References: <20220816060139.111934-1-s-vadapalli@ti.com>
 <20220816060139.111934-2-s-vadapalli@ti.com>
 <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
 <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
 <9c331cdc-e34a-1146-fb83-84c2107b2e2a@linaro.org>
 <176ab999-e274-e22a-97d8-31f655b16800@ti.com>
 <da82e71f-e32c-7adb-250e-0c80cc6e30bd@ti.com>
 <0ca78aad-2145-c88b-a26e-9ababa38df6e@ti.com>
 <9d9c2f78-db3e-71aa-2cdd-e2d9aa2b30cf@linaro.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <9d9c2f78-db3e-71aa-2cdd-e2d9aa2b30cf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 19/08/22 17:34, Krzysztof Kozlowski wrote:
> On 19/08/2022 13:43, Siddharth Vadapalli wrote:
> 
>>>>> Anyway the location is not correct. Regardless if this is if-then or
>>>>> allOf-if-then, put it just like example schema is suggesting.
>>>>
>>>> I will move the if-then statements to the lines above the
>>>> "additionalProperties: false" line. Also, I will add an allOf for this
>>>
>>> I had a look at the example at [1] and it uses allOf after the
>>> "additionalProperties: false" line. Would it be fine then for me to add
>>> allOf and the single if-then statement below the "additionalProperties:
>>> false" line? Please let me know.
>>>
>>> [1] -> https://github.com/devicetree-org/dt-schema/blob/mai/test/schemas/conditionals-allof-example.yaml
>>
>> Sorry, the correct link is:
>> https://github.com/devicetree-org/dt-schema/blob/main/test/schemas/conditionals-allof-example.yaml
> 
> You are referring to tests? I did not suggest that. Please put it in
> place like example schema is suggesting:
> 
> https://elixir.bootlin.com/linux/v5.19/source/Documentation/devicetree/bindings/example-schema.yaml

Thank you for the clarification. I will follow this schema and add the
allOf and the single if-then statement just above the
"additionalProperties: false" line.

Regards,
Siddharth.
