Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADC9284416
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgJFC3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:29:51 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:42778 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgJFC3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 22:29:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0962S93K005537;
        Tue, 6 Oct 2020 04:28:09 +0200
Date:   Tue, 6 Oct 2020 04:28:09 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Kees Cook <keescook@chromium.org>
Cc:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <20201006022808.GA5531@1wt.eu>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
 <202010051910.BC7E9F4@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010051910.BC7E9F4@keescook>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Mon, Oct 05, 2020 at 07:12:29PM -0700, Kees Cook wrote:
> On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> > From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > 
> > Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> > and activity") broke compilation and was temporarily fixed by Linus in
> > 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> > gcc plugin") by entirely moving net_rand_state out of the things handled
> > by the latent_entropy GCC plugin.
> > 
> > From what I understand when reading the plugin code, using the
> > __latent_entropy attribute on a declaration was the wrong part and
> > simply keeping the __latent_entropy attribute on the variable definition
> > was the correct fix.
> > 
> > Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Willy Tarreau <w@1wt.eu>
> > Cc: Emese Revfy <re.emese@gmail.com>
> > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Yes, that looks correct. Thank you!
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
> via my gcc plugin tree if no one else takes it. :)

It was already merged as commit 09a6b0bc3be79 and queued for -stable.

Cheers,
Willy
