Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5531DCC737
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfJEBcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:32:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:32:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A834114F363A3;
        Fri,  4 Oct 2019 18:32:40 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:32:40 -0700 (PDT)
Message-Id: <20191004.183240.244874742596847425.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] nfc: fix memory leak in llcp_sock_bind()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004180834.108250-1-edumazet@google.com>
References: <20191004180834.108250-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:32:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  4 Oct 2019 11:08:34 -0700

> sysbot reported a memory leak after a bind() has failed.
> 
> While we are at it, abort the operation if kmemdup() has failed.
> 
> BUG: memory leak
 ...
> Fixes: 30cc4587659e ("NFC: Move LLCP code to the NFC top level diirectory")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
