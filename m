Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44030EB8A6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfJaVCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:02:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfJaVCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:02:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D2B114FF95DF;
        Thu, 31 Oct 2019 14:02:13 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:02:13 -0700 (PDT)
Message-Id: <20191031.140213.1989291310066375753.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com, w@1wt.eu, ycao009@ucr.edu
Subject: Re: [PATCH net] net: increase SOMAXCONN to 4096
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030163620.140387-1-edumazet@google.com>
References: <20191030163620.140387-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:02:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 30 Oct 2019 09:36:20 -0700

> SOMAXCONN is /proc/sys/net/core/somaxconn default value.
> 
> It has been defined as 128 more than 20 years ago.
> 
> Since it caps the listen() backlog values, the very small value has
> caused numerous problems over the years, and many people had
> to raise it on their hosts after beeing hit by problems.
> 
> Google has been using 1024 for at least 15 years, and we increased
> this to 4096 after TCP listener rework has been completed, more than
> 4 years ago. We got no complain of this change breaking any
> legacy application.
> 
> Many applications indeed setup a TCP listener with listen(fd, -1);
> meaning they let the system select the backlog.
> 
> Raising SOMAXCONN lowers chance of the port being unavailable under
> even small SYNFLOOD attack, and reduces possibilities of side channel
> vulnerabilities.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
