Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81B3A32F1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFJSWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:22:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13996 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230307AbhFJSV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:21:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AICnwl032589;
        Thu, 10 Jun 2021 18:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=b9Jx40n4EZl0KxRz6LYxvDgVi0EEguSU/bHr4pn0T6s=;
 b=gwM8cpQqTntpgnj9csTspbJx8/8YNzTmKIizYGiz/K07Vk0RsgKsag3aoUjx0uEggQN8
 gyRW4ifCll16ztR3Vgt0ubJhpmjtK45IYYkPEEDpWCBGyeTg08HVicqn2mv+fcXGBoNF
 2yiNsReIHj4+ZgHXy84Yr2mkaZZW2PuE0hRv+GZV5Dyru9DlCCvurB/tR2wToZxzKP6C
 i8wSDDlgFJMX91wY4HOamQUnT/qZxvccwU47rM07pzyD1oO4Mu89xq/p2MCjnkZ0zEgC
 harpRR7gRur0nTXUvHqFpe9oLPGKMJ948tMl/twQ8BFRfaNqVJToKHcnP2B+kOt3B0Of Rw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 393mkb82kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 18:19:54 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15AIJrae047356;
        Thu, 10 Jun 2021 18:19:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38yxcwtv3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 18:19:53 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15AIJqEV047341;
        Thu, 10 Jun 2021 18:19:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 38yxcwtv2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 18:19:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15AIJnMG014769;
        Thu, 10 Jun 2021 18:19:49 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Jun 2021 11:19:48 -0700
Date:   Thu, 10 Jun 2021 21:19:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: Fix assigned yet unused return
 code rc
Message-ID: <20210610181937.GA10983@kadam>
References: <20210609174353.298731-1-colin.king@canonical.com>
 <20210610062358.GH1955@kadam>
 <20210610175124.m56tftv4qjuyxkiq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610175124.m56tftv4qjuyxkiq@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: OGh04CUjCramFeP3ewrLWSEr4fanSRNf
X-Proofpoint-GUID: OGh04CUjCramFeP3ewrLWSEr4fanSRNf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 08:51:24PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 10, 2021 at 09:23:58AM +0300, Dan Carpenter wrote:
> > On Wed, Jun 09, 2021 at 06:43:53PM +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > The return code variable rc is being set to return error values in two
> > > places in sja1105_mdiobus_base_tx_register and yet it is not being
> > > returned, the function always returns 0 instead. Fix this by replacing
> > > the return 0 with the return code rc.
> > > 
> > > Addresses-Coverity: ("Unused value")
> > > Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >  drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > > index 8dfd06318b23..08517c70cb48 100644
> > > --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> > > +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > > @@ -171,7 +171,7 @@ static int sja1105_mdiobus_base_tx_register(struct sja1105_private *priv,
> > >  out_put_np:
> > >  	of_node_put(np);
> > >  
> > > -	return 0;
> > > +	return rc;
> > 
> > Should this function really return success if of_device_is_available()?
> 
> If _not_ of_device_is_available you mean? Yup. Nothing wrong with not
> having an internal MDIO bus. This is a driver which supports switches
> that do and switches that don't, and even if the node exists, it may
> have status = "disabled", which is again fine.
> Or am I misunderstanding the question?

Yeah.  I left out the "!".  That answers the question.  Thanks!

regards,
dan carpenter
