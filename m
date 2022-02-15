Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4C94B5EFD
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiBOAWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:22:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBOAWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:22:53 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679FB135725
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:22:45 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id bs32so15946065qkb.1
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2jZUgLqnhahw+gLupg9iynRXZT4E5Qs4e6rKnkb62s8=;
        b=U3jYD+3lN36eR/1MR9TQJ+pYkeI5pCasgWXk7WsbBP17WZzobhniqnhWC1LvLYITmm
         FXhEdh+ROFUuPv6qfO5tILU9dFafxqcWQvv9x6ihHPrw6xtzdaclJWg+D+x4sJxSj7Uz
         RdEiSeEgEVkLMshmFU/pVHHwfN+f9s3+xwU2i7Hhco5CX54piU7e35b7NZc353uJZVCv
         th6sK1Czgy05L4TJnswR/SqEk7F54hwpLtQTHdZzX4R8neywUxb4cGHozQDxpLZsN/HF
         nCh5BsMLlez+fWoI5B/ih3NC2ddLJs42i1U4FF5pRYdzH6kWZql+ls5vtiRQS+Zl3Air
         +DVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2jZUgLqnhahw+gLupg9iynRXZT4E5Qs4e6rKnkb62s8=;
        b=eIe/oRUUH2ft+y00uQnVnIu3xKlZjfI/AyYzKEqFY/rAP652/tnVL5gkT9wK7PYdB0
         AtlkZlw7EK66so6uF1UtKywlY9wGvc+Ge11xkoiIikNOChdiP9m+pIUIZjPwg+pUidTq
         fdDVtQ+DP1VIatnMt1bd++ybBJ7fZbe4nn5SQ66WZCPIu6p26cT+kUlTPXCF5Roaqf4I
         t2/9k2/UmUvf2sUt/dQ77piHtskdzjwW6r6xhrIiKYuXW9QyHtZD7F3wncLcuFyh04C5
         3ehFXd274Qx7t6fvs7l3k+lawLbzgKCLWZyp3J/xD8ri8xuWu8eohLmLDwRNbhqOGMmL
         S1Rw==
X-Gm-Message-State: AOAM532G9rGME/weU2Vvm7ZD7Nkf1KS33N5bZRchOsNFNpbg8jTgY6VU
        pqW269VmYSxmNyqNBiJbgr1OKQ==
X-Google-Smtp-Source: ABdhPJyZpdPXqb4ZeC8Sw/PAMKA42ZqfL643lIGknDrQ1sT7gV2naDFTcPxmNmz1GeVNl5H4LCwbKA==
X-Received: by 2002:a05:620a:4149:: with SMTP id k9mr857398qko.323.1644884564517;
        Mon, 14 Feb 2022 16:22:44 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id n7sm18992481qta.78.2022.02.14.16.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 16:22:43 -0800 (PST)
Message-ID: <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
Date:   Mon, 14 Feb 2022 19:22:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Content-Language: en-US
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 09:32, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patch allows user to select queue_mapping, range
> from A to B. And user can use skbhash, cgroup classid
> and cpuid to select Tx queues. Then we can load balance
> packets from A to B queue. The range is an unsigned 16bit
> value in decimal format.
> 
> $ tc filter ... action skbedit queue_mapping skbhash A B
> 
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> is enhanced with flags:
> * SKBEDIT_F_TXQ_SKBHASH
> * SKBEDIT_F_TXQ_CLASSID
> * SKBEDIT_F_TXQ_CPUID
> 
> Use skb->hash, cgroup classid, or cpuid to distribute packets.
> Then same range of tx queues can be shared for different flows,
> cgroups, or CPUs in a variety of scenarios.
> 
> For example, F1 may share range R1 with F2. The best way to do
> that is to set flag to SKBEDIT_F_TXQ_HASH, using skb->hash to
> share the queues. If cgroup C1 want to share the R1 with cgroup
> C2 .. Cn, use the SKBEDIT_F_TXQ_CLASSID. Of course, in some other
> scenario, C1 use R1, while Cn can use the Rn.
> 

So while i dont agree that ebpf is the solution for reasons i mentioned
earlier - after looking at the details think iam confused by this change
and maybe i didnt fully understand the use case.

What is the driver that would work  with this?
You said earlier packets are coming out of some pods and then heading to
the wire and you are looking to balance and isolate between bulk and
latency  sensitive traffic - how are any of these metadatum useful for
that? skb->priority seems more natural for that.


cheers,
jamal


