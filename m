Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B923B222
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgHDBNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHDBNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:13:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B3C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:13:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCA5D1278A794;
        Mon,  3 Aug 2020 17:57:03 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:13:48 -0700 (PDT)
Message-Id: <20200803.181348.333074926504563408.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add support for buffer drop traps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:57:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon,  3 Aug 2020 19:11:32 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> A recent patch set added the ability to mirror buffer related drops
> (e.g., early drops) through a netdev. This patch set adds the ability to
> trap such packets to the local CPU for analysis.
> 
> The trapping towards the CPU is configured by using tc-trap action
> instead of tc-mirred as was done when the packets were mirrored through
> a netdev. A future patch set will also add the ability to sample the
> dropped packets using tc-sample action.
> 
> The buffer related drop traps are added to devlink, which means that the
> dropped packets can be reported to user space via the kernel's
> drop_monitor module.
> 
> Patch set overview:
> 
> Patch #1 adds the early_drop trap to devlink
> 
> Patch #2 adds extack to a few devlink operations to facilitate better
> error reporting to user space. This is necessary - among other things -
> because the action of buffer drop traps cannot be changed in mlxsw
> 
> Patch #3 performs a small refactoring in mlxsw, patch #4 fixes a bug that
> this patchset would trigger.
> 
> Patches #5-#6 add the infrastructure required to support different traps
> / trap groups in mlxsw per-ASIC. This is required because buffer drop
> traps are not supported by Spectrum-1
> 
> Patch #7 extends mlxsw to register the early_drop trap
> 
> Patch #8 adds the offload logic for the "trap" action at a qevent block.
> 
> Patch #9 adds a mlxsw-specific selftest.

Series applied, thank you.
