Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69533673C0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245558AbhDUTut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:50:49 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45265 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235545AbhDUTus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 15:50:48 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13LJnp00015873
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 15:49:52 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8A16C15C3B0D; Wed, 21 Apr 2021 15:49:51 -0400 (EDT)
Date:   Wed, 21 Apr 2021 15:49:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Weikeng Chen <w.k@berkeley.edu>
Cc:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, dwysocha@redhat.com,
        gregkh@linuxfoundation.org, kuba@kernel.org, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, pakki001@umn.edu,
        trond.myklebust@hammerspace.com
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YICB3wiptvvtTeA5@mit.edu>
References: <CAHr+ZK-ayy2vku9ovuSB4egtOxrPEKxCdVQN3nFqMK07+K5_8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHr+ZK-ayy2vku9ovuSB4egtOxrPEKxCdVQN3nFqMK07+K5_8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:35:00AM -0700, Weikeng Chen wrote:
> 
> [1] I think the UMN IRB makes an incorrect assertion that the
> research is not human research, and that starts the entire problem
> and probably continues to be.

I think what we need to somehow establish is some norms about how
academic researchers engage with Open Source communities in general,
and the Linux Kernel community in particular.

To be fair, I don't know if Aditya Pakki was deliberately trying to
get nonsense patches in just to demonstrate that there is less review
for trivial patches, or whether he was creating a completely
incompetent, non-state-of-the-art static code analyzer, and was too
incompetent to hand check the patch to realize the results were
nonsense.

The big problem here is the lack of disclosure that the patch was
computer generated, using a new tool that might not be giving accurate
results, and that instead of diclosing this fact, submitting it as a
patch to be reviewed.  Again, I don't know whether or not this was
submitted in bad faith --- but the point is, Aditya belongs to
research group which has previously submitted patches in bad faith,
without disclosure, and his supervising professor and UMN's IRB
doesn't see any problem with it.  So it's a bit rich when Aditya seems
to be whining that we're not giving him the benefit of the doubt and
not assuming that his patches might have been submitted in good faith
--- when the only *responsible* thing to do is to assume that it is
sent in bad faith, given the past behaviour of his research group, and
the apparently lack of any kind of institutional controls at UMN
regarding this sort of thing.

Of course, UMN researchers could just start using fake e-mail
addresses, or start using personal gmail or yahoo or hotmail
addresses.  (Hopefully at that point the ethics review boards at UMN
will be clueful enough to realize that maybe, just maybe, UMN
researchers have stepped over a line.)

However, your larger point is a fair one.  We do need to do a better
job of reviewing patches, even "trivial" ones, and if that means that
we might need to be a bit more skeptical dealing with newbies who are
trying to get started, that's a price we will need to pay.  Speaking
for myself, I've always tried to be highly skeptical about patches and
give them a thorough review.  And I don't need to assume malice from
nation-state intelligence agencies; we're all human, and we all make
mistakes.

Cheers,

					- Ted
