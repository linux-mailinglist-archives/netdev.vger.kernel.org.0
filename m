Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6B26E9F23
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjDTWiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjDTWiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:38:24 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C2B3C07;
        Thu, 20 Apr 2023 15:38:23 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682030301; bh=RROvBsZouizJZbT/+MfyL7hKGqy3iT9UJY9igD8NDzw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Iy9/XFF+Awcyj4f+sJGX2vESbkpe64jr7xETrPXZPVoyPLLIU+k8209adYxvP1lWz
         4oCCeZNArJikadqyTkQDg5nY94142ezE/m/b00OtLfvLCUowEet2ekMgBrDosfawuO
         zc0IEOtEiNA8WWahd/WC4P/BTJ0fk7uzYVWc7GQwkfLExz0zcHYWsilKBGC5A3qMFO
         hK56A9351YyjsCqFJ02KXMr8TAxbNWJE6kx85w5er2ue+fzTl14ED+maskqNLbplqR
         kYvvK7yOQle66mQWcluKK9mmhMbhgtO5W0VwUP5Zl55uVEJrYxVgttK4m08RqErBPt
         em5SaA/mmLpdA==
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: One-off regression fix for 6.3 [was: Re: [PATCH] wifi: ath9k:
 Don't mark channelmap stack variable read-only in
 ath9k_mci_update_wlan_channels()]
In-Reply-To: <CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com>
References: <20230413214118.153781-1-toke@toke.dk> <87zg72s1jz.fsf@toke.dk>
 <CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com>
Date:   Fri, 21 Apr 2023 00:38:19 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ttxarxgk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Apr 20, 2023 at 2:09=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@toke.dk> wrote:
>>
>> So, with a bit of prodding from Thorsten, I'm writing this to ask you if
>> you'd be willing to pull this patch directly from the mailing list as a
>> one-off? It's a fairly small patch, and since it's a (partial) revert
>> the risk of it being the cause of new regressions should be fairly
>> small.
>
> Sure. I'm always open to direct fixes when there is no controversy
> about the fix. No problem. I still happily deal with individual
> patches.

Awesome, thanks!

> And yes, I do consider "regression in an earlier release" to be a
> regression that needs fixing.
>
> There's obviously a time limit: if that "regression in an earlier
> release" was a year or more ago, and just took forever for people to
> notice, and it had semantic changes that now mean that fixing the
> regression could cause a _new_ regression, then that can cause me to
> go "Oh, now the new semantics are what we have to live with".
>
> But something like this, where the regression was in the previous
> release and it's just a clear fix with no semantic subtlety, I
> consider to be just a regular regression that should be expedited -
> partly to make it into stable, and partly to avoid having to put the
> fix into _another_ stable kernel..

OK, duly noted; thank you for clarifying :)

-Toke
