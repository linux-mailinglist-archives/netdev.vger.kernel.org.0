Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B747237796E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 01:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhEIX5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 19:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhEIX5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 19:57:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6438EC061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 16:55:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lp4so8731630pjb.1
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 16:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B9gNzdRw34AgzKGQuey0qxX87HsKelUILGaPj7Ys504=;
        b=pcO/n70f/cgwzhG1tZO74Xru0BhOsTUZYMiJhMCrVapTGgCHq8q99MfqcKSLdjmmgS
         3gsLfrsKrYVPiOQWm3e5aPCp2OX6WRa6aiDnV70HGLY27LCdKCPRS7Yl33aVDq7BxJF2
         ykUBCkWmsRqXeacpjxJYFcvBkuJBWUbZVqrGzbDYNfx5m4CsZCsp7hgEiE0LZn+NgJ+d
         k2SmxYngOVJzwvEZ3cezugqoeU8m/yzvKRSDSJ5CJtvOqNMRabNyPd8Ol9Z13ODOAzHS
         8gxnIubXyxGkzEGa6VTA754Vi9cARZ3nUFaHBEa4q3VRenm+/GdUQosxMwflbhUwZXox
         uz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B9gNzdRw34AgzKGQuey0qxX87HsKelUILGaPj7Ys504=;
        b=W5NJvbOXSSGGQP4NfYX2Xaje3sQ05YKORjxntvxzvMEHji9To2PKBoJloQ/vbWEnuM
         VxOQ11J/LGleUT9Mxx/5hPmlF9CxmLlniPNAr+QaxvP9KMlTPGdjJ8Go3GkFytUPHZJa
         I9dGGuQk/ascoEY9JA2FNX8c+AQa+YoypTBX4kDsNKhXv3Z0wOqI+C8KjWjyoF2XSm8m
         +nsPO18T/MddMDYFs2u4t3Ro43vbW6ISvP0trDR6qZWyHFNC4yc6e7iGMOvYeWHmekVF
         7bvpLT27WqOqz0cWJ72RJkr/ig2bLSQ4jaMlHEi9VecBcbEsSOZ6qH+ZZ51jRfEc+Z3T
         7sdQ==
X-Gm-Message-State: AOAM533MMyczi1RfRleZJFJbrKrV3YX1IZpwPIwpb48lByfHlMjs/gB/
        KRvZvRLobypWYV7Xee1qZWs=
X-Google-Smtp-Source: ABdhPJyQEojhzKrDg07sKTXPdVehOmwD/kF2+y6cuTjr/gme13aSPBjJSusr81PtDwWs+x8HJAYK9w==
X-Received: by 2002:a17:90b:182:: with SMTP id t2mr23785579pjs.138.1620604558988;
        Sun, 09 May 2021 16:55:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p36sm9414297pgm.74.2021.05.09.16.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 16:55:58 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 10 May 2021 07:54:05 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <20210509235405.skx6vr2tulbxx53i@Rk>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
 <20210507013239.4kmzsxtxnrpdqhuk@Rk>
 <20210508232705.6v6otnlphabfsgz7@Rk>
 <YJeUZo+zoNZmFuKs@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YJeUZo+zoNZmFuKs@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 04:51:02PM +0900, Benjamin Poirier wrote:
>On 2021-05-09 07:27 +0800, Coiby Xu wrote:
>> On Fri, May 07, 2021 at 09:32:39AM +0800, Coiby Xu wrote:
>> > On Wed, May 05, 2021 at 05:59:46PM +0900, Benjamin Poirier wrote:
>> > > On 2021-05-04 21:14 +0800, Coiby Xu wrote:
>> > > > Hi Benjamin,
>> > > >
>> > > > As you have known, I'm working on improving drivers/staging/qlge. I'm
>> > > > not sure if I correctly understand some TODO items. Since you wrote the TODO
>> > > > list, could you explain some of the items or comment on the
>> > > > corresponding fix for me?
>> > > >
>> [...]
>> > >
>> > > However, in the same area, there is also
>> > > 			skb = netdev_alloc_skb(qdev->ndev, length);
>> > > 			[...]
>> > > 			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
>> > > 					   lbq_desc->p.pg_chunk.offset,
>> > > 					   length);
>> > >
>> > > Why is the skb allocated with "length" size? Something like
>> > > 	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
>> > > would be better I think. The head only needs enough space for the
>> > > subsequent hlen pull.
>> >
>> > Thanks for the explanation! I think this place needs to modified. I'll
>> > try to figure out how to reach this part of code so I can make sure the
>> > change wouldn't introduce an issue.
>>
>> After failing to reach to this part of code, it occurred to me this
>> may be what the first TODO item meant by "dead code" that handle
>> non-split case,
>>
>> > * commit 7c734359d350 ("qlge: Size RX buffers based on MTU.", v2.6.33-rc1)
>> >   introduced dead code in the receive routines, which should be rewritten
>> >   anyways by the admission of the author himself, see the comment above
>> >   ql_build_rx_skb(). That function is now used exclusively to handle packets
>> >   that underwent header splitting but it still contains code to handle non
>> >   split cases.
>>
>> Do you think so?
>
>Yes
>
>> Btw, I think you meant commit 4f848c0a9c265cb3457fbf842dbffd28e82a44fd
>> ("qlge: Add RX frame handlers for non-split frames") here. Because it was in this
>> commit where the ql_process_mac_split_rx_intr was first introduced,
>>
>>     -static void ql_process_mac_rx_intr(struct ql_adapter *qdev,
>>     +static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
>>                                        struct rx_ring *rx_ring,
>>     -                                  struct ib_mac_iocb_rsp *ib_mac_rsp)
>>     +                                  struct ib_mac_iocb_rsp *ib_mac_rsp,
>>     +                                  u16 vlan_id)
>
>It's possible that I referenced the wrong commit in the TODO. Clearly
>there is dead code after commit 4f848c0a9c26 ("qlge: Add RX frame
>handlers for non-split frames.") like you say. I don't remember for sure
>if I had found some before even before that.

Thanks for confirming it:)

>
>>
>> Another TODO item I don't understand is as follows,
>> > * the driver has a habit of using runtime checks where compile time checks are
>> >  possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
>>
>> Could be more specific about which runtime checks are used in
>> ql_free_rx_buffers and ql_alloc_rx_buffers?
>
>This specific example was fixed in commit
>e4c911a73c89 ("staging: qlge: Remove rx_ring.type")
>
>I forgot to update the TODO when making that commit.
>
>Here are other examples:
>a68a5b2fd3a2 ("staging: qlge: Remove bq_desc.maplen")
>16714d98bf63 ("staging: qlge: Remove rx_ring.sbq_buf_size")
>ec705b983b46 ("staging: qlge: Remove qlge_bq.len & size")

Thanks for giving these examples!

>
>I don't remember of remaining examples to point you to. Maybe there
>aren't but given that there were indeed quite a few, I would suggest
>that you look at those commits and keep this item in mind as you work on
>the other items earlier in the list. If at the end you think that this
>is no longer a problem, then remove it from the list.

OK. I'll keep this item in mind. Thanks for the reminding!

-- 
Best regards,
Coiby
