Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755821C07A7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgD3UPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgD3UPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:15:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F24C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:15:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECEF1128A82BB;
        Thu, 30 Apr 2020 13:15:51 -0700 (PDT)
Date:   Thu, 30 Apr 2020 13:15:51 -0700 (PDT)
Message-Id: <20200430.131551.251608567526593202.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] Mellanox, mlx5 updates
 2020-04-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 13:15:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 30 Apr 2020 10:18:20 -0700

> This series adds misc updates to mlx5 driver.
> 
> For more info please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled.

> Please note that this series starts with a merge commit of mlx5-next
> branch.
> 
> Merge conflict note:
> Once merged with latest mlx5 fixes submission to net:
> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-29
> 
> A merge conflict will appear: 
> This can be fixed by simply deleting dr_cq_event() function and the
> one reference to it.

Thanks, this helps me a lot.
