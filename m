Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C62B154EEE
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 23:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBFWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 17:31:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgBFWbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 17:31:36 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D1341572CD35;
        Thu,  6 Feb 2020 14:31:35 -0800 (PST)
Date:   Thu, 06 Feb 2020 23:31:04 +0100 (CET)
Message-Id: <20200206.233104.1031012830840981440.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-02-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 14:31:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu,  6 Feb 2020 12:57:05 -0800

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.19:
>  ('net/mlx5: IPsec, Fix esp modify function attribute')
>  ('net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx')
> 
> For -stable v5.4:
>    ('net/mlx5: Deprecate usage of generic TLS HW capability bit')
>    ('net/mlx5: Fix deadlock in fs_core')
> 
> For -stable v5.5:
>    ('net/mlx5e: TX, Error completion is for last WQE in batch')

Queued up.
