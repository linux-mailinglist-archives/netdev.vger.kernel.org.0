Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B371C4313
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgEDRlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729597AbgEDRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:41:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16857C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:41:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF49B15BDB6D7;
        Mon,  4 May 2020 10:41:21 -0700 (PDT)
Date:   Mon, 04 May 2020 10:41:20 -0700 (PDT)
Message-Id: <20200504.104120.790348339297515024.davem@davemloft.net>
To:     ayal@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org, eranbe@mellanox.com,
        moshe@mellanox.com
Subject: Re: [PATCH net] devlink: Fix reporter's recovery condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588580866-18098-1-git-send-email-ayal@mellanox.com>
References: <1588580866-18098-1-git-send-email-ayal@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:41:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>
Date: Mon,  4 May 2020 11:27:46 +0300

> Devlink health core conditions the reporter's recovery with the
> expiration of the grace period. This is not relevant for the first
> recovery. Explicitly demand that the grace period will only apply to
> recoveries other than the first.
> 
> Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks.
