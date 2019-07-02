Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F45D9B0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfGCAug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:50:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfGCAug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:50:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECAD114013BC7;
        Tue,  2 Jul 2019 15:32:19 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:32:19 -0700 (PDT)
Message-Id: <20190702.153219.745790952731148399.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, colin.king@canonical.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_ptp: Fix validation in
 mlxsw_sp1_ptp_packet_finish()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3f905fb4d20f266f777ef56648f7615edaaffc9c.1562094119.git.petrm@mellanox.com>
References: <3f905fb4d20f266f777ef56648f7615edaaffc9c.1562094119.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:32:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Tue, 2 Jul 2019 19:06:47 +0000

> Before mlxsw_sp1_ptp_packet_finish() sends the packet back, it validates
> whether the corresponding port is still valid. However the condition is
> incorrect: when mlxsw_sp_port == NULL, the code dereferences the port to
> compare it to skb->dev.
> 
> The condition needs to check whether the port is present and skb->dev still
> refers to that port (or else is NULL). If that does not hold, bail out.
> Add a pair of parentheses to fix the condition.
> 
> Fixes: d92e4e6e33c8 ("mlxsw: spectrum: PTP: Support timestamping on Spectrum-1")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Applied, thank you.
