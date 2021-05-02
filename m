Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F92370B4E
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhEBL2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:28:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:41380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhEBL2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:28:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F13F3AE38;
        Sun,  2 May 2021 11:27:07 +0000 (UTC)
Subject: Re: [RFC PATCH v4 16/27] qedn: Add qedn - Marvell's NVMeTCP HW
 offload vendor driver
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-17-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4c17c44e-a08a-93cc-5ccf-51045cba0f0f@suse.de>
Date:   Sun, 2 May 2021 13:27:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-17-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> This patch will present the skeleton of the qedn driver.
> The new driver will be added under "drivers/nvme/hw/qedn" and will be
> enabled by the Kconfig "Marvell NVM Express over Fabrics TCP offload".
> 
> The internal implementation:
> - qedn.h:
>    Includes all common structs to be used by the qedn vendor driver.
> 
> - qedn_main.c
>    Includes the qedn_init and qedn_cleanup implementation.
>    As part of the qedn init, the driver will register as a pci device and
>    will work with the Marvell fastlinQ NICs.
>    As part of the probe, the driver will register to the nvme_tcp_offload
>    (ULP).
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   MAINTAINERS                      |  10 ++
>   drivers/nvme/Kconfig             |   1 +
>   drivers/nvme/Makefile            |   1 +
>   drivers/nvme/hw/Kconfig          |   8 ++
>   drivers/nvme/hw/Makefile         |   3 +
>   drivers/nvme/hw/qedn/Makefile    |   5 +
>   drivers/nvme/hw/qedn/qedn.h      |  19 +++
>   drivers/nvme/hw/qedn/qedn_main.c | 201 +++++++++++++++++++++++++++++++
>   8 files changed, 248 insertions(+)
>   create mode 100644 drivers/nvme/hw/Kconfig
>   create mode 100644 drivers/nvme/hw/Makefile
>   create mode 100644 drivers/nvme/hw/qedn/Makefile
>   create mode 100644 drivers/nvme/hw/qedn/qedn.h
>   create mode 100644 drivers/nvme/hw/qedn/qedn_main.c
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
