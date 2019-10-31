Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AA7EB89D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfJaU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:56:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfJaU4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:56:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B557A14FEE6D8;
        Thu, 31 Oct 2019 13:56:14 -0700 (PDT)
Date:   Thu, 31 Oct 2019 13:56:10 -0700 (PDT)
Message-Id: <20191031.135610.684836389491757031.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: Fix 64-bit division in
 mlxsw_sp_sb_prs_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030160152.11305-1-natechancellor@gmail.com>
References: <20191030160152.11305-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 13:56:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 30 Oct 2019 09:01:52 -0700

> When building for 32-bit ARM, there is a link time error because of a
> 64-bit division:
> 
> ld.lld: error: undefined symbol: __aeabi_uldivmod
>>>> referenced by spectrum_buffers.c
>>>>               net/ethernet/mellanox/mlxsw/spectrum_buffers.o:(mlxsw_sp_buffers_init) in archive drivers/built-in.a
>>>> did you mean: __aeabi_uidivmod
>>>> defined in: arch/arm/lib/lib.a(lib1funcs.o
> 
> Avoid this by using div_u64, which is designed to avoid this problem.
> 
> Fixes: bc9f6e94bcb5 ("mlxsw: spectrum_buffers: Calculate the size of the main pool")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks.
