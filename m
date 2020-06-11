Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DCB1F61F7
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgFKG6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgFKG6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 02:58:12 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715312072F;
        Thu, 11 Jun 2020 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591858691;
        bh=0LbPkXRKmQkzn1hd+4rIfvZFetgQ3Peh+JzAEL1lQps=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=O3qs0YGIPTZOCVvYK09B38ZLCrvyQXfhFPkNIj9EONJrb4gx4y/3C82XzGAUvROYX
         UKxLQBKEIYP8vHde8UwgJibJwfxGpIe4e6Ur2/8Oo2nnUTNxnCKvsMBrbA0Q3YwQcr
         CpIZk4jcSbcafBckOgnl0MEO3t7egdQMUgLhllBU=
Date:   Thu, 11 Jun 2020 08:58:06 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Peter Hutterer <peter.hutterer@who-t.net>
cc:     Andrey Konovalov <andreyknvl@google.com>,
        syzbot <syzbot+6921abfb75d6fc79c0eb@syzkaller.appspotmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        amir73il@gmail.com, Felipe Balbi <balbi@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: INFO: task hung in corrupted (2)
In-Reply-To: <20200611045118.GA306934@jelly>
Message-ID: <nycvar.YFH.7.76.2006110856290.13242@cbobk.fhfr.pm>
References: <0000000000004afcae05a7041e98@google.com> <CAAeHK+ykPQ8Fmit_3cn17YKzrCWtX010HRKmBCJAQ__OMdwCDA@mail.gmail.com> <nycvar.YFH.7.76.2006041339220.13242@cbobk.fhfr.pm> <20200611045118.GA306934@jelly>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020, Peter Hutterer wrote:

> based on the line numbers it's the while loop in there which is also the one
> that could be unbounded if the hid collection isn't set up correctly or if
> we have some other corruption happening.

Given the fact this is syzkaller-induced, it's almost certainly a 
completely bogus collection. So we are surely missing sanity check that 
there exists a collection with idx -1.

> Need to page this back in to figure out what could be happening here.

Thanks,

-- 
Jiri Kosina
SUSE Labs

