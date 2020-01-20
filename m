Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11C71427A8
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgATJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:50:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:50:30 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1716D153D88BE;
        Mon, 20 Jan 2020 01:50:28 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:50:27 +0100 (CET)
Message-Id: <20200120.105027.695127072650482577.davem@davemloft.net>
To:     moshe@mellanox.com
Cc:     jiri@mellanox.com, vikas.gupta@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Add health recover notifications on
 devlink flows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579446268-26540-1-git-send-email-moshe@mellanox.com>
References: <1579446268-26540-1-git-send-email-moshe@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:50:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>
Date: Sun, 19 Jan 2020 17:04:28 +0200

> Devlink health recover notifications were added only on driver direct
> updates of health_state through devlink_health_reporter_state_update().
> Add notifications on updates of health_state by devlink flows of report
> and recover.
> 
> Fixes: 97ff3bd37fac ("devlink: add devink notification when reporter update health state")
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

I really dislike forward declarations and almost all of the time they are
unnecessary.

Could you please just rearrange the code as needed and resubmit?

Thank you.
