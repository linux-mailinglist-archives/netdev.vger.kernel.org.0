Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9791D7E98
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgERQeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgERQeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:34:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC9220709;
        Mon, 18 May 2020 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589819664;
        bh=gMfwCxrgLc9Bc8pZCXEdHtlJ4uexDsK/SheKdw2OGrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q7fZb/pl5NIzKPFh8OMQEkvDKRuATvahsKdrt8qXymP/8hIear4Eeeej+Sc88MsU+
         SKv3N2/OEWUe6XHrHFjrcmpiD4yjqBcxyyI2nNRdbylsneO7ujW9IKbAhypC9CVOSR
         GpuMajPj8YBcMvKkyW03FFMmycosT7DYyiADR/Yw=
Date:   Mon, 18 May 2020 09:34:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V6 16/20] net: ks8851: Implement register, FIFO, lock
 accessor callbacks
Message-ID: <20200518093422.38a52ca7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200517003354.233373-17-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
        <20200517003354.233373-17-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 02:33:50 +0200 Marek Vasut wrote:
> The register and FIFO accessors are bus specific, so is locking.
> Implement callbacks so that each variant of the KS8851 can implement
> matching accessors and locking, and use the rest of the common code.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member '____cacheline_aligned' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'tx_space' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'lock' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'unlock' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdreg16' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrreg16' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rdfifo' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'wrfifo' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'start_xmit' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'rx_skb' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:138: warning: Function parameter or member 'flush_tx_work' not described in 'ks8851_net'
drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer1' not described in 'ks8851_net_spi'
drivers/net/ethernet/micrel/ks8851.c:163: warning: Function parameter or member 'spi_xfer2' not described in 'ks8851_net_spi'
drivers/net/ethernet/micrel/ks8851.c:561: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb_spi'
drivers/net/ethernet/micrel/ks8851.c:570: warning: Function parameter or member 'ks' not described in 'ks8851_rx_skb'
