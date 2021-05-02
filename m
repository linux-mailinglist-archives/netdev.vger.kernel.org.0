Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E26370B67
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhEBL6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:58:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:48272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhEBL6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:58:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 20701B1AE;
        Sun,  2 May 2021 11:57:58 +0000 (UTC)
Subject: Re: [RFC PATCH v4 26/27] qedn: Add Connection and IO level recovery
 flows
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-27-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <daa07a1c-add4-9f27-5f55-05b1191e85c1@suse.de>
Date:   Sun, 2 May 2021 13:57:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-27-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> This patch will present the connection level functionalities:
>   - conn clear-sq: will release the FW restrictions in order to flush all
>     the pending IOs.
>   - drain: in case clear-sq is stuck, will release all the device FW
>     restrictions in order to flush all the pending IOs.
>   - task cleanup - will flush the IO level resources.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/hw/qedn/qedn.h      |   8 ++
>   drivers/nvme/hw/qedn/qedn_conn.c | 133 ++++++++++++++++++++++++++++++-
>   drivers/nvme/hw/qedn/qedn_main.c |   1 +
>   drivers/nvme/hw/qedn/qedn_task.c |  27 ++++++-
>   4 files changed, 166 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
