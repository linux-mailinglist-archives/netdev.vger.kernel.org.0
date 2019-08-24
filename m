Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE759C0FB
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfHXXbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:31:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfHXXbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:31:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C1E31525FA04;
        Sat, 24 Aug 2019 16:31:06 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:31:06 -0700 (PDT)
Message-Id: <20190824.163106.1621211468386035734.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 0/8] Mellanox, mlx5 updates 2019-08-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:31:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 22 Aug 2019 23:35:45 +0000

> This series provides some misc updates to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.

I agree with Jakub that the new statistic can probably have a more
descriptive name.

Thanks.
