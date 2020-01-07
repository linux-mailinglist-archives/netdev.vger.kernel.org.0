Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE3131D95
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 03:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgAGC2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 21:28:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGC2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 21:28:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C78E159E784A;
        Mon,  6 Jan 2020 18:28:30 -0800 (PST)
Date:   Mon, 06 Jan 2020 18:28:29 -0800 (PST)
Message-Id: <20200106.182829.2014327130595532083.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-01-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106233248.58700-1-saeedm@mellanox.com>
References: <20200106233248.58700-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jan 2020 18:28:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 6 Jan 2020 23:36:21 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.3
>  ('net/mlx5: Move devlink registration before interfaces load')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix hairpin RSS table size')
>  ('net/mlx5: DR, Init lists that are used in rule's member')
>  ('net/mlx5e: Always print health reporter message to dmesg')
>  ('net/mlx5: DR, No need for atomic refcount for internal SW steering resources')

Queued up, thanks.
