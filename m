Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF30135C04
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgAIO6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 09:58:55 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36421 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732156AbgAIO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 09:58:54 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so5943226iln.3;
        Thu, 09 Jan 2020 06:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XLp4HzIibE892QDHCqNKq4lozGRKQ0dXyrjbBEHkh4E=;
        b=l4Bzalxpj9qAWjG2OjZBfaX8qE9AN2lGm2PF1169VF6BfEUpHXYIDZIN08Xe2VY5H5
         0++X8jERaPQNYEPI8pPF5c1s6/Ljg8Klww8bjOKZnBifpERhUI8ICdswpTnYm56zvgH5
         T2K9Lm/9m2t+dqH8c4KzBt4p/vjKBQEeH4lYpQW7u09SluiT18hNu4Uz55aGfEJLpaVd
         qRVe0ec8TndRSZ8xO8QwceZ+DZRZqJAtNAKVEtYAmhB1Ex3jq+SjQAr7SE8ux/f4QQ8a
         O1yY253Bgial2+dW15DXzE08+pIKXAXI28e4F5eAC3KQCooSkRVFhJ2HdQwhXsmOYYrn
         ByrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XLp4HzIibE892QDHCqNKq4lozGRKQ0dXyrjbBEHkh4E=;
        b=Ug2634qZODYyu8wP/jXvn1rHzS5BO8eUBQRwhZHO6fbqjR0DA0V+PG9hnoWGApuLLo
         9HoJztSBLUpca69vBy4fFVWZ3bfBQck7GVS0GbjsXn7tg3OS2/1AX2broBkJhYLf8W8Y
         /L82KVDd9j0GltBFaRiLHSS19xOAGkyjT+3FJtAC73iuPzgZHVGSQGtm6CktU+VxR4YW
         sMRNI81RCqcO32xPKp1I4FgmKbjCVNGhNZtcpfvw4wF5TWuUuvqOuZCCe/vH7Fp2TwMC
         d9DnZH18ID/S65dvzxZrq9MYbSUONj/d6woD+VCsrKsfAjhugOM2M2DiHJhqQD7LvMXE
         vZng==
X-Gm-Message-State: APjAAAVF3VYZ9coc3ntOOXpaQ1PlWCKHyObHf3+DRL7YIQdaZUIPqa4e
        ar9//2raJ6cigA63bswxEP4=
X-Google-Smtp-Source: APXvYqyEBUOMgjTc1BHjPyJhEHDdIck25bZwD98UM7E6mlmAai2a415h1rU67EqIw7CbycFG608R1A==
X-Received: by 2002:a92:d183:: with SMTP id z3mr8884912ilz.214.1578581933490;
        Thu, 09 Jan 2020 06:58:53 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v21sm1458410ios.69.2020.01.09.06.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:52 -0800 (PST)
Date:   Thu, 09 Jan 2020 06:58:44 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        jbrouer@redhat.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Message-ID: <5e173fa42e1d5_35982ae92e9d45bc4b@john-XPS-13-9370.notmuch>
In-Reply-To: <b74865dd-c8ff-4a93-a4b6-0dfd021eca66@gmail.com>
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
 <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
 <5e16c99ecc70b_279f2af4a0e725c49a@john-XPS-13-9370.notmuch>
 <b74865dd-c8ff-4a93-a4b6-0dfd021eca66@gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita wrote:
> On 2020/01/09 15:35, John Fastabend wrote:
> > Toshiaki Makita wrote:
> >> On 2020/01/09 6:35, John Fastabend wrote:
> >>> Now that we depend on rcu_call() and synchronize_rcu() to also wait
> >>> for preempt_disabled region to complete the rcu read critical section
> >>> in __dev_map_flush() is no longer relevant.
> >>>
> >>> These originally ensured the map reference was safe while a map was
> >>> also being free'd. But flush by new rules can only be called from
> >>> preempt-disabled NAPI context. The synchronize_rcu from the map free
> >>> path and the rcu_call from the delete path will ensure the reference
> >>> here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
> >>> pair to avoid any confusion around how this is being protected.
> >>>
> >>> If the rcu_read_lock was required it would mean errors in the above
> >>> logic and the original patch would also be wrong.
> >>>
> >>> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> >>> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> >>> ---
> >>>    kernel/bpf/devmap.c |    2 --
> >>>    1 file changed, 2 deletions(-)
> >>>
> >>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >>> index f0bf525..0129d4a 100644
> >>> --- a/kernel/bpf/devmap.c
> >>> +++ b/kernel/bpf/devmap.c
> >>> @@ -378,10 +378,8 @@ void __dev_map_flush(void)
> >>>    	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
> >>>    	struct xdp_bulk_queue *bq, *tmp;
> >>>    
> >>> -	rcu_read_lock();
> >>>    	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
> >>>    		bq_xmit_all(bq, XDP_XMIT_FLUSH);
> >>> -	rcu_read_unlock();
> >>
> >> I introduced this lock because some drivers have assumption that
> >> .ndo_xdp_xmit() is called under RCU. (commit 86723c864063)
> >>
> >> Maybe devmap deletion logic does not need this anymore, but is it
> >> OK to drivers?
> > 
> > Ah OK thanks for catching this. So its a strange requirement from
> > virto_net to need read_lock like this. Quickly scanned the drivers
> > and seems its the only one.
> > 
> > I think the best path forward is to fix virtio_net so it doesn't
> > need rcu_read_lock() here then the locking is much cleaner IMO.
> 
> Actually veth is calling rcu_dereference in .ndo_xdp_xmit() so it needs
> the same treatment. In the reference I sent in another mail, Jesper
> said mlx5 also has some RCU dependency.

So veth, virtio and tun seem to need rcu_read_lock/unlock because
they use an rcu_dereference() in the xdp_xmit path. I'll audit the
rest today.

@Jesper, recall why mlx5 would require rcu_read_lock()/unlock()
pair? I just looked at mlx5_xdp_xmit and I'm not seeing a
rcu_dereference in there so if it is required I would want
to understand why.

> 
> > I'll send a v2 and either move the xdp enabled check (the piece
> > using the rcu_read_lock) into a bitmask flag or push the
> > rcu_read_lock() into virtio_net so its clear that this is a detail
> > of virtio_net and not a general thing. FWIW I don't think the
> > rcu_read_lock is actually needed in the virtio_net case anymore
> > either but pretty sure the rcu_dereference will cause an rcu
> > splat. Maybe there is another annotation we can use. I'll dig
> > into it tomorrow. Thanks
> 
> I'm thinking we can just move the rcu_lock to wrap around only ndo_xdp_xmit.
> But as you suggest if we can identify all drivers which depends on RCU and move the
> rcu_lock into the drivers (or remove the dependency) it's better.

I think we are working in bpf-next tree here so it would be best
to identify the minimal set of drivers that require the read_lock
and push that into the driver. I prefer these things are a precise
so its easy to understand when reading the code. Otherwise its
really not clear without grepping through the code or walking
the git history why we wrapped this in a rcu_read_lock/unlock.
At minimum we want a comment but that feels like a big hammer
that is not needed.

Most drivers should not care about the rcu_read_lock it seems
to just be special cases in the software devices where this happens.
veth for example is dereferencing the peer netdev. tun is dereference
the tun_file. virtio_net usage seems to be arbitrary to me and
is simply used to decide if xdp is enabled but we can do that
in a cleaner way.

I'll put a v2 together today and send it out for review.
