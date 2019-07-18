Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557D16D477
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391205AbfGRTLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:11:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfGRTLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:11:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EC8F1527DFC5;
        Thu, 18 Jul 2019 12:11:30 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:11:30 -0700 (PDT)
Message-Id: <20190718.121130.1625873392550008613.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     hslester96@gmail.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, leon@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5: Replace kfree with kvfree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76783a8ca91cb7d0e454cf699c4984243df0081d.camel@mellanox.com>
References: <20190717101456.17401-1-hslester96@gmail.com>
        <76783a8ca91cb7d0e454cf699c4984243df0081d.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:11:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 18 Jul 2019 18:38:34 +0000

> On Wed, 2019-07-17 at 18:14 +0800, Chuhong Yuan wrote:
>> Variable allocated by kvmalloc should not be freed by kfree.
>> Because it may be allocated by vmalloc.
>> So replace kfree with kvfree here.
>> 
>> Fixes: 9b1f298236057 ("net/mlx5: Add support for FW fatal reporter
>> dump")
>> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Dave, i guess this can go to net.

Ok, applied.
