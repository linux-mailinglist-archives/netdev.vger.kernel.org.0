Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641D1105228
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 13:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUMSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 07:18:08 -0500
Received: from foss.arm.com ([217.140.110.172]:55414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfKUMSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 07:18:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 895F61045;
        Thu, 21 Nov 2019 04:18:07 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF27B3F703;
        Thu, 21 Nov 2019 04:18:06 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:18:05 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     devicetree@vger.kernel.org, f.fainelli@gmail.com,
        linux-rdma@vger.kernel.org, maz@kernel.org, phil@raspberrypi.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com,
        linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org, mbrugger@suse.com,
        bcm-kernel-feedback-list@broadcom.com, wahrenst@gmx.net,
        james.quinlan@broadcom.com, linux-pci@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] Raspberry Pi 4 PCIe support
Message-ID: <20191121121804.GY43905@e119886-lin.cambridge.arm.com>
References: <20191112155926.16476-1-nsaenzjulienne@suse.de>
 <20191119111848.GR43905@e119886-lin.cambridge.arm.com>
 <1b116fabe85a324e2d05a593d38811467f43fb91.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b116fabe85a324e2d05a593d38811467f43fb91.camel@suse.de>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 12:49:24PM +0100, Nicolas Saenz Julienne wrote:
> On Tue, 2019-11-19 at 11:18 +0000, Andrew Murray wrote:
> > On Tue, Nov 12, 2019 at 04:59:19PM +0100, Nicolas Saenz Julienne wrote:
> > > This series aims at providing support for Raspberry Pi 4's PCIe
> > > controller, which is also shared with the Broadcom STB family of
> > > devices.
> > > 
> > > There was a previous attempt to upstream this some years ago[1] but was
> > > blocked as most STB PCIe integrations have a sparse DMA mapping[2] which
> > > is something currently not supported by the kernel.  Luckily this is not
> > > the case for the Raspberry Pi 4.
> > > 
> > > Note that the driver code is to be based on top of Rob Herring's series
> > > simplifying inbound and outbound range parsing.
> > > 
> > > [1] https://patchwork.kernel.org/cover/10605933/
> > > [2] https://patchwork.kernel.org/patch/10605957/
> > > 
> > 
> > What happened to patch 3? I can't see it on the list or in patchwork?
> 
> For some reason the script I use to call get_maintainer.sh or git send-mail
> failed to add linux-pci@vger.kernel.org and linux-kernel@vger.kernel.org as
> recipients. I didn't do anything different between v1 and v2 as far as mailing
> is concerned.
> 
> Nevertheless it's here: https://www.spinics.net/lists/arm-kernel/msg768461.html
> and should be present in the linux-arm-kernel list.
> 
> I'll look in to it and make sure this doesn't happen in v3.

No problem.

Thanks,

Andrew Murray

> 
> Regards,
> Nicolas
> 


