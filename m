Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E162EC779
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfKARZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:25:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfKARZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:25:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B65A11511ABF7;
        Fri,  1 Nov 2019 10:25:56 -0700 (PDT)
Date:   Fri, 01 Nov 2019 10:25:56 -0700 (PDT)
Message-Id: <20191101.102556.721413828280813656.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     heiko@sntech.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: arc: add the missed
 clk_disable_unprepare
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101121725.13349-1-hslester96@gmail.com>
References: <20191101121725.13349-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 10:25:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Fri,  1 Nov 2019 20:17:25 +0800

> The remove misses to disable and unprepare priv->macclk like what is done
> when probe fails.
> Add the missed call in remove.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied, thank you.
