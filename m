Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F1F60DF36
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiJZLDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiJZLCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:02:47 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC5BC78D
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 04:02:40 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id z14so12180658wrn.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 04:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMjfY9UYMjWL6dm7905skNAQCrE1/dBAyB7CzPbBVNE=;
        b=CwMw7Nv2L3Q4OASsVUc0r4M70ZalTm12mREJVQV0AbtLaTAxDghKzovoOLrvPfCqM3
         nfFvcj2vfe2QYXftvfGtfQfIpaCQBgT8BhOkdJeMIs7f1gZvOyG9CnL5zreGgVZeKG8o
         +5WpbPXqVX1hPvCCC42qYs3BayKvAKU+AX/AMSR1kvUGDXYAIzScPKLG4GHY3I0bhFIY
         cxHwToajAgYkjXFacYONtuxHYGhe9KTfcG5haYqHFVB9JJl0+C0bT5hGfsPzrchwmFwu
         8ixh1pfyAxreEVEZkU4JYlKLctEsHq3T3/EDyieY/qpABqC4P+yFFu50Y/G38Kq+JlRU
         48Fg==
X-Gm-Message-State: ACrzQf2QRvcuM2mZefNQvt5Wd5xoJQYTZ/n6DazqUENInnQ3GzOE8w2B
        WMS6T//UukF3lTfIICoLv+0=
X-Google-Smtp-Source: AMsMyM7kn+Deq53dx5kuzGh+Jm5M8zS0Nq0FyeyXkh3sz5FDwwFKHLGGVSZjt64MCyyH1k0jyN1F2w==
X-Received: by 2002:a5d:5c13:0:b0:236:5575:a3fd with SMTP id cc19-20020a5d5c13000000b002365575a3fdmr18119108wrb.475.1666782158532;
        Wed, 26 Oct 2022 04:02:38 -0700 (PDT)
Received: from [192.168.64.94] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id n66-20020a1ca445000000b003cdf141f363sm1657727wme.11.2022.10.26.04.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 04:02:37 -0700 (PDT)
Message-ID: <4a721959-c3c3-4377-d1e3-7fa7d6c3e814@grimberg.me>
Date:   Wed, 26 Oct 2022 14:02:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 04/23] Revert "nvme-tcp: remove the unused queue_size
 member in nvme_tcp_queue"
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-5-aaptel@nvidia.com> <20221025161442.GD26372@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221025161442.GD26372@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> This reverts commit fb8745d040ef5b9080003325e56b91fefe1022bb.
>>
>> The newly added NVMeTCP offload requires the field
>> nvme_tcp_queue->queue_size in the patch
>> "nvme-tcp: Add DDP offload control path" in nvme_tcp_offload_socket().
>> The queue size is part of struct ulp_ddp_config
>> parameters.
> 
> Please never do reverts if you just bring something back for an entirely
> differenet reason.

Agreed.

> And I think we need a really good justification of
> why you have a code path that can get the queue struct and not the
> controller, which really should not happen.

What is wrong with just using either ctrl->sqsize/NVME_AQ_DEPTH based
on the qid?
