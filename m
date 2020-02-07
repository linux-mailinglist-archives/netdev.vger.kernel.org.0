Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB5155D28
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBGRsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:48:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGRsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:48:32 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FB7715B27981;
        Fri,  7 Feb 2020 09:48:31 -0800 (PST)
Date:   Fri, 07 Feb 2020 18:48:29 +0100 (CET)
Message-Id: <20200207.184829.1971454141455904967.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net 0/5] mlxsw: Various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 09:48:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri,  7 Feb 2020 19:26:23 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains various fixes for the mlxsw driver.
> 
> Patch #1 fixes an issue introduced in 5.6 in which a route in the main
> table can replace an identical route in the local table despite the
> local table having an higher precedence.
> 
> Patch #2 contains a test case for the bug fixed in patch #1.
> 
> Patch #3 also fixes an issue introduced in 5.6 in which the driver
> failed to clear the offload indication from IPv6 nexthops upon abort.
> 
> Patch #4 fixes an issue that prevents the driver from loading on
> Spectrum-3 systems. The problem and solution are explained in detail in
> the commit message.
> 
> Patch #5 adds a missing error path. Discovered using smatch.

Series applied, thank you.
