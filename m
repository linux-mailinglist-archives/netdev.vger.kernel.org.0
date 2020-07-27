Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6422F631
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgG0RI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:08:26 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:41759 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgG0RI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:08:26 -0400
Received: (qmail 74184 invoked by uid 89); 27 Jul 2020 17:08:24 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 27 Jul 2020 17:08:24 -0000
Date:   Mon, 27 Jul 2020 10:08:19 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 03/21] mm: Allow DMA mapping of pages which are
 not online
Message-ID: <20200727170819.eix3n66gwb4izlq7@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-4-jonathan.lemon@gmail.com>
 <20200727055813.GA1503@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727055813.GA1503@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 07:58:13AM +0200, Christoph Hellwig wrote:
> On Sun, Jul 26, 2020 at 10:28:28PM -0700, Jonathan Lemon wrote:
> > Change the system RAM check from 'valid' to 'online', so dummy
> > pages which refer to external DMA resources can be mapped.
> 
> NAK.  This looks completely bogus.  Maybe you do have a good reason
> somewhere (although I doubt it), but then you'd actualy need to both
> explain it here, and also actually make sure I get the whole damn series.

The entire patchset was sent out in one command - I have no control over
how the mail server ends up delivering things.

An alternative here would just allocate 'struct pages' from normal
system memory, instead of from the system resources.  I initially did it
this way so the page could be used in the normal fashion to locate the
DMA address, instead of having a separate lookup table.
-- 
Jonathan
