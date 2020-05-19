Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000A61D8C53
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgESAeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgESAeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:34:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62811C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:34:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD0BB1276512B;
        Mon, 18 May 2020 17:34:23 -0700 (PDT)
Date:   Mon, 18 May 2020 17:33:04 -0700 (PDT)
Message-Id: <20200518.173304.1928081655387944185.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 1/1] net sched: fix reporting the first-time use
 timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
References: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:34:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sun, 17 May 2020 08:46:31 -0400

> When a new action is installed, firstuse field of 'tcf_t' is explicitly set
> to 0. Value of zero means "new action, not yet used"; as a packet hits the
> action, 'firstuse' is stamped with the current jiffies value.
> 
> tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.
> 
> Fixes: 48d8ee1694dd ("net sched actions: aggregate dumping of actions timeinfo")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Applied and queued up for -stable, thanks.
