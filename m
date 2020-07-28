Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1122FF11
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgG1BsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:48:19 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:61402 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG1BsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 21:48:18 -0400
Received: (qmail 65444 invoked by uid 89); 28 Jul 2020 01:48:16 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 28 Jul 2020 01:48:16 -0000
Date:   Mon, 27 Jul 2020 18:48:12 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-22-jonathan.lemon@gmail.com>
 <20200727073509.GB3917@lst.de>
 <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
 <20200727182424.GA10178@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727182424.GA10178@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 08:24:25PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 27, 2020 at 10:00:03AM -0700, Jonathan Lemon wrote:
> > On Mon, Jul 27, 2020 at 09:35:09AM +0200, Christoph Hellwig wrote:
> > > Seriously?  If you only even considered this is something reasonable
> > > to do you should not be anywhere near Linux kernel development.
> > > 
> > > Just go away!
> > 
> > This isn't really a constructive comment.
> 
> And this wasn't a constructive patch.  If you really think adding tons
> of garbage to the kernel to support a proprietary driver you really
> should not be here at all.

This is not in support of a proprietary driver.  As the cover letter
notes, this is for data transfers between the NIC/GPU, while still
utilizing the kernel protocol stack and leaving the application in
control.

While the current GPU utilized is nvidia, there's nothing in the rest of
the patches specific to Nvidia - an Intel or AMD GPU interface could be
equally workable.

I think this is a better patch than all the various implementations of
the protocol stack in the form of RDMA, driver code and device firmware.

I'm aware that Nvidia code is maintained outside the tree, so this last
patch may better placed there; I included it here so reviewers can see
how things work.
-- 
Jonathan

