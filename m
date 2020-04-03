Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62F119CDF9
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391192AbgDCAzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:55:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390138AbgDCAzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:55:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1291D127401BE;
        Thu,  2 Apr 2020 17:55:50 -0700 (PDT)
Date:   Thu, 02 Apr 2020 17:55:49 -0700 (PDT)
Message-Id: <20200402.175549.2287578271928617904.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCHv3 net-next] neigh: support smaller retrans_time settting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200401064620.493-1-liuhangbin@gmail.com>
References: <20200401020749.2608-1-liuhangbin@gmail.com>
        <20200401064620.493-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 17:55:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed,  1 Apr 2020 14:46:20 +0800

> Currently, we limited the retrans_time to be greater than HZ/2. i.e.
> setting retrans_time less than 500ms will not work. This makes the user
> unable to achieve a more accurate control for bonding arp fast failover.
> 
> Update the sanity check to HZ/100, which is 10ms, to let users have more
> ability on the retrans_time control.
> 
> v3: sync the behavior with IPv6 and update all the timer handler
> v2: use HZ instead of hard code number
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, I like the consistency between ipv4 and ipv6 now.

Thanks.
