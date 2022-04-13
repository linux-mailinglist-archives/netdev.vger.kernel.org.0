Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911864FF69B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiDMMXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 08:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiDMMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 08:23:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B086F5AA6C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 05:21:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b15so2137982edn.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 05:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AkGklnty57yCILmUblbJRB8X6WGVVTnSwjTLFB+Ahyg=;
        b=zEjDLJeNwDYO20naLR11cjx1Ddm5ja6P93pjnR9KqLYy6aYXUjVBkGik/xCW6jxQ2S
         pZLxk6SE2PsQ4LpxUPJYvq++DWdvrCSfjCqp2PJMt9TklorXz5yHar0poqG34egddajr
         yytuTvCh1H1AiwPiCCI8/TSp2CaWA9mDjcjWs9Yi0sYZbwQQqgPuFiblKIe+7GowiONv
         HdrPc/KlJ9xX7nefFkCgSIsTjQPigqgvtlFCIve7Gnfj1p84aJSEiJ/fQdAL/xAdwsNf
         RjIp7syMVwSTmqlT/B5kGjPtc1+1oiBvPYdNkNVQTle0JGvxH5cdQSwXSQ5dUzj1T9zF
         DfPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AkGklnty57yCILmUblbJRB8X6WGVVTnSwjTLFB+Ahyg=;
        b=qkvmf2K2z5b+1uPAH2xA1HCFCetkq3pT1w5yQAXzzpm44BNFqk2wwQjDX6uLSycl3b
         vkXrzViAx9crWqnV2xnvtQ/x+oihOg8wbwSwaSDlj31kqxS0iYUqnRJU/dTcgV9YGsOQ
         emtpaprn0vrwvbprzf4f0VBeRRINgiFOQw+3cW5iNXnhMIhjfI6xtngsCFMGInb2oabD
         ViJZvm8480oQ7jYvOlvAi8qrvQmPTMqDd1FgXOlVYe/8HAVRRixG9x9vitLB0z8RhUYe
         tAV+ukGOYgHfuNOVKVxMJfv9pwF3mWLLEOFmzNM5chucwmfvzqNeX6lwESTZ5FYrLiOS
         GOSg==
X-Gm-Message-State: AOAM531tE3jjWEibjrp9Kf0U7DujhdXl3vUO3qcVpWM8DHIY9zOa3KlM
        Rc3Bi5bXt5pUvjNAPhn7Q7zBL3Hj17/OL+Uo
X-Google-Smtp-Source: ABdhPJxxc4eT5SAGj/mlGvnOM6KVnBOBe11XEP9aAdc5R4HouwJCU63i5p3FksYBdg7MDl3DT+IXZQ==
X-Received: by 2002:a50:cd8d:0:b0:416:63d7:9326 with SMTP id p13-20020a50cd8d000000b0041663d79326mr43073833edi.233.1649852475004;
        Wed, 13 Apr 2022 05:21:15 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z23-20020a170906435700b006b0e62bee84sm14155560ejm.115.2022.04.13.05.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 05:21:14 -0700 (PDT)
Message-ID: <e43b5033-d350-fc81-71be-de3e1053c72a@blackwall.org>
Date:   Wed, 13 Apr 2022 15:21:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v4 05/12] net: rtnetlink: add bulk delete support
 flag
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, roopa@nvidia.com,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-6-razor@blackwall.org> <Yla8wj7khYxpwxan@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <Yla8wj7khYxpwxan@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2022 15:06, Ido Schimmel wrote:
> On Wed, Apr 13, 2022 at 01:51:55PM +0300, Nikolay Aleksandrov wrote:
>> Add a new rtnl flag (RTNL_FLAG_BULK_DEL_SUPPORTED) which is used to
>> verify that the delete operation allows bulk object deletion. Also emit
>> a warning if anyone tries to set it for non-delete kind.
>>
>> Suggested-by: David Ahern <dsahern@kernel.org>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>> v4: new patch
>>
>>  include/net/rtnetlink.h | 3 ++-
>>  net/core/rtnetlink.c    | 8 ++++++++
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
>> index 0bf622409aaa..bf8bb3357825 100644
>> --- a/include/net/rtnetlink.h
>> +++ b/include/net/rtnetlink.h
>> @@ -10,7 +10,8 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
>>  typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
>>  
>>  enum rtnl_link_flags {
>> -	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
>> +	RTNL_FLAG_DOIT_UNLOCKED		= BIT(0),
>> +	RTNL_FLAG_BULK_DEL_SUPPORTED	= BIT(1),
>>  };
>>  
>>  enum rtnl_kinds {
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index beda4a7da062..63c7df52a667 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -249,6 +249,8 @@ static int rtnl_register_internal(struct module *owner,
>>  	if (dumpit)
>>  		link->dumpit = dumpit;
>>  
>> +	WARN_ON(rtnl_msgtype_kind(msgtype) != RTNL_KIND_DEL &&
>> +		(flags & RTNL_FLAG_BULK_DEL_SUPPORTED));
>>  	link->flags |= flags;
>>  
>>  	/* publish protocol:msgtype */
>> @@ -6009,6 +6011,12 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  	}
>>  
>>  	flags = link->flags;
>> +	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
>> +	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
>> +		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
>> +		goto err_unlock;
> 
> If a buggy user space application is sending messages with NLM_F_BULK
> set (unintentionally), will it break on newer kernel? I couldn't find
> where the kernel was validating that reserved flags are not used (I
> suspect it doesn't).

Correct, it doesn't.

> 
> Assuming the above is correct and of interest, maybe just emit a warning
> via extack and drop the goto? Alternatively, we can see if anyone
> complains which might never happen
> 

TBH I prefer to error out on an unsupported flag, but I get the problem. These
weren't validated before and we start checking now. The problem is that we'll
return an extack without an error, but the delete might also remove something.
Hrm.. perhaps we can rephrase the error in that case (since it becomes a warning
in iproute2 terms):
 "NLM_F_BULK flag is set but bulk delete operation is not supported"
So it will warn the user it has an unsupported flag.

WDYT ?

IMO we should bite the bullet and keep the error though. :)

>> +	}
>> +
>>  	if (flags & RTNL_FLAG_DOIT_UNLOCKED) {
>>  		doit = link->doit;
>>  		rcu_read_unlock();
>> -- 
>> 2.35.1
>>

