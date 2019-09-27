Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524EEC013D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfI0Ide (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:33:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfI0Ide (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:33:34 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5384014DF0D7D;
        Fri, 27 Sep 2019 01:33:29 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:33:28 +0200 (CEST)
Message-Id: <20190927.103328.1345010550910672678.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        yishaih@mellanox.com, maximmi@mellanox.com, eranbe@mellanox.com,
        tariqt@mellanox.com, bodong@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: prevent memory leak in
 mlx5_fpga_conn_create_cq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925032038.22943-1-navid.emamdoost@gmail.com>
References: <20190925032038.22943-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:33:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Tue, 24 Sep 2019 22:20:34 -0500

> In mlx5_fpga_conn_create_cq if mlx5_vector2eqn fails the allocated
> memory should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Saeed, please queue this up.
