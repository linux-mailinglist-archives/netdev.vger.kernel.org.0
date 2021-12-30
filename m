Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF8481D2D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240021AbhL3Oj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:39:28 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46937 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235691AbhL3Oj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:39:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A27C95800BC;
        Thu, 30 Dec 2021 09:39:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 30 Dec 2021 09:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=q2R4bf
        eWpVftxMmuZnfMxIctzZld7yNvMq7VilwNzDE=; b=gbpssR+Rpr0Lw3g3ByqvJJ
        RU0331/rriNCirksVqeJBZosBG2SQjXyR0OQtz5u/cAyYikiZjOcyzk0o2iQcpS3
        0Mxn1vZYnbUfBTmpJbcqMut5gdrpqf1iPkmzoqLOfmeczOF2/7nTEMn9lGWkffLJ
        fs70fx80hbCrSCPjKOj8ExuMnC9ZGIfzuEIEDdFBMoH3SfN27bC+/rLtv4wfKYcm
        zzSftfekFf/WeWjb7skRso1fC/+rfszMhivFxYUoox61LSvZ16x+UHCIXoPY9zTV
        W/YstDWv0B0s9TR8Lue/meWEq2mYrV2+obGIDUIlQ7Fauahj+YLyHX+BazaoX2HQ
        ==
X-ME-Sender: <xms:nsTNYYJvLFTTaUJVlkcTyCs2TzZk1H8oDwImUNexGghqTgBANEeFfA>
    <xme:nsTNYYJi6JILa4fc8SVtAp35_JXU_oNYSM1dRxjhrNXkXpK6KuMEFeJi9JDn5YIgi
    xJjy13LT3YXGbk>
X-ME-Received: <xmr:nsTNYYsVq9h30aoxcXArBV7OKKe6JvvDTv_kA8OuJbzQP1oI-QJFAq_2893buwYEbb7y0L00XzgF1sLQ4cZ21PO7bjxaBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeilefghfehvdehjeevhefhvefggeeflefghfdtgffhfeejgfevhefggfejteek
    feenucffohhmrghinhepihhfrggtvgdruggvvhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nsTNYVZ6OqEwWGolt8MVMC56mhyNpQP9QybGqY30Sp0bF_3wR8C-sg>
    <xmx:nsTNYfYeW8cdBaazWK_9QUBiMsR5UEECThVuGjEOHGAVKKZ1NQ8dgg>
    <xmx:nsTNYRDPSx9Y31L63xvc-9CsV4Td5mEobhGWUiEtLDQogfLc2NM_Ag>
    <xmx:nsTNYcRaPywX4hCace5aF9haPcZXDOqwMFRH7zttF8IuzBeOuiMKDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 09:39:25 -0500 (EST)
Date:   Thu, 30 Dec 2021 16:39:23 +0200
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
Subject: Re: [PATCH net-next v2 6/6] net: marvell: prestera: Implement
 initial inetaddr notifiers
Message-ID: <Yc3EmyltW1BVQv2n@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-7-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-7-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:31PM +0200, Yevhen Orlov wrote:
> Add inetaddr notifiers to support add/del IPv4 address on switchdev
> port. We create TRAP on first address, added on port and delete TRAP,
> when last address removed.
> Currently, driver supports only regular port to became routed.
> Other port type support will be added later
> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
> v1-->v2
> * Remove useless assigment in prestera_fix_tb_id
> ---
>  .../marvell/prestera/prestera_router.c        | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> index 0eb5f5e00e4e..483f0ba45ce0 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> @@ -4,16 +4,31 @@
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/inetdevice.h>
> +#include <net/switchdev.h>
>  
>  #include "prestera.h"
>  #include "prestera_router_hw.h"
>  
> +/* This util to be used, to convert kernel rules for default vr in hw_vr */
> +static u32 prestera_fix_tb_id(u32 tb_id)
> +{
> +	if (tb_id == RT_TABLE_UNSPEC ||
> +	    tb_id == RT_TABLE_LOCAL ||
> +	    tb_id == RT_TABLE_DEFAULT)
> +		tb_id = RT_TABLE_MAIN;
> +
> +	return tb_id;
> +}
> +
>  static int __prestera_inetaddr_port_event(struct net_device *port_dev,
>  					  unsigned long event,
>  					  struct netlink_ext_ack *extack)
>  {
>  	struct prestera_port *port = netdev_priv(port_dev);
>  	int err;
> +	struct prestera_rif_entry *re;
> +	struct prestera_rif_entry_key re_key = {};
> +	u32 kern_tb_id;

Reverse xmas tree

>  
>  	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
>  	if (err) {
> @@ -21,9 +36,34 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
>  		return err;
>  	}
>  
> +	kern_tb_id = l3mdev_fib_table(port_dev);
> +	re_key.iface.type = PRESTERA_IF_PORT_E;
> +	re_key.iface.dev_port.hw_dev_num  = port->dev_id;
> +	re_key.iface.dev_port.port_num  = port->hw_id;
> +	re = prestera_rif_entry_find(port->sw, &re_key);
> +
>  	switch (event) {
>  	case NETDEV_UP:
> +		if (re) {
> +			NL_SET_ERR_MSG_MOD(extack, "rif_entry already exist");

These messages are communicated to user space so use a message that is
more user friendly / informative

> +			return -EEXIST;
> +		}
> +		re = prestera_rif_entry_create(port->sw, &re_key,
> +					       prestera_fix_tb_id(kern_tb_id),
> +					       port_dev->dev_addr);
> +		if (!re) {
> +			NL_SET_ERR_MSG_MOD(extack, "Can't create rif_entry");
> +			return -EINVAL;
> +		}
> +		dev_hold(port_dev);

What is the purpose of this dev_hold()?

> +		break;
>  	case NETDEV_DOWN:
> +		if (!re) {
> +			NL_SET_ERR_MSG_MOD(extack, "rif_entry not exist");
> +			return -EEXIST;
> +		}
> +		prestera_rif_entry_destroy(port->sw, re);
> +		dev_put(port_dev);
>  		break;
>  	}
>  
> -- 
> 2.17.1
> 
