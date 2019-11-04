Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D861EE8D9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:37:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbfKDThT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:37:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B102151D725E;
        Mon,  4 Nov 2019 11:37:18 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:37:17 -0800 (PST)
Message-Id: <20191104.113717.2295250160418396664.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, tnagel@google.com
Subject: Re: [PATCH net] dccp: do not leak jiffies on the wire
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104155755.18916-1-edumazet@google.com>
References: <20191104155755.18916-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:37:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  4 Nov 2019 07:57:55 -0800

> For some reason I missed the case of DCCP passive
> flows in my previous patch.
> 
> Fixes: a904a0693c18 ("inet: stop leaking jiffies on the wire")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Thiemo Nagel <tnagel@google.com>

Applied and queued up for -stable, thanks.
