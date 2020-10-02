Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C6281675
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbgJBPWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:22:43 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:42353 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:22:43 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 092FMJhG003890;
        Fri, 2 Oct 2020 17:22:19 +0200
Date:   Fri, 2 Oct 2020 17:22:19 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <20201002152219.GB3875@1wt.eu>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> and activity") broke compilation and was temporarily fixed by Linus in
> 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> gcc plugin") by entirely moving net_rand_state out of the things handled
> by the latent_entropy GCC plugin.
> 
> From what I understand when reading the plugin code, using the
> __latent_entropy attribute on a declaration was the wrong part and
> simply keeping the __latent_entropy attribute on the variable definition
> was the correct fix.

Ah thank you, this is what I tried to figure and failed to! Spender
mentioned that a one-liner was all that was needed to fix this but
never responded to my request asking about it.

Willy
