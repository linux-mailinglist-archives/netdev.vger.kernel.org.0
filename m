Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A643B317F
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfIOSxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:53:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfIOSxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:53:49 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46697153E761A;
        Sun, 15 Sep 2019 11:53:48 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:53:46 +0100 (WEST)
Message-Id: <20190915.195346.491621328476847786.davem@davemloft.net>
To:     zhongjiang@huawei.com
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
References: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:53:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Date: Fri, 13 Sep 2019 00:59:02 +0800

> mlx5_unload_one do not need local variable to store different value,
> Hence just remove it.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Saeed, just take this directly via one of your trees.

Thank you.
