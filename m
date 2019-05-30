Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1AA3020D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfE3Sif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:38:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3Sif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:38:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCEC814D97253;
        Thu, 30 May 2019 11:38:34 -0700 (PDT)
Date:   Thu, 30 May 2019 11:38:34 -0700 (PDT)
Message-Id: <20190530.113834.1375315944928930917.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-05-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:38:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 29 May 2019 02:07:57 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.13:
> ('net/mlx5: Allocate root ns memory using kzalloc to match kfree')
> 
> For -stable v4.16:
> ('net/mlx5: Avoid double free in fs init error unwinding path')
> 
> For -stable v4.18:
> ('net/mlx5e: Disable rxhash when CQE compress is enabled')

Queued up.
