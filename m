Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501912B0E96
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgKLT5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgKLT5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:57:19 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B69720791;
        Thu, 12 Nov 2020 19:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605211038;
        bh=3J3WDBu9OtjNNtA9foG7njMe/qOCfV8e26e1rfWIZek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iLDos9NrfFEbpF7KWp/0tZgEQc+G6Pa4EJag53FXT0bQnO5AVh5Np5NVOED50dd6v
         6xsAeoBHmCL0Gec4Sg7BRsz+FD5hTGBDpxq08SSlp7l8PjIrGAKseTaTCZgnRZbJje
         5lFh+ri2A9ZtQPO1RxDd458D02UFymtgA+1apYYo=
Message-ID: <87ee2a8c0353feebdca50d2ea999ddd965d000fd.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 01/13] octeontx2-af: Modify default KEX
 profile to extract TX packet fields
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Date:   Thu, 12 Nov 2020 11:57:16 -0800
In-Reply-To: <20201111071404.29620-2-naveenm@marvell.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
         <20201111071404.29620-2-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-11 at 12:43 +0530, Naveen Mamindlapalli wrote:
> From: Stanislaw Kardach <skardach@marvell.com>
> 
> The current default Key Extraction(KEX) profile can only use RX
> packet fields while generating the MCAM search key. The profile
> can't be used for matching TX packet fields. This patch modifies
> the default KEX profile to add support for extracting TX packet
> fields into MCAM search key. Enabled Tx KPU packet parsing by
> configuring TX PKIND in tx_parse_cfg.
> 
> Also modified the default KEX profile to extract VLAN TCI from
> the LB_PTR and exact byte offset of VLAN header. The NPC KPU
> parser was modified to point LB_PTR to the starting byte offset
> of VLAN header which points to the tpid field.
> 
> Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


