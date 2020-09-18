Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7019726EA32
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRA7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIRA7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:59:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95D8C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:58:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CC11136821B9;
        Thu, 17 Sep 2020 17:42:11 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:58:30 -0700 (PDT)
Message-Id: <20200917.175830.159022412492195930.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [PATCH net-next] net: remove comments on struct rtnl_link_stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917175132.592308-1-kuba@kernel.org>
References: <20200917175132.592308-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:42:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 17 Sep 2020 10:51:32 -0700

> We removed the misleading comments from struct rtnl_link_stats64
> when we added proper kdoc. struct rtnl_link_stats has the same
> inline comments, so remove them, too.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thank you.
