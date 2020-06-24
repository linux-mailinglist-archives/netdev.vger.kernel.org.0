Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40DC206AAD
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbgFXDgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388187AbgFXDgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:36:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918BEC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:36:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 426701298633D;
        Tue, 23 Jun 2020 20:36:13 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:36:12 -0700 (PDT)
Message-Id: <20200623.203612.598579724539724071.davem@davemloft.net>
To:     mika.westerberg@linux.intel.com
Cc:     kuba@kernel.org, michael.jamet@intel.com, YehezkelShB@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: thunderbolt: Add comment clarifying
 prtcstns flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622163022.53298-1-mika.westerberg@linux.intel.com>
References: <20200622163022.53298-1-mika.westerberg@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:36:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Mon, 22 Jun 2020 19:30:22 +0300

> ThunderboltIP protocol currently has two flags from which we only
> support and set match frags ID. The first flag is reserved for full E2E
> flow control. Add a comment that clarifies them.
> 
> Suggested-by: Yehezkel Bernat <yehezkelshb@gmail.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks.
