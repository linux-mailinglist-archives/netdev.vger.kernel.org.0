Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5633CCC8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhCPExl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhCPExY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 00:53:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4516512C;
        Tue, 16 Mar 2021 04:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615870403;
        bh=S6PCC5lZDAkJ7gbxaW2Yof8+VaWn5H/y2gGHwTfIxs8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qk/7KDwNCQxSJZe0d3BDsZ6yZeS3R/Wxo9NszYrNGmG3375j1LCuKmUVprugGsTel
         enQy9xk99GsR2GaYypK4P3aGCMRvqlr1HSbygrwVaWuombLNb4Sw8nYKULMgPFw4Ch
         c3A4gI2D2NjRKfRbEd0odK6V2sBItrvUkqkOvz4ZuGFAEOJhUIBhcIDiyPrmrwPbsI
         +suUqhzTok4A399BQCaY4uCwwILchfUzI0tGImC57JhWkOHw/BJUtlLgWaj5yjLP0C
         tbICx+pw9rAezrwY1qlVkcu67o34YWxxBYamzGSGLNX3TLvbY8TEdGmLOX2TIGErBW
         t0BDK8tfyDWYg==
Date:   Tue, 16 Mar 2021 10:23:20 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/4] Adding the Sparx5 Serdes driver
Message-ID: <YFA5wJSVolB8ZFHC@vkoul-mobl>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
 <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Steen,

On 15-03-21, 16:04, Steen Hegelund wrote:
> Hi Kishon, Vinod, Andrew, Jacub, and David, 
> 
> I just wanted to know if you think that the Generic PHY subsystem might
> not be the right place for this Ethernet SerDes PHY driver after all.
> 
> Originally I chose this subsystem for historic reasons: The
> Microchip/Microsemi Ocelot SerDes driver was added here when it was
> upstreamed.
> On the other hand the Ocelot Serdes can do both PCIe and Ethernet, so
> it might fit the signature of a generic PHY better.
> 
> At the moment the acceptance of the Sparx5 Serdes driver is blocking us
> from adding the Sparx5 SwitchDev driver (to net), so it is really
> important for us to resolve which subsystem the Serdes driver belongs
> to.
> 
> I am very much looking forward to your response.

Generic PHY IMO is the right place for this series, I shall review it
shortly and do the needful. I have asked Kishon to check the new phy API
and ack it...

Thanks
-- 
~Vinod
