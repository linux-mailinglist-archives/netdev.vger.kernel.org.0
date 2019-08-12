Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E971895FB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfHLEUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:20:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfHLEUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:20:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C443114522F08;
        Sun, 11 Aug 2019 21:20:53 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:20:53 -0700 (PDT)
Message-Id: <20190811.212053.267113714802631044.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: register couple of devlink params
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809110512.31779-1-jiri@resnulli.us>
References: <20190809110512.31779-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:20:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  9 Aug 2019 13:05:12 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Register couple of devlink params, one generic, one driver-specific.
> Make the values available over debugfs.
> 
> Example:
> $ echo "111" > /sys/bus/netdevsim/new_device
> $ devlink dev param
> netdevsim/netdevsim111:
>   name max_macs type generic
>     values:
>       cmode driverinit value 32
>   name test1 type driver-specific
>     values:
>       cmode driverinit value true
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
> 32
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
> Y
> $ devlink dev param set netdevsim/netdevsim111 name max_macs cmode driverinit value 16
> $ devlink dev param set netdevsim/netdevsim111 name test1 cmode driverinit value false
> $ devlink dev reload netdevsim/netdevsim111
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
> 16
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks Jiri.
