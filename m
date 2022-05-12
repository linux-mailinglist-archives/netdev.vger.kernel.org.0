Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFF524254
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 04:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbiELCIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbiELCIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 22:08:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC476D38C;
        Wed, 11 May 2022 19:07:58 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24C27abX015835
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 22:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652321259; bh=N0RrHZICQeD+jMKffmiVOPCX1VOHVXkmF2unBxL2MJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ICSnAYgUceKKXsBKoRVPVEIQKsCW0KTrDhONUN31qeHKplZYIzPxqs8r+P+6YnX6x
         abGDraN6I6t1+6cpTxV+pX/G3fEwMzr4yTmbUKBr0T0taRo1DJimXKf5Gg79Ohpl3X
         JpMubQ0WlA6eF0LKDzQNgnOqe3puzHfHVqCXvtBW3+YG7uyHfHolbIovUtrn+rdOwy
         JRr9Qa2HfVEUQ+aQ+EAp9AyaK7SPZhtHVsCbScLn15PNFhEYvE1xXltNl0sfjvJCFF
         uoPI6+2MP/NnYrl1D9pLkyRIkK7Nn5W9/l5pldeyIP7y4GsgumtbbEERrnA1b/cRhh
         9OGVUNr2s3ldg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0BBB915C3F2A; Wed, 11 May 2022 22:07:36 -0400 (EDT)
Date:   Wed, 11 May 2022 22:07:36 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <Ynxr6JNczWFTwxVw@mit.edu>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
 <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
 <20220511125140.ormw47yluv4btiey@meerkat.local>
 <87a6bo89w4.fsf@mpe.ellerman.id.au>
 <20220511163116.fpw2lvrkjbxmiesz@meerkat.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511163116.fpw2lvrkjbxmiesz@meerkat.local>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 12:31:16PM -0400, Konstantin Ryabitsev wrote:
> > But my mailer, editor and terminal don't know what to do with a Message-Id.
> > 
> > Whereas they can all open an https link.
> > 
> > Making people paste message ids into lore to see the original submission
> > is not a win. People make enough fun of us already for still using email
> > to submit patches, let's not make their job any easier :)
> 
> Okay, I'm fine with using a dedicated trailer for this purpose, perhaps an
> "Archived-At"? That's a real header that was proposed by IETF for similar
> purposes. E.g.:
> 
>     Archived-at: https://lore.kernel.org/r/CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com
>

I'd suggest is "Patch-Link".  Then we can also have "Bug-Link:",
"Test-Link:", etc.

"Patch-Link" is a tad bit shorter "Archived-at", and ultimately, it's
not actually not the patch which is being archived.  It's the fact
that it's a pointer to the patch review which is of most interest.

					- Ted
