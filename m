Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F063FD5D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfD3QBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:01:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfD3QBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 12:01:19 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 988AF100047A8;
        Tue, 30 Apr 2019 09:01:18 -0700 (PDT)
Date:   Tue, 30 Apr 2019 12:01:17 -0400 (EDT)
Message-Id: <20190430.120117.1616322040923778364.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-04-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
References: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 09:01:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 30 Apr 2019 18:10:01 +0300

> here's one more pull request to net tree for 5.1, more info below.
> 
> Also note that this pull conflicts with net-next. And I want to emphasie
> that it's really net-next, so when you pull this to net tree it should
> go without conflicts. Stephen reported the conflict here:
> 
> https://lkml.kernel.org/r/20190429115338.5decb50b@canb.auug.org.au
> 
> In iwlwifi oddly commit 154d4899e411 adds the IS_ERR_OR_NULL() in
> wireless-drivers but commit c9af7528c331 removes the whole check in
> wireless-drivers-next. The fix is easy, just drop the whole check for
> mvmvif->dbgfs_dir in iwlwifi/mvm/debugfs-vif.c, it's unneeded anyway.
> 
> As usual, please let me know if you have any problems.

Pulled, thanks Kalle.

Thanks for the conflict resolution information, it is very helpful.

However, can you put it into the merge commit text next time as well?
I cut and pasted it in there when I pulled this stuff in.

Thanks!
