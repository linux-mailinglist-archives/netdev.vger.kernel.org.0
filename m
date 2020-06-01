Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2F1EB0C5
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgFAVNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:13:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:53576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgFAVNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:13:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AEC2EABC7;
        Mon,  1 Jun 2020 21:13:10 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A6B4F60343; Mon,  1 Jun 2020 23:13:07 +0200 (CEST)
Date:   Mon, 1 Jun 2020 23:13:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of
 cycle
Message-ID: <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz>
References: <20200601062946.160954-1-Jason@zx2c4.com>
 <20200601.110044.945252928135960732.davem@davemloft.net>
 <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 01:33:46PM -0600, Jason A. Donenfeld wrote:
> Hi Dave,
> 
> On Mon, Jun 1, 2020 at 12:00 PM David Miller <davem@davemloft.net> wrote:
> > This is going to make nearly every -stable backport not apply cleanly,
> > which is a severe burdon for everyone having to maintain stable trees.
> 
> This possibility had occurred to me too, which is why I mentioned the
> project being sufficiently young that this can work out. It's not
> actually in any LTS yet, which means at the worst, this will apply
> temporarily for 5.6,

It's not only about stable. The code has been backported e.g. into SLE15
SP2 and openSUSE Leap 15.2 kernels which which are deep in RC phase so
that we would face the choice between backporting this huge patch in
a maintenance update and keeping to stumble over it in most of future
backports (for years). Neither is very appealing (to put it mildly).
I have no idea how many other distributions would be affected or for how
long but I doubt we are the only ones.

Of course, if this really brought some value, it would be easier to live
with it. But you want to reshuffle the code just because checkpatch will
no longer complain. There are places where your changes obviously
improve readability of the code - but it's a minority.

Moreover, reading the message of commit bdc48fa11e46
("checkpatch/coding-style: deprecate 80-column warning"), I don't think
the intent was for people to start rewriting existing code to use 100
columns whereever possible. Right in the first sentence, it clearly says
"staying withing 80 columns is certainly still _preferred_". And then
there is also the concern "to avoid unnecessary whitespace changes in
files".

> and only then on the off chance that a patch is near code that this
> touches.

The patch has ~4400 lines, IIRC the whole wireguard submission had
something like 8000 or 9000. I'm afraid the chance is actually much
bigger than you claim.

> Alternatively, it'd be easy enough to add a Fixes: to this, just in
> case.

I don't understand what you meant by this sentence but I hope you didn't
mean to suggest that this patch should go into stable.

Michal
