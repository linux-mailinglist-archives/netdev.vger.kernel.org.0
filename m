Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E517DD989E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390753AbfJPRmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:42:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfJPRmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:42:31 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FB641423879C;
        Wed, 16 Oct 2019 10:42:30 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:42:27 -0400 (EDT)
Message-Id: <20191016.134227.1267823632300989943.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        mahesh@bandewar.net
Subject: Re: [PATCH net] Revert "blackhole_netdev: fix syzkaller reported
 issue"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016070438.156372-1-maheshb@google.com>
References: <20191016070438.156372-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:42:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Wed, 16 Oct 2019 00:04:38 -0700

> This reverts commit b0818f80c8c1bc215bba276bd61c216014fab23b.
> 
> Started seeing weird behavior after this patch especially in
> the IPv6 code path. Haven't root caused it, but since this was
> applied to net branch, taking a precautionary measure to revert
> it and look / analyze those failures
> 
> Revert this now and I'll send a better fix after analysing / fixing
> the weirdness observed.
> 
> CC: Eric Dumazet <edumazet@google.com>
> CC: Wei Wang <weiwan@google.com>
> CC: David S. Miller <davem@davemloft.net>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Ok, applied.
