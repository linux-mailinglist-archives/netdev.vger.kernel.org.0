Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DBB217B05
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGGWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGWeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:34:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18488C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:34:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1BCE120ED48D;
        Tue,  7 Jul 2020 15:34:22 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:34:21 -0700 (PDT)
Message-Id: <20200707.153421.604215061963164385.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH net] net: Added pointer check for
 dst->ops->neigh_lookup in dst_neigh_lookup_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593939229-8191-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1593939229-8191-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:34:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Sun,  5 Jul 2020 14:23:49 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The packets from tunnel devices (eg bareudp) may have only
> metadata in the dst pointer of skb. Hence a pointer check of
> neigh_lookup is needed in dst_neigh_lookup_skb
> 
> Kernel crashes when packets from bareudp device is processed in
> the kernel neighbour subsytem.
 ...
> Fixes: aaa0c23cb901 ("Fix dst_neigh_lookup/dst_neigh_lookup_skb return value handling bug")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Applied and queued up for -stable, thanks.
