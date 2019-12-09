Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644C8117317
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLIRsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:48:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:48:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 007F9154370A5;
        Mon,  9 Dec 2019 09:48:11 -0800 (PST)
Date:   Mon, 09 Dec 2019 09:48:11 -0800 (PST)
Message-Id: <20191209.094811.683339172232787241.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] neighbour: remove neigh_cleanup() method
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191207202321.148251-1-edumazet@google.com>
References: <20191207202321.148251-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 09:48:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  7 Dec 2019 12:23:21 -0800

> neigh_cleanup() has not been used for seven years, and was a wrong design.
> 
> Messing with shared pointer in bond_neigh_init() without proper
> memory barriers would at least trigger syzbot complains eventually.
> 
> It is time to remove this stuff.
> 
> Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied to net-next.
