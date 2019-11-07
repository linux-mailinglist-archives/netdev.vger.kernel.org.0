Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1EF3C3A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfKGX3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:29:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKGX3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:29:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D788915379966;
        Thu,  7 Nov 2019 15:29:39 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:29:39 -0800 (PST)
Message-Id: <20191107.152939.1810472801928268045.davem@davemloft.net>
To:     ayal@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Add method for time-stamp on reporter's
 dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573120553-3887-1-git-send-email-ayal@mellanox.com>
References: <1573120553-3887-1-git-send-email-ayal@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:29:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>
Date: Thu,  7 Nov 2019 11:55:53 +0200

> When setting the dump's time-stamp, use ktime_get_real in addition to
> jiffies. This simplifies the user space implementation and bypasses
> some inconsistent behavior with translating jiffies to current time.
> The time taken is transformed into nsec, to comply with y2038 issue.
> 
> Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

This does not apply to the current 'net' tree, please respin.
