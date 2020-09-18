Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A310527037A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIRRnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRRnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:43:51 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF2021707;
        Fri, 18 Sep 2020 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600451031;
        bh=bmrz+5cSN1jQUkPE/uJ3j/F7IxA5I9S0PGdC3Yy94n8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sFAWCIGgv4gKZH5aIEyNTRds2vifCG1UDOCdP71ag5gDgSHoNzNEVzmp959LxkCTd
         2VKVPEcUrbt2olxvm6qFdoCXEe0OjSs/bpqIBbzTf3F1q6QD4yg/pq5gRKvOli9Mzz
         q/rvAFit09mAlHKnWMtL3EoT/oTEKtvnCQX2koHA=
Message-ID: <43ba897632383543e6d7e82f141ad14a265b46f7.camel@kernel.org>
Subject: Re: [PATCH net-next] liquidio: Fix -Wmissing-prototypes warnings
 for liquidio
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 18 Sep 2020 10:43:50 -0700
In-Reply-To: <20200918130210.16902-1-wanghai38@huawei.com>
References: <20200918130210.16902-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-09-18 at 21:02 +0800, Wang Hai wrote:
> If the header file containing a function's prototype isn't included
> by
> the sourcefile containing the associated function, the build system
> complains of missing prototypes.
> 
> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/cavium/liquidio/cn68xx_device.c:124:5: warning:
> no previous prototype for ‘lio_setup_cn68xx_octeon_device’ [-
> Wmissing-prototypes]
> drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:159:1: warning:
> no previous prototype for ‘octeon_pci_read_core_mem’ [-Wmissing-
> prototypes]
> drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:168:1: warning:
> no previous prototype for ‘octeon_pci_write_core_mem’ [-Wmissing-
> prototypes]
> drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:176:5: warning:
> no previous prototype for ‘octeon_read_device_mem64’ [-Wmissing-
> prototypes]
> drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:185:5: warning:
> no previous prototype for ‘octeon_read_device_mem32’ [-Wmissing-
> prototypes]
> drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:194:6: warning:
> no previous prototype for ‘octeon_write_device_mem32’ [-Wmissing-
> prototypes]
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

