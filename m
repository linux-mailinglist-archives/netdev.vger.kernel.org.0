Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7809312AE5C
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 20:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLZTuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 14:50:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZTuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 14:50:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 528CF14325459;
        Thu, 26 Dec 2019 11:50:20 -0800 (PST)
Date:   Thu, 26 Dec 2019 11:50:17 -0800 (PST)
Message-Id: <20191226.115017.708837293686080083.davem@davemloft.net>
To:     leon@kernel.org
Cc:     mlxsw@mellanox.com, vladyslavt@mellanox.com,
        netdev@vger.kernel.org, ayal@mellanox.com, leonro@mellanox.com
Subject: Re: [PATCH net] net/mlxfw: Fix out-of-memory error in mfa2 flash
 burning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226084156.9561-1-leon@kernel.org>
References: <20191226084156.9561-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 11:50:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 26 Dec 2019 10:41:56 +0200

> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> 
> The burning process requires to perform internal allocations of large
> chunks of memory. This memory doesn't need to be contiguous and can be
> safely allocated by vzalloc() instead of kzalloc(). This patch changes
> such allocation to avoid possible out-of-memory failure.
> 
> Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> Reviewed-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied and queued up for -stable, thank you.
