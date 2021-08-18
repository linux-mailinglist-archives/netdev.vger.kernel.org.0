Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2313F03B2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhHRM3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbhHRM26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:28:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9733C061764;
        Wed, 18 Aug 2021 05:28:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id bo19so2848353edb.9;
        Wed, 18 Aug 2021 05:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ASCrLZq+5KaiR51SjpL26ngVy47N8yw0XayWraK3fo0=;
        b=q4mKB2IpTwz3Or9BZAZcXjO1t2Oy1cn+u6d0gGgg8ZeQN7ZI9MwnkwdC93xjkhkdiq
         qdC7hwb8gLZi9ihKkucCNaEB+g/q1pv2LwNW+T7xylyJ91cJfDF0mRWgnVpI0V14FohU
         3dhhJZ3n80tnuGqFYJxpQ3BYAZwXF6VBjnjkB7yUpX48Fsm0PRpeD/ReRPsz8LD4jY1T
         Ws3EFjvw2mCc7BNmRIAIchCenQtGZ8UobE3+gm9K7jt8UyuMp8tPVcm/T6/CFWbPY6HQ
         jPjNWf1yQ1k/lZGAlR0OcqmIGcYXhpvDjeTQL5+gG6TvgEtDK8itVaiZMJxxyFgQl3X9
         q7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ASCrLZq+5KaiR51SjpL26ngVy47N8yw0XayWraK3fo0=;
        b=E4EFx2svYewvv0sYxtDk6PWoMCvz3B01sPLUCtYTkUZVk5mS7u7/NLpgbFn8FqeKqw
         Vt/9Cv8zZj/Ct7tjM/nkrb29B9p/ohaGMd5M8xXI5hM617hdwJnxkWdLXkwSNqdXkbZ6
         G9c+KACtxS8AeUZa4cGjb0zcIytlOyFuGhZ2W2hzGgW/dnCpYa8GTMzEB72c4hz1GD/7
         vVIKXGxSDfaCpJ+PUw00oDc6bp9y43+ygRC7miL0EGnFGnnWS9f7/ZWNOvVQcfwtj9bl
         ZaIgl1W55KRchG0GmtUBr/YnsU4nEn0FS76OVFcWKqI6dI8qMAaydSpfVIT6iu283fhX
         4tgQ==
X-Gm-Message-State: AOAM5308c/d93UFiIRGT6dGayfnUiNquY5CZz6/y6U0jyu2NsUwbPktV
        +4swOtS4uYQWuHqSBGCIZmPh4At9niw=
X-Google-Smtp-Source: ABdhPJyZmxwxN0QCyUh/fxNuIoxhgsW5wCCkEIykUZkudkXQ0G+KOESh29Ild4E6FZHKqNpZ1eBCjg==
X-Received: by 2002:a05:6402:4243:: with SMTP id g3mr9801588edb.85.1629289702250;
        Wed, 18 Aug 2021 05:28:22 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id v15sm948186ejq.116.2021.08.18.05.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:28:21 -0700 (PDT)
Subject: Re: [PATCH] net/mlx4: Use ARRAY_SIZE to get an array's size
To:     Joe Perches <joe@perches.com>, Jason Wang <wangborong@cdjrlc.com>,
        kuba@kernel.org
Cc:     davem@davemloft.net, tariqt@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210817121106.44189-1-wangborong@cdjrlc.com>
 <d96db1d04062a2a88eb51f319c2aef0a440755c3.camel@perches.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <5612b0fa-5623-f7d9-6dbe-e2f7165611a6@gmail.com>
Date:   Wed, 18 Aug 2021 15:28:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d96db1d04062a2a88eb51f319c2aef0a440755c3.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2021 3:39 AM, Joe Perches wrote:
> On Tue, 2021-08-17 at 20:11 +0800, Jason Wang wrote:
>> The ARRAY_SIZE macro is defined to get an array's size which is
>> more compact and more formal in linux source. Thus, we can replace
>> the long sizeof(arr)/sizeof(arr[0]) with the compact ARRAY_SIZE.
> []
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
> []
>> @@ -739,7 +739,7 @@ static void mlx4_cleanup_qp_zones(struct mlx4_dev *dev)
>>   		int i;
>>   
>>
>>   		for (i = 0;
>> -		     i < sizeof(qp_table->zones_uids)/sizeof(qp_table->zones_uids[0]);
>> +		     i < ARRAY_SIZE(qp_table->zones_uids);
>>   		     i++) {
> 
> trivia:  could now be a single line
> 
> 		for (i = 0; i < ARRAY_SIZE(qp_table->zones_uids); i++) {
> 
> 

I'm fine with both suggestions.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
Tariq
