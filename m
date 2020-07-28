Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B013E230ECB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbgG1QFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:05:16 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:56288 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbgG1QFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:05:14 -0400
Received: (qmail 67215 invoked by uid 89); 28 Jul 2020 16:05:13 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 28 Jul 2020 16:05:13 -0000
Date:   Tue, 28 Jul 2020 09:05:08 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728160508.ip55hzzw34wuwlam@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-22-jonathan.lemon@gmail.com>
 <20200727073509.GB3917@lst.de>
 <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
 <20200727182424.GA10178@lst.de>
 <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
 <20200728064706.GA21377@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728064706.GA21377@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 08:47:06AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 27, 2020 at 06:48:12PM -0700, Jonathan Lemon wrote:
> > I'm aware that Nvidia code is maintained outside the tree, so this last
> > patch may better placed there; I included it here so reviewers can see
> > how things work.
> 
> Sorry dude, but with statements like this you really disqualify yourself
> from kernel work.  Please really just go away and stop this crap.  It's
> not just your attitude, but also the resulting crap code.

The attitude appears to be on your part, as apparently you have no
technical comments to contribute here.
-- 
Jonathan
