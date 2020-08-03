Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C9B23B027
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgHCW1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCW1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 18:27:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF71720722;
        Mon,  3 Aug 2020 22:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596493620;
        bh=xADYXv66odoZ1OJDENv2L2OVT41L1d7moMmf7PvNPzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ef7AytR5UvaYUnV3TflIDylHgPo0QLZ/V93a3eu36K1SNXMx4mWEyTRSHJ4foPDAX
         LjlNmmvEgqEwHPYTKO56DL3gZFulKSxyNRAshlJsBZdn1Wj6xzfZdoMx3/BSIeeNO5
         LkAvk+6ISqd4kL2x0JiFttDONglZ5IPBCFylC4Gk=
Date:   Mon, 3 Aug 2020 15:26:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/11] sfc: driver for EF100 family NICs,
 part 2
Message-ID: <20200803152657.43060397@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 21:30:32 +0100 Edward Cree wrote:
> This series implements the data path and various other functionality
>  for Xilinx/Solarflare EF100 NICs.
> 
> Changed from v2:
>  * Improved error handling of design params (patch #3)
>  * Removed 'inline' from .c file in patch #4
>  * Don't report common stats to ethtool -S (patch #8)
> 
> Changed from v1:
>  * Fixed build errors on CONFIG_RFS_ACCEL=n (patch #5) and 32-bit
>    (patch #8)
>  * Dropped patch #10 (ethtool ops) as it's buggy and will need a
>    bigger rework to fix.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
