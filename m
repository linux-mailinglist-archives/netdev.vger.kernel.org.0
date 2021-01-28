Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBA306B0F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhA1CW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:22:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhA1CVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:21:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4wvU-002xuj-5K; Thu, 28 Jan 2021 03:20:52 +0100
Date:   Thu, 28 Jan 2021 03:20:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 net-next] From: Petr Vandrovec <petr@vmware.com>
Message-ID: <YBIfhK1Kayf6kS62@lunn.ch>
References: <20210128020816.31318-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128020816.31318-1-doshir@vmware.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 06:08:16PM -0800, Ronak Doshi wrote:
> buf_info structures in RX & TX queues are private driver data that
> do not need to be visible to the device.  Although there is physical
> address and length in the queue descriptor that points to these
> structures, their layout is not standardized, and device never looks
> at them.
> 
> So lets allocate these structures in non-DMA-able memory, and fill
> physical address as all-ones and length as zero in the queue
> descriptor.
> 
> That should alleviate worries brought by Martin Radev in
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
> that malicious vmxnet3 device could subvert SVM/TDX guarantees.
> 
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

Hi Ronak

The Subject line is still messed up, it contains Petr name rather than
a subject.

	Andrew
