Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B14F501880
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiDNQ3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbiDNQ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:27:42 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BC5E38B0
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 08:59:06 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id e128so2074540qkd.7
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 08:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1DX0lyINfb1pO0E9UqEP2udMW5s1Q48MThNGtw+CSPw=;
        b=F9SyxpO2X8uUUwPgnv8NDxaWHPbLydGjR0rY1+R0OjpWuzyTS2DefgZJ6v8GdyTcYh
         GIc6mLfF6ytHElmCn5AokFCfDjFju+tKY4AcULO+aEE9g/E5MXwyQegafX9yQ5Wcf60E
         mfyxnZ2DgbybfVl9XANh+fe0Nc8schG6hzevKiPZcon/4WwV8GXbwV3lwBQidi0R6VYW
         TOPBZn8q9dQoWsmCKSOWVGEYTDlFuug3+3n4gefbUL8aiLMN8FztzTo8CvIoZqxXAGoK
         BPy1jwaHvvcgox/wW1r4/+u6vlWrYeR1i2dk3Om/1E4XsJqNM9dMi4PLkv5s1bYRJrFM
         L9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1DX0lyINfb1pO0E9UqEP2udMW5s1Q48MThNGtw+CSPw=;
        b=7ThwksBqV84Gvvp3jSxiWwt5m9jBh5PCqL06Eh1HG0xxpfGaUoFdyOVafhX/oybypU
         kz/EyFa2ZivMNX3o+amQVFfHse4LzZlC8WBqQKJLBh0Dt5AIueaS1jtyHyz6r7/dd45y
         cm5Pd2kGM03q/QIgx/UTvUqWB5qh7iNucUPdDfu7J0gHfpLqtHfLOK5rrTkTku7uWEVK
         p3D+1J0ixsFUnHNz79ACKTle+aKz8aoqrH8g0A+m9yZWSsGzUivRtPu8pwNqCou0pAP2
         HrdX3jKxKxNjkCMOhBdj3D3BTt3w4omaEW4iZSMvx+PNx+cvZlK3H0kHYp5fQXOj14p6
         nFjg==
X-Gm-Message-State: AOAM533XbnwzUToBFOVWlxJVV+LpbEPOC8hwvgs1twVqx7RVzAX3k73p
        JGoY8vRJ7wCxnmojKzpNHhhwAw==
X-Google-Smtp-Source: ABdhPJxgSppQa6lxMPMHNXuZsRlGmELqFsI+wlVnLVfuRgM+8HMbuo7CwLe+oVYIR49fu6rXG5mVEQ==
X-Received: by 2002:a05:620a:2848:b0:67d:35de:bb5b with SMTP id h8-20020a05620a284800b0067d35debb5bmr2318047qkp.499.1649951945134;
        Thu, 14 Apr 2022 08:59:05 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id h8-20020ac87d48000000b002e1c6faae9csm1401646qtb.28.2022.04.14.08.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 08:59:04 -0700 (PDT)
Message-ID: <60ef60b7-f562-917a-ebd8-1d7cf7080d82@mojatatu.com>
Date:   Thu, 14 Apr 2022 11:59:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix netns refcount changes in
 u32_change()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20220413173542.533060-1-eric.dumazet@gmail.com>
 <20220413173542.533060-2-eric.dumazet@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220413173542.533060-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-13 13:35, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We are now able to detect extra put_net() at the moment
> they happen, instead of much later in correct code paths.
> 
> u32_init_knode() / tcf_exts_init() populates the ->exts.net
> pointer, but as mentioned in tcf_exts_init(),
> the refcount on netns has not been elevated yet.
> 
> The refcount is taken only once tcf_exts_get_net()
> is called.
> 
> So the two u32_destroy_key() calls from u32_change()
> are attempting to release an invalid reference on the netns.
> 

Looks good to me.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
