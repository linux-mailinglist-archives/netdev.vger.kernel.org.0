Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A151A3B6D21
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhF2Dtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhF2Dte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:49:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB51FC061574;
        Mon, 28 Jun 2021 20:47:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e20so17319185pgg.0;
        Mon, 28 Jun 2021 20:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hZzqtbvkB7GBRgetqJbBkcO8TSNI10ddi6eSpYQhmjk=;
        b=u9wduzDmN6NnfbfcHJ6Z+ZIf6NZApRuPIqHspA8SfbBh44cMhfCkLtrmvuSzR/Xwm3
         fBnpUaot1FuwKG4xF4umBk3biBH/iWmOmSR+2+wsE4WKI4IN6eoXRaRXbzTFnHww3Kv3
         tfVTMMwBqoAdXFHD0jIi2OkTZ8opsWfIb+T5Qhz8QjewANwp6IDySHQMi5XXfxJy1qz6
         zqsSV3g3mBMRKeUa8eXrj+kmeWQHSOGSrmbMTHnSL/mWY4wXSYLuSJ1EcmrrFGDRx3PC
         u0dwJYmv8icWioAO5t9W1OoGYTudl61L+SJAccGz8C9NS83YoPB7KJXzDXGn/+ENPvW5
         uGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZzqtbvkB7GBRgetqJbBkcO8TSNI10ddi6eSpYQhmjk=;
        b=luX4s3fQvpmkcID5hiPteQFKzlHHVd1E6fSPmAbLUfEsd1W4NkPXdioT7TvAZ3J4Pe
         AYQRW/MEfapsM0f8Xtww/ELnRWD5phC5kbh1MY+47U+lqBfvJe72Vxgd6jDZKfyIVpCq
         G2ziFve6jGUNjdxdSy/F193VUX2flPU5uYvJSv93xiO6H1gNOo8g4/NyMVndeT0Wz955
         Ca51vvrShvCiLB7XzM0FQrlCmDwDRE2XwA+eNUjWvhmpXS4LUKE/sIOHAF/TNFkkL1UA
         JemW+kiEsK/gXih7u9kWU929uPHTKFNlYPkCbVje+/39PNOPaSfMmpYA3ySQJLIH+uiK
         j3QQ==
X-Gm-Message-State: AOAM530QLN7QFxB2rht29vvFW1U4DBIFRcoRNJcBltBEMbLrMSVklpB2
        di0ddLPgH+Hwzgi4KUa/xCQng6dhV0Q=
X-Google-Smtp-Source: ABdhPJzr517gUfci9KTm5fRHv38JUMaAO8LsYEEvRWR63qVQgiEE0MWdkUoZkzyGDsqiWHeaFmFtyg==
X-Received: by 2002:a63:d909:: with SMTP id r9mr26771453pgg.285.1624938427052;
        Mon, 28 Jun 2021 20:47:07 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id z15sm9134313pgc.13.2021.06.28.20.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:47:06 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210625215732.209588-1-opendmb@gmail.com>
 <79839c8f-4c4d-a70d-178c-1d7674e2b429@gmail.com>
Message-ID: <8076667b-59e7-5289-362d-5cc55bfb56f5@gmail.com>
Date:   Mon, 28 Jun 2021 20:47:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <79839c8f-4c4d-a70d-178c-1d7674e2b429@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 3:03 PM, Florian Fainelli wrote:
> On 6/25/21 2:57 PM, Doug Berger wrote:
>> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
>> logic of the internal PHY to prevent the system from sleeping. Some
>> internal PHYs will report that energy is detected when the network
>> interface is closed which can prevent the system from going to sleep
>> if WoL is enabled when the interface is brought down.
>>
>> Since the driver does not support waking the system on this logic,
>> this commit clears the bit whenever the internal PHY is powered up
>> and the other logic for manipulating the bit is removed since it
>> serves no useful function.
>>
>> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 

Doug, it looks like this patch introduces an unused "reg" variable 
warning at lines 3296 and 4137 which is why the patch was marked as 
"Changes Requested":

https://patchwork.kernel.org/project/netdevbpf/patch/20210625215732.209588-1-opendmb@gmail.com/
https://patchwork.hopto.org/static/nipa//507371/12345957/build_32bit


-- 
Florian
