Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442772D373B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgLHXzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730611AbgLHXzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:55:36 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B5C06179C;
        Tue,  8 Dec 2020 15:54:56 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A65B84D248DBC;
        Tue,  8 Dec 2020 15:54:55 -0800 (PST)
Date:   Tue, 08 Dec 2020 15:54:54 -0800 (PST)
Message-Id: <20201208.155454.2156057383798260135.davem@davemloft.net>
To:     cengiz@kernel.wtf
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tipc: prevent possible null deref of link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207081423.67313-1-cengiz@kernel.wtf>
References: <20201207081423.67313-1-cengiz@kernel.wtf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 15:54:55 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cengiz Can <cengiz@kernel.wtf>
Date: Mon,  7 Dec 2020 11:14:24 +0300

> `tipc_node_apply_property` does a null check on a `tipc_link_entry`
> pointer but also accesses the same pointer out of the null check block.
> 
> This triggers a warning on Coverity Static Analyzer because we're
> implying that `e->link` can BE null.
> 
> Move "Update MTU for node link entry" line into if block to make sure
> that we're not in a state that `e->link` is null.
> 
> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
> ---

Applied, thanks.,
