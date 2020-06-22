Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C320447A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgFVXah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbgFVXag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:30:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6C3C061795
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:30:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBEE81297216A;
        Mon, 22 Jun 2020 16:30:32 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:30:32 -0700 (PDT)
Message-Id: <20200622.163032.618270174941503260.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        colin.king@canonical.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum: Do not rely on machine endianness
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621082917.475558-1-idosch@idosch.org>
References: <20200621082917.475558-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:30:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 21 Jun 2020 11:29:17 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The second commit cited below performed a cast of 'u32 buffsize' to
> '(u16 *)' when calling mlxsw_sp_port_headroom_8x_adjust():
> 
> mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);
> 
> Colin noted that this will behave differently on big endian
> architectures compared to little endian architectures.
> 
> Fix this by following Colin's suggestion and have the function accept
> and return 'u32' instead of passing the current size by reference.
> 
> Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
> Fixes: 60833d54d56c ("mlxsw: spectrum: Adjust headroom buffers for 8x ports")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Suggested-by: Colin Ian King <colin.king@canonical.com>

Applied and queued up for -stable, thanks.
