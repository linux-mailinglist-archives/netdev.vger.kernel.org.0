Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB210A634
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZVuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbfKZVuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 16:50:24 -0500
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4D32064B;
        Tue, 26 Nov 2019 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574805023;
        bh=fviU4DYleNx/9leEWr8KlLRaZcRV5/31mbcIkscLwXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=uUIlGVPyKOrvuHVpQv/b+ruVHCQDTlDu1+qzEemw7EkSDCS8/n4JPZHteVMdX0WFZ
         91sGaPq8CDozUc+9UqG1loem0V7LuABz1cFlkueEdKM8Bnyqsc6Xkrw3oMKIRDoyoo
         AdKDLXRSe79ve81TcXBrMFWSSipAW0nQkoXOLgX0=
Date:   Tue, 26 Nov 2019 15:50:21 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, james.quinlan@broadcom.com,
        mbrugger@suse.com, f.fainelli@gmail.com, phil@raspberrypi.org,
        wahrenst@gmx.net, jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v3 0/7] Raspberry Pi 4 PCIe support
Message-ID: <20191126215020.GA191414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126091946.7970-1-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 10:19:38AM +0100, Nicolas Saenz Julienne wrote:
> This series aims at providing support for Raspberry Pi 4's PCIe
> controller, which is also shared with the Broadcom STB family of
> devices.

> Jim Quinlan (3):
>   dt-bindings: PCI: Add bindings for brcmstb's PCIe device
>   PCI: brcmstb: add Broadcom STB PCIe host controller driver
>   PCI: brcmstb: add MSI capability

Please update these subjects to match the others, i.e., capitalize
"Add".  Also, I think "Add MSI capability" really means "Add support
for MSI ..."; in PCIe terms the "MSI Capability" is a structure in
config space and it's there whether the OS supports it or not.

No need to repost just for this.

> Nicolas Saenz Julienne (4):
>   linux/log2.h: Add roundup/rounddown_pow_two64() family of functions
>   ARM: dts: bcm2711: Enable PCIe controller
>   MAINTAINERS: Add brcmstb PCIe controller
>   arm64: defconfig: Enable Broadcom's STB PCIe controller
