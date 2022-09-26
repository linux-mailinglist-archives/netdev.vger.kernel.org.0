Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393C05EAF09
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiIZSEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiIZSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:04:27 -0400
Received: from mx02lb.world4you.com (mx02lb.world4you.com [81.19.149.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A9E5FDE2;
        Mon, 26 Sep 2022 10:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZAf44rBvGuSXOQvnNY6B6qvnrHAsB41r5ogWFrBLiAo=; b=kON3cx2zE3uZn+KTXghiZgNLjf
        F3cwbx8Xok+DCN/NRfPQrY9RKN9v73wKjgyQJdzhs+ubg7XTEGfOtHN9+TMDsOAwa/vIkHEkZ1vYl
        VWg4K3XhJcerJH/j8sfB+uqDf50eIbP8fSi1I4/+g6RlNqfM2M61OBerMCKByvmZNjfE=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx02lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ocsC2-0001Nw-8h; Mon, 26 Sep 2022 19:46:58 +0200
Message-ID: <12c95c44-a2ab-3ae6-23fa-24a251c4a1d7@engleder-embedded.com>
Date:   Mon, 26 Sep 2022 19:46:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 1/6] dt-bindings: net: tsnep: Allow
 dma-coherent
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
References: <20220923202911.119729-1-gerhard@engleder-embedded.com>
 <20220923202911.119729-2-gerhard@engleder-embedded.com>
 <6e814bf8-7033-2f5d-9124-feaa6593a129@linaro.org>
 <773e8425-58ff-1f17-f0eb-2041f3114105@engleder-embedded.com>
 <7c7f67d3-d42e-a053-256d-706cc9dfb947@linaro.org>
 <7782924b-9664-6946-f8f6-c70cec618df9@engleder-embedded.com>
 <6e43fd39-3452-c36d-d9ff-fd508ac337c9@linaro.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <6e43fd39-3452-c36d-d9ff-fd508ac337c9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.09.22 10:55, Krzysztof Kozlowski wrote:
> On 25/09/2022 10:14, Gerhard Engleder wrote:
>> On 25.09.22 09:41, Krzysztof Kozlowski wrote:
>>> On 24/09/2022 20:11, Gerhard Engleder wrote:
>>>> On 24.09.22 11:15, Krzysztof Kozlowski wrote:
>>>>> On 23/09/2022 22:29, Gerhard Engleder wrote:
>>>>>> Fix the following dtbs_check error if dma-coherent is used:
>>>>>>
>>>>>> ...: 'dma-coherent' does not match any of the regexes: 'pinctrl-[0-9]+'
>>>>>>    From schema: .../Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>>>>>
>>>>> Skip last line - it's obvious. What instead you miss here - the
>>>>> DTS/target which has this warning. I assume that some existing DTS uses
>>>>> this property?
>>>>
>>>> I will skip that line.
>>>>
>>>> The binding is for an FPGA based Ethernet MAC. I'm working with
>>>> an evaluation platform currently. The DTS for the evaluation platform
>>>> is mainline, but my derived DTS was not accepted mainline. So there is
>>>> no DTS. This is similar for other FPGA based devices.
>>>
>>> If this is not coming from mainline, then there is no warning...  we are
>>> not interested in warnings in out-of-tree code, because we are not
>>> fixing them.
>>
>> Ok. So I would rewrite the description that it just allows dma-coherent
>> and remove the fix/warning stuff. Is that ok?
> 
> That would be okay, but please add answer to why you are making this change.

I already prepared it:

Within SoCs like ZynqMP, FPGA logic can be connected to different kinds
of AXI master ports. Also cache coherent AXI master ports are available.
The property "dma-coherent" is used to signal that DMA is cache
coherent.
Add "dma-coherent" property to allow the configuration of cache coherent
DMA.

Thanks!

Gerhard
