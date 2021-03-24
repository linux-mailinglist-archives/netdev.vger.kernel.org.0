Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280433484FA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbhCXW6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhCXW6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:58:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038E3C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:58:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso115427pjb.3
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tU9LfJGC/xVweQBwdTKa2+xrDPhRbtP/JWerDdoV/zc=;
        b=Avopmtl2xEowNVkC0c0SrXVBbs5I4c9FlHXKsyZ0+1u+HVCvY0ynLKaNIH7cqlXR3q
         7TtdgQ9pJeyaAlz1Va1h4l3oQ6NJHvGhevwQRezV2/lZPg9PVe89OIw02j/sOwjov4mt
         wPEjGM9I+YE0okyHLLxYdeqfJq3Y0LyrFSuoDU0X8MgXBimPCyR3kNImwNgmMJyJ9GQd
         4oBHv+1zE71DL6jEwwtXu1KAFKLICV0ErsqJTI4cqp3WhkWHlXAerXJ3EGmyvpuq6khZ
         BOEj4m14/8elmMKTLPkWXYTTL0EFUCYD8EQSdEHlMPtNZTSubBIZuLQvQ6mmFAC+HM33
         HLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tU9LfJGC/xVweQBwdTKa2+xrDPhRbtP/JWerDdoV/zc=;
        b=mToO0jcOCSlxDq2g8jn6pwvWpXeYuJQH9hApyS8EVsq3OKCacEj+irQZxszB7crWxH
         h22NEpyuxzR1BKGfRAL7NxIupw4pN6YGz3uizj6DR+i9kXd6wlToRXqLdg+cIMrG9X4E
         wNHhM4BKSH0JWt8rl6VFj7BJX5+fUgGcSjG6loOQ16pW8jvOjRC3JDk9+H1hyVh987oW
         Uv3xLZikr/cr46w6OHWcQEN7V8MbfoPV2wsIX+JocbwlLt9L85914SP0j6+Hbc49IgPj
         jWX1uTl9oDUGqEu8jfWXwTnl4gBLJiwTaIDiUe6spZgbYxqYiCZwYe+c7jVpJRPRJfM5
         cGuQ==
X-Gm-Message-State: AOAM532hWlNUW5QlHtsXjicYAaQXHXBVqxNEmn0K9v3FarDsV3wqOQqA
        8/RVC/DRILvL36wfSMNOwY0=
X-Google-Smtp-Source: ABdhPJzVBYvyFouvEcLy0HgGKHe/1AswKkGc2nBZQcSX2Stxjzm80O1ZOcFTqqxaQBAXdSWLjrDLuQ==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr5675932pjp.199.1616626720360;
        Wed, 24 Mar 2021 15:58:40 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z192sm3404971pgz.94.2021.03.24.15.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:58:39 -0700 (PDT)
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     Hauke Mehrtens <hauke@hauke-m.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
 <d354b9b3-5421-4018-c7ae-d0784d9ff163@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <836aec14-0546-c880-214a-9e1b6561dce2@gmail.com>
Date:   Wed, 24 Mar 2021 15:58:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <d354b9b3-5421-4018-c7ae-d0784d9ff163@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 3:50 PM, Hauke Mehrtens wrote:
> On 3/24/21 10:09 PM, Florian Fainelli wrote:
>>
>>
>> On 3/24/2021 1:13 PM, Vladimir Oltean wrote:
>>> Hi Martin,
>>>
>>> On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
>>>> Hello,
>>>>
>>>> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
>>>> support for multiple (TX) queues.
>>>> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
>>>>
>>>> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
>>>> The vendor driver (which mixes DSA/switch and MAC functionality in one
>>>> driver) uses the following approach:
>>>> - eth0 ("lan") uses the first TX queue
>>>> - eth1 ("wan") uses the second TX queue
>>>>
>>>> With the current (mainline) lantiq_xrx200 driver some users are able
>>>> to fill up the first (and only) queue.
>>>> This is why I am thinking about adding support for the second queue to
>>>> the lantiq_xrx200 driver.
>>>>
>>>> My main question is: how do I do it properly?
>>>> Initializing the second TX queue seems simple (calling
>>>> netif_tx_napi_add for a second time).
>>>> But how do I choose the "right" TX queue in xrx200_start_xmit then?
>>
>> If you use DSA you will have a DSA slave network device which will be
>> calling into dev_queue_xmit() into the DSA master which will be the
>> xrx200 driver, so it's fairly simple for you to implement a queue
>> selection within the xrx200 tagger for instance.
>>
>> You can take a look at how net/dsa/tag_brcm.c and
>> drivers/net/ethernet/broadcom/bcmsysport.c work as far as mapping queues
>> from the DSA slave network device queue/port number into a queue number
>> for the DSA master.
>>
> 
> Hi,
> 
> The PMAC in the xrx200 has 4 TX queues and 8 RX queues. We can not map
> one queue to each port as there are more ports than queues. I am also
> unsure if the DSL part which is using an out of tree driver uses some of
> these DMA resources.

bcmsysport.c for the "Lite" version has the same kind of limitation, so
what it does is limit the number of DSA slave queues to continue to
support a 1:1 mapping.

> 
> Is it possible to configure a mapping between a DSA bridge and a queue
> on the mater device with tc from user space? We could expose these 4 TX
> queues on the mac driver to Linux and then Linux configure somehow a
> mapping between ports or bridges and queues.

There is not a way to establish a mapping from user-space between the
DSA slave queues and the DSA master queues, I am not too sure what would
be the right way to do that but it would likely require changes to the
'tc' tool and ndo_setup_tc() most likely.
-- 
Florian
