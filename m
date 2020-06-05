Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA411F00F0
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgFEUXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgFEUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:23:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F347C08C5C3;
        Fri,  5 Jun 2020 13:23:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC172127B15D3;
        Fri,  5 Jun 2020 13:23:17 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:23:17 -0700 (PDT)
Message-Id: <20200605.132317.18284412642220043.davem@davemloft.net>
To:     efremov@linux.com
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: Use kfree() instead kvfree() where appropriate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605191144.78083-1-efremov@linux.com>
References: <20200605191144.78083-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:23:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Fri,  5 Jun 2020 22:11:44 +0300

> Use kfree(buf) in blocked_fl_read() because the memory is allocated with
> kzalloc(). Use kfree(t) in blocked_fl_write() because the memory is
> allocated with kcalloc().
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied.
