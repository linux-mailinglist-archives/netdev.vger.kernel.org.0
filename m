Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1D6155D2B
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgBGRtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:49:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgBGRtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:49:25 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8368715B2799F;
        Fri,  7 Feb 2020 09:49:23 -0800 (PST)
Date:   Fri, 07 Feb 2020 18:49:22 +0100 (CET)
Message-Id: <20200207.184922.684717862938638775.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] drop_monitor: Do not cancel uninitialized work item
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207172928.129123-1-idosch@idosch.org>
References: <20200207172928.129123-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 09:49:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri,  7 Feb 2020 19:29:28 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Drop monitor uses a work item that takes care of constructing and
> sending netlink notifications to user space. In case drop monitor never
> started to monitor, then the work item is uninitialized and not
> associated with a function.
> 
> Therefore, a stop command from user space results in canceling an
> uninitialized work item which leads to the following warning [1].
> 
> Fix this by not processing a stop command if drop monitor is not
> currently monitoring.
...
> Fixes: 8e94c3bc922e ("drop_monitor: Allow user to start monitoring hardware drops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for v5.4+ -stable, thanks.
