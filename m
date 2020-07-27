Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5AF22E5A5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 07:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgG0F6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 01:58:17 -0400
Received: from verein.lst.de ([213.95.11.211]:42062 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgG0F6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 01:58:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B1CC268B05; Mon, 27 Jul 2020 07:58:13 +0200 (CEST)
Date:   Mon, 27 Jul 2020 07:58:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, hch@lst.de,
        robin.murphy@arm.com, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        edumazet@google.com, steffen.klassert@secunet.com,
        saeedm@mellanox.com, maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 03/21] mm: Allow DMA mapping of pages which are
 not online
Message-ID: <20200727055813.GA1503@lst.de>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-4-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727052846.4070247-4-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 10:28:28PM -0700, Jonathan Lemon wrote:
> Change the system RAM check from 'valid' to 'online', so dummy
> pages which refer to external DMA resources can be mapped.


NAK.  This looks completely bogus.  Maybe you do have a good reason
somewhere (although I doubt it), but then you'd actualy need to both
explain it here, and also actually make sure I get the whole damn series.

Until you fix up how you send these stupid partial cc lists I'll just
ignore this crap.
