Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B564C0242
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiBVTr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiBVTr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:47:56 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D3AB4582;
        Tue, 22 Feb 2022 11:47:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v4so626792pjh.2;
        Tue, 22 Feb 2022 11:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2W938Ggu2Aydi5IPGQ9z0TKv8ovKzH72EC0el5VtOyQ=;
        b=YMqtl9StewhccBKOdrPVC8tdw8VjBKym1msstZyS3FTcnHKXv7uJAC2b2zX6Xjv2mF
         ragQiQpjFOnP6HMFlMebezCrOouXJzLctcvzP1dqWVkJaA121Wvwf6iBkF5EnXl2mfUL
         9c1PLbiS9n/YHpuC7P63VXwrtFYc8+1L60dd3hOH95oxRHfG+vohOMg4yLzl/rsuMOoj
         +ebDDqbHWrIsFyJ2Wq7lbW3lFj8vt9rn7LX1A3LRhKNtfZ52OhBM0/YqLMX1bwYmiQbi
         LYhavcAN6WPTKSH2KvSmlFLc43hfY255BtFekjmqEtB0LBjNnXJ5Bdzf3kJNcp0OXFkO
         ZFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2W938Ggu2Aydi5IPGQ9z0TKv8ovKzH72EC0el5VtOyQ=;
        b=JqCBz/tqq0vVCsiKqr+0eJJ2Ax0QhJORyBNiyjRzOTQjyXyOw6rOJiAAz8xqFP8qII
         M7FgnYkSVt38OUONIhLPrBWOQ9Hm3Y9jRsR2EvFlPxfc7GnqTV56BKpXf/OjEn3ALC32
         MeizuHQ3BANsTjjw/82CMswpw761iYzHwqywFRVzyUjQQgCCekpwAq3UiVs8fNVGPu3e
         gnOXGOFxwVoSHQlD0V/ZbgIcn9j+VqpBtaNPWVLOj7Vbd5G6rgBZsDrc9U60SX4nvIFl
         a6i0Qud8UeK09zO4XfPyQb+zi5kFrrJw1kE5S5J+4d9bN2B5E3Crdl/yfBo/lPzQip5D
         Cc4g==
X-Gm-Message-State: AOAM5316pnWMsNbTKj6TIiOaDyfOaVUKgTP7vJNRyFxkCpgCWdnb7/FF
        OQS3iq7ffEqFoF1TkQNIgBY=
X-Google-Smtp-Source: ABdhPJwnj5EJPQHUhEAFys23GNoiaml0c9MnGqifgybD1GdXBesdE+GvgAvz5kUq+M8rxLuH+W3c7Q==
X-Received: by 2002:a17:902:76c5:b0:14e:e325:9513 with SMTP id j5-20020a17090276c500b0014ee3259513mr24548706plt.55.1645559250319;
        Tue, 22 Feb 2022 11:47:30 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y191sm18599469pfb.78.2022.02.22.11.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 11:47:29 -0800 (PST)
Message-ID: <0bf8c693-3e0e-535f-f6f1-2059c11779ad@gmail.com>
Date:   Tue, 22 Feb 2022 11:47:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
 <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
 <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
 <d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com>
 <4b3a954cde4e9d1b6a94991964eb21e80278a8ab.camel@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <4b3a954cde4e9d1b6a94991964eb21e80278a8ab.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/2022 8:38 AM, Prasanna Vengateshan wrote:
> On Fri, 2022-02-11 at 19:56 -0800, Florian Fainelli wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>> content is safe
>>
>> On 2/9/2022 3:58 AM, Prasanna Vengateshan wrote:
>>> On Mon, 2022-02-07 at 18:53 -0800, Florian Fainelli wrote:
>>>>
>>>>> +                rx-internal-delay-ps:
>>>>> +                  $ref: "#/$defs/internal-delay-ps"
>>>>> +                tx-internal-delay-ps:
>>>>> +                  $ref: "#/$defs/internal-delay-ps"
>>>>
>>>> Likewise, this should actually be changed in ethernet-controller.yaml
>>>
>>> There is *-internal-delay-ps property defined for mac in ethernet-
>>> controller.yaml. Should that be changed like above?
>>
>> It seems to me that these properties override whatever 'phy-mode'
>> property is defined, but in premise you are right that this is largely
>> applicable to RGMII only. I seem to recall that the QCA8K driver had
>> some sort of similar delay being applied even in SGMII mode but I am not
>> sure if we got to the bottom of this.
>>
>> Please make sure that this does not create regressions for other DTS in
>> the tree before going with that change in ethernet-controller.yaml.
> 
> Okay, Can these be submitted as a seperate patch?

Well yes, it has to be a separate patch, but it should be part of the 
same series as this one, otherwise your patch adding the binding for 
lan937x would fail validation.
-- 
Florian
