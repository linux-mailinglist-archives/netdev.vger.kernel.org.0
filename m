Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E73775D3
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 09:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhEIHwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 03:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhEIHwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 03:52:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF065C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 00:51:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ge1so8092446pjb.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 00:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0totEIVo+196OQXkSAcXRKH+cicRhbOAxI9ctBdNXzc=;
        b=KDsAl+zyJvyuVqmTYyfBRbH25FcUtS1Zm1J59LZxrNJ09mss+ZsnQWCxJwHslyg1ro
         rxfcs+YrSUpeNBU92tqDOwQB/RfO54Ekeweri4jUB8hFeYet8NMh10lL3HbWa4tim1qF
         3tBaPAaPJ/b3wHvoOz6JLjH0uvFJft6aQ5O9bt9mTDjIBct+gRdE/lGom5hrPIe+9Tcb
         727TK/O3Iqy1eOUgrl9knS8jMRhz80rqw83mSXtlh7oFsNKbE8MUwVQ7VRsE1uoxE3R3
         WkJz0XKNQIXzQ+JZmr1i5mP0RJLBfFa0mDl8Oa5i6bT9+xeVtnWya3SKhbomESZ2Ahrt
         4C6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0totEIVo+196OQXkSAcXRKH+cicRhbOAxI9ctBdNXzc=;
        b=e2VbuLJe2ezGLUm4FDU/1oUSq6gXGvPgma0UOTtnzYpnJkBqQ3Eqza56ezWJLOmU67
         P49k05kxfRyPec1bFZ/sLDfUVydBkLG5529WU0iQTrwpr31tyedBdbDHbCzcHX5a8gnV
         kdtkdq6rJGOja7FN8c/CbA9Xwy0UrzgNNGtJmPmPVv2jNen3GQDIlfr5zj1za1kkBWIX
         yQnSl1kyMmpfYti3s7M2r1+DFKjAgf3FuEptDp37uTJxYLqKl+NkQ7dPka0RqtrCLJh/
         LYnR6SyJZ6Vt/CKMooQ4HeRinBcbWoJlaK8l49NzAQoSBkikK+1gWukbabGtMvgeORe7
         jOrQ==
X-Gm-Message-State: AOAM532gaJCEnDcZlcxEG/m3z4PH9rO8OgqzZ+K8uVpuTwOeVmRF75Z9
        T0BAxGD0/Kp1EbC8SUUa/Kl6pfURrSiN5Q==
X-Google-Smtp-Source: ABdhPJzl8PbWxYbGX1s3IZyWl59KHp5OKrQTtiu11bezg8TJWjLC+MwrJs4uK8Ochev8aHDHj3MKvQ==
X-Received: by 2002:a17:90a:eac2:: with SMTP id ev2mr29646694pjb.134.1620546667402;
        Sun, 09 May 2021 00:51:07 -0700 (PDT)
Received: from f3 ([2405:6580:97e0:3100:436:f9d5:2c0c:fa57])
        by smtp.gmail.com with ESMTPSA id a12sm7206714pfg.102.2021.05.09.00.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 00:51:06 -0700 (PDT)
Date:   Sun, 9 May 2021 16:51:02 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <YJeUZo+zoNZmFuKs@f3>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
 <20210507013239.4kmzsxtxnrpdqhuk@Rk>
 <20210508232705.6v6otnlphabfsgz7@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508232705.6v6otnlphabfsgz7@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-09 07:27 +0800, Coiby Xu wrote:
> On Fri, May 07, 2021 at 09:32:39AM +0800, Coiby Xu wrote:
> > On Wed, May 05, 2021 at 05:59:46PM +0900, Benjamin Poirier wrote:
> > > On 2021-05-04 21:14 +0800, Coiby Xu wrote:
> > > > Hi Benjamin,
> > > > 
> > > > As you have known, I'm working on improving drivers/staging/qlge. I'm
> > > > not sure if I correctly understand some TODO items. Since you wrote the TODO
> > > > list, could you explain some of the items or comment on the
> > > > corresponding fix for me?
> > > > 
> [...]
> > > 
> > > However, in the same area, there is also
> > > 			skb = netdev_alloc_skb(qdev->ndev, length);
> > > 			[...]
> > > 			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
> > > 					   lbq_desc->p.pg_chunk.offset,
> > > 					   length);
> > > 
> > > Why is the skb allocated with "length" size? Something like
> > > 	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
> > > would be better I think. The head only needs enough space for the
> > > subsequent hlen pull.
> > 
> > Thanks for the explanation! I think this place needs to modified. I'll
> > try to figure out how to reach this part of code so I can make sure the
> > change wouldn't introduce an issue.
> 
> After failing to reach to this part of code, it occurred to me this
> may be what the first TODO item meant by "dead code" that handle
> non-split case,
> 
> > * commit 7c734359d350 ("qlge: Size RX buffers based on MTU.", v2.6.33-rc1)
> >   introduced dead code in the receive routines, which should be rewritten
> >   anyways by the admission of the author himself, see the comment above
> >   ql_build_rx_skb(). That function is now used exclusively to handle packets
> >   that underwent header splitting but it still contains code to handle non
> >   split cases.
> 
> Do you think so? 

Yes

> Btw, I think you meant commit 4f848c0a9c265cb3457fbf842dbffd28e82a44fd
> ("qlge: Add RX frame handlers for non-split frames") here. Because it was in this
> commit where the ql_process_mac_split_rx_intr was first introduced,
> 
>     -static void ql_process_mac_rx_intr(struct ql_adapter *qdev,
>     +static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
>                                        struct rx_ring *rx_ring,
>     -                                  struct ib_mac_iocb_rsp *ib_mac_rsp)
>     +                                  struct ib_mac_iocb_rsp *ib_mac_rsp,
>     +                                  u16 vlan_id)

It's possible that I referenced the wrong commit in the TODO. Clearly
there is dead code after commit 4f848c0a9c26 ("qlge: Add RX frame
handlers for non-split frames.") like you say. I don't remember for sure
if I had found some before even before that.

> 
> Another TODO item I don't understand is as follows,
> > * the driver has a habit of using runtime checks where compile time checks are
> >  possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
> 
> Could be more specific about which runtime checks are used in
> ql_free_rx_buffers and ql_alloc_rx_buffers?

This specific example was fixed in commit
e4c911a73c89 ("staging: qlge: Remove rx_ring.type")

I forgot to update the TODO when making that commit.

Here are other examples:
a68a5b2fd3a2 ("staging: qlge: Remove bq_desc.maplen")
16714d98bf63 ("staging: qlge: Remove rx_ring.sbq_buf_size")
ec705b983b46 ("staging: qlge: Remove qlge_bq.len & size")

I don't remember of remaining examples to point you to. Maybe there
aren't but given that there were indeed quite a few, I would suggest
that you look at those commits and keep this item in mind as you work on
the other items earlier in the list. If at the end you think that this
is no longer a problem, then remove it from the list.
