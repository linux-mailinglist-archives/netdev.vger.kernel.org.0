Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E218A2B62
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfH3AZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:25:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH3AZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:25:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4014B153B973E;
        Thu, 29 Aug 2019 17:25:45 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:25:44 -0700 (PDT)
Message-Id: <20190829.172544.2238285118664929734.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next v2 0/8] Mellanox, mlx5 updates
 2019-08-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:25:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 28 Aug 2019 18:57:39 +0000

> This series provides some misc updates to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> v2: 
>  - Change statistics counter name to dev_internal_queue_oob as
>    suggested by Jakub.
>  - Fixed an issue with IP-in-IP TSO patch, found by regression testing.

Pulled, thanks.
