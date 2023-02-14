Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9356966DD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjBNO3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjBNO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:29:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA92B299;
        Tue, 14 Feb 2023 06:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QA+QFHpo/yr+1QPhF3GkUty/YChC2ZC03b0aBnBQUoI=; b=FrTvxM3brmQJh4xLkeaBwticuW
        DDjoHzS0HwU4A78K23AFPO5b7ArBn8MPmfXMwJ1FL8ZpeGz3I1RTVkwAAhc1SdFtxT/owPq4+eOvm
        wenpdn4DyQoy7xXtuLgWA8q2APKqK/l8FAXHNc2foi/UnFt4Eo0xeRgUfsvknI3DlJ4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRvgz-004xCy-Ly; Tue, 14 Feb 2023 14:49:57 +0100
Date:   Tue, 14 Feb 2023 14:49:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Message-ID: <Y+uRhY+tPZ9ePmwV@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > --- a/drivers/net/ethernet/freescale/fec_main.c
> > > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > > @@ -66,6 +66,7 @@
> > >  #include <linux/mfd/syscon.h>
> > >  #include <linux/regmap.h>
> > >  #include <soc/imx/cpuidle.h>
> > > +#include <net/pkt_sched.h>
> > 
> > Some alphabetic order? At least for new files :D
> > 
> I just want to keep the reverse Christmas tree style, although the whole #include
> order is already out of the style.

Reverse Christmass tree does not apply to includes, just local
variables. And the FEC driver has never been very good at it.

	   Andrew
