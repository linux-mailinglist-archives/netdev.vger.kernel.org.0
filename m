Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9692D653
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfE2H2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:28:47 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:40751 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfE2H2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:28:47 -0400
X-Originating-IP: 90.88.147.134
Received: from bootlin.com (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id A1C95C000A;
        Wed, 29 May 2019 07:28:42 +0000 (UTC)
Date:   Wed, 29 May 2019 09:28:45 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 06/11] net: phylink: Add struct
 phylink_config to PHYLINK API
Message-ID: <20190529092845.4bc7439f@bootlin.com>
In-Reply-To: <1559065097-31832-7-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
        <1559065097-31832-7-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ioana,

On Tue, 28 May 2019 20:38:12 +0300
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

>The phylink_config structure will encapsulate a pointer to a struct
>device and the operation type requested for this instance of PHYLINK.
>This patch does not make any functional changes, it just transitions the
>PHYLINK internals and all its users to the new API.
>
>A pointer to a phylink_config structure will be passed to
>phylink_create() instead of the net_device directly. Also, the same
>phylink_config pointer will be passed back to all phylink_mac_ops
>callbacks instead of the net_device. Using this mechanism, a PHYLINK
>user can get the original net_device using a structure such as
>'to_net_dev(config->dev)' or directly the structure containing the
>phylink_config using a container_of call.

I see that you mixed both to_net_dev and container_of uses in mvpp2, is
there a reason for that ?

Other than that, for the mvpp2 part,

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Thanks,

Maxime
