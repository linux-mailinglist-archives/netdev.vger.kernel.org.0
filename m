Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684DD26E97E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgIQXeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIQXeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:34:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC1AC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:34:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 106DD1365D74B;
        Thu, 17 Sep 2020 16:17:20 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:34:06 -0700 (PDT)
Message-Id: <20200917.163406.855865844509135163.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix memory leak during module unload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916162039.26369-1-rajur@chelsio.com>
References: <20200916162039.26369-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:17:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Wed, 16 Sep 2020 21:50:39 +0530

> Fix the memory leak in mps during module unload
> path by freeing mps reference entries if the list
> adpter->mps_ref is not already empty
> 
> Fixes: 28b3870578ef ("cxgb4: Re-work the logic for mps refcounting")
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied and queued up for -stable, thank you.
