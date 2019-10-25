Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65C9E5136
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633049AbfJYQaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:30:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39868 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633030AbfJYQaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:30:04 -0400
Received: by mail-io1-f67.google.com with SMTP id y12so3103424ioa.6
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 09:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NFzovqHITpKQQZnPtHYfX5MJCsnd/hMdxVkOqr8V9L0=;
        b=bgI0pYqDPUl6GscvHocQkQ61TEil0827iOQS97Qo058KYICUvSH7R+QqPUD+8hgoNU
         LOoIVFQllcW3F4A4MhKLjxWgwAccijf3xKu9fF8ZdRy6o5Q24iyFcLoW/PFm1lwAWTnx
         Ylv2AS8nmO6rRtA3KShzbZSa6cF9kKI0EUDom0ynMs6PAAVSq2Wd3GTprx+mI5WFegcP
         4dSAnWolczsk+CsGdxtO9d66PLlCVuwgLlWtRsqhjUS+t7fRxAFpmd0hKFoX3G2fkrAj
         XlmLj9DPI1DSCGV1zjBJRXp0sqFcRfoE9tnfKIDOT/aKqIvcIvyFyc4Zp6zjlfDhGKRs
         JLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NFzovqHITpKQQZnPtHYfX5MJCsnd/hMdxVkOqr8V9L0=;
        b=Zps5ms/MAXh8+Mz12Ev+SWpxVGAl1O3BU8pWSfRHQxZehVXl8opKKr5ajnkmh3brLy
         R+uaOR1NzDnk03PLSqbh03ACwj/hTIDQTztzSm7TQzeLM0BkjfWRznEqXnpIOAKrcDcq
         V0QkRyFEDIHTyPNVRwxdW/ZUb9Yj0LcS0WgtQWZdO6BjNH55tYk2AVLtVF+eCt9xgpkx
         Wn8oh2kKarOVSC4iGZ7tefTWuLKZH2a9mMjXL22BsoHBsiej+yGGrL6vnzl/ElXlv9Hq
         mjL8dqzT1hFfEBSeZ8Vd+x+f0+BjKgxM2E7+W6aJhQFQ4mBCtSNODwMkQ0SIaVpxOwvs
         c+rA==
X-Gm-Message-State: APjAAAU2vuE1oqQpIPlNULAv5AeBFd8SroFuZogaD/ONIk/2dKeixcn+
        qnAkNi5f+PjX4VA1VVlkpk8KPA==
X-Google-Smtp-Source: APXvYqwGNg/gADjBMOkE8dvY+CgFP8VQzr7lKZ6Z0iVaier50F41XfOScMEDeM33AOM1+Y7SOUdAdw==
X-Received: by 2002:a02:a90b:: with SMTP id n11mr4749451jam.13.1572021002253;
        Fri, 25 Oct 2019 09:30:02 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id 133sm415872ila.25.2019.10.25.09.30.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 09:30:01 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
Date:   Fri, 25 Oct 2019 12:29:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfpniku7pr.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 12:10 p.m., Vlad Buslov wrote:
> 

>> Hold on. Looking more at the code, direct call for tcf_action_init_1()
>> from the cls code path is for backward compat of old policer approach.
>> I think even modern iproute2 doesnt support that kind of call
>> anymore. So you can pass NULL there for the *flags.
> 
> But having the FAST_INIT flag set when creating actions through cls API
> is my main use case. Are you suggesting to only have flags when actions
> created through act API?
>

Not at all. Here's my thinking...

I didnt see your iproute2 change; however, in user space - i think all
the classifiers eventually call parse_action()? You can stick the flags
there under TCA_ACT_ROOT_FLAGS

In the kernel, tcf_exts_validate() - two spots:
tcf_action_init_1() pass NULL
tcf_action_init() before invocation extract the TCA_ACT_ROOT_FLAGS
(similar to the act_api approach).

Am i missing something? Sorry - dont have much cycles right now
but i could do a prototype later.

cheers,
jamal
