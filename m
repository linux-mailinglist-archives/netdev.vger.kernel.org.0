Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBC89B84A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbfHWVpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:45:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfHWVpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:45:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AC741543B41C;
        Fri, 23 Aug 2019 14:45:17 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:45:16 -0700 (PDT)
Message-Id: <20190823.144516.1474535743879521178.davem@davemloft.net>
To:     eranbe@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, haiyangz@microsoft.com
Subject: Re: [PATCH net-next] net/mlx5: Fix return code in case of hyperv
 wrong size read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566563687-29760-1-git-send-email-eranbe@mellanox.com>
References: <1566563687-29760-1-git-send-email-eranbe@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:45:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>
Date: Fri, 23 Aug 2019 15:34:47 +0300

> Return code value could be non deterministic in case of wrong size read.
> With this patch, if such error occurs, set rc to be -EIO.
> 
> In addition, mlx5_hv_config_common() supports reading of
> HV_CONFIG_BLOCK_SIZE_MAX bytes only, fix to early return error with
> bad input.
> 
> Fixes: 913d14e86657 ("net/mlx5: Add wrappers for HyperV PCIe operations")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>

Applied, thank you.
