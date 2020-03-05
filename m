Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F101C17AF2B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCETr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:47:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCETr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 14:47:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32B9815BE447D;
        Thu,  5 Mar 2020 11:47:28 -0800 (PST)
Date:   Thu, 05 Mar 2020 11:47:25 -0800 (PST)
Message-Id: <20200305.114725.1265986516045554303.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, subashab@codeaurora.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: rmnet: several code cleanup for
 rmnet module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304232415.12205-1-ap420073@gmail.com>
References: <20200304232415.12205-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 11:47:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed,  4 Mar 2020 23:24:15 +0000

> This patchset is to cleanup rmnet module code.
> 
> 1. The first patch is to add module alias
> rmnet module can not be loaded automatically because there is no
> alias name.
> 
> 2. The second patch is to add extack error message code.
> When rmnet netlink command fails, it doesn't print any error message.
> So, users couldn't know the exact reason.
> In order to tell the exact reason to the user, the extack error message
> is used in this patch.
> 
> 3. The third patch is to use GFP_KERNEL instead of GFP_ATOMIC.
> In the sleepable context, GFP_KERNEL can be used.
> So, in this patch, GFP_KERNEL is used instead of GFP_ATOMIC.
> 
> Change log:
>  - v1->v2: change error message in the second patch.

Looks good, series applied, thanks.
