Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F367204B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391757AbfGWUCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:02:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391752AbfGWUCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:02:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C898E153BA915;
        Tue, 23 Jul 2019 13:02:13 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:02:11 -0700 (PDT)
Message-Id: <20190723.130211.1967999203654051483.davem@davemloft.net>
To:     leon@kernel.org
Cc:     dledford@redhat.com, jgg@mellanox.com, edwards@mellanox.com,
        linux-rdma@vger.kernel.org, yishaih@mellanox.com,
        saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723190414.GU5125@mtr-leonro.mtl.com>
References: <20190723071255.6588-1-leon@kernel.org>
        <20190723.112850.610952032088764951.davem@davemloft.net>
        <20190723190414.GU5125@mtr-leonro.mtl.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:02:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 23 Jul 2019 22:04:14 +0300

> The intention was to have this patch in shared mlx5 branch, which is
> picked by RDMA too. This "Cc: stable@..." together with merge through
> RDMA will ensure that such patch will be part of stable automatically.

Why wouldn't it come via Saeed's usual mlx5 bug fix pull requests to me?
