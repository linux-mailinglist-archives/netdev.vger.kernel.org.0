Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024E9286295
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgJGPup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgJGPup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:50:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF578C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 08:50:45 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o8so1208795pll.4
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 08:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=enMXeXhce7HWX1K+XIyHLmz0fniYh9OVD5FFxd9xnNI=;
        b=uJQPINsXVk8NIclA9Pdo6Ux16QfvM28KhUI1LS7bJPpo8Fy89ytk/OQNNH3oRbZ0gp
         cqbfGU7fSJVKhxkj9dvRsEc13APWP7H1uxD1Wd5ss5/LlXy1kNvIPn6m56lldrPEMb+A
         UdhRJqYyx+0Bzs41fAZxk6FveX9Wm1c+eWU+hc6DMbpF+8g/N47ebBNWyU8SnF5i+iOh
         i1y38R98xC91HmsxyEKtV59bkW3bXpoYM8PGWZv6urse1qtRVY9qWNYIFYG8fM2yUDAj
         qB3F2JwKLICzthqE4CI8uYIO2Ri76tlWJpFgoVZ1aobBnhH23NoQrWerpN+jVsGnO9+U
         l41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=enMXeXhce7HWX1K+XIyHLmz0fniYh9OVD5FFxd9xnNI=;
        b=SB3J/uFmWeNDCQPyqWbXbuEldYB5zVbyk5e7nDo4W7Gxn2jDf+wW2YUy1EeoJ2V7UI
         j2au/ZvKvxlV5Aiho2JS/4xvX+uLu7q4yuGSuR2cofj7Q8X7TR2nzNC666MruMrGKfM2
         f10tB9ZNcaMEREdjkA/2Rc5f0fsihmTfo24SKtD4fp5bOY5flXtZ0HYOSfRyhXM8QECc
         qXWR8JJZP0xjYu0iJzT5yjOgd1vsn9q0UHMshCHPlwJzI0u+iDOwb9SfxKkif7ZMUece
         5iWld27TK7T4m98JnIwcokF3qPdcH2uuzeb/lX79V8PDfW2/wbHu7x8MkSWmA+zDIeyb
         VI5g==
X-Gm-Message-State: AOAM532vU38H6Gf+p07x5AfswFsJel2A357tZQvac9QktxR9neLP4iUZ
        mjwdItkPJ3dRA8lQMnhfbkCjMCBn8EuvNQ==
X-Google-Smtp-Source: ABdhPJzWTSjOLTij+Bu1kmKRjyiB/ywPWEdcRhEvadVhLEJMNIJquD7vWdwaBWjMypkbrBvIozP43A==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr3353029pjb.221.1602085845018;
        Wed, 07 Oct 2020 08:50:45 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.184.170])
        by smtp.gmail.com with ESMTPSA id t186sm3791817pgc.49.2020.10.07.08.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 08:50:44 -0700 (PDT)
Subject: Re: net: Initialize return value in gro_cells_receive
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
 <9c6415e4-9d3b-2ba9-494a-c24316ec60c4@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <03e2fd9c-e4c9-cff4-90c9-99ea9d3a5713@gmail.com>
Date:   Wed, 7 Oct 2020 08:50:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <9c6415e4-9d3b-2ba9-494a-c24316ec60c4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/2020 1:21 AM, Eric Dumazet wrote:
> 
> 
> On 10/6/20 8:53 PM, Gregory Rose wrote:
>> The 'res' return value is uninitalized and may be returned with
>> some random value.  Initialize to NET_RX_DROP as the default
>> return value.
>>
>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>>
>> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
>> index e095fb871d91..4e835960db07 100644
>> --- a/net/core/gro_cells.c
>> +++ b/net/core/gro_cells.c
>> @@ -13,7 +13,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
>>   {
>>          struct net_device *dev = skb->dev;
>>          struct gro_cell *cell;
>> -       int res;
>> +       int res = NET_RX_DROP;
>>
>>          rcu_read_lock();
>>          if (unlikely(!(dev->flags & IFF_UP)))
> 
> I do not think this is needed.
> 
> Also, when/if sending a patch fixing a bug, we require a Fixes: tag.
> 
> Thanks.
> 
If it's not needed then feel free to ignore it.  It just looked like
the unlikely case returns without setting the return value.

Thanks

- Greg

Thanks,
