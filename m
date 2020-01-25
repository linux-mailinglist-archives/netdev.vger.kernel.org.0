Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6752514942D
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAYJfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:35:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:35:16 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5203815A1C162;
        Sat, 25 Jan 2020 01:35:14 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:35:12 +0100 (CET)
Message-Id: <20200125.103512.2165079681638219887.davem@davemloft.net>
To:     moshe@mellanox.com
Cc:     jiri@mellanox.com, vikas.gupta@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] devlink: Add health recover notifications
 on devlink flows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579802233-27224-1-git-send-email-moshe@mellanox.com>
References: <1579802233-27224-1-git-send-email-moshe@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:35:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>
Date: Thu, 23 Jan 2020 19:57:13 +0200

> Devlink health recover notifications were added only on driver direct
> updates of health_state through devlink_health_reporter_state_update().
> Add notifications on updates of health_state by devlink flows of report
> and recover.
> 
> Moved functions devlink_nl_health_reporter_fill() and
> devlink_recover_notify() to avoid forward declaration.
> 
> Fixes: 97ff3bd37fac ("devlink: add devink notification when reporter update health state")
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Applied, thank you.
