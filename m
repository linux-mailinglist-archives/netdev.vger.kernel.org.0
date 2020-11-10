Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377672AD27C
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgKJJ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJJ3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:29:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 260D020781;
        Tue, 10 Nov 2020 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605000587;
        bh=DjYVnsB1n+4U5DFBhXS7OdLzvk2H4JBbzRMijh8t9lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=op7OvAtID4qBqivXBKKnrTJLWij/OW7xA00+WL4MxOQJ7DUWJABaBYShnN/ZKprFx
         RiK2XasP9bzKGKzwI9hJ57wpFXfJF+XU1uODy5bPuEu9s7oAPtCNWFA10s23FlhG/I
         TpvdZ50rzgz7TGFq3n+FhawlMRwzg5eTxNJ0zSkg=
Date:   Tue, 10 Nov 2020 10:30:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/10] thunderbolt: Add DMA traffic test driver
Message-ID: <X6pdxfCFicGVqcM5@kroah.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 12:19:47PM +0300, Mika Westerberg wrote:
> Hi all,
> 
> This series adds a new Thunderbolt service driver that can be used on
> manufacturing floor to test that each Thunderbolt/USB4 port is functional.
> It can be done either using a special loopback dongle that has RX and TX
> lanes crossed, or by connecting a cable back to the host (for those who
> don't have these dongles).
> 
> This takes advantage of the existing XDomain protocol and creates XDomain
> devices for the loops back to the host where the DMA traffic test driver
> can bind to.
> 
> The DMA traffic test driver creates a tunnel through the fabric and then
> sends and receives data frames over the tunnel checking for different
> errors.
> 
> The previous version can be found here:
> 
>   https://lore.kernel.org/linux-usb/20201104140030.6853-1-mika.westerberg@linux.intel.com/
> 
> Changes from the previous version:
> 
>   * Fix resource leak in tb_xdp_handle_request() (patch 2/10)
>   * Use debugfs_remove_recursive() in tb_service_debugfs_remove() (patch 6/10)
>   * Add tags from Yehezkel

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
