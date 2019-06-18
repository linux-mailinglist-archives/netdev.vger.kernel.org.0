Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD64A5F7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfFRP4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:56:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfFRP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:56:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7D8315069DDB;
        Tue, 18 Jun 2019 08:56:52 -0700 (PDT)
Date:   Tue, 18 Jun 2019 08:56:50 -0700 (PDT)
Message-Id: <20190618.085650.1421670017271227288.davem@davemloft.net>
To:     shalomt@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        mlxsw@mellanox.com, natechancellor@gmail.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_ptp: Fix compilation on
 32-bit ARM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618124521.22612-1-shalomt@mellanox.com>
References: <20190618124521.22612-1-shalomt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 08:56:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>
Date: Tue, 18 Jun 2019 12:45:35 +0000

> Compilation on 32-bit ARM fails after commit 992aa864dca0 ("mlxsw:
> spectrum_ptp: Add implementation for physical hardware clock operations")
> because of 64-bit division:
> 
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.o: in function
> `mlxsw_sp1_ptp_phc_settime': spectrum_ptp.c:(.text+0x39c): undefined
> reference to `__aeabi_uldivmod'
> 
> Fix by using div_u64().
> 
> Fixes: 992aa864dca0 ("mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations")
> Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thank you.
