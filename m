Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3902E60BFBB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJYAhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJYAhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:37:32 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5990212B348;
        Mon, 24 Oct 2022 16:04:16 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id o8so7470771qvw.5;
        Mon, 24 Oct 2022 16:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vLlCqMJKWuNDpuccm5yHGN1m80GGUQRyR5+DMzM1ImE=;
        b=EtaBzm4HF6lXJZIDu/yz7MCLUgjbdIk37dTF/fuI//BAObQFGoZQMbUrOpxmg4mtQ4
         tJ2M+rWaiCe1rirqg9zCQlBkfY4y5C+fx4+Itg/Bc8WRYZBa3GsDvNUrmJekT7dELSGY
         mX4W53R+U6PGl3fCYtENuWkX8DROoY40n7Z7wNOkYAgoSdBXG+F4fJx3KyF26JAV7oil
         b58I0bNcd+LIC4yWSKojMWPMDLabyYZwGQCc7VkQFFjrejtt5voQLAKjwr1d2YmWyLXL
         2geVWabq38kHRI1zCiTJJYizgKo9C/zuVNK7FRHsKAQmcLAm6J2+/bIqE9Y+SjQ8s5ri
         Jlaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLlCqMJKWuNDpuccm5yHGN1m80GGUQRyR5+DMzM1ImE=;
        b=vEZY5/4jchEYkuv3i7BiHQLYsMb7QlA7HyO+QKGcumcJeyhvpAmgk4vOpPvxGMIlms
         gHObZcT3QXWOOZvXdEcR9ts5IAy9j4wzS4cK5tDP0g+E/Q4s/BlVZ4OKr92fW2IJsLI2
         /Jew2Szy/M0mjyxQkbhYfxfbsEOsh4bZseZ+tJG4om1FhxA5WRLFOj+eeWuuTHa9tdHD
         G6Rb3c7r8gnzYfVao5JFE2YRGFG2xFL+z9UPKfYQxhp6fY/THs5QuS5yRJ9tAkFp5TjX
         +TsF37qkw+KbzvCAXElzo0lkPH2gf+J2or4V2snnkPOIKW9th8aiwEGVLpUE7SB5jbnA
         FhSw==
X-Gm-Message-State: ACrzQf3sFFLAojB0eCFnCizWBnqrVeAqMPIX+n0/YVgtFrSrcSwykIi/
        rG48S4Tbzh+01Eq06fxJnR8=
X-Google-Smtp-Source: AMsMyM6ZaGQDIK9BT0ZiNUtt+dz+JGcWSE9ZV14alk9CUnYlKOuNTxj/0HiHhpgLFgpfsKa2m5jP5g==
X-Received: by 2002:a05:6214:27c5:b0:4b1:7aba:1c51 with SMTP id ge5-20020a05621427c500b004b17aba1c51mr30377188qvb.128.1666652655371;
        Mon, 24 Oct 2022 16:04:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w13-20020a05620a444d00b006ce30a5f892sm864632qkp.102.2022.10.24.16.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 16:04:14 -0700 (PDT)
Message-ID: <b98e3074-e29c-df7e-f429-cc114f360370@gmail.com>
Date:   Mon, 24 Oct 2022 16:04:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com> <Y1FXHDHxD4w7v3d1@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y1FXHDHxD4w7v3d1@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 07:11, Andrew Lunn wrote:
> On Wed, Oct 19, 2022 at 07:23:26PM -0700, Florian Fainelli wrote:
>>
>>
>> On 10/19/2022 1:35 AM, Yoshihiro Shimoda wrote:
>>> Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
>>> ethernet controller.
>>>
>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>
>> How can this be a switch driver when it does not include any switchdev
>> header files nor does it attempt to be using the DSA framework? You are
>> certainly duplicating a lot of things that DSA would do for you like
>> managing PHYs and registering per-port nework devices. Why?
> 
> Hi Florian
> 
> It is not clear yet if this is actually a DSA switch. I asked these
> questions a few revisions ago and it actually looks like it is a pure
> switchdev switch. It might be possible to make it a DSA switch. It is
> a bit fuzzy, since it is all internal and integrated.

We were dealing with an integrated Ethernet MAC and switch back in 2014 
when DSA was resurrected to support bcm_sf2 + bcmsysport, also, we are 
about to get support for in-band DSA tags with Maxime's patch series.

I suppose that as long as the binding is conforming, we can always make 
the driver evolve, it would be good to see all of the pieces now though.
-- 
Florian

