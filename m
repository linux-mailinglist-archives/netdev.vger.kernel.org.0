Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B853E377495
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 01:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEHX2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 19:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhEHX2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 19:28:39 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4CFC061573
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 16:27:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b15so11101153pfl.4
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 16:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yI85t36aIwioyk01Cmwa0vRQbi0rMQSsWtsvyPS+bBc=;
        b=dqllkWKAjDO46hBN5Lvwmm/0FLe2fU2YcyHzDcY9bH9ncW/wfdVwnKVMYrAPTDLHRG
         zAxdgt3QIpEtK51qH/Z3Xm/zd8H8UX4PJcKk20BYbN1y7VzpdZJvSmMKw0ToV6L7lJ6h
         9D2OUuvnuVQ2gwFFOJfEDhjA9X2naB5vwnlgwWWgv88/FR6iSecZjoqnM8euOQJratq5
         iF20l05UD7zgIlPKhUBs7XfpQRM4/PslFRS1XpfV9RSuLpNXgusHq05NGFE7jQBHeIxm
         hn+AZ3+sFiF+vtb7ZmtoOl9H7szUvqgAsMhMVa7pB5IwgTJeFdnsCyAFj2Z5qWrhA031
         xsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yI85t36aIwioyk01Cmwa0vRQbi0rMQSsWtsvyPS+bBc=;
        b=a17XhoUcoedWlbblPhnFXPX2AMU2etHe5ICeGGJEu84Y27SMsoXWe19lYxcq0OhT7b
         VjzqW2/SGoJw4kqqhdQnmHDPxpegCGd2YGj8RCMAk2t85/AK/RZieyZWtFx7ESLrUhT2
         H6GVGjZKSf0Py3SN4rl1xKPXMudlvz1t09vDgrx8HeMtBMEPoA8NGN/NQnXbE36K2IC6
         3CLJrdInt6ak3oK59mcgdcQ2fl9HMugpktq9x2ZGlCZ5b/8SUChEiBdsFDBB89RqMhZ9
         6yqRLFl3aSdPesNH19WamY3Yf+kwDNjwVgEBIM2r7bv0uj7guJu4XVSMWe2gRdDXfMLC
         fqdA==
X-Gm-Message-State: AOAM5304gl9UDVGmY3NeXQVyqBHqukWtKMIAskQnaymY8yQS37BcEKOu
        w07kRfIH0tAAbqdtFqCc/jQjUUgtM3pQTcSU
X-Google-Smtp-Source: ABdhPJzaEACEjBLCzEKRzm4sjTJO1HyIynDNxDxKQ9jJPPppHv0p0a27EMjqXqBNs+kzbm6yL3xHIA==
X-Received: by 2002:a63:4b19:: with SMTP id y25mr7807263pga.313.1620516455120;
        Sat, 08 May 2021 16:27:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s8sm7666142pfe.112.2021.05.08.16.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 16:27:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sun, 9 May 2021 07:27:05 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <20210508232705.6v6otnlphabfsgz7@Rk>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
 <20210507013239.4kmzsxtxnrpdqhuk@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210507013239.4kmzsxtxnrpdqhuk@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 09:32:39AM +0800, Coiby Xu wrote:
>On Wed, May 05, 2021 at 05:59:46PM +0900, Benjamin Poirier wrote:
>>On 2021-05-04 21:14 +0800, Coiby Xu wrote:
>>>Hi Benjamin,
>>>
>>>As you have known, I'm working on improving drivers/staging/qlge. I'm
>>>not sure if I correctly understand some TODO items. Since you wrote the TODO
>>>list, could you explain some of the items or comment on the
>>>corresponding fix for me?
>>>
[...]
>>
>>However, in the same area, there is also
>>			skb = netdev_alloc_skb(qdev->ndev, length);
>>			[...]
>>			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
>>					   lbq_desc->p.pg_chunk.offset,
>>					   length);
>>
>>Why is the skb allocated with "length" size? Something like
>>	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
>>would be better I think. The head only needs enough space for the
>>subsequent hlen pull.
>
>Thanks for the explanation! I think this place needs to modified. I'll
>try to figure out how to reach this part of code so I can make sure the
>change wouldn't introduce an issue.

After failing to reach to this part of code, it occurred to me this
may be what the first TODO item meant by "dead code" that handle
non-split case,

> * commit 7c734359d350 ("qlge: Size RX buffers based on MTU.", v2.6.33-rc1)
>   introduced dead code in the receive routines, which should be rewritten
>   anyways by the admission of the author himself, see the comment above
>   ql_build_rx_skb(). That function is now used exclusively to handle packets
>   that underwent header splitting but it still contains code to handle non
>   split cases.

Do you think so? Btw, I think you meant commit 4f848c0a9c265cb3457fbf842dbffd28e82a44fd
("qlge: Add RX frame handlers for non-split frames") here. Because it was in this
commit where the ql_process_mac_split_rx_intr was first introduced,  

     -static void ql_process_mac_rx_intr(struct ql_adapter *qdev,
     +static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
                                        struct rx_ring *rx_ring,
     -                                  struct ib_mac_iocb_rsp *ib_mac_rsp)
     +                                  struct ib_mac_iocb_rsp *ib_mac_rsp,
     +                                  u16 vlan_id)


Another TODO item I don't understand is as follows,
> * the driver has a habit of using runtime checks where compile time checks are
>  possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())

Could be more specific about which runtime checks are used in ql_free_rx_buffers 
and ql_alloc_rx_buffers?

-- 
Best regards,
Coiby
