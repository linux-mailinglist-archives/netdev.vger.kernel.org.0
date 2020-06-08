Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B931F1364
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 09:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFHHQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 03:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgFHHQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 03:16:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D2CC08C5C3;
        Mon,  8 Jun 2020 00:16:15 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jiC0f-00HFSS-Ay; Mon, 08 Jun 2020 09:15:53 +0200
Message-ID: <8242a0fbe56f44f81952ee3c009d646d79b4e366.camel@sipsolutions.net>
Subject: Re: Hang on wireless removal..
From:   Johannes Berg <johannes@sipsolutions.net>
To:     sedat.dilek@gmail.com
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 08 Jun 2020 09:15:37 +0200
In-Reply-To: <CA+icZUVLb9Kq88yfB3kZCjDczmSaUE1vvRygPjGH6Ps+0PhDMQ@mail.gmail.com> (sfid-20200608_091452_022900_7DEA1358)
References: <CAHk-=wj0QUaYcLHKG=_fw65NqhGbqvnU958SkHak9mg9qNwR+A@mail.gmail.com>
         <5DD82C75-5868-4F2D-B90F-F6205CA85C66@sipsolutions.net>
         <CA+icZUVLb9Kq88yfB3kZCjDczmSaUE1vvRygPjGH6Ps+0PhDMQ@mail.gmail.com>
         (sfid-20200608_091452_022900_7DEA1358)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-08 at 09:14 +0200, Sedat Dilek wrote:
> On Sat, Jun 6, 2020 at 9:56 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > Hi, sorry for the top post, on my phone.
> > 
> > Yes, your analysis is spot on I think. I've got a fix for this in my
> > jberg/mac80211 tree, there's a deadlock with a work struct and the
> > rtnl.
> > 
> > Sorry about that. My testing should've caught it, but that exact
> > scenario didn't happen, and lockdep for disabled due to some
> > unrelated issues at early boot,so this didn't show up... (I also
> > sent fixes for the other issue in user mode Linux)
> > 
> 
> Is that the fix you are talking about?
> 
> commit 79ea1e12c0b8540100e89b32afb9f0e6503fad35
> "cfg80211: fix management registrations deadlock"

Right. I only have two fixes in that tree ;)

I'll see if I have anything else, and send it off to davem later.

johannes

