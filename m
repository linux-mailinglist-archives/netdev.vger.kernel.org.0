Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8318E63E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgCVDVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:21:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbgCVDVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:21:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19C0015AC429C;
        Sat, 21 Mar 2020 20:21:04 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:21:03 -0700 (PDT)
Message-Id: <20200321.202103.682709364176957538.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: Remove set but not used variable
 'can_ack'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318020157.178956-1-yuehaibing@huawei.com>
References: <20200318020157.178956-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:21:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 18 Mar 2020 02:01:57 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/mptcp/options.c: In function 'mptcp_established_options_dss':
> net/mptcp/options.c:338:7: warning:
>  variable 'can_ack' set but not used [-Wunused-but-set-variable]
> 
> commit dc093db5cc05 ("mptcp: drop unneeded checks")
> leave behind this unused, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
