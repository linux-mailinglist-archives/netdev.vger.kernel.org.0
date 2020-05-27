Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72E81E367D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgE0DZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0DZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:25:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77926C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:25:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8F9E12790FEE;
        Tue, 26 May 2020 20:25:23 -0700 (PDT)
Date:   Tue, 26 May 2020 20:25:22 -0700 (PDT)
Message-Id: <20200526.202522.1369809008652733687.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: check untrusted gso_size at kernel entry
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525190740.82224-1-willemdebruijn.kernel@gmail.com>
References: <20200525190740.82224-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:25:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 25 May 2020 15:07:40 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Syzkaller again found a path to a kernel crash through bad gso input:
> a packet with gso size exceeding len.
> 
> These packets are dropped in tcp_gso_segment and udp[46]_ufo_fragment.
> But they may affect gso size calculations earlier in the path.
> 
> Now that we have thlen as of commit 9274124f023b ("net: stricter
> validation of untrusted gso packets"), check gso_size at entry too.
> 
> Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks Willem.
