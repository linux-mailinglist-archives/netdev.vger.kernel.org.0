Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB551C12F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380034AbiEENtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380032AbiEENtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:49:50 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8244C425;
        Thu,  5 May 2022 06:46:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g6so8859978ejw.1;
        Thu, 05 May 2022 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=CmoyTtPjJebV46XUr6LOOtlTzAOsGOF3XhLcusYZkKo=;
        b=qkGXMkTe1Qn7XTDKJ0umXoiwPn5bieN4DnmYFJMb0AnzSptY+nMg2rpWw6JMaL1OoG
         /DmLSgpjm7MTwRJtjaClvGnTmV9avpKaOzL4JwgchJQXsbEbbq1WoOmBs1dGdvuYH0cw
         inHqyIGCCglhWykXXAqimkc7JaV6VWFJtuf9teARjR2/gEULg7V+1YHzSL/6RDCh2R2h
         uK8jNTKOcTmFfTGT/HSoudWCyH7ZiuXg4EIR507WDjsx4C1DpHRB6AKvzhW5muD7P0ML
         wpqBiQ95OHuXkC31U+b8SfaeNJaMQAEQJDcfBSCwQ8VOBtuLwm2m/1QfrjZca9MJxk/u
         d/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CmoyTtPjJebV46XUr6LOOtlTzAOsGOF3XhLcusYZkKo=;
        b=T4/HRi7c24q1FZqblkLM0D2fZqwiUqAB90osK27OoCFTLiewLF0Awnws6w3Y6DvGZe
         m0zHJuLDHFEq85KWVk5kdHSHAZBcLnYOXAIllS5Hh6+/0BNHCmXlcC3SRu42Xzw//q6Z
         f3XUR3lWT2HPRQ75Kb8KR4jOuAgz77arqILe0rh/c+fjjyaFzsIGY81UqE8/A9fly03f
         65XMF2//BncNUfBW8DTF4Q4ozuBngeQ01Gsn+pZpMCujxX7K3cgKG8PJZR5XNwRSk2kg
         EaWvY1RrgiYpUpNij4YReWsGXzisjrb7UBpVCurfDMKFmN/HPBTykICcEJEWgUmK/Cad
         Pfng==
X-Gm-Message-State: AOAM531XwkhsG3TONXY2aodTRmlUBwM4Jupnlc3k74bPfw+KjQ+HOI9K
        EFwYoj+4n+GLwnvPsTq/V0x8Si9xcI00iw==
X-Google-Smtp-Source: ABdhPJz/S7duDzv1qxhCsbjUa4Gc3wRiKALN4dKxHxOaNoCS//xTIyD2dmAu/BorcD1LheMMIkbTAQ==
X-Received: by 2002:a17:906:2883:b0:6e8:7012:4185 with SMTP id o3-20020a170906288300b006e870124185mr8852264ejd.204.1651758368873;
        Thu, 05 May 2022 06:46:08 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id s19-20020aa7c553000000b0042617ba63c1sm837838edr.75.2022.05.05.06.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 06:46:08 -0700 (PDT)
Message-ID: <47bafeae-34fb-fc55-3758-d248bd9706af@gmail.com>
Date:   Thu, 5 May 2022 15:46:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 1/4] dt-bindings: net: add bitfield defines for Ethernet
 speeds
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org
References: <20220503153613.15320-1-zajec5@gmail.com>
 <235aa025-7c12-f7e1-d788-9a2ef97f664f@gmail.com> <YnPASLy4oWJ6BJDq@lunn.ch>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <YnPASLy4oWJ6BJDq@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't understand anything from below, I'm sorry. Could you clarify,
please?

On 5.05.2022 14:17, Andrew Lunn wrote:
> On Thu, May 05, 2022 at 07:19:41AM +0200, Rafał Miłecki wrote:
>> On 3.05.2022 17:36, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This allows specifying multiple Ethernet speeds in a single DT uint32
>>> value.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>
>> Ansuel please check if my patchset conflicts in any way with your work.
>>
>> Andrew suggested to combine both but right now I don't see it as
>> necessary.
>>
>> I'd still appreciate your review of my work. Such binding may be
>> required for some hardware controlled LEDs setup too I guess.


 > Please look at the LED binding.

My binding or Ansuel's binding?


 > It is an LED you are trying to control, so that is the binding you should be using.

Well, of course, LED setup requires DT binding.


 > How do you describe this functionality using that binding.

I allow describing trigger source network device by using
"trigger-sources" property referencing network device. That is an
extension or what we already use for describing USB port that are
trigger sources.


 > Ansuel code will give you the framework to actually do the implementation within.

I was planning to base my work on top of Ansuel's one. I'll send proof
on concept meanwhile without asking for it to be applied.
