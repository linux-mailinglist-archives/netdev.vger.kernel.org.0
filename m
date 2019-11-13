Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C03FABD6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfKMIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:16:52 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:58581 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfKMIQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 03:16:51 -0500
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 6F8EA200011;
        Wed, 13 Nov 2019 08:16:48 +0000 (UTC)
Date:   Wed, 13 Nov 2019 09:16:47 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     David Miller <davem@davemloft.net>
Cc:     antoine.tenart@bootlin.com, linux@armlinux.org.uk, andrew@lunn.ch,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mparab@cadence.com, piotrs@cadence.com, dkangude@cadence.com,
        ewanm@cadence.com, arthurm@cadence.com, stevenh@cadence.com
Subject: Re: [PATCH net-next v2] net: macb: convert to phylink
Message-ID: <20191113081647.GC4783@kwain>
References: <20191112142548.13037-1-antoine.tenart@bootlin.com>
 <20191112.114357.667316757358233747.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191112.114357.667316757358233747.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, Nov 12, 2019 at 11:43:57AM -0800, David Miller wrote:
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Date: Tue, 12 Nov 2019 15:25:48 +0100
> 
> > This patch converts the MACB Ethernet driver to the Phylink framework.
> > The MAC configuration is moved to the Phylink ops and Phylink helpers
> > are now used in the ethtools functions. This helps to access the flow
> > control and pauseparam logic and this will be helpful in the future
> > for boards using this controller with SFP cages.
> > 
> > Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> 
> Things like pulling out the buffer init code into a helper function are
> separate from the actual phylink conversion, so please split these changes
> out into separate patches and make this a bonafide patch series.
> 
> Please do not forget to provide an appropriate patch series header
> posting when you do this.

Will do for v3.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
