Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF22B361F
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgKOQ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgKOQ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 11:26:52 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CEDC0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 08:26:52 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id l2so14402619qkf.0
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 08:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wLGHDcDHFN2qSQrUpYjjusEu2/USwQ9t+K3H57Ndmb8=;
        b=q6S79p68f9G4cIo1TtMUxh2JvCsMzwIe/W4yzIHCKN5badr8lAFBIpmnH61eYzrJk5
         cLIIn3yhoMqFAOY5CEt9Lig7PuAYh5JmqDEalAsChMpJftkvkqJsE+X2API9UR1oIBIH
         oWjzRtToFZq6kVdCN+SleYy7tq1s5LhPyR/80CCF14K0KW3zdhqjXrIfZ8Gpq+LsN42l
         D2VbONdO96DvlAmWeQLMF71rBhb9PRSJKEe2zUOUn/F6yWQ1TjghhuPCz71AtOb8ZYMy
         mPHk7pJ1ciuMC5CvtRG6PmXoZoBeEz1f8E/mSJjYUAkX2CrNlTb2utCRXEaxbhuwppFd
         1bjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wLGHDcDHFN2qSQrUpYjjusEu2/USwQ9t+K3H57Ndmb8=;
        b=JGBJpUfGWeaSXpBku23NqbE6yGa5oHNlNn1Au02BunMaHSBpCEZXnVF6OiHI9XgdEe
         r8xoUhh0X2zMqMN/zwN7MJ2KvZ4xYYemtzB2Fw1w4+UjEbud7TyXvWbsWKVnHRVdLJ0O
         VBO4LLY4f1lKQHYg58kxLt9wBFZhiUyHosxFbhLRUZSfjlMbiuUSn+szJLK1vrp+pHj2
         8TmQp2PyN1ILnUgsee8rKrez5wwUR6yM4dDVT8MCQtZwfNuHB7FEOgg4QDffCXJCdPAa
         0gyDhDtn2dgqhFIyE+8JGxrgKofuEOJRoA0Q70ngWvaqFRdNhLo1xgd1cpT2ajLU1I85
         lGXw==
X-Gm-Message-State: AOAM530oQzBlZZZZAarp/y3uB9Vm6k6z3G3Ao9kC+xo1epgT+qLyBAZk
        Y7cxm35/N8trYr5urd86rkvgPwH1oKFeYA==
X-Google-Smtp-Source: ABdhPJwEno0Zsj8byZwZNXvUb4EmdpuDqheoHVqn7MmPyv4ooc5p8yxdCTL8WGWIXNM5JBI+H7nQHQ==
X-Received: by 2002:a37:8041:: with SMTP id b62mr1000679qkd.244.1605457610347;
        Sun, 15 Nov 2020 08:26:50 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id o15sm10446765qtq.91.2020.11.15.08.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 08:26:49 -0800 (PST)
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <81ce3451-a40b-ae54-fb7b-420d5557e839@mojatatu.com>
Date:   Sun, 15 Nov 2020 11:26:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This nagged me:
What happens if all the frags dont make it out?
Should you at least return an error code(from tcf_fragment?)
and get the action err counters incremented?

cheers,
jamal

On 2020-11-15 8:05 a.m., wenxu wrote:
> 
> 在 2020/11/15 2:05, Cong Wang 写道:
>> On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
>>> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
>>> new file mode 100644
>>> index 0000000..3a7ab92
>>> --- /dev/null
>>> +++ b/net/sched/act_frag.c
>> It is kinda confusing to see this is a module. It provides some
>> wrappers and hooks the dev_xmit_queue(), it belongs more to
>> the core tc code than any modularized code. How about putting
>> this into net/sched/sch_generic.c?
>>
>> Thanks.
> 
> All the operations in the act_frag  are single L3 action.
> 
> So we put in a single module. to keep it as isolated/contained as possible
> 
> Maybe put this in a single file is better than a module? Buildin in the tc core code or not.
> 
> Enable this feature in Kconifg with NET_ACT_FRAG?
> 
> +config NET_ACT_FRAG
> +	bool "Packet fragmentation"
> +	depends on NET_CLS_ACT
> +	help
> +         Say Y here to allow fragmenting big packets when outputting
> +         with the mirred action.
> +
> +	  If unsure, say N.
> 
> 
>>

