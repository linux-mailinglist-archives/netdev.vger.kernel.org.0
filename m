Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27C45F3C3D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 06:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJDEvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 00:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJDEvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 00:51:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1831F3D5BD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 21:51:19 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ofZtf-0003Qw-Or; Tue, 04 Oct 2022 06:51:11 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ofZtc-0002B7-RK; Tue, 04 Oct 2022 06:51:08 +0200
Date:   Tue, 4 Oct 2022 06:51:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kernel test robot <lkp@intel.com>,
        linux@rempel-privat.de, andrew@lunn.ch, bagasdotme@gmail.com
Subject: Re: [PATCH net-next] eth: pse: add missing static inlines
Message-ID: <20221004045108.GA14757@pengutronix.de>
References: <20221004040327.2034878-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221004040327.2034878-1-kuba@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 09:03:27PM -0700, Jakub Kicinski wrote:
> build bot reports missing 'static inline' qualifiers in the header.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
> CC: linux@rempel-privat.de
> CC: andrew@lunn.ch
> CC: bagasdotme@gmail.com
> CC: lkp@intel.com
> ---
>  include/linux/pse-pd/pse.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pse-pd/pse.h b/include/linux/pse-pd/pse.h
> index fd1a916eeeba..fb724c65c77b 100644
> --- a/include/linux/pse-pd/pse.h
> +++ b/include/linux/pse-pd/pse.h
> @@ -110,16 +110,16 @@ static inline void pse_control_put(struct pse_control *psec)
>  {
>  }
>  
> -int pse_ethtool_get_status(struct pse_control *psec,
> -			   struct netlink_ext_ack *extack,
> -			   struct pse_control_status *status)
> +static inline int pse_ethtool_get_status(struct pse_control *psec,
> +					 struct netlink_ext_ack *extack,
> +					 struct pse_control_status *status)
>  {
>  	return -ENOTSUPP;
>  }
>  
> -int pse_ethtool_set_config(struct pse_control *psec,
> -			   struct netlink_ext_ack *extack,
> -			   const struct pse_control_config *config)
> +static inline int pse_ethtool_set_config(struct pse_control *psec,
> +					 struct netlink_ext_ack *extack,
> +					 const struct pse_control_config *config)
>  {
>  	return -ENOTSUPP;
>  }
> -- 
> 2.37.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
