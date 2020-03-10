Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53CA180C21
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgCJXOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:14:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgCJXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:14:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67EF514CD0E99;
        Tue, 10 Mar 2020 16:14:40 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:14:39 -0700 (PDT)
Message-Id: <20200310.161439.2227645091198630571.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: fix macro MIRROR_PORT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310182050.10170-1-dqfext@gmail.com>
References: <20200310182050.10170-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:14:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Wed, 11 Mar 2020 02:20:50 +0800

> The inner pair of parentheses should be around the variable x
> Fixes: 37feab6076aa ("net: dsa: mt7530: add support for port mirroring")
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Two things:

1) In the Subject line always indicate the target tree for your changes.
   This case would be net-next since that is the only tree where the
   Fixes: tag commit exists, thus "Subject: [PATCH net-next] ..."

2) Always group the various tags together into a contiguous series of
   lines of text, starting the the Fixes tag.  Make sure there is an
   empty line between the commit message description text, and the tags.

I fixes it up for you this time, but next time I will not and push back
for you to fix it up yourself.

Applied to net-next, thank you.

   
