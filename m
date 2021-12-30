Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D50481CA3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhL3Ns1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:48:27 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57395 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235821AbhL3Ns1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:48:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id B18E55803AD;
        Thu, 30 Dec 2021 08:48:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 30 Dec 2021 08:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r5nxOi
        syFTtm3Lt210TuCZFrjiI0ZSYmX8dE32zPpw8=; b=AWw3JK/M3koYuH0ByXnmGm
        cL+kBFzuaLWpr0Fh9usE8semlLoiXpUed1/QP9NefTtfSkhIgDKbORZn43OP2pEJ
        spqf4FJ4ClRQVLumYPXeyUYYqMCM20Z/clpzCho0Yj1aQGlf8xENJTYxeE3pBfmt
        wy0OVQqHrkHu2WY/exMBbej8wfIKQm1VhQjewS91JozysT5poBAo/k7YyLUqw5i3
        w6/gS/kx/e3F+Hh7rX1XVt7k0cJfrI07H7bxaZaG2UCNX/xtPnL2h1IlBF0XsCHa
        E8QKxibKNvko4e09v8POk9RJN4bbfzZVAATpbF5QwijMNsJnOyzIrjF815nF5/AA
        ==
X-ME-Sender: <xms:qrjNYbRacaVIKXABNVPNYUvQw3elwZtDqGZ6IgD1v9vNwzPfaoAaoA>
    <xme:qrjNYcxyp0ajpOp7Mw5jPdpfr6mAFN6xcQb8qnJivRWT-VpIxQi0CoXeHhm7PzXtV
    s2buxnhyL99hqY>
X-ME-Received: <xmr:qrjNYQ2B3znPDH0__J1zTL6cR85-Ox7-9beNGYp_h__WlglwkbTIHVjpIkXQAoUIaeaSmQdEL-jEkdTyR0h86byWlP38kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qrjNYbAM-_QZyBdfEFUuWPxn2wRkPzTacOuyvucaclZ1m39rNvdpPQ>
    <xmx:qrjNYUhLzmr0m5ahE1O0NzfYnsyLkqGa6EF_IAFC74G70hSqFQcSGg>
    <xmx:qrjNYfpZvyihOVrxjwAhjQpU5Laz_HVB1c2m1s57TBwqlagCV05zKg>
    <xmx:qrjNYZY__mdKNZclg_DkhfSxj0Gp_ggtn9UindjAa-TxIVRbHF5_IA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 08:48:25 -0500 (EST)
Date:   Thu, 30 Dec 2021 15:48:22 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: marvell: prestera: Add prestera
 router infra
Message-ID: <Yc24pow5B9PaFWP2@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-4-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-4-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:28PM +0200, Yevhen Orlov wrote:
> Add prestera_router.c, which contains code to subscribe/unsubscribe on
> kernel notifiers for router. This handle kernel notifications,
> parse structures to make key to manipulate prestera_router_hw's objects.
> 
> Also prestera_router is container for router's objects database.
> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
> v1-->v2
> * No changes
> ---
>  .../net/ethernet/marvell/prestera/Makefile    |  3 +-
>  .../net/ethernet/marvell/prestera/prestera.h  | 11 ++++++++
>  .../ethernet/marvell/prestera/prestera_main.c |  6 ++++
>  .../marvell/prestera/prestera_router.c        | 28 +++++++++++++++++++
>  4 files changed, 47 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
> index 48dbcb2baf8f..ec69fc564a9f 100644
> --- a/drivers/net/ethernet/marvell/prestera/Makefile
> +++ b/drivers/net/ethernet/marvell/prestera/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
>  prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
>  			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
>  			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
> -			   prestera_flower.o prestera_span.o prestera_counter.o
> +			   prestera_flower.o prestera_span.o prestera_counter.o \
> +			   prestera_router.o
>  
>  obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> index 636caf492531..7160da678457 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -270,12 +270,20 @@ struct prestera_switch {
>  	u32 mtu_min;
>  	u32 mtu_max;
>  	u8 id;
> +	struct prestera_router *router;
>  	struct prestera_lag *lags;
>  	struct prestera_counter *counter;
>  	u8 lag_member_max;
>  	u8 lag_max;
>  };
>  
> +struct prestera_router {
> +	struct prestera_switch *sw;
> +	struct list_head vr_list;
> +	struct list_head rif_entry_list;
> +	bool aborted;

Never used

> +};
> +
>  struct prestera_rxtx_params {
>  	bool use_sdma;
>  	u32 map_addr;
> @@ -303,6 +311,9 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
>  
>  int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes);
>  
> +int prestera_router_init(struct prestera_switch *sw);
> +void prestera_router_fini(struct prestera_switch *sw);
> +
>  struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
>  
>  int prestera_port_cfg_mac_read(struct prestera_port *port,
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index a0dbad5cb88d..242904fcd866 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -893,6 +893,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  	if (err)
>  		return err;
>  
> +	err = prestera_router_init(sw);
> +	if (err)
> +		goto err_router_init;
> +
>  	err = prestera_switchdev_init(sw);
>  	if (err)
>  		goto err_swdev_register;
> @@ -949,6 +953,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  err_rxtx_register:
>  	prestera_switchdev_fini(sw);
>  err_swdev_register:
> +	prestera_router_fini(sw);

Missing a call in prestera_switch_fini(). Most likely visible with
kmemleak enabled

> +err_router_init:
>  	prestera_netdev_event_handler_unregister(sw);
>  	prestera_hw_switch_fini(sw);
>  
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> new file mode 100644
> index 000000000000..f3980d10eb29
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +
> +#include "prestera.h"
> +
> +int prestera_router_init(struct prestera_switch *sw)
> +{
> +	struct prestera_router *router;
> +
> +	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
> +	if (!router)
> +		return -ENOMEM;
> +
> +	sw->router = router;
> +	router->sw = sw;
> +
> +	return 0;
> +}
> +
> +void prestera_router_fini(struct prestera_switch *sw)
> +{
> +	kfree(sw->router);
> +	sw->router = NULL;
> +}
> +
> -- 
> 2.17.1
> 
