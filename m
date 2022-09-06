Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0A5AF6E4
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIFVeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIFVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:34:44 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C142FD20
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:34:43 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id x5so9091216qtv.9
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 14:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=CyoAyBh0Kwy9IfWf5RQ8u0H8gAfoJ5mRkiZbwC+pfVY=;
        b=U/c4ADcDg3CetCPMq/zsP/Gf1sI2SBsXul2foAkm3ZrFcws0HgRCR+5vwJppcZhYLf
         Flkdc5H3E8Rwx6eHh40mrAZdTURhdJmdNQ0quwbAjgyR19zFSG4NRsKz9ZOeGijXsfpm
         flIIGQ0gHmsktQGkmQFXNnyw9HiD4XSV3N5UXiYEtv6zW6K1NNJCoQJeEmDv9Li1OOz9
         GroiaEvUrMWhn+DoIOr1woLKA89f7W28kfCtivyR76qFIKxur4vlxxchPCalVduP/Z+u
         yqZZCjIF48qhelvwTkmi5HTmltvovX8iqiKExNACr+PAMG32n4/JtzM131PRi/EysMf6
         LDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CyoAyBh0Kwy9IfWf5RQ8u0H8gAfoJ5mRkiZbwC+pfVY=;
        b=X+O4vJljeDls1jML9Ue7ZR0iG+MoqMTffnq5y0xRrQ3WV1Oqp/0sMKF1OtgzDtc9FK
         7jq2FgsaO7PL20Do1BgjZgTtVHDztthhz5IIVxrAvUHKKktT9hqfo12UXjkdXxfvj5M+
         9xbFWtrAea2gQ6ipbKcBva7/0SbTVvkLHfDZe7A5rcmMl7CPtZqLdgUlzDN7kdS/G9Rw
         V/riyj5tUXilxE0TS/NHdHWveDyTahVMUjByaExyOrvAZxqrnil2OEaoAlQVFrNsE+nU
         Y4CZoNNO10hUlBNoBMUQtq3cQrfXVfd7PeXLVtUMjqP83CCbMnM15eBFuFDDoy1CWr3j
         MIaw==
X-Gm-Message-State: ACgBeo3pkM2XAFOLzFuqLSyUMCCD9/GOigxrNS758rkNKn6ah5UUcSqa
        AbyBaWNBgFcG5WpXsC3Gkhc=
X-Google-Smtp-Source: AA6agR7b3GSIIWIatDTObP8t1XcwfvV18Y6kHcyfiw2mp47D1eEJvtkee64eUzx9o7lYDhfoIsx+uQ==
X-Received: by 2002:a05:622a:18a8:b0:343:6c8c:13e5 with SMTP id v40-20020a05622a18a800b003436c8c13e5mr574889qtc.544.1662500081948;
        Tue, 06 Sep 2022 14:34:41 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u18-20020a05620a0c5200b006bb8b5b79efsm12537069qki.129.2022.09.06.14.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:34:41 -0700 (PDT)
Message-ID: <5e98d4b6-671e-bb1e-f9e6-8d5b716081e1@gmail.com>
Date:   Tue, 6 Sep 2022 14:34:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220906141719.4482f31d@hermes.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906141719.4482f31d@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 2:17 PM, Stephen Hemminger wrote:
> On Tue, 6 Sep 2022 13:33:09 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> On 9/6/2022 1:05 PM, Andrew Lunn wrote:
>>>> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]
>>>
>>> Unfortunately, it is not gender neutral, which i assume is a
>>> requirement?
>>>
>>> Plus the plural is also schnauzer, which would make your current
>>> multiple CPU/schnauzer patches confusing, unless you throw the rule
>>> book out and use English pluralisation.
>>
>> What a nice digression, I had no idea you two mastered German that well
>> :). How about "conduit" or "mgmt_port" or some variant in the same lexicon?
> 
> Is there an IEEE or PCI standard for this? What is used there?

This is not covered by any standard as it is really attaching a managed 
switch to an Ethernet controller and that is product design more than 
anything. Obviously there is a standard for the electrical interfaces, 
but it does not care whether you have a switch, another Ethernet 
controller, an Ethernet PHY or something else entirely.

Vendors refer to "management port" or even "in-band management port" 
though all that the Ethernet controller does is just pass through 
Ethernet frames to manage the switch.
-- 
Florian
