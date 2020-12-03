Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F4B2CE183
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgLCWVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCWVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 17:21:38 -0500
Date:   Thu, 3 Dec 2020 14:20:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607034057;
        bh=sJTZOuaQLWgAkLjU/1D2hpQxVLj/LjujUTWRVPbXgoc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=uMtG2O4kX2o0F+/hdjxy+ldteyemQOl147uqhmiiqZTAfR01B+ZyV1zKVHvx8Glc+
         O9MYm4yMKlKBYX/9OiEm8AaF3QMGohDq73Jok3UmCj8fJuRJ9MZucvU6xQQtYp3dHA
         nM0Z/pYBl7LxiCalLTBPKscMysyYtCAxDH06zDwzeVtS07hqNm/XLui3XjH/5ibqiT
         9RoVqBjH8oVd7dblCAq16ybGsCy1/ynL67hxFsD7G7NS/2EMaIV7WVjWd5B71s2T11
         dmYFXYhNiCf5ksZbsn4w29xaLGn3Tpc+gGnj2BItZRjU8Bolc8zVFesJLWI6koJ1qV
         q5q75pvq5R9BQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Networking for 5.10-rc7
Message-ID: <20201203142056.5bf81035@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAHk-=wgBDP8WwpO-yyv0fvdc0w9qoQwugywvwsARp4HMfUkD1g@mail.gmail.com>
References: <20201203204459.3963776-1-kuba@kernel.org>
        <CAHk-=wgBDP8WwpO-yyv0fvdc0w9qoQwugywvwsARp4HMfUkD1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 13:18:13 -0800 Linus Torvalds wrote:
> On Thu, Dec 3, 2020 at 12:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Networking fixes for 5.10-rc7, including fixes from bpf, netfilter,
> > wireless drivers, wireless mesh and can.  
> 
> Thanks, pulled.
> 
> And btw - maybe I've already talked about this, but since next week is
> (hopefully) going to be the last week of rc release: since the
> networking pulls tend to be some of the bigger ones, one thing I've
> asked David to do in the past is to (a) not send a big networking pull
> request right before the final release and (b) let me know whether
> there is anything worrisome going on in networking.
> 
> So if you send it on a Thursday (like this one), then that's all good
> - it's the "Oh, it's Sunday noon, I was planning on a final release in
> the afternoon, and I have a big networking fix pull request in my
> mailbox" that I'd prefer to not see.

Make sense.

I'm not anticipating that the last PR will be much smaller, given 
we get a constant stream of fixes for older releases and the review
coverage is pretty good so we can apply stuff with confidence.

Sounds like a comparable PR size will not be a major concern to you as
long as the PR comes in early on Thu and we are reporting any sign of
trouble. Sounds good!

> A heads up on the "Uhhuh - we have something bad going in the
> networking tree" kind of situation you can obviously send at any time.
> If there are known issues, I'll just make an rc8 - I prefer not to
> _have_ to, of course, but I'd always much rather be safe than release
> the final kernel just because I didn't know of some pending issue.

Will do!

> (And the reverse - just a note saying "everything looks fine, none of
> this is scary and there's nothing pending that looks at all worrisome
> either" - for the last rc pull is obviously also always appreciated,
> but generally I'll assume that unless something else is said, we're in
> good shape).

Ack, it's been smooth sailing so far in this release. 

No big scares, knock on wood.

This time around (other than the large-ish ibmvnic set which was in 
the works for a while) the PR was smaller, but I think that's only 
due to Turkey lethargy.

Thanks for this note, I was shy to ask about the endgame :)
