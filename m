Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8A051C253
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242137AbiEEOZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiEEOZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:25:16 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128AE1AF34;
        Thu,  5 May 2022 07:21:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p4so5421977edx.0;
        Thu, 05 May 2022 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=uGwNvCukPKt5KAQuzs31ksMVk3XSI3SIHYayYJ4DWVY=;
        b=WWQMyoa/m9OntHX7muyAMEMDG2bYFsVfOLRK7TNHzgaxLF3C1M+93LSzz1zEX6+hmY
         iCeo1KnKWUyIBM+9C6K4xX2BM93C0n94VpGY7XYCUMWLnpSMaQVVGIg9ltI9v4D/2KoQ
         nasoI3dJTEz0QM+izEobsfCWIHWjZyWmFjJ8uuO11vXQJsvX76yduzng3pU87SG711ln
         InsZHaHuJuoikXNEnzwijd7TU5uPYZR9ZUctgWEqb1yOgfEUoP/H0FTydtrKD/CqeO9q
         0nz3G8Kd//xPi/Y0v18qc57dZnSMRyJZoH4Obqsbecrm2Ya9cbSFPzLPhOzxvRD2A7EP
         PPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uGwNvCukPKt5KAQuzs31ksMVk3XSI3SIHYayYJ4DWVY=;
        b=IqUAv8iw08DOiozGlTGsNqu3TDosgVxAtqmdkIpAwa1IeyuczQM+M70p1GYYiAuxB2
         +6FUsJNz2vhHzD5ov5fB/qLO8d0V47hWDVwIw0T58MsNOha5+EjfW5r6mhSma9UH5ggT
         rQ/HqHB/4O1O/S/muxezTnDSFQ4AOywIyqi7S4YJSsQxi/NK/6ut5l80cu1myb3/IpNc
         kunQovv/piPxNhfXMzu+GrdxOIQtTsCbl1mA2SBSrxFd5MQZwjXODT1HA+sYIdQ2uHJ8
         FnqRQQAttITHPtwtUOxzQcHuMgVXJ7CY92PDgAlxgL2Jxth6maQ3j+ZDZzJiFaWfPQjl
         H3ag==
X-Gm-Message-State: AOAM532R4nMuvSuvIvPDmJJPcSDq16Ivz+3qAwob7YO0WpUkrWmgN5h4
        gu7Zc4lw9ON+7c53AEE+LDo=
X-Google-Smtp-Source: ABdhPJwxXRp+klyB4r5bfDnlD02Sfhwzq69K52d+xQh42GTTQ4osTHucxjSDxQ1lJweWXodvb27pgw==
X-Received: by 2002:a05:6402:364:b0:425:f88d:7d4a with SMTP id s4-20020a056402036400b00425f88d7d4amr30252039edw.68.1651760495661;
        Thu, 05 May 2022 07:21:35 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id v16-20020a17090690d000b006f3ef214da8sm820652ejw.14.2022.05.05.07.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 07:21:35 -0700 (PDT)
Message-ID: <b9ef7ce4-2a9d-9ecb-0aee-3f671c25d13f@gmail.com>
Date:   Thu, 5 May 2022 16:21:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH RESEND 0/5] dt-bindings: support Ethernet devices as LED
 triggers
To:     Ansuel Smith <ansuelsmth@gmail.com>
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
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20220505135512.3486-1-zajec5@gmail.com>
 <6273d900.1c69fb81.fbc61.4680@mx.google.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <6273d900.1c69fb81.fbc61.4680@mx.google.com>
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

On 5.05.2022 16:02, Ansuel Smith wrote:
> On Thu, May 05, 2022 at 03:55:07PM +0200, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Some LEDs are designed to represent a state of another device. That may
>> be USB port, Ethernet interface, CPU, hard drive and more.
>>
>> We already have support for LEDs that are designed to indicate USB port
>> (e.g. light on when USB device gets connected). There is DT binding for
>> that and Linux implementation in USB trigger.
>>
>> This patchset adds support for describing LEDs that should react to
>> Ethernet interface status. That is commonly used in routers. They often
>> have LED to display state and activity of selected physical port. It's
>> also common to have multiple LEDs, each reacting to a specific link
>> speed.
>>
> 
> I notice this is specific to ethernet speed... I wonder if we should
> expand this also to other thing like duplex state or even rx/tx.

I didn't see any router with separated Rx/Tx LEDs, but it still sounds
like a valid case.

We could add flags for that in proposed field like:
trigger-sources = <&port (SPEED_1000 | LINK | TX)>;

Or add separated field for non-speed flags like:
trigger-sources = <&port SPEED_1000 (LINK | TX)>;

Let's see what DT experts say about it.
