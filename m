Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA02B249038
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHRViF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHRViE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:38:04 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5438CC061389;
        Tue, 18 Aug 2020 14:38:04 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id r19so10298968qvw.11;
        Tue, 18 Aug 2020 14:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sqA8LPcQ85pMO8OzNJzloE7dE18F1S8vPI6TaXKjits=;
        b=kgmS+GjPN47SJgCokMC2a1De0BuhAfsOgUyJKG4UQNGTmBGvo7nCqyJ77adX7TUoYC
         2tHdfr2I+773cUzW21O4rRi3sI085pbazMgtgpMxTQ/LnGpzwiPqkfaH7IMOolJIbyu2
         2PlEW4O/KnTEPV2V7I+isCSijfay3Tv6VI+ajltF3YdgPCx/8qNzIvchEC3cdwj/a70k
         lXlggWqcEEZyWxnQDkUPPaPNXqRtT9xAWeA/Li8GfLT8mdkQej+5nADYpedqd5FSxMvV
         OEqHGh5wc7ZdZsA8vhEKiZ2FpY8IW21G19W9LJHEslgEGHbJ2UbOthZy6q+Vi79G1ZAa
         /grQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sqA8LPcQ85pMO8OzNJzloE7dE18F1S8vPI6TaXKjits=;
        b=syxTbJ2eEZ2fC9T3XeNMXeDRoTgDO9c6xr3EAYqu5N65LeL3/p8+QMTjScuOKBC3zL
         uTCqObkZG0QcFblhXl+y+2BDICZfTMTRMKxbHn6r0Irx95I6SJBIXrBch7QV4DdCYdhA
         SQDEEKdpex0lZfRoV4aaoPi8ySVvyJE3ksGUTz+YXoxH9PhduInEFRztMqS1SlnRmV7T
         wFowQ7A1FYlkOXB0RkE0FRFe5qrAq8t7Tfo+sadK27X3E0I7eYjxU0yMs9JZS2TlAm6H
         wP1QMM/LTmU+TaCchz+yXwI4fBE4hadR/A3iaOSUmUogl23Nw1AdiqNqVlzBsM9cYurd
         UaAA==
X-Gm-Message-State: AOAM5310YUCzOG1O5tJagt1+NIONXyExRN7Pr/Yab1t1n0nOnRv1v5dS
        oO33ceVs/UozGc1fYYqN7Z4I3vSyYncCow==
X-Google-Smtp-Source: ABdhPJzUO2BnGioUxZhyqLc6/hhJqb8aSr+739ww3fBZ5piTAzJKjPaBEsszfiCqIGBfpWrtkqgEtQ==
X-Received: by 2002:a05:6214:1108:: with SMTP id e8mr21052593qvs.237.1597786683303;
        Tue, 18 Aug 2020 14:38:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:8002:1323:e13e:9d76:7bc8])
        by smtp.gmail.com with ESMTPSA id d46sm26018955qtk.37.2020.08.18.14.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 14:38:02 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 46836C18A0; Tue, 18 Aug 2020 18:38:00 -0300 (-03)
Date:   Tue, 18 Aug 2020 18:38:00 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: Use of genradix in sctp
Message-ID: <20200818213800.GJ906397@localhost.localdomain>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:38:09PM +0000, David Laight wrote:
> A few years ago (for 5.1) the 'arrays' that sctp uses for
> info about data streams was changed to use the 'genradix'
> functions.
> 
> I'm not sure of the reason for the change, but I don't
> thing anyone looked at the performance implications.

I don't have something like a CI for it, but I do run some performance
benchmarks every now and then and it didn't trigger anything
noticeable in my tests.

Yet, can it be improved? Certainly. Patches welcomed. :-)

> 
> The code contains lots of SCTP_SI(stream, i) with the
> probable expectation that the expansion is basically
> stream->foo[i] (a pointer to a big memory array).
> 
> However the genradix functions are far more complicated.
> Basically it is a list of pointers to pages, each of
> which is split into the maximum number of items.
> (With the page pointers being in a tree of pages
> for large numbers of large items.)
> 
> So every SCTP_S[IO]() has inline code to calculate
> the byte offset:
> 	idx / objs_per_page * PAGE_SIZE + idx % objs_per_page * obj_size
> (objs_per_page and obj_size are compile time constants)
> and then calls a function to do the actual lookup.
> 
> This is all rather horrid when the array isn't even sparse.
> 
> I also doubt it really helps if anyone is trying to allow
> a lot of streams. For 64k streams you might be trying to
> allocate ~700 pages in atomic context.

Yes, and kvrealloc as you suggested on another email is not a
solution, because it can't fallback to vmalloc in atomic contexts.

Genradix here allows it to use several non-contiguous pages, which is
a win if compared to a simple kmalloc(..., GFP_ATOMIC) it had before
flex_arrays, and anything that we could implement around such scheme
would be just re-implementing genradix/flex_arrays again. After all,
it does need 64k elements allocated.

How soon it needs them? Well, it already deferred some allocation with
the usage of sctp_stream_out_ext (which is only allocated when the
stream is actually used, but added another pointer deref), leaving
just stuff couldn't be (easily) initialized later, there.

> 
> For example look at the object code for sctp_stream_clear()
> (__genradix_ptr() is in lib/generic-radix-tree.c).

sctp_stream_clear() is rarely called.

Caller graph:
sctp_stream_clear
  sctp_assoc_update
    SCTP_CMD_UPDATE_ASSOC
      sctp_sf_do_dupcook_b
      sctp_sf_do_dupcook_a

So, well, I'm not worried about it.

> 
> There is only one other piece of code that uses genradix.
> All it needs is a fifo list.

Specs say 64k streams, so we should support that and preferrably
without major regressions. Traversing 64k elements each time to find
an entry is very not performant.

For a more standard use case, with something like you were saying, 17
streams, genradix here doesn't use too much memory. I'm afraid a
couple of integer calculations to get an offset is minimal overhead if
compared to the rest of the code. For example, the stream scheduler
operations, accessed via struct sctp_sched_ops (due to retpoline), is
probably more interesting fixing than genradix effects here.

  Marcelo
