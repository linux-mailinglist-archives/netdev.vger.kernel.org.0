Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38F558EB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFYUeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:34:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:34:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F613128FF110;
        Tue, 25 Jun 2019 13:34:05 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:34:04 -0700 (PDT)
Message-Id: <20190625.133404.1626801368802216614.davem@davemloft.net>
To:     jes.sorensen@gmail.com
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org, kernel-team@fb.com,
        jsorensen@fb.com
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625152708.23729-2-Jes.Sorensen@gmail.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
        <20190625152708.23729-2-Jes.Sorensen@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:34:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jes Sorensen <jes.sorensen@gmail.com>
Date: Tue, 25 Jun 2019 11:27:08 -0400

> From: Jes Sorensen <jsorensen@fb.com>
> 
> The previous patch broke the build with a static declaration for
> a public function.
> 
> Fixes: 8f0916c6dc5c (net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled)
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>

Saeed, I'm assuming I will get this via your next pull request once things
are sorted.

Thanks.
