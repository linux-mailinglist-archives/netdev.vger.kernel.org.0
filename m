Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5232C8525
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgK3N3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgK3N3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 08:29:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0B8120643;
        Mon, 30 Nov 2020 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606742910;
        bh=DQ+wSsfzzJvTpM5c/TAOzAqu4JhPI6Qw2CdCl7s9bnI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iy6VsNPZIpqRMHbzHaZf4KAofuWIQmOzOyJdKPIJ3nmFXEOjDhBNETct6pTPa7KZa
         349/iqZtmBD+ozP3DeMiZdmAICZq9sXO/WuEaHhDd3HI4GtlOgDKPZQmN7vCK/BjbU
         GAUTn3NWGsgfMFU5RRd+CLK8/UccbsHngseKQN3M=
Date:   Mon, 30 Nov 2020 14:28:26 +0100
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
Message-ID: <X8TzeoIlR3G5awC6@kroah.com>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:33:46AM +0100, Paolo Bonzini wrote:
> On 29/11/20 22:06, Sasha Levin wrote:
> > On Sun, Nov 29, 2020 at 06:34:01PM +0100, Paolo Bonzini wrote:
> > > On 29/11/20 05:13, Sasha Levin wrote:
> > > > > Which doesn't seem to be suitable for stable either...  Patch 3/5 in
> > > > 
> > > > Why not? It was sent as a fix to Linus.
> > > 
> > > Dunno, 120 lines of new code?  Even if it's okay for an rc, I don't
> > > see why it is would be backported to stable releases and release it
> > > without any kind of testing.  Maybe for 5.9 the chances of breaking
> > 
> > Lines of code is not everything. If you think that this needs additional
> > testing then that's fine and we can drop it, but not picking up a fix
> > just because it's 120 lines is not something we'd do.
> 
> Starting with the first two steps in stable-kernel-rules.rst:
> 
> Rules on what kind of patches are accepted, and which ones are not, into the
> "-stable" tree:
> 
>  - It must be obviously correct and tested.
>  - It cannot be bigger than 100 lines, with context.

We do obviously take patches that are bigger than 100 lines, as there
are always exceptions to the rules here.  Look at all of the
spectre/meltdown patches as one such example.  Should we refuse a patch
just because it fixes a real issue yet is 101 lines long?

thanks,

greg k-h
