Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 067E017CC86
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgCGGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:43:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgCGGne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:43:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF4CE155371CC;
        Fri,  6 Mar 2020 22:43:33 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:43:33 -0800 (PST)
Message-Id: <20200306.224333.609016114112242678.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:43:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu,  5 Mar 2020 15:17:34 -0800

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.4
>  ('net/mlx5: DR, Fix postsend actions write length')
> 
> For -stable v5.5
>  ('net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow')
>  ('net/mlx5e: Fix endianness handling in pedit mask')

Queued up, thanks.
