Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAFA102F97
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfKSWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:55:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfKSWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:55:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F1551424DB5B;
        Tue, 19 Nov 2019 14:55:14 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:55:13 -0800 (PST)
Message-Id: <20191119.145513.561465860770576481.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: fec: fix clock count mis-match
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118121826.26353-1-hslester96@gmail.com>
References: <20191118121826.26353-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 14:55:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Mon, 18 Nov 2019 20:18:26 +0800

> pm_runtime_put_autosuspend in probe will call suspend to disable clks
> automatically if CONFIG_PM is defined. (If CONFIG_PM is not defined,
> its implementation will be empty, then suspend will not be called.)
> 
> Therefore, we can call pm_runtime_get_sync to resume it first to enable
> clks, which matches the suspend. (Only when CONFIG_PM is defined, otherwise
> pm_runtime_get_sync will also be empty, then resume will not be called.)
> 
> Then it is fine to disable clks without causing clock count mis-match.
> 
> Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Please fix the commit message typos pointed out by Andy Duan and resubmit,
thank you.
