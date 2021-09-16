Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBC40ED41
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbhIPWUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 18:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240949AbhIPWUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 18:20:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490A6C061756
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:19:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id b18so22907583lfb.1
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZXGKR8r/HN56qTH2XDx/MfiA/uG/YME9xDPw73hqKJw=;
        b=hr/znkwatsayH6ZNjZzlwGoQBQEzJja2k0yKqzRc8/lBD+5RMZsXlxt88Q5EXxhp5z
         nGDNwThSRsaBjoJLe7AC1i33IwfBpPD7r46JAS4YFCng3pQye/gG/m+z3lxlxPm7pTm0
         9PFhWPFRSwhWwgcLV8AFpWJwz3318DKaR6jyMNFQr6XGdkMA7oLZS0iIWu/8jpUc8n00
         NUzjQoOaeqWWDyQKYVXTeXGOx2PN39GklWFNaKui6qWQ+fA9LHUJ882UamkdrNG/7bVw
         JgqnNC5vUN9yiUgsAOW8ryI18GgNKRRF/UomN6LaBMEM2I972VTsd7eKK3+0wL73yRmJ
         ebVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZXGKR8r/HN56qTH2XDx/MfiA/uG/YME9xDPw73hqKJw=;
        b=1fS80LIAN1dKnlGlJ8sGgX1YiKwrCLKeTdylWahWSLVPgo/Oh9EhCeTAFR58qaq2Lv
         yd75fZdrn6UzT0CiiElk+qPVFtWAgm+LzD/zgkvr8v4zZYnSpFdfax7PjUxPTSCanAhU
         BsLP9esJ2BXsiamaUa6oQVuOAaskwU4JATvhqrCqTPfSZfTFghBGhG7wi5FLOqe7GikU
         9pzMnLXBHqMyIlAOWcD5Z10OQnIjqUOGAQSlRgBDbRxS/Q7sHzWXPJ7IOllmp4SmL9sn
         i1ByD67Y5kUc/LlGo7m24sl+cTLfUXaHdrUPYz6+absT6DLLkDOoIrWE3Wkb7Pe1lt2Z
         kcNg==
X-Gm-Message-State: AOAM532fmR8r00eUv1ZqaSK7NgNoQHk+ydL+jaNyZPelINwJYcGT6x7O
        wSComGqNtJ+avKWtD1gIMv0=
X-Google-Smtp-Source: ABdhPJxhmr6DriGTWC61I1rG7KBw6+1UzumW30Qn/3nu2bPOhd9tdbUkLgTo4VaC/LRP3B3hLVFn+A==
X-Received: by 2002:a2e:7503:: with SMTP id q3mr6861229ljc.48.1631830746667;
        Thu, 16 Sep 2021 15:19:06 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id z7sm483072ljh.59.2021.09.16.15.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 15:19:05 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
 <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
Date:   Fri, 17 Sep 2021 00:19:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.09.2021 23:46, Florian Fainelli wrote:
> On 9/16/21 9:23 AM, Florian Fainelli wrote:
>> On 9/16/21 5:03 AM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This has been tested on:
>>>
>>> 1. Luxul XBR-4500 with used CPU port 5
>>> [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0
>>>
>>> 2. Netgear R8000 with used CPU port 8
>>> [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5
>>
>> These look good at first glance, let me give them a try on 7445 and 7278
>> at least before responding with Reviewed-by/Tested-by tags, thanks!
>>
> Found some issues on 7445 and 7278 while moving to the latest net-next
> which I will be addressing but this worked nicely.
> 
> What do you think about removing dev->enabled_ports and
> b53_for_each_port entirely and using a DSA helper that iterates over the
> switch's port list? Now that we have dev->num_ports accurately reflect
> the number of ports it should be equivalent.

The limitation I see in DSA is skipping unavailable ports. E.g. BCM5301x
switches that don't have port 6. The closest match for such case I found
is DSA_PORT_TYPE_UNUSED but I'm not sure if it's enough to handle those
cases.

That DSA_PORT_TYPE_UNUSED would probably require investigating DSA & b53
behaviour *and* discussing it with DSA maintainer to make sure we don't
abuse that.
