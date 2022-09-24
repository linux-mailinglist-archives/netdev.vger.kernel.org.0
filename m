Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5B5E8F29
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiIXSLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 14:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbiIXSLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 14:11:15 -0400
Received: from mx09lb.world4you.com (mx09lb.world4you.com [81.19.149.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097824F1B2;
        Sat, 24 Sep 2022 11:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CI6HQI94xf7JBmvpNWvJyiZolXyndjhrYwMt0KF/IUQ=; b=R6shB7K2yD18yaRq6gLEw2ogDl
        T5YURRXGJO435/j+VCAo/d5+UL+XfW1P6vJQ9g8i7c0F4qSBHIdaNz3g5Lo2EzeRjOsDF8n/IR2fc
        epHOU26+q7udn3iuMOz1zug87uN9F6PffXE6JENxZWg1Ps3zMdSXsz2siVwrJjrc34+s=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx09lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oc9cN-0007IB-43; Sat, 24 Sep 2022 20:11:11 +0200
Message-ID: <773e8425-58ff-1f17-f0eb-2041f3114105@engleder-embedded.com>
Date:   Sat, 24 Sep 2022 20:11:10 +0200
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
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <6e814bf8-7033-2f5d-9124-feaa6593a129@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.09.22 11:15, Krzysztof Kozlowski wrote:
> On 23/09/2022 22:29, Gerhard Engleder wrote:
>> Fix the following dtbs_check error if dma-coherent is used:
>>
>> ...: 'dma-coherent' does not match any of the regexes: 'pinctrl-[0-9]+'
>>  From schema: .../Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> 
> Skip last line - it's obvious. What instead you miss here - the
> DTS/target which has this warning. I assume that some existing DTS uses
> this property?

I will skip that line.

The binding is for an FPGA based Ethernet MAC. I'm working with
an evaluation platform currently. The DTS for the evaluation platform
is mainline, but my derived DTS was not accepted mainline. So there is
no DTS. This is similar for other FPGA based devices.

>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Best regards,
> Krzysztof

Thanks!

Gerhard
