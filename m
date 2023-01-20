Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01EA67612B
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 00:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjATXEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 18:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjATXEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 18:04:00 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D0E5E504;
        Fri, 20 Jan 2023 15:03:58 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id iv8-20020a05600c548800b003db04a0a46bso1828524wmb.0;
        Fri, 20 Jan 2023 15:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ro+oitckYt5jOp5YL0JaN8ca7x/Tmhj4QZYlwgIUjjg=;
        b=TA574iROHDwnAQyIpCPDXhFkXwnEk3PrKDpsSdLsxcIPn10qZL78YMa+snrKP81osF
         VYgniwcQVhhtDiNCJYF3hkw2KsZKNY/V/GqlXaruNJ7WQ4nXhiVulkWr9Ne3wf7B6ne8
         lJn0vWySVt62yauhmQfJAa9KpDY2otYlFm+lIeFL6tqhyk4ir2MQil2MkbNT8SAjTbxa
         M8U5Le1X21EYNee5Z1z8JewpKigRRF9VwqMvnIQlRMbJed+IGSMxP6TmBeXnZNC5ysUO
         RzewRq5QYM4GnibJa/4RTpj9VHBcOU8O1lP0OZUncjVnXSabJikLzLsS9X9fal2Y8Ts5
         +RTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ro+oitckYt5jOp5YL0JaN8ca7x/Tmhj4QZYlwgIUjjg=;
        b=ZtjOuCFmo+l0am4XH78ql5V11bwRMhHvr9zpyTz7SFu8QSfLr00s7RSd0dX7criPEA
         +4Zpvs6gJCOYVOJBLimoKirZdbEnGO8afV2xlbcVUIj4Vf2lhveHqhbGeNJEQxw5M+8J
         cCPirQ74xteWgf4ULXpA9s+oOyddg4T9gxmT1yy3dWAo9bl/NsO77uUftySj+gmTUeBF
         g/mVtwOKzxtXHi1gWnIR7Eu48Yi04xfA5imF4xnmVGc2QyC2CrjOOWuPWG4E13bcnSoK
         4u1G+7VUPgwYUNL2dWUwf+CDYR4yJLSi7+h9kOG+fdKgN8yoLAFPcyDMs54pkyfAm5zv
         5gbQ==
X-Gm-Message-State: AFqh2krOaSup+gWnFEe4p/xZqzpJARcAgeaFnyuJJqfTIGfgiJ+5/Rkc
        W6EbN/LL2LHFvvMoyvReSfQ=
X-Google-Smtp-Source: AMrXdXttVeE6FPW+yMTsmK7Qn5ozmICGfKY9IDpm0+Mn54uDJtKKw+x/Sfj3DjLcf/SonD1Mjs4YoA==
X-Received: by 2002:a05:600c:4fcb:b0:3db:1919:41b5 with SMTP id o11-20020a05600c4fcb00b003db191941b5mr10079707wmq.21.1674255836625;
        Fri, 20 Jan 2023 15:03:56 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id bg24-20020a05600c3c9800b003d9ed40a512sm5218413wmb.45.2023.01.20.15.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 15:03:55 -0800 (PST)
Subject: Re: [net-next v3] ipv6: Document that max_size sysctl is depreciated
To:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20230119224049.1187142-1-jmaxwell37@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5429676d-13b3-3f9e-b76d-8f794add0fc4@gmail.com>
Date:   Fri, 20 Jan 2023 23:03:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230119224049.1187142-1-jmaxwell37@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2023 22:40, Jon Maxwell wrote:
> v3: Change kernel version from 6.2 to 6.3. Add "commit" in front of hash.
> 
> Document that max_size is depreciated due to:

typo: deprecated (also in Subject line).

> 
> commit af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")
> 
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 7fbd060d6047..4cc2fab58dea 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -156,6 +156,9 @@ route/max_size - INTEGER
>  	From linux kernel 3.6 onwards, this is deprecated for ipv4
>  	as route cache is no longer used.
>  
> +	From linux kernel 6.3 onwards, this is deprecated for ipv6
> +	as garbage collection manages cached route entries.
> +
>  neigh/default/gc_thresh1 - INTEGER
>  	Minimum number of entries to keep.  Garbage collector will not
>  	purge entries if there are fewer than this number.
> 

