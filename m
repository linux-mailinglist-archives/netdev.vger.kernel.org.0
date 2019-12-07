Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD93115B09
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 06:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfLGFD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 00:03:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfLGFD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 00:03:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54A591537E8F8;
        Fri,  6 Dec 2019 21:03:56 -0800 (PST)
Date:   Fri, 06 Dec 2019 21:03:55 -0800 (PST)
Message-Id: <20191206.210355.276201389308734670.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/8] Mellanox, mlx5 fixes 2019-12-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 21:03:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 5 Dec 2019 21:12:04 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.
> 
> For -stable v4.19:
>  ('net/mlx5e: Query global pause state before setting prio2buffer')
> 
> For -stable v5.3
>  ('net/mlx5e: Fix SFF 8472 eeprom length')
>  ('net/mlx5e: Fix translation of link mode into speed')
>  ('net/mlx5e: Fix freeing flow with kfree() and not kvfree()')
>  ('net/mlx5e: ethtool, Fix analysis of speed setting')
>  ('net/mlx5e: Fix TXQ indices to be sequential')

Pulled and queued up for -stable, thanks.
