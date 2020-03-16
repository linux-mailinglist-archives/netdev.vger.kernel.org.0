Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0129618691D
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgCPKbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:31:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730565AbgCPKbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:31:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F70A1495C2D7;
        Mon, 16 Mar 2020 03:31:50 -0700 (PDT)
Date:   Mon, 16 Mar 2020 03:31:47 -0700 (PDT)
Message-Id: <20200316.033147.103337138915274508.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        paulb@mellanox.com
Subject: Re: [patch net-next] net: sched: set the hw_stats_type in pedit
 loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316080325.6513-1-jiri@resnulli.us>
References: <20200316080325.6513-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 03:31:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 16 Mar 2020 09:03:25 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> For a single pedit action, multiple offload entries may be used. Set the
> hw_stats_type to all of them.
> 
> Fixes: 44f865801741 ("sched: act: allow user to specify type of HW stats for a filter")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks Jiri.
