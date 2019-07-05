Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2309660E1B
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 01:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfGEXY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 19:24:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGEXY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 19:24:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15E5015044B7A;
        Fri,  5 Jul 2019 16:24:59 -0700 (PDT)
Date:   Fri, 05 Jul 2019 16:24:58 -0700 (PDT)
Message-Id: <20190705.162458.759755629941822480.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com
Subject: Re: [pull request][net-next V2 0/2] Mellanox, mlx5 updates
 2019-07-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704205050.3354-1-saeedm@mellanox.com>
References: <20190704205050.3354-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 16:24:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 4 Jul 2019 20:51:22 +0000

> This series adds the support for devlink fw query in mlx5
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> This what was actually missing from my previous submission of the 2
> devlink patches.
> 
> v1->v2:
>   - Removed the TLS patches from the pull request and will post them as a
>     standalone series for Jakub to review.

Pulled.
