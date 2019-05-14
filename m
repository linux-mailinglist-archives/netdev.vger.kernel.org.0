Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7484E1E534
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfENWjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:39:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:39:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8C4014C0379F;
        Tue, 14 May 2019 15:39:36 -0700 (PDT)
Date:   Tue, 14 May 2019 15:39:36 -0700 (PDT)
Message-Id: <20190514.153936.554293393640870983.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com, xudingke@huawei.com
Subject: Re: [PATCH net] net/mlx4_core: Change the error print to info print
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557831799-15220-1-git-send-email-wangyunjian@huawei.com>
References: <1557831799-15220-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:39:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Tue, 14 May 2019 19:03:19 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The error print within mlx4_flow_steer_promisc_add() should
> be a info print.
> 
> Fixes: 592e49dda812 ('net/mlx4: Implement promiscuous mode with device managed flow-steering')
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied, thanks.
