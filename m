Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030D281E31
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBWWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJBWWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:22:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0236DC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:22:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 135F211E480E0;
        Fri,  2 Oct 2020 15:05:23 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:22:10 -0700 (PDT)
Message-Id: <20201002.152210.882739609746128600.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH] netlink: fix policy dump leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
References: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:05:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  2 Oct 2020 09:46:04 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> If userspace doesn't complete the policy dump, we leak the
> allocated state. Fix this.
> 
> Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and queued up for -stable, thanks.

> Jakub, this conflicts with your series now, of course. Not sure how
> we want to handle that?

I applied this to both net and net-next in order to facilitate Jakub's
work.
