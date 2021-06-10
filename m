Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F03A2478
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhFJG0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 02:26:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53658 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJG0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 02:26:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A6G35i022915;
        Thu, 10 Jun 2021 06:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cxapp2OSP/95LVw7tdGcnxuS5fjaY5U8T8+WTbN4vKc=;
 b=uIw5FFiRdSzgD367etO1V9hXexwlkTym9fK4mzTcT8Vb5ZY3P1GdWRo54CbYfcHiNGLF
 KNcuue+b68ebB/SR36r0PbymVaE3ujg6jHN3cAhkKxfp87ors/4b4k0mHrRTnVnQdebx
 zsBa0rBoMhaj54gdLUGCJxkm4KFcK5eGeYYb3+zbzA005+SQdQ2t7jZn7iPEjOiAilR5
 ilKLRIO1hjOVP8Ltf2TrB9K7pza6UESji7JhFSQhYhccURtoXu+UQbGFNDSR4R21U2/k
 626siu30xbnbDcOOc2NSYJFv+rQMaCctfRCBWH+4fPRCvVRmyyRYYSg1T20S9OhBSlHa 9A== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 392yvb88md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:24:17 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15A6OEvB159994;
        Thu, 10 Jun 2021 06:24:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38yyaca6xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:24:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15A6HYaC148013;
        Thu, 10 Jun 2021 06:24:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38yyaca6wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:24:15 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15A6O89j017890;
        Thu, 10 Jun 2021 06:24:08 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 23:24:07 -0700
Date:   Thu, 10 Jun 2021 09:23:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: Fix assigned yet unused return
 code rc
Message-ID: <20210610062358.GH1955@kadam>
References: <20210609174353.298731-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609174353.298731-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: hnzEYv2Q0scNvl_zw9nEKYxrm9K3MU53
X-Proofpoint-GUID: hnzEYv2Q0scNvl_zw9nEKYxrm9K3MU53
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 06:43:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The return code variable rc is being set to return error values in two
> places in sja1105_mdiobus_base_tx_register and yet it is not being
> returned, the function always returns 0 instead. Fix this by replacing
> the return 0 with the return code rc.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> index 8dfd06318b23..08517c70cb48 100644
> --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> @@ -171,7 +171,7 @@ static int sja1105_mdiobus_base_tx_register(struct sja1105_private *priv,
>  out_put_np:
>  	of_node_put(np);
>  
> -	return 0;
> +	return rc;

Should this function really return success if of_device_is_available()?

regards,
dan carpenter

