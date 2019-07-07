Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938936176B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 22:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfGGUTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 16:19:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfGGUTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 16:19:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C3001527D81B;
        Sun,  7 Jul 2019 13:19:13 -0700 (PDT)
Date:   Sun, 07 Jul 2019 13:19:13 -0700 (PDT)
Message-Id: <20190707.131913.135693864850820307.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] tipc: use rcu dereference functions properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190706.151544.2015985674047795584.davem@davemloft.net>
References: <CADvbK_emyKTg8=ye8n2ZTBx0QFK9gPL02aVDfn44DuyUTP-ofw@mail.gmail.com>
        <CADvbK_eDnUMSaoT65hco2PF5-f1PO=CKBeMPz3sTRZvg5qKGVA@mail.gmail.com>
        <20190706.151544.2015985674047795584.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 13:19:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 06 Jul 2019 15:15:44 -0700 (PDT)

> From: Xin Long <lucien.xin@gmail.com>
> Date: Sat, 6 Jul 2019 14:48:48 +0800
> 
>> Hi, David, I saw this patch in "Changes Requested".
> 
> I just put it back to Under Review, thanks.

Applied to net-next, thank you.
