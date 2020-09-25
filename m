Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE427953B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgIYXzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIYXzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:55:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1817CC0613CE;
        Fri, 25 Sep 2020 16:55:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 184D613BA0E7B;
        Fri, 25 Sep 2020 16:38:30 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:55:16 -0700 (PDT)
Message-Id: <20200925.165516.1977040744847893527.davem@davemloft.net>
To:     ivan.khoronzhuk@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        alexander.sverdlin@nokia.com, linux-kernel@vger.kernel.org,
        ikhoronz@cisco.com
Subject: Re: [PATCH] net: ethernet: cavium: octeon_mgmt: use phy_start and
 phy_stop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925124439.19946-1-ikhoronz@cisco.com>
References: <20200925124439.19946-1-ikhoronz@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:38:30 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@gmail.com>
Date: Fri, 25 Sep 2020 15:44:39 +0300

> To start also "phy state machine", with UP state as it should be,
> the phy_start() has to be used, in another case machine even is not
> triggered. After this change negotiation is supposed to be triggered
> by SM workqueue.
> 
> It's not correct usage, but it appears after the following patch,
> so add it as a fix.
> 
> Fixes: 74a992b3598a ("net: phy: add phy_check_link_status")
> Signed-off-by: Ivan Khoronzhuk <ikhoronz@cisco.com>

Applied and queued up for -stable, thanks.
