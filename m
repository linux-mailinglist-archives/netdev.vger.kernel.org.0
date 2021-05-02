Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41DF370B3F
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhEBLOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:14:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhEBLOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:14:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E229DAFAB;
        Sun,  2 May 2021 11:13:17 +0000 (UTC)
Subject: Re: [RFC PATCH v4 04/27] qed: Add support of HW filter block
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-5-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <761a58da-2933-4750-510e-c12dfe8f919c@suse.de>
Date:   Sun, 2 May 2021 13:13:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-5-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> This patch introduces the functionality of HW filter block.
> It adds and removes filters based on source and target TCP port.
> 
> It also add functionality to clear all filters at once.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>   drivers/net/ethernet/qlogic/qed/qed.h         |  10 ++
>   drivers/net/ethernet/qlogic/qed/qed_dev.c     | 107 ++++++++++++++++++
>   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |   5 +
>   include/linux/qed/qed_nvmetcp_if.h            |  24 ++++
>   4 files changed, 146 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
