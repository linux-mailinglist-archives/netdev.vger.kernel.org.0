Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5321C9B97
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgEGUEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGUEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:04:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC58C05BD43;
        Thu,  7 May 2020 13:04:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF35F1195077D;
        Thu,  7 May 2020 13:04:44 -0700 (PDT)
Date:   Thu, 07 May 2020 13:04:44 -0700 (PDT)
Message-Id: <20200507.130444.617282849452789073.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     tariqt@mellanox.com, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: mlx4: remove unneeded variable "err" in
 mlx4_en_ethtool_add_mac_rule()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507110857.38035-1-yanaijie@huawei.com>
References: <20200507110857.38035-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:04:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Thu, 7 May 2020 19:08:57 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlx4/en_ethtool.c:1396:5-8: Unneeded
> variable: "err". Return "0" on line 1411
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
