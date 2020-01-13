Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1FF1394AE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAMPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:20:53 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56605 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgAMPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:20:52 -0500
X-Originating-IP: 90.76.211.102
Received: from localhost (lfbn-tou-1-1151-102.w90-76.abo.wanadoo.fr [90.76.211.102])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 937EAFF813;
        Mon, 13 Jan 2020 15:20:49 +0000 (UTC)
Date:   Mon, 13 Jan 2020 16:20:48 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 06/15] net: macsec: add nla support for
 changing the offloading selection
Message-ID: <20200113152048.GE3078@kwain>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200110162010.338611-7-antoine.tenart@bootlin.com>
 <20200113150202.GC2131@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200113150202.GC2131@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

On Mon, Jan 13, 2020 at 04:02:02PM +0100, Jiri Pirko wrote:
> 
> I wonder, did you consider having MACSEC_OFFLOAD_ATTR_TYPE attribute
> passed during the macsec device creation (to macsec_newlink), so the
> device is either created "offloded" or not? Looks like an extra step.
> Or do you see a scenario one would change "offload" setting on fly?
> If not, I don't see any benefit in having this as a separate command.

That would be possible as well. When we discussed offloading selection
we thought allowing the user to fallback to another offloading mode when
a rule or a set of rules isn't supported by a given device would be
useful, even though updating the offloading selection at runtime isn't
fully transparent for now (this would be a nice follow-up).

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
