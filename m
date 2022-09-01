Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F55A9304
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiIAJUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiIAJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:20:15 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B292F00F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:20:13 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1662024011; bh=jE5aYXO5o+Pv7NuDIL7qCOKMA3u6a/q/Wk8R4ae8zoQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WOmlZIk6jD7HCE5cf46aavc8CYHK5cF9AP2cbBNU5YP+d5fR+tsqH2FNhKPHajXD3
         T7QXhiSARVEubXC7AD30sK3SJA2v7NjcC0PYS476Mi3Nfd2dzK52n6AmIubepHbpLX
         9ypmJ6D1cA7RL9ZXqOducikB+RHPTukQCnFcdXKcByXlWWuDgu/hQ5o4c2ypwmiQ9T
         04R+MGCJWq3N4Kz8JQ6WVI0yHcZv0QhAZncHkGt1s898hFAUIxsLPcwKXVX2UnHsJV
         yDHSm/NtNhX0NfoLyFRKZQ2rR8fKweEh3aRQZ+AO5bsd9Wk/RyMzo12duYZhVKhx4v
         8JFMIOWL4tOxQ==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        cake@lists.bufferbloat.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
In-Reply-To: <20220831200724.45cb3b99@kernel.org>
References: <20220831092103.442868-1-toke@toke.dk>
 <166198321517.20200.12054704879498725145.git-patchwork-notify@kernel.org>
 <87wnao2ha3.fsf@toke.dk> <20220831200724.45cb3b99@kernel.org>
Date:   Thu, 01 Sep 2022 11:20:10 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fshb30z9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 01 Sep 2022 00:13:24 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ah, crossed streams (just sent v2[0]).
>
> Sorry about that, traveling knocked out my sense of time and I kept
> thinking it's Thursday, and the discussion happened yesterday :S

Haha, OK, no worries :)

>> Hmm, okay, so as noted in the changelog to v2, just this patch will
>> break htb+cake (because htb will now skip htb_activate()); do you prefer
>> that I send a follow-up to fix HTB in this mode, or to revert this and
>> apply the fix to sfb in v2 instead?
>
> Reverted. Let's review v2 as if v1 was not applied.

SGTM!

-Toke
