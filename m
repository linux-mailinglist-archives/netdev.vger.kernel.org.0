Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C6387462
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405987AbfHIIj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:39:59 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:47463 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfHIIj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:39:59 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id E781A20007;
        Fri,  9 Aug 2019 08:39:57 +0000 (UTC)
Date:   Fri, 9 Aug 2019 10:39:31 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matt Pelland <mpelland@starry.com>
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net-next 0/2] net: mvpp2: Implement RXAUI Support
Message-ID: <20190809083931.GC3516@kwain>
References: <20190808230606.7900-1-mpelland@starry.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808230606.7900-1-mpelland@starry.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt,

One small comment: it seems you made a typo on davem's email address.
It's .net, not .com :)

Thanks,
Antoine

On Thu, Aug 08, 2019 at 07:06:04PM -0400, Matt Pelland wrote:
> This patch set implements support for configuring Marvell's mvpp2 hardware for
> RXAUI operation. There are two other patches necessary for this to work
> correctly that concern Marvell's cp110 comphy that were emailed to the general
> linux-kernel mailing list earlier on. I can post them here if need be. This
> patch set was successfully tested on both a Marvell Armada 7040 based platform
> as well as an Armada 8040 based platform.
> 
> Changes since v1:
> 
> - Use reverse christmas tree formatting for all modified declaration blocks.
> - Bump MVP22_MAX_COMPHYS to 4 to allow for XAUI operation.
> - Implement comphy sanity checking.
> 
> Matt Pelland (2):
>   net: mvpp2: implement RXAUI support
>   net: mvpp2: support multiple comphy lanes
> 
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   8 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 129 ++++++++++++++----
>  2 files changed, 110 insertions(+), 27 deletions(-)
> 
> -- 
> 2.21.0
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
