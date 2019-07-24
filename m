Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E44B7252A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGXDN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfGXDN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:13:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 831122253D;
        Wed, 24 Jul 2019 03:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563938035;
        bh=AXiCpbshNYcz7VQFZBfLifrrHxAILqoy+ggfj5ZCmDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYqG5d7XafM9NmvZ4tQSMuyhPB6Om9BauPTfY7VtmNBKE9oXbBMLR94LluniH220H
         d8TfVk5IaFIPml09gcFbL9EEjjwHx0tHWW6EXhnI9IqFiPKSjcqSo2gGXK5Njn+sxY
         COIS9ZxjWXe9b6ABW3LDtSeAxjhnfnJ6gIVZsLL0=
Date:   Tue, 23 Jul 2019 20:13:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 3 open syzbot bugs in vhost subsystem
Message-ID: <20190724031354.GV643@sol.localdomain>
Mail-Followup-To: Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190724023835.GY643@sol.localdomain>
 <fabf96ac-e472-c7fd-07ff-486fe03e6433@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fabf96ac-e472-c7fd-07ff-486fe03e6433@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:05:14AM +0800, Jason Wang wrote:
> > --------------------------------------------------------------------------------
> > Title:              KASAN: use-after-free Write in tlb_finish_mmu
> > Last occurred:      5 days ago
> > Reported:           4 days ago
> > Branches:           Mainline
> > Dashboard link:     https://syzkaller.appspot.com/bug?id=d57b94f89e48c85ef7d95acc208209ea4bdc10de
> > Original thread:    https://lkml.kernel.org/lkml/00000000000045e7a1058e02458a@google.com/T/#u
> > 
> > This bug has a syzkaller reproducer only.
> > 
> > This bug was bisected to:
> > 
> > 	commit 7f466032dc9e5a61217f22ea34b2df932786bbfc
> > 	Author: Jason Wang <jasowang@redhat.com>
> > 	Date:   Fri May 24 08:12:18 2019 +0000
> > 
> > 	  vhost: access vq metadata through kernel virtual address
> > 
> > No one has replied to the original thread for this bug yet.
> > 
> > If you fix this bug, please add the following tag to the commit:
> >      Reported-by: syzbot+8267e9af795434ffadad@syzkaller.appspotmail.com
> > 
> > If you send any email or patch for this bug, please reply to the original
> > thread.  For the git send-email command to use, or tips on how to reply if the
> > thread isn't in your mailbox, see the "Reply instructions" at
> > https://lkml.kernel.org/r/00000000000045e7a1058e02458a@google.com
> > 
> > --------------------------------------------------------------------------------
> > Title:              KASAN: use-after-free Read in finish_task_switch (2)
> > Last occurred:      5 days ago
> > Reported:           4 days ago
> > Branches:           Mainline
> > Dashboard link:     https://syzkaller.appspot.com/bug?id=9a98fcad6c8bd31f5c3afbdc6c75de9f082c0ffa
> > Original thread:    https://lkml.kernel.org/lkml/000000000000490679058e0245ee@google.com/T/#u
> > 
> > This bug has a syzkaller reproducer only.
> > 
> > This bug was bisected to:
> > 
> > 	commit 7f466032dc9e5a61217f22ea34b2df932786bbfc
> > 	Author: Jason Wang <jasowang@redhat.com>
> > 	Date:   Fri May 24 08:12:18 2019 +0000
> > 
> > 	  vhost: access vq metadata through kernel virtual address
> > 
> > No one has replied to the original thread for this bug yet.
> 
> 
> Hi:
> 
> We believe above two bugs are duplicated with the report "WARNING in
> __mmdrop". Can I just dup them with
> 
> #syz dup "WARNING in __mmdrop"
> 
> (If yes, just wonder how syzbot differ bugs, technically, several different
> bug can hit the same warning).
> 

Yes, please mark them as duplicates; see https://goo.gl/tpsmEJ#status for
correct syntax.  You need to send the command to the syzbot email address
specific to each bug.  Easiest way is to reply to the original threads.

- Eric
