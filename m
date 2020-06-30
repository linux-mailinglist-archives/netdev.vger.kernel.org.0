Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBBC20FCCA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgF3Ta7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgF3Ta7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:30:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D85EC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:30:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0373812736417;
        Tue, 30 Jun 2020 12:30:58 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:30:58 -0700 (PDT)
Message-Id: <20200630.123058.875499975377948138.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, ndev@hwipl.net
Subject: Re: [PATCH net v2 0/8] support AF_PACKET for layer 3 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 12:30:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 29 Jun 2020 19:06:17 -0600

> Hans reported that packets injected by a correct-looking and trivial
> libpcap-based program were not being accepted by wireguard. In
> investigating that, I noticed that a few devices weren't properly
> handling AF_PACKET-injected packets, and so this series introduces a bit
> of shared infrastructure to support that.
 ...
> This patchset addresses the issue by first adding a layer 3 header parse
> function, much akin to the existing one for layer 2 packets, and then
> adds a shared header_ops structure that, also much akin to the existing
> one for layer 2 packets. Then it wires it up to a few immediate places
> that stuck out as requiring it, and does a bit of cleanup.
> 
> This patchset seems like it's fixing real bugs, so it might be
> appropriate for stable. But they're also very old bugs, so if you'd
> rather not backport to stable, that'd make sense to me too.

Series applied, thanks Jason.

I think for now I'll defer on a -stable submission for this work.  But
in the future maybe we can reconsider.

Thanks.
