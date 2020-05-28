Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058011E6906
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391430AbgE1SEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391258AbgE1SEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:04:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB55C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 11:04:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E3BF1295A266;
        Thu, 28 May 2020 11:04:42 -0700 (PDT)
Date:   Thu, 28 May 2020 11:04:41 -0700 (PDT)
Message-Id: <20200528.110441.1577117316027261701.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V3 00/15] mlx5 updates 2020-05-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:04:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 27 May 2020 18:16:41 -0700

> This series adds support for mlx5 switchdev VM failover using FW bonded
> representor vport and probed VF interface via eswitch vport ACLs.
> Plus some extra misc updates.
> 
> v1->v2:
>   - Dropped the suspend/resume support patch, will re-submit it to net and
>     -stable as requested by Dexuan.
> v2->v3:
>   - Fix build warnings reported by Jakub.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
