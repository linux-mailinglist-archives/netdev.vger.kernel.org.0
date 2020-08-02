Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B341A2354D5
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 03:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgHBBqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 21:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgHBBqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 21:46:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA3CC06174A;
        Sat,  1 Aug 2020 18:46:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F78212880998;
        Sat,  1 Aug 2020 18:29:17 -0700 (PDT)
Date:   Sat, 01 Aug 2020 18:45:59 -0700 (PDT)
Message-Id: <20200801.184559.1165786746889167943.davem@davemloft.net>
To:     torvalds@linux-foundation.org
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHk-=whiwBCM-a=k8bd4_umR2Od6gf7d8Do3ryGAaFneNRGFng@mail.gmail.com>
References: <20200801.143631.1794965770015082550.davem@davemloft.net>
        <CAHk-=whiwBCM-a=k8bd4_umR2Od6gf7d8Do3ryGAaFneNRGFng@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 18:29:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Aug 2020 16:45:49 -0700

> On Sat, Aug 1, 2020 at 2:36 PM David Miller <davem@davemloft.net> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> 
> How is this wrt an rc8 or a final?

Nothing scary in there, I think you can safely do a -final with those
networking changes.

> On a very much related note, I really wish you didn't send the
> networking fixes the day before a release is scheduled.
> 
> If it's really quiet., send them on (say) Wed/Thu. And then on
> Saturday, send a note saying "no, important stuff", hold on. Or say
> "nothing new".
> 
> Because right now the "last-minute network pull request" has become a
> pattern, and I have a very hard time judging whether I should delay a
> release for it.

Sorry about that, just the way things work during the week I can't
catch my breath until late Friday night or Saturday usually to review
what I have and send a pull request to you.

I'll shoot for more mid-week pulls in the future.
