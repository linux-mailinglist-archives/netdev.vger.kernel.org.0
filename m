Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F92313799
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfEDFjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:39:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfEDFjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:39:32 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 386C114DA648D;
        Fri,  3 May 2019 22:39:28 -0700 (PDT)
Date:   Sat, 04 May 2019 01:39:24 -0400 (EDT)
Message-Id: <20190504.013924.1617847326346032679.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipmr_base: Do not reset index in mr_table_dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502221415.3542-1-dsahern@kernel.org>
References: <20190502221415.3542-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:39:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  2 May 2019 15:14:15 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> e is the counter used to save the location of a dump when an
> skb is filled. Once the walk of the table is complete, mr_table_dump
> needs to return without resetting that index to 0. Dump of a specific
> table is looping because of the reset because there is no way to
> indicate the walk of the table is done.
> 
> Move the reset to the caller so the dump of each table starts at 0,
> but the loop counter is maintained if a dump fills an skb.
> 
> Fixes: e1cedae1ba6b0 ("ipmr: Refactor mr_rtm_dumproute")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
