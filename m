Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7917282A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgB0Sxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:53:42 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:47727 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgB0Sxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:53:42 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id D443EFF804;
        Thu, 27 Feb 2020 18:53:39 +0000 (UTC)
Date:   Thu, 27 Feb 2020 19:53:39 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Quentin Schulz <foss@0leil.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay
 configuration
Message-ID: <20200227185339.GD1686232@kwain>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-4-antoine.tenart@bootlin.com>
 <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
 <20200227162506.GD5245@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227162506.GD5245@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 05:25:06PM +0100, Andrew Lunn wrote:
> > Also, do we actually need to write that register only when skews are defined
> > in the DT? Can't we just write to it anyway (I guess the fact that 0_2 skew
> > is actually 0 in value should put me on the right path but I prefer to ask).
> 
> Ideally, you don't want to rely on the boot loader doing some
> magic. So i would prefer the skew is set to 0 if the properties are
> not present.

Will do.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
