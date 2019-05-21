Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40365258CC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfEUUXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:23:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfEUUXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:23:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9513C14C8371C;
        Tue, 21 May 2019 13:23:31 -0700 (PDT)
Date:   Tue, 21 May 2019 13:23:31 -0700 (PDT)
Message-Id: <20190521.132331.1475679105999327536.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Revert "cxgb4: Remove
 SGE_HOST_PAGE_SIZE dependency on page size"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558410122-29341-1-git-send-email-vishal@chelsio.com>
References: <1558410122-29341-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:23:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Tue, 21 May 2019 09:12:02 +0530

> This reverts commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1
> SGE's BAR2 Doorbell/GTS Page Size is now interpreted correctly in the
> firmware itself by using actual host page size. Hence previous commit
> needs to be reverted.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Really confusing.

First of all, I see a lot of cxgb4 patch submissions targetting net-next that
are really legitimate bug fixes.

Are you only targetting net-next to be "on the safe side" because you are
unsure of the 'net' rules?  Please don't do that.  If it's a bug fix, send
it to 'net' as appropriate.

Second, so what happens to people running older firmware?  Have you made a
completely incompatible change to the firmware behavior?  If so, you have
to version check the firmware and use the correct interpretation based upon
how the firmware verion interprets things.

Thanks.
