Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD3522767
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbiEJXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbiEJXMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7C527C5;
        Tue, 10 May 2022 16:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4085961902;
        Tue, 10 May 2022 23:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20430C385CE;
        Tue, 10 May 2022 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652224334;
        bh=3xtgrnNf+mLrclHKUYUOhlm/8Xu2QGyjyfrnDwPEHJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOJoJTYCPkAeHaWwcjtqgY0OX6vUf+2XHG2nYIVBgUZqTg0Dnk9gZIGUxhqzJxFMo
         0EE0L0jL1tZgj6i86ceoADGL04HCmoPk90df8w1S761Z2RiEhe/oXnucGPNWcJVtgW
         6aswNu1XP76OeScFduW8O/edeDbI1Ae7sJKXTIUYVAFjrUAAsv/aEXekP985Cb6niM
         nSMgeyeAfOglyVkbje4r+vX86BYJ6Mmnt3fTD0xO7lHnTP1ZIV2V/A3bQmNS5878rt
         3IBpOfQrVxweTVVA3+So5uKYLNztkdouEuhugKizkfUBd2aFfpYhl5H5rQyiGvDjU8
         mO9YFAfQjXQqg==
Date:   Tue, 10 May 2022 16:12:12 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:23:11AM -0700, Linus Torvalds wrote:
> On Tue, May 10, 2022 at 5:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > A last minute fixup of the transitional ID numbers.
> > Important to get these right - if users start to depend on the
> > wrong ones they are very hard to fix.
> 
> Hmm. I've pulled this, but those numbers aren't exactly "new".
> 
> They've been that way since 5.14, so what makes you think people
> haven't already started depending on them?
> 
> And - once again - I want to complain about the "Link:" in that commit.
> 
> It points to a completely useless patch submission. It doesn't point
> to anything useful at all.
> 
> I think it's a disease that likely comes from "b4", and people decided
> that "hey, I can use the -l parameter to add that Link: field", and it
> looks better that way.
> 
> And then they add it all the time, whether it makes any sense or not.
> 
> I've mainly noticed it with the -tip tree, but maybe that's just
> because I've happened to look at it.
> 
> I really hate those worthless links that basically add zero actual
> information to the commit.
> 
> The "Link" field is for _useful_ links. Not "let's add a link just
> because we can".

For what it's worth, as someone who is frequently tracking down and
reporting issues, a link to the mailing list post in the commit message
makes it much easier to get these reports into the right hands, as the
original posting is going to have all relevant parties in one location
and it will usually have all the context necessary to triage the
problem. While lore.kernel.org has made it much easier to find patch
postings with the "all" list and the search syntax that public-inbox
offers, it is simpler to just import the thread with 'b4 mbox' using the
link directly.

However, I do agree that it should be easier for people to tell whether
or not the link is additional context or information or just a link to
the original patch posting on the mailing list. Perhaps there should be
a new tag like "Archived-at:", "Posted-at:", or "Submitted-at:" that
makes this clearer?

Cheers,
Nathan
