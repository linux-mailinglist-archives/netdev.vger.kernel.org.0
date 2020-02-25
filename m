Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD516EE38
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgBYSl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:41:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731502AbgBYSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:41:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44A1513B24C6D;
        Tue, 25 Feb 2020 10:41:25 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:41:24 -0800 (PST)
Message-Id: <20200225.104124.426697838382401029.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ayal@mellanox.com,
        saeedm@mellanox.com, ranro@mellanox.com, moshe@mellanox.com
Subject: Re: [patch net] mlx5: register lag notifier for init network
 namespace only
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225092546.30710-1-jiri@resnulli.us>
References: <20200225092546.30710-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 10:41:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 25 Feb 2020 10:25:46 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The current code causes problems when the unregistering netdevice could
> be different then the registering one.
> 
> Since the check in mlx5_lag_netdev_event() does not allow any other
> network namespace anyway, fix this by registerting the lag notifier
> per init network namespace only.
> 
> Fixes: d48834f9d4b4 ("mlx5: Use dev_net netdevice notifier registrations")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Tested-by: Aya Levin <ayal@mellanox.com>

Saeed, should I apply this directly?
