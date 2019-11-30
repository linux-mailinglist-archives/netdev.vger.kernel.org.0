Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA10E10DF3D
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfK3UYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:24:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfK3UYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:24:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6199144B3066;
        Sat, 30 Nov 2019 12:24:12 -0800 (PST)
Date:   Sat, 30 Nov 2019 12:24:12 -0800 (PST)
Message-Id: <20191130.122412.738209563027806422.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net] selftests: forwarding: fix race between packet
 receive and tc check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128123857.1216-1-jiri@resnulli.us>
References: <20191128123857.1216-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 12:24:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 28 Nov 2019 13:38:57 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> It is possible that tc stats get checked before the packet we check for
> actually arrived into the interface and accounted for.
> Fix it by checking for the expected result in a loop until
> timeout is reached (by default 1 second).
> 
> Fixes: 07e5c75184a1 ("selftests: forwarding: Introduce tc flower matching tests")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks Jiri.
