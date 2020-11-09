Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0378C2AB193
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgKIHIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgKIHIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:08:01 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C50C0613CF;
        Sun,  8 Nov 2020 23:08:01 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so4264317pls.10;
        Sun, 08 Nov 2020 23:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ig88mEC01f7q0jI6xrbAOl/qIg5GjGP1YYZefcxWLo=;
        b=mQzWXDc61IGD7Db/edr2dlha/SlcMh5SPFyhVE4wfUJbmHpDoWs2Dv8dFvQJqt4deH
         5zvwJ+mCwaAjvb49IYEXTFCzJsNC+QFJ/r2rZhUE/Qukui8SKg90Y3r3becM8240izQt
         Ux8WgfF/ArZSEFi0aWITJjQenOF7zNNyW0TdhmaYrM4kGc5qR5pkbTz4lB5dipcFjDpL
         FpravKwyxGq+ZzSWwgN7CMXdUfUJflY8u4OeMh+sqItZKtEz0fCSaYk3FYi6va1HgrAL
         0sDb0JWG4MG85zn2d+hhzhJa9FDaNNSB9L3J7AwMg8+ReuCGXQrZwvF+hjcMa4nbmGqk
         nV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ig88mEC01f7q0jI6xrbAOl/qIg5GjGP1YYZefcxWLo=;
        b=kac7WFs7X+RDcOcw7CtLHT95qjH2472oUKa/nfQBQ1S9eozngeKqAbE7q5OScKqAAj
         qtaE1sK7BrWp866y7KV5L+LB/ZXYjru9vZ+p7IXtaclk7/g5ZJFC6EUl3QbRZ7Gla9Bg
         CzJIe1f3VHbzidwr4XTAt/ogKceR5XAWu82ichMnONcNS+XJbVET303Ygc46xSiW2z1N
         2lADiSbTxHdb2zBms44gi4TcE8Jn0hthRugysU53u/iNt+kKEuEdOkrEbfTJSun73tRE
         6BpKAniHfnkr15zACv1WSan33/AokNS7dqQLYoMJEtYrazFN9hKbqsUmqDhx2wjzvnNT
         h2pg==
X-Gm-Message-State: AOAM530+NaeuavBDasQdKZWmg9bX2C7ioFo62UBbuPNaHXulA8rWpc5x
        8087GtWLieAiSX2S5OOGpg==
X-Google-Smtp-Source: ABdhPJwnylcG9t6htJ7XwroOO2HX8dCurPznJUr4q0IvIC02GLDBBsHb/Y3k/plmswIXv69AJYvhJw==
X-Received: by 2002:a17:902:bc81:b029:d6:ed57:b7c7 with SMTP id bb1-20020a170902bc81b02900d6ed57b7c7mr11074317plb.1.1604905680843;
        Sun, 08 Nov 2020 23:08:00 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id gp22sm9855025pjb.31.2020.11.08.23.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 23:08:00 -0800 (PST)
Subject: Re: [PATCH] net/mlx4: Assign boolean values to a bool variable
To:     Tariq Toukan <ttoukan.linux@gmail.com>, tariqt@nvidia.com,
        tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
 <9c8efc31-3237-ed3b-bfba-c13494b6452d@gmail.com>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <c6901fed-d063-91be-afd6-b6eedb2b65b6@gmail.com>
Date:   Mon, 9 Nov 2020 15:07:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <9c8efc31-3237-ed3b-bfba-c13494b6452d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/8 16:20, Tariq Toukan wrote:
> 
> 
> On 11/7/2020 8:53 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> Fix the following coccinelle warnings:
>>
> 
> Hi Kaixu,
> 
> Which coccinelle version gave this warning?

Hi Tariq,

The version is coccinelle-1.0.7.

Thanks,
Kaixu
> 
> 
>> ./drivers/net/ethernet/mellanox/mlx4/en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
>>
>> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> index 502d1b97855c..b0f79a5151cf 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> @@ -684,7 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>>       xdp_prog = rcu_dereference(ring->xdp_prog);
>>       xdp.rxq = &ring->xdp_rxq;
>>       xdp.frame_sz = priv->frag_info[0].frag_stride;
>> -    doorbell_pending = 0;
>> +    doorbell_pending = false;
>>         /* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
>>        * descriptor offset can be deduced from the CQE index instead of
>>
> 

-- 
kaixuxia
