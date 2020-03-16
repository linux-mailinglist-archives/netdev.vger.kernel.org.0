Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468611860AA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgCPAEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:04:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbgCPAEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:04:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03D871212978B;
        Sun, 15 Mar 2020 17:04:33 -0700 (PDT)
Date:   Sun, 15 Mar 2020 17:04:33 -0700 (PDT)
Message-Id: <20200315.170433.535458592852208068.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: reg: Increase register field length to 31
 bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200315080735.747353-1-idosch@idosch.org>
References: <20200315080735.747353-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 17:04:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 15 Mar 2020 10:07:35 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The cited commit set a value of 2^31-1 in order to "disable" the shaper
> on a given a port. However, the length of the maximum shaper rate field
> was not updated from 28 bits to 31 bits, which means ports are still
> limited to ~268Gbps despite supporting speeds of 400Gbps.
> 
> Fix this by increasing the field's length.
> 
> Fixes: 92afbfedb77d ("mlxsw: reg: Increase MLXSW_REG_QEEC_MAS_DIS")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>

Applied, thanks.
