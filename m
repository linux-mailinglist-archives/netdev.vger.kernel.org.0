Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538331946E9
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCZTBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:01:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZTBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:01:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B231815CB9BD9;
        Thu, 26 Mar 2020 12:01:30 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:01:29 -0700 (PDT)
Message-Id: <20200326.120129.10247438354279964.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_mr: Fix list iteration in error
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326141733.1395337-1-idosch@idosch.org>
References: <20200326141733.1395337-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 12:01:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 26 Mar 2020 16:17:33 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> list_for_each_entry_from_reverse() iterates backwards over the list from
> the current position, but in the error path we should start from the
> previous position.
> 
> Fix this by using list_for_each_entry_continue_reverse() instead.
> 
> This suppresses the following error from coccinelle:
> 
> drivers/net/ethernet/mellanox/mlxsw//spectrum_mr.c:655:34-38: ERROR:
> invalid reference to the index variable of the iterator on line 636
> 
> Fixes: c011ec1bbfd6 ("mlxsw: spectrum: Add the multicast routing offloading logic")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks.
