Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3605065E6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbiDSHdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349403AbiDSHcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:32:25 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BB932999
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:43 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id r19so4159785wmq.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=e2MJ89ipUoPM0hUpWDvCWyRAZw1/0antsYxr1TtB7Kk=;
        b=RwsgIY0fEyrJPtEp85MTBGvuEnBemH1BQmKHdqPcHIsQeKn5J68OyzAh3EXgBDDNLI
         qbgsYeu0KbygVlB8GiOxPztVHr5fFPU+ofIEtMmvnGqmm7Lt7YABQYUXW6Dp4jlrgR6+
         cVIE0l2xo8+eXFfuQNWp8AereDtpQuEqKo20Ph3dxrVqX+UoKVXz7AoeDkh1rMP5mdhU
         bOkrnOHxSy1IIXdtvqnFlxu1pq4F5h8sS4UY7kYjfxD7y518gT9aENEdxEQ9xYhWxDlh
         pWKbS+EId8OIa2nmLD6h/c0GgYHurgin8E/ErHTflyKo5s7J/wehkSJAsq8PmFKnHBV9
         NQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e2MJ89ipUoPM0hUpWDvCWyRAZw1/0antsYxr1TtB7Kk=;
        b=38zHROcpp1Rb2HYxCWoHbtiGqgWqtiS5bvrKBAr5Sw0Ehz0QKpEEm2/IJpJll9meQS
         sLJ4klwRvuM6bqu1h36mi5SKpqOJSFFpleKLMojVBcDRrBn1cXsFNL2/PbdUEwbRyUtX
         65aDiaikqbpZqxC7P5BhEppJ8Bu6O9rZiAxTyD076z7+eqV4iclxKxEWUvPYnBLcZ2hr
         fbI5S4fFeOfRuONt2yDB5DWQyT0LkM34gxqf6Mvda/7i6ylJ3D95lgqa3V2UwYVj5fKH
         /pkCNK3uFf3z8TtgnRxaBbrL2APm6YdvQq0y4PEO/DkeSkGsnSImre4VRzMvT3h6eYiD
         AwxQ==
X-Gm-Message-State: AOAM530YOWQpESac1BP9ypFTv48gOlZgFw7oclEeVzBRYKUTvV/vqq0E
        Gbz2QdnNoDfQgUwvKt/WXdEOfg==
X-Google-Smtp-Source: ABdhPJw2G5/IYenxI9CVA9rl3HHdezcADbN8I/PGPqAqdTc1+t/1biGWkuli/JcogDuNVyda8/U6Ow==
X-Received: by 2002:a7b:cb05:0:b0:38c:7910:d935 with SMTP id u5-20020a7bcb05000000b0038c7910d935mr18429857wmj.170.1650353381620;
        Tue, 19 Apr 2022 00:29:41 -0700 (PDT)
Received: from [10.4.59.131] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b00392910b276esm7238392wmq.9.2022.04.19.00.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 00:29:41 -0700 (PDT)
Message-ID: <b8b90d39-9052-c150-18f6-a482686db7b8@wifirst.fr>
Date:   Tue, 19 Apr 2022 09:29:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 net-next 4/4] rtnetlink: return EINVAL when request
 cannot succeed
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
 <20220415165330.10497-5-florent.fourcot@wifirst.fr>
 <20220415122601.0b793cb9@hermes.local>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220415122601.0b793cb9@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> -		return -ENODEV;
>> +		return -EINVAL;
> 
> Sometimes changing errno can be viewed as ABI change and break applications.

I agree, but I think this one is OK. __rtnl_newlink function has more 
than 20 return, I don't see how an application can have behavior based 
on this specific path.

And actually, patch 1/4 is protecting almost all previous callers, this 
return is now only here for calls without ifindex/ifname/ifgroup, and 
NLM_F_CREATE not set.

If you think that this change can be merged, I can add extack error at 
this place. EINVAL is indeed very hard to parse.

-- 
Florent Fourcot.
