Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF06A20A8B3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407741AbgFYXRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406523AbgFYXRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:17:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A36C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:17:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5EFB153C7171;
        Thu, 25 Jun 2020 16:17:36 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:17:35 -0700 (PDT)
Message-Id: <20200625.161735.822308990824129945.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, o.rempel@pengutronix.de
Subject: Re: [PATCH net] ethtool: fix error handling in
 linkstate_prepare_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624220908.E2C5460460@lion.mk-sys.cz>
References: <20200624220908.E2C5460460@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:17:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 25 Jun 2020 00:09:08 +0200 (CEST)

> When getting SQI or maximum SQI value fails in linkstate_prepare_data(), we
> must not return without calling ethnl_ops_complete(dev) as that could
> result in imbalance between ethtool_ops ->begin() and ->complete() calls.
> 
> Fixes: 806602191592 ("ethtool: provide UAPI for PHY Signal Quality Index (SQI)")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thank you.
