Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AE14B009
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 04:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfFSCah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 22:30:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSCah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 22:30:37 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9A1214DB3D1D;
        Tue, 18 Jun 2019 19:30:28 -0700 (PDT)
Date:   Tue, 18 Jun 2019 22:30:23 -0400 (EDT)
Message-Id: <20190618.223023.244389297657538568.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5: add missing void argument to function
 mlx5_devlink_alloc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618151510.18672-1-colin.king@canonical.com>
References: <20190618151510.18672-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 19:30:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 18 Jun 2019 16:15:10 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Function mlx5_devlink_alloc is missing a void argument, add it
> to clean up the non-ANSI function declaration.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
