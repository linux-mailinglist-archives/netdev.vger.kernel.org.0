Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EED220DFF6
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgF2UlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbgF2TOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAB5C08C5F9
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:42:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 627DE129CF863;
        Sun, 28 Jun 2020 21:42:19 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:42:18 -0700 (PDT)
Message-Id: <20200628.214218.1545115469096968495.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] llc: make sure applications use ARPHRD_ETHER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627203150.1178776-1-edumazet@google.com>
References: <20200627203150.1178776-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:42:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 27 Jun 2020 13:31:50 -0700

> syzbot was to trigger a bug by tricking AF_LLC with
> non sensible addr->sllc_arphrd
> 
> It seems clear LLC requires an Ethernet device.
> 
> Back in commit abf9d537fea2 ("llc: add support for SO_BINDTODEVICE")
> Octavian Purdila added possibility for application to use a zero
> value for sllc_arphrd, convert it to ARPHRD_ETHER to not cause
> regressions on existing applications.
 ...
> Fixes: abf9d537fea2 ("llc: add support for SO_BINDTODEVICE")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
