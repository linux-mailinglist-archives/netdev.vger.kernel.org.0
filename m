Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34353190403
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCXD5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:57:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXD5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 23:57:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 594D115513618;
        Mon, 23 Mar 2020 20:57:45 -0700 (PDT)
Date:   Mon, 23 Mar 2020 20:57:44 -0700 (PDT)
Message-Id: <20200323.205744.1206748041598234398.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_cnt: Fix 64-bit division in
 mlxsw_sp_counter_resources_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320021638.1916-1-natechancellor@gmail.com>
References: <20200320021638.1916-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 20:57:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Thu, 19 Mar 2020 19:16:38 -0700

> When building arm32 allyesconfig:
> 
> ld.lld: error: undefined symbol: __aeabi_uldivmod
>>>> referenced by spectrum_cnt.c
>>>>               net/ethernet/mellanox/mlxsw/spectrum_cnt.o:(mlxsw_sp_counter_resources_register) in archive drivers/built-in.a
>>>> did you mean: __aeabi_uidivmod
>>>> defined in: arch/arm/lib/lib.a(lib1funcs.o)
> 
> pool_size and bank_size are u64; use div64_u64 so that 32-bit platforms
> do not error.
> 
> Fixes: ab8c4cc60420 ("mlxsw: spectrum_cnt: Move config validation along with resource register")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to net-next.

Please be clear about the intended target GIT tree for your changes in the
Subject line in the future, thank you.
