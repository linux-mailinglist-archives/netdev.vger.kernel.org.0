Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720B220FBD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgGOOp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729534AbgGOOpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:45:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88059C061755;
        Wed, 15 Jul 2020 07:45:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3892129A5587;
        Wed, 15 Jul 2020 07:45:53 -0700 (PDT)
Date:   Wed, 15 Jul 2020 07:45:53 -0700 (PDT)
Message-Id: <20200715.074553.61988591235123973.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: Remove unused inline function
 mptcp_rcv_synsent()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200715023613.9492-1-yuehaibing@huawei.com>
References: <20200715023613.9492-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jul 2020 07:45:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 15 Jul 2020 10:36:13 +0800

> commit 263e1201a2c3 ("mptcp: consolidate synack processing.")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
