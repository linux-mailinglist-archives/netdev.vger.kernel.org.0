Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D03522622
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiEJVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiEJVMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:12:09 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843B1CE60C
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:12:07 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id k2so57005qtp.1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BHYB7ZR1B69FnFphXq5G/Miae+Woe0CMGX0CpE69bPU=;
        b=YPJjwSEjNjwONrn6LnTL+UzbHTbjNSWSSRXpf5S/NuUuG2WCaY06yN5JkfMuijZxYS
         W0wwf7hcl5iALqK8ycxx9qZQ9NOq499k0A4Un5Il2z3z8HN9Vf6wYpHwd4ZIbHEJ0a35
         4U/NpOPwRN8HTMgzUSQvwlFB3pSu+FPFxnULukUagz85T/XI1qbRCJLIRxmw5z4D3QMV
         TQnhf+p5vXV6DFW+dtk2WjLE50Vs/1bYtmNpZEOLD9LMGC8SNIinz4K7+TwIPv9JiRDk
         54Pqrfn8VFPIMmQhhCh4If/tup6YuzgIRrOQIV35oUp8Q7B4Mmo6qu0mff9SmRIO+MOp
         bmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BHYB7ZR1B69FnFphXq5G/Miae+Woe0CMGX0CpE69bPU=;
        b=d5bX4TW95PKUhD3Ia6hldy4aYRdO+rd15R8WWtO06mLTo0ITPUMU/NjOPavEK/lv8E
         e4KugX90hq+XDIfF7JOSv8j6El+Pg3iaeGex9WQE65AgxYgLaEhS28fxXiXlM1AVzfNI
         LDSsQLPoYZ5Nu61/jJrQPvOf97IjXHlm4huXp7pb8B7TMVwdLv/Y4xVt5I9nksUQ6lgY
         QCcy+a6oNvbNnRhaa+zaZGf0XEgXqpvGrbg5jZlW4NXhJ8k3nLtgo0piHauspR7n/wSV
         8OCHi8mogOgOulPZBePEYEQfpZmC4SwNYpZA6kUhuSob9+mEpkGoqWOAVaJDJSC8+Iwx
         qL4Q==
X-Gm-Message-State: AOAM530BECo4VUiSKuC3gz4MQP83zjkhNYh5M75Fv/u/7mpw46SDGp72
        Ei16DIrld69lSlTEI4y848liDuKsqRIjPQ==
X-Google-Smtp-Source: ABdhPJxrZJ9GuA/EoZlbRWW8AmNuNipIEGuqjQ58lgkmElOF3G8WlowkpE3qrod8js3XCv1jzgqfzg==
X-Received: by 2002:a05:622a:551:b0:2f3:d590:9a5e with SMTP id m17-20020a05622a055100b002f3d5909a5emr12746861qtx.165.1652217126576;
        Tue, 10 May 2022 14:12:06 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id o24-20020ac841d8000000b002f39b99f686sm34445qtm.32.2022.05.10.14.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 14:12:06 -0700 (PDT)
Message-ID: <03c742ba-3984-85c6-2d42-77d338e76a4c@mojatatu.com>
Date:   Tue, 10 May 2022 17:12:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 net] net/sched: act_pedit: really ensure the skb is
 writable
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
References: <1fcf78e6679d0a287dd61bb0f04730ce33b3255d.1652194627.git.pabeni@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <1fcf78e6679d0a287dd61bb0f04730ce33b3255d.1652194627.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-10 10:57, Paolo Abeni wrote:
> Currently pedit tries to ensure that the accessed skb offset
> is writable via skb_unclone(). The action potentially allows
> touching any skb bytes, so it may end-up modifying shared data.
> 
> The above causes some sporadic MPTCP self-test failures, due to
> this code:
> 
> 	tc -n $ns2 filter add dev ns2eth$i egress \
> 		protocol ip prio 1000 \
> 		handle 42 fw \
> 		action pedit munge offset 148 u8 invert \
> 		pipe csum tcp \
> 		index 100
> 
> The above modifies a data byte outside the skb head and the skb is
> a cloned one, carrying a TCP output packet.
> 
> This change addresses the issue by keeping track of a rough
> over-estimate highest skb offset accessed by the action and ensuring
> such offset is really writable.
> 
> Note that this may cause performance regressions in some scenarios,
> but hopefully pedit is not in the critical path.
> 
> v2 -> v3:
>   - more descriptive commit message (Jamal)
> 
> v1 -> v2:
>   - cleanup hint update (Jakub)
>   - avoid raices while accessing the hint (Jakub)
>   - re-organize the comments for clarity
> 
> Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Tested-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Thanks.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
