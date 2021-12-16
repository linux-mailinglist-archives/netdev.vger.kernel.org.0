Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B234780CE
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 00:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhLPXna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 18:43:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54490 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhLPXn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 18:43:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98DADB8261B;
        Thu, 16 Dec 2021 23:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2179CC36AE2;
        Thu, 16 Dec 2021 23:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639698206;
        bh=2TTjo7fVWWn1YFCwt4xaPzq9NafIyUjKp5x5kKoqI5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qAz1cWM2frebuTegNT+pDYr9ChV4EBLmxPDRO4zPnT7Fyq8+RCPwpSRc+aYtFBrfr
         n9QR6cxV4f3CoK/NImfMguGCZ6L+mWipWMcz1/r1gkpK4griBppCuoe37MjpR8LR7L
         Pimo7U5f9Y7NA6j4RcMUzp86cTkRc1iD+23GsOmf0lvoRlNyQqkqhDzv2qxmcDDEbn
         16+IELvUgJerpsxfstBxp/la++QERcPlejMhXLx2q09FrTc8C+G71f4BJm1Gs6MSAu
         JZzcHlwvdvRHfLgByJaXVHX0IW3XQX0EevIWKNO+P6EDiqywJLDlZ5PRV4aBIRleaI
         ioqzvhBImB1YQ==
Date:   Thu, 16 Dec 2021 15:43:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [GIT PULL] Networking for 5.16-rc6
Message-ID: <20211216154324.5adcd94d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
References: <20211216213207.839017-1-kuba@kernel.org>
        <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 15:14:27 -0800 Linus Torvalds wrote:
> On Thu, Dec 16, 2021 at 1:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Relatively large batches of fixes from BPF and the WiFi stack,
> > calm in general networking.  
> 
> Hmm. I get a very different diffstat, and also a different shortlog
> than the one you quote.
> 
> I do get the top commit you claim:
> 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc6
> >
> > for you to fetch changes up to 0c3e2474605581375d808bb3b9ce0927ed3eef70:
> >
> >   Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-12-16 13:06:49 -0800)  
> 
> But your shortlog doesn't contain
> [...]
> and that seems to be the missing diffstat contents also.
> 
> It looks like your pull request was done without that last merge, even
> though you do mention it as being the top of tree.

But you are able to get the bpf patches, from the tag, right?

> I've pulled this, because that last merge looks fine and intentional,
> but I'd like you to double-check your workflow to see what happened to
> give a stale diffstat and shortlog...

Very strange, I didn't fix it up, redo or anything, push the tree, 
tag, push the tag, git request-pull >> email. And request-pull did 
not complain about anything.

I will double check all the outputs next time, really not sure how this
happened..

While I have you - I see that you drop my SoB at the end of the merge
message, usually. Should I not put it there?  I put it there because
of something I read in Documentation/process/...
