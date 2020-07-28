Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6121A230340
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgG1GrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:47:11 -0400
Received: from verein.lst.de ([213.95.11.211]:46893 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgG1GrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 02:47:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9926F68BEB; Tue, 28 Jul 2020 08:47:06 +0200 (CEST)
Date:   Tue, 28 Jul 2020 08:47:06 +0200
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
Message-ID: <20200728064706.GA21377@lst.de>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-22-jonathan.lemon@gmail.com> <20200727073509.GB3917@lst.de> <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com> <20200727182424.GA10178@lst.de> <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 06:48:12PM -0700, Jonathan Lemon wrote:
> I'm aware that Nvidia code is maintained outside the tree, so this last
> patch may better placed there; I included it here so reviewers can see
> how things work.

Sorry dude, but with statements like this you really disqualify yourself
from kernel work.  Please really just go away and stop this crap.  It's
not just your attitude, but also the resulting crap code.
