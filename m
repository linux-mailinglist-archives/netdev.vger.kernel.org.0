Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16B826998F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINXRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:17:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:42154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgINXRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:17:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89E27AD12;
        Mon, 14 Sep 2020 23:17:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B663A60787; Tue, 15 Sep 2020 01:17:27 +0200 (CEST)
Date:   Tue, 15 Sep 2020 01:17:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] Adding 100base FX support
Message-ID: <20200914231727.ftyuvgbj2qrqzp7j@lion.mk-sys.cz>
References: <20200914170638.22451-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914170638.22451-1-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 12:06:37PM -0500, Dan Murphy wrote:
> Hello
> 
> I am adding the 100base Fx support for the ethtool.  There are a few PHYs that
> support the Fiber connection and the ethtool should be able to properly display
> that the PHY supports the 100base-FX Full and Half Duplex modes.
> 
> I am adding this support in the ethtool first and then submit the fiber bits
> into the kernel.
> 
> If the kernel needs to be updated first then I can prepare those patches and
> reference them.

Please add the support to kernel first. Otherwise the kernel-userspace
API may change (e.g. if someone adds another mode before yours so that
the constants would be different from your current submission). You
don't have to wait until the change reaches mainline but it should be
accepted at least to the net-next kernel tree.

Some technical notes:

  - please use "[PATCH ethtool]" subject prefix rather than "ethtool: "
    for ethtool utility patches to distinguish them from patches
    targeting kernel ethtool code
  - please update the header file copies in uapi/ directory in
    a separate patch and update all of them to a specific kernel commit
    as requested in
    https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html

Michal

> 
> Dan
> 
> Dan Murphy (1):
>   ethtool: Add 100BaseFX half and full duplex link modes
> 
>  ethtool.c            | 6 ++++++
>  netlink/settings.c   | 2 ++
>  uapi/linux/ethtool.h | 2 ++
>  3 files changed, 10 insertions(+)
> 
> -- 
> 2.28.0
> 
