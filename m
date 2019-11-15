Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9762FD2A8
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKOCCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:02:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOCCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:02:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C58EF14B79EBC;
        Thu, 14 Nov 2019 18:02:07 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:02:07 -0800 (PST)
Message-Id: <20191114.180207.382334990021821994.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [pull request][net-next V2 0/7] Mellanox, mlx5 updates
 2019-11-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:02:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 13 Nov 2019 22:41:29 +0000

> This series adds misc updates to mlx5 driver,
> For more information please see tag log below.
> 
> Highlights:
> 1) Devlink reload support
> 2) TC Flowtable offloads 
> 
> Please pull and let me know if there is any problem.
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> v1->v2:
> - dropped the 2 patches dealing with sriov vlan trunks, as it was nacked.
> - merged the flowtables offloads low level infrastructure into mlx5-next
>   and updated the mlx5-next merge commit.
> - added mlx5 TC flowtables offload support patch on top of this series.

Pulled, thank you.
