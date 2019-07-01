Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D65B2C4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfGABmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:42:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfGABmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:42:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5536133E9BD5;
        Sun, 30 Jun 2019 18:42:12 -0700 (PDT)
Date:   Sun, 30 Jun 2019 18:42:10 -0700 (PDT)
Message-Id: <20190630.184210.1441167336506307389.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/10] Mellanox, mlx5e updates
 2019-06-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628231759.16374-1-saeedm@mellanox.com>
References: <20190628231759.16374-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Jun 2019 18:42:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 28 Jun 2019 23:18:18 +0000

> This series adds misc updates to mlx5e driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> This pull provides the resolution of the conflict reported by Stephen:
> https://lkml.org/lkml/2019/6/27/1016

Ok, pulled, thank you.
