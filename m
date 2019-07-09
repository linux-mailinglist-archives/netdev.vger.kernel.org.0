Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D46C62E43
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfGICjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:39:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGICjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:39:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15971133E976D;
        Mon,  8 Jul 2019 19:39:04 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:39:03 -0700 (PDT)
Message-Id: <20190708.193903.1733587425759708535.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com, willemb@google.com
Subject: Re: [PATCH net-next v2] skbuff: increase verbosity when dumping
 skb data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707095155.58578-1-willemdebruijn.kernel@gmail.com>
References: <20190707095155.58578-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:39:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun,  7 Jul 2019 05:51:55 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> skb_warn_bad_offload and netdev_rx_csum_fault trigger on hard to debug
> issues. Dump more state and the header.
> 
> Optionally dump the entire packet and linear segment. This is required
> to debug checksum bugs that may include bytes past skb_tail_pointer().
> 
> Both call sites call this function inside a net_ratelimit() block.
> Limit full packet log further to a hard limit of can_dump_full (5).
> 
> Based on an earlier patch by Cong Wang, see link below.
> 
> Changes v1 -> v2
>   - dump frag_list only on full_pkt
> 
> Link: https://patchwork.ozlabs.org/patch/1000841/
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Nice to finally have this, applied.
