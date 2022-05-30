Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6864A5387AA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242370AbiE3TJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiE3TJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:09:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452E5633B0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:09:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id f21so22448476ejh.11
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hqDBmN4Fwx5+r7RqzfiXafCYERQq5UsMFBKRBWVA7kE=;
        b=td1mA7IvN12TkStkEUB8qAbAokYSgtDV1rAnlS7kG/NLBOIs8FXMyXhk5iIBV4+RIG
         JE7LXlKSlPQShufbfuo1/N3Jc56M+qjwzPv9Qliu9xph4/1DSgt76vGKVTSPWSMN3ISy
         lWUP93BoaXla6zZzGjTwE/bwoDZIFDegEP9/W5LhV5eiv7+CC6Rt3hs1SFQDPjrfjHyu
         T8HV4dLRrBLUm56Uqf3JVqdg3EJdb3nSfQXhswOCgrXqdfrCeM3+zUdzMIbPasC91Wo3
         vNpilxXjlbH5CPXXRQkbEWkmfXo6IQ3M7pAkasxXzwJB5nW16LivuVhznJWNut7/8WPC
         8V6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hqDBmN4Fwx5+r7RqzfiXafCYERQq5UsMFBKRBWVA7kE=;
        b=7QB1Dyd7+lS4g0oDWdVfy0SB8zuQXyvqlQvcOp5U5cRKpsWxLioRv3F0qajXh2h/Ew
         +8vQtXLRqp/JY0vq5l/idxPxCEZdwYvesIBhuG5wcYF44KYQWrRvSER6OdgMAs4gYbC+
         e80yna26cEhDcDlyeUxvS9t4ZttmrPmGdOqYp7FRO2mKvc1sOL1EVy3SOfECXgF2N5B9
         rihS3g9BNQPrdXPUPHeoz0zHCfSxfo8tugIuJ40ZwudL9e4ppluEDtcD76L/sLTFmFpg
         ZcqG0LhAR9CEsyuIuEnH0guboItnaFPL6r52lGxsbdyiZIrY+af/aRJCA2IUyHNCnzEb
         yCsg==
X-Gm-Message-State: AOAM5332vkUm5uhhdrDcQELQE47U82hznfVoEJOwA8lIByN7a0uq8iak
        F7YmoTPsrPAM6JLEse119aT+pg==
X-Google-Smtp-Source: ABdhPJzlooXqbu7R0ahRzMkj3PgZr7xpPjbwUGBEwx+kpiC34uqOX9lpEBa9CbkX1HGa7uCXSQDQZg==
X-Received: by 2002:a17:907:94c4:b0:6f9:f69f:2fd5 with SMTP id dn4-20020a17090794c400b006f9f69f2fd5mr51136723ejc.347.1653937775835;
        Mon, 30 May 2022 12:09:35 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id q3-20020a50aa83000000b0042dc513ced8sm3953987edc.30.2022.05.30.12.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 12:09:35 -0700 (PDT)
Message-ID: <6f3d43ca-c980-851d-e7b2-869371a1f4ec@linaro.org>
Date:   Mon, 30 May 2022 21:09:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Content-Language: en-US
To:     Radhey Shyam Pandey <radheys@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "harini.katakam@amd.com" <harini.katakam@amd.com>,
        "michal.simek@amd.com" <michal.simek@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git@amd.com" <git@amd.com>
References: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
 <SA1PR02MB85602AA1C1A0157A2F0DA28BC7DD9@SA1PR02MB8560.namprd02.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <SA1PR02MB85602AA1C1A0157A2F0DA28BC7DD9@SA1PR02MB8560.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/05/2022 15:21, Radhey Shyam Pandey wrote:
>>
>>> +        local-mac-address = [00 0a 35 00 00 00];
>>
>> Each device should get it's own MAC address, right? I understand you
>> leave it for bootloader, then just fill it with 0.
> 
> The emaclite driver uses of_get_ethdev_address() to get mac from DT.
> i.e  'local-mac-address' if present in DT it will be read and this MAC 
> address is programmed in the MAC core. So I think it's ok to have a 
> user defined mac-address (instead of 0s) here in DT example?

And you want to program the same MAC address in every device in the
world? How would that work?



Best regards,
Krzysztof
