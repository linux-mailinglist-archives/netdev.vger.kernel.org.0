Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160405047CB
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiDQM7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiDQM7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:59:23 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CFD33367;
        Sun, 17 Apr 2022 05:56:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3BF6EC01F; Sun, 17 Apr 2022 14:56:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650200205; bh=tHEP8gfQwDFMMxr4TFcTxg5xIKCVyVv7/0p74EUs/nY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSPuxDtWuYG0ub+oHnLvmU/l6NpKJBOKU22mDeIBmZ4NrG05HPtQuukBnC5LkSQ+W
         BYIq4RcXsLt2Vc39bUqbTzutaZf4BbfyfxnlkagrEcw25SnwNUqwTfoqWTeHAPStOB
         Fe1NFKii2kE4YXQPGy7usRmQNfbyLg6GH2DLbhtfmkwKkq//vg+r/QzYdojQOJXZaW
         VDxkB1G9wN4uweuf7fG3lC4fZiNfZeJjDOyOKXr7hoP6PI2zKP9HKcTrkDRHrqdbI6
         6TeEGXc7NQF4mofBp8DnEcphThcgnLkOyKxDc0A+XUkM3QFBtiU9177jsfXJpqk4oy
         +p1kJXMCr7qVA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 51C11C009;
        Sun, 17 Apr 2022 14:56:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650200204; bh=tHEP8gfQwDFMMxr4TFcTxg5xIKCVyVv7/0p74EUs/nY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CtflF6i30N58Ns/YghbsJqu0IVwstb5hoRHlCqDHS0Z8knR2Ge9BAoz9Ld0D06ssb
         KgcHe0knkl1FMjGYJNbxBUHqeAfZTmTqJdGHcOz97838ae2Gxz2PL1DJGcqSCnD0ZB
         UDJ/Dqdmgbbjr6MPzk8JaWrbsimFhbcd7qVtn6rqiKvSZngeJjRxeaYP5Th04zj8bJ
         Z4SDHf2y+R/K1AYaXSPGkDTJk0gic0J5WJAJXMayJNfSVYamKeKrQ5FNc0zHXMQiXf
         ohaZGwn8evqUVG0/WdMfnOqobYfhXBi4qRlVCXc4qhVYOo1riAscMpy9M6NVs4EQiN
         G3GtvhMsPugUg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4a89f87c;
        Sun, 17 Apr 2022 12:56:37 +0000 (UTC)
Date:   Sun, 17 Apr 2022 21:56:22 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie
 detected)
Message-ID: <YlwOdqVCBZKFTIfC@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3119964.Qa6D4ExsIi@silver>
 <YlX/XRWwQ7eQntLr@codewreck.org>
 <2551609.RCmPuZc3Qn@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2551609.RCmPuZc3Qn@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Apr 14, 2022 at 02:44:53PM +0200:
> > Yes, I'm not sure why I can't reproduce... All my computers are pretty
> > slow but the conditions should be met.
> > I'll try again with a command line closer to what you just gave here.
> 
> I'm not surprised that you could not reproduce the EBADF errors yet. To make 
> this more clear, as for the git client errors: I have like 200+ git 
> repositories checked out on that test VM, and only about 5 of them trigger 
> EBADF errors on 'git pull'. But those few repositories reproduce the EBADF 
> errors reliably here.
> 
> In other words: these EBADF errors only seem to trigger under certain 
> circumstances, so it requires quite a bunch of test material to get a 
> reproducer.
> 
> Like I said though, with the Bullseye installation I immediately get EBADF 
> errors already when booting, whereas with a Buster VM it boots without errors.

Okay, I had missed that!

I've managed to reproduce with git:
https://gaia.codewreck.org/local/tmp/c.tar.zst

This archive (~300KB) when decompressed is a ~150MB repo where git reset
produces EBADF reliably for me.

From the looks of it, write fails in v9fs_write_begin, which itself
fails because it tries to read first on a file that was open with
O_WRONLY|O_CREAT|O_APPEND.
Since this is an append the read is necessary to populate the local page
cache when writing, and we're careful that the writeback fid is open in
write, but not about read...

Will have to think how we might want to handle this; perhaps just giving
the writeback fid read rights all the time as well...
Ran out of time for tonight, but hopefully we can sort it out soonish now!

> If somebody has some more ideas what I can try/test, let me know. However ATM 
> I won't be able to review the netfs and vfs code to actually find the cause of 
> these issues.

You've been of great help already, thanks!

-- 
Dominique
