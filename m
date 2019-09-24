Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5EDBC8ED
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632739AbfIXNaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:30:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504934AbfIXNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 09:30:14 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97DB915248DA9;
        Tue, 24 Sep 2019 06:30:12 -0700 (PDT)
Date:   Tue, 24 Sep 2019 15:30:08 +0200 (CEST)
Message-Id: <20190924.153008.1663682877890370513.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9oqRg9L+wdhOra=UO3ypuy9N82DHVrbDJDgLpxSmS-rHQ@mail.gmail.com>
References: <20190924073615.31704-1-Jason@zx2c4.com>
        <20190924.145257.2013712373872209531.davem@davemloft.net>
        <CAHmME9oqRg9L+wdhOra=UO3ypuy9N82DHVrbDJDgLpxSmS-rHQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 06:30:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 24 Sep 2019 14:55:04 +0200

> On Tue, Sep 24, 2019 at 2:53 PM David Miller <davem@davemloft.net> wrote:
>> Please make such test cases integratabe into the selftests area for networking
>> and submit it along with this fix.
> 
> That link is for a WireGuard test-case. When we get that upstream,
> those will all live in selftests/ all the same as you'd like. For now,
> it's running for every kernel on https://build.wireguard.com/ which in
> turn runs for every new commit.

I'm asking you to make a non-wireguard test that triggers the problem.

Or would you like a situation you're interested in to break from time
to time.

Jason, please don't be difficult about this and write a proper test
case just like I would ask anyone else fixing bugs like this to write.

Thank you.
