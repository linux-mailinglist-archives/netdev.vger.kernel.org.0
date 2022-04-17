Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F45049A0
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiDQVZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 17:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiDQVZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 17:25:29 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5D51B7;
        Sun, 17 Apr 2022 14:22:51 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 737C9C009; Sun, 17 Apr 2022 23:22:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650230569; bh=j5U61nV5Q8nDNFs+ul/9hTF36iiMDWiWFRkW/S1vGe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IugD+11QKU2McobSeWuF0R7sbUUonQxLYL0Fk5f8YgxP1gNi8HKECf0h1PWYhaEoH
         1vJcWpTSRGItXRWIBUZ607E84wN+TRqd4/n1ibJgg0sXTxqRyIS1EhE6s3MGlx5g1Z
         MmJrReLBp0hzr1MMRtYWZkfpXAWdEKZX92JLjRY/HLDZy5+U5t4h2pZKcv1tc2Eyhx
         4I79yIy6e2XpE2uBN7A4L6bNbRFoHq9eDujfWL5pWbmrOhELz4KTtCm3C7dqewNXYs
         CnZjBxuGSAI8CEI4enJCZ2xRnJjVYslAjrGYmpsDSb3V0L6FaoOGsMfoVUlWbvMkAh
         mpmU8jXQG/mhA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 40DDBC009;
        Sun, 17 Apr 2022 23:22:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650230568; bh=j5U61nV5Q8nDNFs+ul/9hTF36iiMDWiWFRkW/S1vGe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EBq1h+RviVpkTPLTZzwOI6MgMhI/Cr63GjFsvQx/psPKHzyd5m76kWlqOqWtTGBs5
         b0JpYCsVM8RwkyvFR3KyNez7WMW+nhab67oinQlAMKyL7I838xAG3TPMDtAwR+4ey6
         q5IOJMyOLTKoGKodnrKhfD2TnwXgqUze1n9FlqslBavNufsjjKLYesU/StAXLXtZki
         ul8klNWRjB3QtbLWw5/kB2lTs2Lpm7RhVVLdu9Zq1Vnjwuh9y2D1h0ROeZuPLTzMAM
         SmJUOXD4yYu4k+mHh26VIRO9a6+cdjeWdFrwBpKArx1OCQasjTGFfwSp/9K9agcKo7
         TXoR6HBAdk3cw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 2b704471;
        Sun, 17 Apr 2022 21:22:41 +0000 (UTC)
Date:   Mon, 18 Apr 2022 06:22:26 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie
 detected)
Message-ID: <YlyFEuTY7tASl8aY@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <2551609.RCmPuZc3Qn@silver>
 <YlwOdqVCBZKFTIfC@codewreck.org>
 <8420857.9FB56xACZ5@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8420857.9FB56xACZ5@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sun, Apr 17, 2022 at 03:52:43PM +0200:
> > From the looks of it, write fails in v9fs_write_begin, which itself
> > fails because it tries to read first on a file that was open with
> > O_WRONLY|O_CREAT|O_APPEND.
> > Since this is an append the read is necessary to populate the local page
> > cache when writing, and we're careful that the writeback fid is open in
> > write, but not about read...
> > 
> > Will have to think how we might want to handle this; perhaps just giving
> > the writeback fid read rights all the time as well...
> > Ran out of time for tonight, but hopefully we can sort it out soonish now!
> 
> I fear that would just trade symptoms: There are use cases for write-only 
> permissions, which would then fail after such kind of simple change.

The writeback fid is only used by async ops to flush (and apparently
since 5.10ish populate) the cache; I actually wonder how that "populate
the cache" worked before!
Anyway, since it's not used by direct operations I believe we can mess
with its open mode, but that assumes permission checks are properly done
at vfs level (this is pretty much the line of thinking that allowed
dirty cow... But in this case if a file is opened read-only the
writeback fid isn't allocated afaik, so it's probably ok ?...)

Alternatively we could have the cache issue yet another open for read
when needed, but I think a single RW fid is probably good enough if we
might read from it (no TRUNC)...
It'd break opening the writeback fid on files with -w- permission if the
open is not done as root, but I don't see how we could make appending to
a write only file at something that is not a page boundary either way.

David, netfs doesn't allow cache at byte granularity, correct?

If it does we could fix the problem by only triggering a read when
really needed.



> Independent of this EBADF issue, it would be good to know why 9p performance 
> got so slow with cache=loose by the netfs changes. Maybe David has an idea?

Yes, I've just compared the behaviour of the old cache and new one (with
cache=loose) and the main difference in behaviour I can see if the time
until flush is longer on older version, and reads are bigger with the
new version recently, but the rest is all identical as far as I can see
(4k IOs for write, walk/open/clunk sequences to read a cached file (we
could delay these until reading into cache or a metadata op is
required?), TFSYNC after a series of write or on directories after a
while...), so I don't see a difference.

In particular I don't observe any cache invalidation when the mtime (and
so qid 'version', e.g. cache anciliary data) changes, but for cache=loose
that's how I'd expect it to work as well.


Perhaps the performance difference can be explained just by how
aggressively it's flushed out of memory, since it's written to disk
faster it'd also be easier to forget about and re-issue slow reads?
hmm... I need to spend more time on that as well...

-- 
Dominique


