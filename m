Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3951C7BA2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgEFU57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726815AbgEFU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:57:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC617C061A0F;
        Wed,  6 May 2020 13:57:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E9EC1210A3F3;
        Wed,  6 May 2020 13:57:58 -0700 (PDT)
Date:   Wed, 06 May 2020 13:57:57 -0700 (PDT)
Message-Id: <20200506.135757.899774547217843583.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     tariqt@mellanox.com, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: mlx4: remove unneeded variable "err" in
 mlx4_en_get_rxfh()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506061630.19010-1-yanaijie@huawei.com>
References: <20200506061630.19010-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:57:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Wed, 6 May 2020 14:16:30 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlx4/en_ethtool.c:1238:5-8: Unneeded
> variable: "err". Return "0" on line 1252
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
