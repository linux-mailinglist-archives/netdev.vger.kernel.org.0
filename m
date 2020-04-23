Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299971B6745
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgDWWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWWyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:54:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF32C09B042;
        Thu, 23 Apr 2020 15:54:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E17EA127E6D15;
        Thu, 23 Apr 2020 15:54:16 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:54:16 -0700 (PDT)
Message-Id: <20200423.155416.1837573731946406207.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] qed: Make ll2_cbs static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587626860-97801-1-git-send-email-zou_wei@huawei.com>
References: <1587626860-97801-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:54:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Date: Thu, 23 Apr 2020 15:27:40 +0800

> Fix the following sparse warning:
> 
> drivers/net/ethernet/qlogic/qed/qed_ll2.c:2334:20: warning: symbol 'll2_cbs'
> was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Applied.
