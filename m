Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF934F9A48
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLULp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:11:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfKLULp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:11:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B358154D23B7;
        Tue, 12 Nov 2019 12:11:44 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:11:41 -0800 (PST)
Message-Id: <20191112.121141.248672684728978335.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     vladbu@mellanox.com, netdev@vger.kernel.org, ivecera@redhat.com
Subject: Re: [PATCH net-next] net/sched: actions: remove unused 'order'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
References: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:11:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 12 Nov 2019 15:33:11 +0100

> after commit 4097e9d250fb ("net: sched: don't use tc_action->order during
> action dump"), 'act->order' is initialized but then it's no more read, so
> we can just remove this member of struct tc_action.
> 
> CC: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thanks Davide.
