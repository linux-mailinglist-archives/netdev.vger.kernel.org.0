Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8558B1A3892
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgDIRHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:07:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgDIRHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:07:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DCAB128C1251;
        Thu,  9 Apr 2020 10:07:47 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:07:46 -0700 (PDT)
Message-Id: <20200409.100746.1304029016102772872.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/8] Mellanox, mlx5 fixes 2020-04-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:07:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed,  8 Apr 2020 15:51:16 -0700

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.3
>  ('net/mlx5: Fix frequent ioread PCI access during recovery')
>  ('net/mlx5e: Add missing release firmware call')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix nest_level for vlan pop action')
>  ('net/mlx5e: Fix pfnum in devlink port attribute')

Queued up.

Thanks.
