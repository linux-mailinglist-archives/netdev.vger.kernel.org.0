Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028F45C8CF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 07:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGBFc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfGBFc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 01:32:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B1921479;
        Tue,  2 Jul 2019 05:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562045545;
        bh=5nFy6GF/z0qfMNh+woe1h0Af6Gp8wAjzYHvqnhfpe4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQnB83gcbhxh9jCa+CrKuhTBFi8jR5kt0n1/x5Ue4/gqrjWyaFKSGRr7p2imP+0BN
         Yrrniu1rAl0OeYJsVmWcFcdSrs3NQQZLOTAkjEMkIm9FTM9tXJ+jmto5MAZHNCT0xQ
         gcyHY0Au5F3gvE6D0B1cq1JwF9Fhw1cBSLCQkKuo=
Date:   Mon, 1 Jul 2019 22:32:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Hillf Danton <hdanton@sina.com>, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 2 open syzbot bugs in vhost subsystem
Message-ID: <20190702053223.GA27702@sol.localdomain>
References: <20190702051707.GF23743@sol.localdomain>
 <e2da1124-52c3-84ff-77ce-deb017711138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2da1124-52c3-84ff-77ce-deb017711138@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 01:24:43PM +0800, Jason Wang wrote:
> > --------------------------------------------------------------------------------
> > Title:              INFO: task hung in vhost_init_device_iotlb
> > Last occurred:      125 days ago
> > Reported:           153 days ago
> > Branches:           Mainline and others
> > Dashboard link:     https://syzkaller.appspot.com/bug?id=cb1ea8daf03a5942c2ab314679148cf6e128ef58
> > Original thread:    https://lkml.kernel.org/lkml/0000000000007e86fd058095533f@google.com/T/#u
> > 
> > Unfortunately, this bug does not have a reproducer.
> > 
> > The original thread for this bug received 2 replies; the last was 152 days ago.
> > 
> > If you fix this bug, please add the following tag to the commit:
> >      Reported-by: syzbot+40e28a8bd59d10ed0c42@syzkaller.appspotmail.com
> > 
> > If you send any email or patch for this bug, please consider replying to the
> > original thread.  For the git send-email command to use, or tips on how to reply
> > if the thread isn't in your mailbox, see the "Reply instructions" at
> > https://lkml.kernel.org/r/0000000000007e86fd058095533f@google.com
> > 
> 
> Can syzbot still reproduce this issue?

Apparently not, as it last occurred 125 days ago.

That doesn't necessarily mean the bug isn't still there, though.

But if you (as a person familiar with the code) think it's no longer valid or
not actionable, you can invalidate it.

- Eric
