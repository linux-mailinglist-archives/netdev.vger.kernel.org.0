Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1FF0C14
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfKFCfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:35:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:35:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AC661510CDF5;
        Tue,  5 Nov 2019 18:35:22 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:35:22 -0800 (PST)
Message-Id: <20191105.183522.2155800632990290770.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105145416.60451-1-colin.king@canonical.com>
References: <20191105145416.60451-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:35:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  5 Nov 2019 14:54:16 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a esw_warn warning message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Saeed, please pick this one up.

Thank you.
