Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93317FE50
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfD3RBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 13:01:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50313 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfD3RBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 13:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BtznMGJClosN3hpxBR1MF0LMvYBaVQU8HSmMwTGaRr8=; b=KYUTkcy/1PFlnjOIw1wgJDFgis
        +s7lU7WwA1BKBZnFKsf6TQXYzMjApzfvg8MOeNMi2Fdw2f3CMud2ay+5Kz661eyP8fZlMWBfq7Hz1
        NiVYYpz92RERpcrLdZRxFAV1yFxmodOhN9oMn24m3Za211N7pVMCXcWbiVyo/hKb6ddU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLW7e-0001xJ-Ul; Tue, 30 Apr 2019 19:00:50 +0200
Date:   Tue, 30 Apr 2019 19:00:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/12] net: ll_temac: Fix iommu/swiotlb leak
Message-ID: <20190430170050.GD30817@lunn.ch>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
 <20190430071759.2481-9-esben@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430071759.2481-9-esben@geanix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 09:17:55AM +0200, Esben Haabendal wrote:
> Unmap the actual buffer length, not the amount of data received, avoiding
> resource exhaustion of swiotlb (seen on x86_64 platform).
> 
> Signed-off-by: Esben Haabendal <esben@geanix.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
