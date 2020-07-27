Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527A322F7DF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgG0SjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbgG0SjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:39:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2154DC061794;
        Mon, 27 Jul 2020 11:39:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4388A11DB3142;
        Mon, 27 Jul 2020 11:22:32 -0700 (PDT)
Date:   Mon, 27 Jul 2020 11:39:16 -0700 (PDT)
Message-Id: <20200727.113916.2247175777216104943.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727033810.28883-1-gaurav1086@gmail.com>
References: <20200727033810.28883-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 11:22:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Sun, 26 Jul 2020 23:38:10 -0400

> ipv6_pinfo is initlialized by inet6_sk() which returns NULL. 
> Hence it can cause segmentation fault. Fix this by adding a 
> NULL check.

Please take your time with such changes and actually look at the
compiler output, it will warn that you are adding a new problem.

Specifically, the function now fails to return a value at all.

But even more important, how is the situation you are fixing
possible?  Do you have a sample crash?  Can you please describe
the code paths and conditions that lead to the problem?

You must also provide a valid and properly formatted Fixes: tag
for bug fixes such as this.

Thank you.
