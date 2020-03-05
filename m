Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A8517B126
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgCEWDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:03:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgCEWDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 17:03:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9AA015BEF987;
        Thu,  5 Mar 2020 14:03:48 -0800 (PST)
Date:   Thu, 05 Mar 2020 14:03:45 -0800 (PST)
Message-Id: <20200305.140345.1414440008084098711.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] mlxsw: Offload FIFO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 14:03:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  5 Mar 2020 09:16:39 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> If an ETS or PRIO band contains an offloaded qdisc, it is possible to
> obtain offloaded counters for that band. However, some of the bands will
> likely simply contain the default invisible FIFO qdisc, which does not
> present the counters.
> 
> To remedy this situation, make FIFO offloadable, and offload it by mlxsw
> when below PRIO and ETS for the sole purpose of providing counters for the
> bands that do not include other qdiscs.
> 
> - In patch #1, FIFO is extended to support offloading.
> - Patches #2 and #3 restructure bits of mlxsw to facilitate
>   the offload logic.
> - Patch #4 then implements the offload itself.
> - Patch #5 changes the ETS selftest to use the new counters.

Series applied, thanks.
