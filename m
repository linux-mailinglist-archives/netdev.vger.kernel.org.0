Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C5D340126
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhCRIpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhCRIpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 04:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0AA864EF9;
        Thu, 18 Mar 2021 08:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616057110;
        bh=IifrKZQiEWghQTpvbwlZtaVxkHJIO+RuZrr2c7oPbzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPW7Tg1yOM+DTIm5e9XHZlTHwTXHCMM+o4Ke72VPKG0rIh7gK7UrBGoRf0XHwdkhU
         R0klymOrpWvrC85yYbV4bdGx84/SVjEXaVZSwkn6MLCUcqXmioOq9+SbL5NZDDfTu1
         Qk+CspzR8Q0N86HH1s5ChFAk7K8HyD7pI++snCAnu9FJKe7GcMRb5MrtMHEzNzmGpx
         FqNaplblmw1R3kM/ide+pjX0/k0bggm6DFiGgLIKs4uYio+tYPiiifO1vmDINbSs/K
         X5FfKiqT9qUfzwPNfWBr8MfaBN8IjxkxNLBFHibX2DYt8uLR168Fi6oKcgX0COM5/z
         xME7mE26SGxUQ==
Date:   Thu, 18 Mar 2021 10:45:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jarvis Jiang <jarvis.w.jiang@gmail.com>
Cc:     davem@davemloft.net, rppt@linux.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, cchen50@lenovo.com, mpearson@lenovo.com
Subject: Re: [PATCH] Add MHI bus support and driver for T99W175 5G modem
Message-ID: <YFMTEr5yGU0owYoM@unreal>
References: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 05:42:37AM -0700, Jarvis Jiang wrote:
> T99W175 using MBIM or RmNet over PCIe interface with
> MHI protocol support.
> Ported from IPQ8072 platform, including MHI, MBIM, RmNet
>
> Supporting below PCI devices:
>
>   PCI_DEVICE(0x17cb, 0x0300)
>   PCI_DEVICE(0x17cb, 0x0301)
>   PCI_DEVICE(0x17cb, 0x0302)
>   PCI_DEVICE(0x17cb, 0x0303)
>   PCI_DEVICE(0x17cb, 0x0304)
>   PCI_DEVICE(0x17cb, 0x0305)
>   PCI_DEVICE(0x17cb, 0x0306)
>   PCI_DEVICE(0x105b, 0xe0ab)
>   PCI_DEVICE(0x105b, 0xe0b0)
>   PCI_DEVICE(0x105b, 0xe0b1)
>   PCI_DEVICE(0x105b, 0xe0b3)
>   PCI_DEVICE(0x1269, 0x00b3)
>   PCI_DEVICE(0x03f0, 0x0a6c)
>
> Signed-off-by: Jarvis Jiang <jarvis.w.jiang@gmail.com>

<...>

> +FOXCONN 5G MODEM DRIVER
> +M:	Jarvis Jiang <jarvis.w.jiang@gmail.com>
> +S:	Orphan
> +F:	drivers/bus/mhi/
> +F:	drivers/net/ethernet/qualcomm/rmnet/
> +F:	include/linux/ipc_logging.h
> +F:	include/linux/mhi.h
> +F:	include/linux/mod_devicetable.h
> +F:	include/linux/msm-bus.h
> +F:	include/linux/msm_pcie.h

<...>

> +F:	include/linux/netdevice.h
> +F:	include/uapi/linux/if_link.h
> +F:	include/uapi/linux/msm_rmnet.h
> +F:	mm/memblock.c
> +F:	net/core/dev.c

That's quite a statement.

Thanks
