Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2364C47F4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiBYOzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiBYOzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:55:16 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8732227597
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:54:43 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d3so4952659wrf.1
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=44cheDsrMga6CJGQS6m14qlfeLe3FI23Gc2e1X2Hnzw=;
        b=ULc+qJe6of+28mEs4uQ5Si1ijlbI4KSNbJM4SF9Dnz+LNraH0mkAi8js2d9DoyCNnj
         ADJiFtrnCLzqHLgN2AzGGx92vZDJhPC5M8r9g3a961kF6xix5jW9/pdU6R49pfGSrErO
         S9ND4AQ6gPb6mCFvGY6sh1Vq6NRVurdqUDKWlSZNbYm/ktE7Ej5JcjYUqr41e358dfPX
         o3x+PQB1h8z8cE98zVeH8SrHgeW39y4nNZM8wqxIOlUZVFqtchXNS5rZw8xMFjhaYu9+
         boukvzU3qVmI0Wws6V9sAFgyj3Vg0CXP6fbIw2B/Z+dXRADTo1D24EO9qyfnw1crlfro
         TIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=44cheDsrMga6CJGQS6m14qlfeLe3FI23Gc2e1X2Hnzw=;
        b=x1x+AYbEydNL/e7ZpYWu8xyWllMBbyKN+bGbtH10V3FjUL4uG1vjRHYj9G8pHitfab
         BqU0WA6a0RIMTSUl5xXLotV1iZk9mU68hHmlOL5Kb5nsQM/EGDbwSKWjVv7PtLo2mqc2
         tTbb3J2Yc9GVP2xk5nBPoDjNFk60ZYgjeqXVdYbyxG/MOlcQ5JnSkJ68LNdJysdagYwN
         fZ3pisF0bJO0CAknHsDPy+1pcxsekw8WtEgoV/Sf1EgaMXuPf7dAAn7IusAnjVyDovli
         fovDWdumFGUJMNz+qj7V/KftmMmS7GfVeKUXa0pw8rO1u0U7CJdDBx9oWAl4yzqHll/0
         pwWw==
X-Gm-Message-State: AOAM533EMIGfV5soIxOLRnliehHizUB3eG1FhPbKNd7GsYSCRESJJ9m+
        oX0J7CM63xzU5F1rZ33Q8qZVdQ==
X-Google-Smtp-Source: ABdhPJw6a856m+LbIbS/RKp6gkNtWXemojFqR++1UDO79dvu/R8BZozv2xax2MyEvHDMynnyx3XkxA==
X-Received: by 2002:a5d:64e7:0:b0:1e4:bb8b:d3eb with SMTP id g7-20020a5d64e7000000b001e4bb8bd3ebmr6343325wri.403.1645800882473;
        Fri, 25 Feb 2022 06:54:42 -0800 (PST)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c26cb00b0037ff53511f2sm5681464wmv.31.2022.02.25.06.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 06:54:42 -0800 (PST)
Message-ID: <7c7c0736-710d-192f-9688-d20dfa48d134@arista.com>
Date:   Fri, 25 Feb 2022 14:54:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next] net/ip6mr: Fix build with !CONFIG_IPV6_PIMSM_V2
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20220223121721.421247-1-dima@arista.com>
 <ed3e1f08-045c-1a9e-9319-5789faddc473@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <ed3e1f08-045c-1a9e-9319-5789faddc473@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/22 03:00, David Ahern wrote:
> On 2/23/22 5:17 AM, Dmitry Safonov wrote:
>> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
>> index a9775c830194..4e74bc61a3db 100644
>> --- a/net/ipv6/ip6mr.c
>> +++ b/net/ipv6/ip6mr.c
>> @@ -1653,7 +1653,6 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
>>  	mifi_t mifi;
>>  	struct net *net = sock_net(sk);
>>  	struct mr_table *mrt;
>> -	bool do_wrmifwhole;
>>  
>>  	if (sk->sk_type != SOCK_RAW ||
>>  	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
>> @@ -1761,6 +1760,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
>>  #ifdef CONFIG_IPV6_PIMSM_V2
>>  	case MRT6_PIM:
>>  	{
>> +		bool do_wrmifwhole;
>>  		int v;
>>  
>>  		if (optlen != sizeof(v))
>>
>> base-commit: 922ea87ff6f2b63f413c6afa2c25b287dce76639
> 
> you could do one better and move it under the
> 'if (v != mrt->mroute_do_pim) {'
> 
> so that the do_wrmifwhole check is only done when needed

I've tried to keep it simple and just to fix the build as I don't know
which tests to run.
Anyway, I sent v2:
https://lore.kernel.org/all/20220225145206.561409-1-dima@arista.com/T/#u

Is it what you meant?

Thanks,
          Dmitry
