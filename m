Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049B867525
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfGLShe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 14:37:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfGLShe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 14:37:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 758F114DE6032;
        Fri, 12 Jul 2019 11:37:33 -0700 (PDT)
Date:   Fri, 12 Jul 2019 11:37:32 -0700 (PDT)
Message-Id: <20190712.113732.1943040089721373555.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     saeedm@mellanox.com, leon@kernel.org, borisp@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com
Subject: Re: [PATCH net-next v3] net/mlx5e: Convert single case statement
 switch statements into if statements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710060614.6155-1-natechancellor@gmail.com>
References: <20190710044748.3924-1-natechancellor@gmail.com>
        <20190710060614.6155-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 11:37:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Tue,  9 Jul 2019 23:06:15 -0700

> During the review of commit 1ff2f0fa450e ("net/mlx5e: Return in default
> case statement in tx_post_resync_params"), Leon and Nick pointed out
> that the switch statements can be converted to single if statements
> that return early so that the code is easier to follow.
> 
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks for following up Nathan.
