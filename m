Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45A42676DB
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgILAhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgILAhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:37:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA6BC061573;
        Fri, 11 Sep 2020 17:37:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D75CA12354C86;
        Fri, 11 Sep 2020 17:20:26 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:37:12 -0700 (PDT)
Message-Id: <20200911.173712.1523119778628815614.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw_new: fix suspend/resume
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910205229.21288-1-grygorii.strashko@ti.com>
References: <20200910205229.21288-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:20:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 10 Sep 2020 23:52:29 +0300

> Add missed suspend/resume callbacks to properly restore networking after
> suspend/resume cycle.
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied and queued up for -stable, thanks.
