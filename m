Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8103198A6A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgCaDOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:14:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgCaDOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:14:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F75A15D187D6;
        Mon, 30 Mar 2020 20:14:37 -0700 (PDT)
Date:   Mon, 30 Mar 2020 20:14:36 -0700 (PDT)
Message-Id: <20200330.201436.2193008910602121027.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     kuba@kernel.org, jacob.e.keller@intel.com, jiri@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: dev: Fix memory leak in
 nsim_dev_take_snapshot_write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330232702.GA3212@embeddedor.com>
References: <20200330232702.GA3212@embeddedor.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 20:14:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 30 Mar 2020 18:27:02 -0500

> In case memory resources for dummy_data were allocated, release them
> before return.
> 
> Addresses-Coverity-ID: 1491997 ("Resource leak")
> Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied, thanks.
