Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1B317EEC5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCJClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:41:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJClP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:41:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEACC120F52BC;
        Mon,  9 Mar 2020 19:41:14 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:41:14 -0700 (PDT)
Message-Id: <20200309.194114.2134558915591441970.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/11] Mellanox, mlx5 updates
 2020-03-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:41:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon,  9 Mar 2020 18:42:35 -0700

> This series adds misc updates and cleanups to mlx5 drivers.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.

Looks all pretty straightforward to me, pulled, thanks Saeed.
