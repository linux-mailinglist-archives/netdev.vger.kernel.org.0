Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E312375E65
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhEGBeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhEGBd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:33:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8E5C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 18:32:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t2-20020a17090a0242b0290155433387beso3769483pje.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 18:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s5IXz0Xh8rnK6C98s15YZFws0grdv+KEyo474HFabyk=;
        b=LdAuXbbdKicQln3RAzfjvOL26/pIMGfPR4JVc6QHX3R4tpACiDDF2rOD8thKd28dKN
         TmpfNoVrmKvd4bdmLmzQUMV2icDbkm/i4SeoLiEr5OqgJ1mLLUdwr2VhdnfiRcAxBEUW
         /RBeXxLsCa/ojNe2Cd6JGR98Is34GqNdIS5YHw4Z/mCOJvTdHWrlqyPQmJfJbJg/9PPS
         Vwbks05BQKBt8M6Z+C1xvkxjQBG12tbihla3RcAjl6UH/q97QuJUjpg047ukp3ek8jUp
         Lo+7pDldiZtwe1dSG4N3b9vCQgeSlyRayxRvou+jxl8v+q2sVzrox1AmtJKEonMYzQyv
         LRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s5IXz0Xh8rnK6C98s15YZFws0grdv+KEyo474HFabyk=;
        b=STJsFJEPeNKeLGcjIeDMem2H1cvPe6P/aTTn28p6lKHgQ4sLhMweWpDgZZJFugZyIx
         MwFLe09RlZLVYig21xhjEBia1zu/qKELJoDHKd2Ui/kN6F/iqgYaSF3JEHJfYxNT7anG
         QgZa7ZifJHmyS63kzYA1QKbSyCkD/HOhNhqeYY2UvtfAwkdvKKi9Cl88eq3WO0XAQ/zj
         F3hyXlxTgRkLI2XwpImc2+ZkSMjp+fzcAPVqY5s9rxgMF6trN6vfBjA9L+TGjQdreVO4
         4Kugzxy+eRkcJKRFvhlQTQEor65rRRh7txMT1KEwokYxKLSAKVmdF71x5XdHNQY7nGKa
         q8lg==
X-Gm-Message-State: AOAM532PBLu9fG3HV/XOCAWKLf4vZXMV8s2AEPP4w9A4cfF810+UKcJk
        PxLyE9PfHhRXWS59h54aG38=
X-Google-Smtp-Source: ABdhPJx5uhHkQYLg+5dtt0oVbJQM6So0CXVD99cNOYTg17OJjQSULALbRLtwekQ865KV6OxwsGhGWw==
X-Received: by 2002:a17:90b:34a:: with SMTP id fh10mr21398701pjb.123.1620351179065;
        Thu, 06 May 2021 18:32:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n26sm3210079pfq.28.2021.05.06.18.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 18:32:58 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 7 May 2021 09:32:39 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <20210507013239.4kmzsxtxnrpdqhuk@Rk>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YJJegiK9mMvAEQwU@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 05:59:46PM +0900, Benjamin Poirier wrote:
>On 2021-05-04 21:14 +0800, Coiby Xu wrote:
>> Hi Benjamin,
>>
>> As you have known, I'm working on improving drivers/staging/qlge. I'm
>> not sure if I correctly understand some TODO items. Since you wrote the TODO
>> list, could you explain some of the items or comment on the
>> corresponding fix for me?
>>
>> > * while in that area, using two 8k buffers to store one 9k frame is a poor
>> >   choice of buffer size.
>>
>> Currently, LARGE_BUFFER_MAX_SIZE is defined as 8192. How about we simply
>> changing LARGE_BUFFER_MAX_SIZE to 4096? This is what
>> drivers/net/ethernet/intel/e1000 does for jumbo frame right now.
>
>I think that frags of 4096 would be better for allocations than the
>current scheme. However, I don't know if simply changing that define is
>the only thing to do.
>
>BTW, e1000 was written long ago and not updated much, so it's not the
>reference I would look at generally. Sadly I don't do much kernel
>development anymore so I don't know which one to recommend either :/ If
>I had to guess, I'd say ixgbe is a device of a similar vintage whose
>driver has seen a lot better work.

Thanks! I think we can simply set it to 4096,
  - I did a basic test. There are two interfaces managed by this qlge
    driver. I started a HTTP server binded to one interface. And curl -I
    THE_OTHER_INTERFACE was fine.
  - ixgbe also set page order to 0 unless FCoE is 
     // drivers/net/ethernet/intel/ixgbe/ixgbe.h
     /*
      * FCoE requires that all Rx buffers be over 2200 bytes in length.  Since
      * this is twice the size of a half page we need to double the page order
      * for FCoE enabled Rx queues.
      */
     static inline unsigned int ixgbe_rx_bufsz(struct ixgbe_ring *ring)
     {
     	if (test_bit(__IXGBE_RX_3K_BUFFER, &ring->state))
     		return IXGBE_RXBUFFER_3K;
     #if (PAGE_SIZE < 8192)
     	if (ring_uses_build_skb(ring))
     		return IXGBE_MAX_2K_FRAME_BUILD_SKB;
     #endif
     	return IXGBE_RXBUFFER_2K;
     }
     
     static inline unsigned int ixgbe_rx_pg_order(struct ixgbe_ring *ring)
     {
     #if (PAGE_SIZE < 8192)
     	if (test_bit(__IXGBE_RX_3K_BUFFER, &ring->state))
     		return 1;
     #endif
     	return 0;
     }
   - e1000 does the same thing.
>
>>
>> > * in the "chain of large buffers" case, the driver uses an skb allocated with
>> >   head room but only puts data in the frags.
>>
>> Do you suggest implementing the copybreak feature which exists for e1000 for
>> this driver, i.e., allocing a sk_buff and coping the header buffer into it?
>
>No. From the "chain of large buffers" quote, I think I was referring to:
>
>\ qlge_refill_sb
>	skb = __netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE, gfp);
>
>\ qlge_build_rx_skb
>		[...]
>		/*
>		 * The data is in a chain of large buffers
>		[...]
>			skb_fill_page_desc(skb, i,
>					   lbq_desc->p.pg_chunk.page,
>					   lbq_desc->p.pg_chunk.offset, size);
>		[...]
>		__pskb_pull_tail(skb, hlen);
>
>So out of SMALL_BUFFER_SIZE, only hlen is used. Since SMALL_BUFFER_SIZE
>is only 256, I'm not sure now if this really has any impact. In fact it
>seems in line with ex. what ixgbe does (IXGBE_RX_HDR_SIZE).

Thanks for the clarification. It seems we needn't to change this place.

>
>However, in the same area, there is also
>			skb = netdev_alloc_skb(qdev->ndev, length);
>			[...]
>			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
>					   lbq_desc->p.pg_chunk.offset,
>					   length);
>
>Why is the skb allocated with "length" size? Something like
>	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
>would be better I think. The head only needs enough space for the
>subsequent hlen pull.

Thanks for the explanation! I think this place needs to modified. I'll
try to figure out how to reach this part of code so I can make sure the
change wouldn't introduce an issue.

Btw, qlge_process_mac_rx_page also has this issue,

     static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
     				     struct rx_ring *rx_ring,
     				     struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
     				     u32 length, u16 vlan_id)
     {
     	struct net_device *ndev = qdev->ndev;
     	struct sk_buff *skb = NULL;
     	void *addr;
     	struct qlge_bq_desc *lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
     	struct napi_struct *napi = &rx_ring->napi;
     	size_t hlen = ETH_HLEN;
         ...
     	skb = netdev_alloc_skb(ndev, length);
     	skb_put_data(skb, addr, hlen);
         ...
     	skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
     			   lbq_desc->p.pg_chunk.offset + hlen, length - hlen);

The code path would include qlge_process_mac_rx_page by
$ ping -I enp94s0f0 -c 4 -s 8800 -M do 192.168.1.209
after enabling jumbo frame.  

>
>BTW, it looks like commit f8c047be5401 ("staging: qlge: use qlge_*
>prefix to avoid namespace clashes with other qlogic drivers") missed
>some structures like struct rx_ring. Defines like SMALL_BUFFER_SIZE
>should also have a prefix.

Thanks for the reminding! When renaming rx_ring to a completion queue,
I'll add a prefix. I'll also add a prefix to other structures. 
>
>>
>> > * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
>> >   qlge_set_multicast_list()).
>>
>> This issue of weird line wrapping is supposed to be all over. But I can
>> only find the ql_set_routing_reg() calls in qlge_set_multicast_list have
>> this problem,
>>
>> 			if (qlge_set_routing_reg
>> 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
>>
>> I can't find other places where functions calls put square and arguments
>> in the new line. Could you give more hints?
>
>Here are other examples of what I would call weird line wrapping:
>
>	status = qlge_validate_flash(qdev,
>				     sizeof(struct flash_params_8000) /
>				   sizeof(u16),
>				   "8000");

Oh, I also found this one but I think it more fits another TODO item,
i.e., "* fix weird indentation (all over, ex. the for loops in
qlge_get_stats())".

>
>	status = qlge_wait_reg_rdy(qdev,
>				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
>
>[...]

Do you mean we should change it as follows,


	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
				               XGMAC_ADDR_XME);

"V=" in vim could detect some indentation problems but not the line
wrapping issue. So I just scanned the code manually to find this issue. 
Do you know there is a tool that could check if the code fits the kernel
coding style?

>
>I put that item towards the end of the TODO list because I think the
>misshapen formatting and the ridiculous overuse of () in expressions
>serve a useful purpose. They clearly point to the code that hasn't yet
>been rewritten; they make it easy to know what code to audit. Because of
>that, I strongly think it would be better to tackle the TODO list
>(roughly) in order.

Thanks for this tip! I'll tackle the TODO list in order.

-- 
Best regards,
Coiby
