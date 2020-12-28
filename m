Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9342D2E6B40
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgL1XAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 18:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgL1XAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:00:37 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72772C0613D6;
        Mon, 28 Dec 2020 14:54:44 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 93CCF4CE93100;
        Mon, 28 Dec 2020 14:54:01 -0800 (PST)
Date:   Mon, 28 Dec 2020 14:54:01 -0800 (PST)
Message-Id: <20201228.145401.2067471886598959966.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org,
        syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com,
        nogahf@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH -net] net: sched: prevent invalid Scell_log shift count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201225062344.32566-1-rdunlap@infradead.org>
References: <20201225062344.32566-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 14:54:01 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Thu, 24 Dec 2020 22:23:44 -0800

> Check Scell_log shift size in red_check_params() and modify all callers
> of red_check_params() to pass Scell_log.
> 
> This prevents a shift out-of-bounds as detected by UBSAN:
>   UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
>   shift exponent 72 is too large for 32-bit type 'int'
> 
> Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
