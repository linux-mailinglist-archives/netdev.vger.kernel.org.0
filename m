Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284FB164DBA
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBSSgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:36:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgBSSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:36:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7F4415AD1940;
        Wed, 19 Feb 2020 10:36:00 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:35:58 -0800 (PST)
Message-Id: <20200219.103558.352164052016423134.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-02-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:36:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 19 Feb 2020 03:06:20 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.3
>  ('net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa')
> 
> For -stable v5.4
>  ('net/mlx5: DR, Fix matching on vport gvmi')
>  ('net/mlx5e: Fix crash in recovery flow without devlink reporter')
> 
> For -stable v5.5
>  ('net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST to RDY')
>  ('net/mlx5e: Don't clear the whole vf config when switching modes')

Queued up.

Thank you.
