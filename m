Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9747233C2D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgG3Xbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730217AbgG3Xbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:31:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A6AC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:31:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D3F9126BEDB4;
        Thu, 30 Jul 2020 16:14:46 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:31:31 -0700 (PDT)
Message-Id: <20200730.163131.1957352945221220808.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, ch3332xr@gmail.com
Subject: Re: [Patch net] ipv6: fix memory leaks on IPV6_ADDRFORM path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200725224053.14752-1-xiyou.wangcong@gmail.com>
References: <20200725224053.14752-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:14:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 25 Jul 2020 15:40:53 -0700

> IPV6_ADDRFORM causes resource leaks when converting an IPv6 socket
> to IPv4, particularly struct ipv6_ac_socklist. Similar to
> struct ipv6_mc_socklist, we should just close it on this path.
> 
> This bug can be easily reproduced with the following C program:
 ...
> Reported-by: ch3332xr@gmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thank you.
