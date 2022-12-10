Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C173648FAC
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 17:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLJQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 11:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJQRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 11:17:17 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6517AE68;
        Sat, 10 Dec 2022 08:17:16 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2BAGHEWC022699;
        Sat, 10 Dec 2022 17:17:14 +0100
Date:   Sat, 10 Dec 2022 17:17:14 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] Add support for epoll min wait time
Message-ID: <20221210161714.GA22696@1wt.eu>
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
 <20221210155811.GA22540@1wt.eu>
 <e55d191b-d838-88a8-9cdb-e9b2e9ef4005@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e55d191b-d838-88a8-9cdb-e9b2e9ef4005@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 09:05:02AM -0700, Jens Axboe wrote:
> On 12/10/22 8:58?AM, Willy Tarreau wrote:
> > Hi Jens,
> > 
> > On Sat, Dec 10, 2022 at 08:36:11AM -0700, Jens Axboe wrote:
> >> Hi Linus,
> >>
> >> I've had this done for months and posted a few times, but little
> >> attention has been received.
> > 
> > I personally think this is particularly cool, for having faced the
> > same needs in the past. I'm just wondering how long we'll avoid the
> > need for marking certain FDs as urgent (i.e. for inter-thread wakeup)
> > which would bypass the min delay.
> 
> Thanks! No opinion on urgent fds, it's not something I have looked
> into...

We'll see over time anyway :-)

> > This last patch fixes a bug introduced by the 5th one. Why not squash it
> > instead of purposely introducing a bug then its fix ? Or maybe it was
> > just overlooked when you sent the PR ?
> 
> I didn't want to rebase it, so I just put the fix at the end. Not that
> important imho, only issue there was an ltp case getting a wrong error
> value. Hence didn't deem it important enough to warrant a rebase.

OK. I tend to prefer making sure that a bisect session can never end up
in the middle of a patch set for a reason other than a yet-undiscovered
bug, that's why I was asking.

Thanks,
Willy
