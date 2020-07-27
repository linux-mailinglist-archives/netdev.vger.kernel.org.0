Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6C22F7B6
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgG0SY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:24:29 -0400
Received: from verein.lst.de ([213.95.11.211]:44772 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbgG0SY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:24:29 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A9FD68B05; Mon, 27 Jul 2020 20:24:25 +0200 (CEST)
Date:   Mon, 27 Jul 2020 20:24:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for
 netgpu
Message-ID: <20200727182424.GA10178@lst.de>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-22-jonathan.lemon@gmail.com> <20200727073509.GB3917@lst.de> <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:00:03AM -0700, Jonathan Lemon wrote:
> On Mon, Jul 27, 2020 at 09:35:09AM +0200, Christoph Hellwig wrote:
> > Seriously?  If you only even considered this is something reasonable
> > to do you should not be anywhere near Linux kernel development.
> > 
> > Just go away!
> 
> This isn't really a constructive comment.

And this wasn't a constructive patch.  If you really think adding tons
of garbage to the kernel to support a proprietary driver you really
should not be here at all.
