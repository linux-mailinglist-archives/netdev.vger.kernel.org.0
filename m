Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353032E6B57
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgL1XEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 18:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgL1XET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:04:19 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E59C0613D6;
        Mon, 28 Dec 2020 15:03:39 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 97F634CE686C5;
        Mon, 28 Dec 2020 15:03:38 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:03:38 -0800 (PST)
Message-Id: <20201228.150338.187303639465700771.davem@davemloft.net>
To:     bodefang@126.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1609078295-4025719-1-git-send-email-bodefang@126.com>
References: <1609078295-4025719-1-git-send-email-bodefang@126.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 15:03:38 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Defang Bo <bodefang@126.com>
Date: Sun, 27 Dec 2020 22:11:35 +0800

> Similar to commit<2423496af35>, the fragmentation code tries to parse the header options in order
> to figure out where to insert the fragment option.  Since nexthdr points
> to an invalid option, the calculation of the size of the network header
> can made to be much larger than the linear section of the skb and data
> is read outside of it.
> 
> Signed-off-by: Defang Bo <bodefang@126.com>

Could you please repost this with a proper Fixes: tag, thank you.
