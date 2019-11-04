Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77327ED807
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 04:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfKDDYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 22:24:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41168 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbfKDDYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 22:24:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E5961503D3C1;
        Sun,  3 Nov 2019 19:24:55 -0800 (PST)
Date:   Sun, 03 Nov 2019 19:24:54 -0800 (PST)
Message-Id: <20191103.192454.1423304794913905843.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] Mellanox, mlx5 updates
 2019-11-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 19:24:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 1 Nov 2019 21:58:55 +0000

> This series adds misc updates to mlx5 core and netdev driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks a lot.

I'll push back out after some quick build testing.
