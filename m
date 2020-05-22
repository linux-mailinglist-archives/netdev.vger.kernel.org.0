Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E281DDB85
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgEVAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730220AbgEVAAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:00:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C1CC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:00:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD7B9120ED482;
        Thu, 21 May 2020 17:00:33 -0700 (PDT)
Date:   Thu, 21 May 2020 17:00:31 -0700 (PDT)
Message-Id: <20200521.170031.935733729746615266.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, o.rempel@pengutronix.de
Subject: Re: [PATCH net] ethtool: count header size in reply size estimate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521202656.95971604F8@lion.mk-sys.cz>
References: <20200521202656.95971604F8@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:00:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sun, 10 May 2020 21:04:09 +0200

> As ethnl_request_ops::reply_size handlers do not include common header
> size into calculated/estimated reply size, it needs to be added in
> ethnl_default_doit() and ethnl_default_notify() before allocating the
> message. On the other hand, strset_reply_size() should not add common
> header size.
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

"May 10th" :-)

Applied and queued up for -stable, thanks.
