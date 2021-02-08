Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD7F313B3D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhBHRnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234906AbhBHRle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:41:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5479F64E84;
        Mon,  8 Feb 2021 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612806053;
        bh=mNLE2ojChgDi+taD9ncxBmFLwoI9y1947dBM0b8ob4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aw1D0fwUBrHK+x7kxHCCjPUEWVmtOJE2si7wAEoo8QLJvRIgknAgraRZtqAg8tUCo
         cTLaOdiyI18OVdwoW7FtuoJgfR0lpXEfCu2d4R0XCaqRLVPipPzE9uaX7mbopBhcAw
         3hgTKxBQObTBpBY1q7HlGdMUFRE6br+88Wy+p1svlw36DuYPesMUR7A2FKojI/PW9Z
         dEguzS4KMUORYFxfR5jUHd12qjO1i+wgUNJpLHF6IAYil+A7G8XnY89rSTrXRH7OXI
         2fTWuYm40jWKd3uQZu4t3bLrob+oTSYd7MbBG1rj12iVq0IJIDrMgKBMXnNjDsVUyr
         scwiR1oWbA7kg==
Date:   Mon, 8 Feb 2021 09:40:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <sgoutham@marvell.com>,
        <davem@davemloft.net>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <jerinj@marvell.com>, <lcherian@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>
Subject: Re: [net-next v4 00/14] Add Marvell CN10K support
Message-ID: <20210208094052.1d90443f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 04:19:59 +0530 Geetha sowjanya wrote:
> The current admin function (AF) driver and the netdev driver supports
> OcteonTx2 silicon variants. The same OcteonTx2's
> Resource Virtualization Unit (RVU) is carried forward to the next-gen
> silicon ie OcteonTx3, with some changes and feature enhancements.
> 
> This patch set adds support for OcteonTx3 (CN10K) silicon and gets
> the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
> features are added.
> 
> Changes cover below HW level differences
> - PCIe BAR address changes wrt shared mailbox memory region
> - Receive buffer freeing to HW
> - Transmit packet's descriptor submission to HW
> - Programmable HW interface identifiers (channels)
> - Increased MTU support
> - A Serdes MAC block (RPM) configuration
> 
> v3-v4
> Fixed compiler warnings.

Still 4 new sparse warnings in patch 1.
