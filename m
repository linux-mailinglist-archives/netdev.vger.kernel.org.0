Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A487A6BF491
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCQVsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCQVsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:48:25 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11E338B52;
        Fri, 17 Mar 2023 14:47:41 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id iw3so6704056plb.6;
        Fri, 17 Mar 2023 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679089597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F/BU/W8lH7cT5BJ1G0LSjqLvqmzeVi/1nXNmiJsFiQw=;
        b=ExxFDNebIPcEMGNRBSRPuF6/2/qWbWZJp1w8uIcEMu6itos3/DoG6V2t2qQitkGNcC
         TlkWMaEPUq6RXcWEi6b8hXSDjA7xT5lG05PuUuL3O994K9yblZvEZMyPZ9hICKJ/8wrf
         KWXxm/ou2sBcRLtUY/9XnJ2DAka3AR1JTOuGdNTUrgPN1Qld0mR/UUWpMTQ0ReAFj26d
         Y/5zjEaRTMvuVhEzpS9wllw7Wdwy8FAzEUVOEoQLaIrjA5ZS9pkC38J0kNb3mGEzlxsH
         UMGT0CE/odXvvgEc/eds5NTukVWUxysBa6/c2d9T814AQ/zxzj3JtoBgaeCXkMvz15Qe
         Gz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679089597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F/BU/W8lH7cT5BJ1G0LSjqLvqmzeVi/1nXNmiJsFiQw=;
        b=FNZH888kDMB2T40KfqaAAA/GqTmFJHXiRshuLe0Wz1YBmL2vKEHuF8wBaIVNmCmFZR
         8vtwe7TD4NyxelFcpumBYb3qd/OX4CAJ3YMx5J+v3OoPbrpiD5gXTA0NlJVvun0MrMgv
         P1PJCj42DfsZJd0PiNM5jX3BN5VmzTYLGjOC+IN8A5X/a1ifR0O8rcV7lVXC37cOZemA
         jS/TTntzUnbgE1rexmeKXI+MZXNX5y8dJlgN/sa2lqDz8ghuEFB+D9bMob+xotl+zjVs
         h80QHAwYh5epmgujp1YVd7RMrZRgS3gbjCDK8yBaeVCDScj0J92W0uKNS+SA2oSQPbyT
         gPxA==
X-Gm-Message-State: AO0yUKWzYP/Hb4hw5/mjsfr7yRcpjXKcBtH7RxtcJPFbYA03mQE39hmg
        x2sTcxVZrxvcYQwGWYPjLTY=
X-Google-Smtp-Source: AK7set8MILLIaeW6Xq+4Uh9meXyQ6MxrFX0iBrKJ+UOvhYnz/ZiAugZ228Jnyxkz7FwexRr40QX5UA==
X-Received: by 2002:a17:902:cecd:b0:19e:9f97:f427 with SMTP id d13-20020a170902cecd00b0019e9f97f427mr10457478plg.10.1679089597455;
        Fri, 17 Mar 2023 14:46:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::1380? ([2620:10d:c090:400::5:87c3])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902b58a00b00198b01b412csm1958472pls.303.2023.03.17.14.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 14:46:36 -0700 (PDT)
Message-ID: <8a268c26-ea57-89ec-9fea-72ec5b8e12e2@gmail.com>
Date:   Fri, 17 Mar 2023 14:46:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v7 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US, en-ZW
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kui-Feng Lee <kuifeng@meta.com>, bpf@vger.kernel.org,
        ast@kernel.org, song@kernel.org, kernel-team@meta.com,
        andrii@kernel.org, sdf@google.com
References: <20230316023641.2092778-1-kuifeng@meta.com>
 <20230316023641.2092778-3-kuifeng@meta.com>
 <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
 <ee8cab13-9018-5f62-0415-16409ee1610b@linux.dev>
 <b8b54ef5-8a24-5886-8f4e-8856dbaa9c34@iogearbox.net>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <b8b54ef5-8a24-5886-8f4e-8856dbaa9c34@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/23 10:23, Daniel Borkmann wrote:
> On 3/17/23 6:18 PM, Martin KaFai Lau wrote:
>> On 3/17/23 8:23 AM, Daniel Borkmann wrote:
>>>  From the function itself what is not clear whether
>>> callers that replace an existing one should do the synchronize_rcu() 
>>> themselves or if this should
>>> be part of tcp_update_congestion_control?
>>
>> bpf_struct_ops_map_free (in patch 1) also does synchronize_rcu() for 
>> another reason (bpf_setsockopt), so the caller (bpf_struct_ops) is 
>> doing it. From looking at tcp_unregister_congestion_control(), make 
>> sense that it is more correct to have another synchronize_rcu() also 
>> in tcp_update_congestion_control in case there will be other non 
>> bpf_struct_ops caller doing update in the future.
> 
> Agree, I was looking at 'bpf: Update the struct_ops of a bpf_link', and 
> essentially as-is
> it was implicit via map free. +1, tcp_update_congestion_control() would 
> be more obvious and
> better for other/non-BPF users.

It makes sense to me.
I will refactor functions as well.

> 
> Thanks,
> Daniel
