Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25E1608A1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgBQDWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:22:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:22:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AEAC155C312D;
        Sun, 16 Feb 2020 19:22:10 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:22:09 -0800 (PST)
Message-Id: <20200216.192209.539596212241074939.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net 0/4] wireguard fixes for 5.6-rc2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214225723.63646-1-Jason@zx2c4.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:22:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 14 Feb 2020 23:57:19 +0100

> Here are four fixes for wireguard collected since rc1:
> 
> 1) Some small cleanups to the test suite to help massively parallel
>    builds.
> 
> 2) A change in how we reset our load calculation to avoid a more
>    expensive comparison, suggested by Matt Dunwoodie.
> 
> 3) I've been loading more and more of wireguard's surface into
>    syzkaller, trying to get our coverage as complete as possible,
>    leading in this case to a fix for mtu=0 devices.
> 
> 4) A removal of superfluous code, pointed out by Eric Dumazet.
> 
> v2 fixes a logical problem in the patch for (3) pointed out by Eric Dumazet. v3
> replaces some non-obvious bitmath in (3) with a more obvious expression, and
> adds patch (4).

Series applied, thanks.
