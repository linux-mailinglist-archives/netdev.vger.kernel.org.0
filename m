Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ABC2C8612
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgK3N6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgK3N6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 08:58:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205312076E;
        Mon, 30 Nov 2020 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606744650;
        bh=iyc/zT3Z69BkU1MFcgEbohwAlNY5zEcNlqG/+vhqKxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cdxfjIdnmP3FHAVkDnr/b4mnJNr3fwiHX+Tf6PDk2ypzF0IXTO17jp+lfmKKerS+X
         pZEOGQZ91YVEhY6YgPUJrxgbKxC0nZKHeb5/oWxPk3j5DlRjOR/LSKz9RK/D/eLRSc
         WUKfIHUgVOQ+94hDTyZ5Vq0EOtYRz3MeKKkyUc6k=
Date:   Mon, 30 Nov 2020 14:57:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <X8T6RWHOhgxW3tRK@kroah.com>
References: <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <X8TzeoIlR3G5awC6@kroah.com>
 <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 02:52:11PM +0100, Paolo Bonzini wrote:
> On 30/11/20 14:28, Greg KH wrote:
> > > > Lines of code is not everything. If you think that this needs additional
> > > > testing then that's fine and we can drop it, but not picking up a fix
> > > > just because it's 120 lines is not something we'd do.
> > > Starting with the first two steps in stable-kernel-rules.rst:
> > > 
> > > Rules on what kind of patches are accepted, and which ones are not, into the
> > > "-stable" tree:
> > > 
> > >   - It must be obviously correct and tested.
> > >   - It cannot be bigger than 100 lines, with context.
> > We do obviously take patches that are bigger than 100 lines, as there
> > are always exceptions to the rules here.  Look at all of the
> > spectre/meltdown patches as one such example.  Should we refuse a patch
> > just because it fixes a real issue yet is 101 lines long?
> 
> Every patch should be "fixing a real issue"---even a new feature.  But the
> larger the patch, the more the submitters and maintainers should be trusted
> rather than a bot.  The line between feature and bugfix _sometimes_ is
> blurry, I would say that in this case it's not, and it makes me question how
> the bot decided that this patch would be acceptable for stable (which AFAIK
> is not something that can be answered).

I thought that earlier Sasha said that this patch was needed as a
prerequisite patch for a later fix, right?  If not, sorry, I've lost the
train of thought in this thread...

thanks,

greg k-h
