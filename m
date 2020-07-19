Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99F0225476
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGSWSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 18:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgGSWSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 18:18:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923EC0619D2;
        Sun, 19 Jul 2020 15:18:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF46F12812C1D;
        Sun, 19 Jul 2020 15:18:00 -0700 (PDT)
Date:   Sun, 19 Jul 2020 15:17:57 -0700 (PDT)
Message-Id: <20200719.151757.18086897439312800.davem@davemloft.net>
To:     grandmaster@al2klimov.de
Cc:     toke@toke.dk, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] sch_cake: Replace HTTP links with HTTPS ones
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719122232.58647-1-grandmaster@al2klimov.de>
References: <20200719122232.58647-1-grandmaster@al2klimov.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 15:18:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please don't do this "for v5.9" stuff.

There is no precendence for this and it looks like -stable patch
series to just about anyone.

There are well defined, established, ways to write Subject lines for
proper patch submissions.

Please do not invent your own way of doing this.  It is very
frustrating for me personally, especially with the amount of
patches I have to process and review, to watch how you wildly
change your patch submission formatting over and over again.

Just do what other developers are doing and you'll be fine.  Don't
invent your own way.

I'm ignoring all of your "for v5.9" formatted patches, sorry.

Thanks.
