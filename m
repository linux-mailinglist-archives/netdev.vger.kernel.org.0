Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442B0450351
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKOLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 06:25:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231486AbhKOLXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 06:23:10 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBAfp0019208;
        Mon, 15 Nov 2021 11:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7A8WJnxEub7TjzKh/8V7/VNswiioRZU7+WSJNf5i2co=;
 b=dPjYjYyVgqesStpkaQIOwX0749NZD6T2zUgGQ3i/3V7RQvBO1fiVxgQF4GadxSRes+ho
 b26A4EIuDkm0dsLVqGDwBVBnvAZ88p37N4k2/iEt41TlAaxKsoTVERKPRoilgOrDSTAZ
 /JOSqnf1CDUyZuXsfhTMhGB2d7BszeiaVPgt4ikRixg+/rUwWW7AYptEYEUrDIBYJoD8
 BwCJPy6OWVdRwGBUTwtPSx5j9k9X/pgrHMV/NmG3vySTm1QfG8Ix8nGngOPn7TlDwyL2
 8Cbw2oz9sLEu6aiGW2IsXb2tF8djMo+KzFlzyiitxAP39U+miQEVcVXsDAc8JAQSP4dE SA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbkwq3cm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:19:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBDX9c026453;
        Mon, 15 Nov 2021 11:19:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca509mpmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:19:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFBCwYw64094594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:12:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ECF64C05C;
        Mon, 15 Nov 2021 11:19:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC25B4C044;
        Mon, 15 Nov 2021 11:19:49 +0000 (GMT)
Received: from [9.171.2.161] (unknown [9.171.2.161])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:19:49 +0000 (GMT)
Message-ID: <a12f593a-a9e4-44bf-1740-92303ceb1dc3@linux.ibm.com>
Date:   Mon, 15 Nov 2021 13:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/6] net: ocelot: add support to get port mac from
 device-tree
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-2-clement.leger@bootlin.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211103091943.3878621-2-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H6wf7pqRbxGK-vgjJd6SfEEuOkcEhfVD
X-Proofpoint-ORIG-GUID: H6wf7pqRbxGK-vgjJd6SfEEuOkcEhfVD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 clxscore=1011 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.11.21 11:19, Clément Léger wrote:
> Add support to get mac from device-tree using of_get_mac_address.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index eaeba60b1bba..d76def435b23 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1704,7 +1704,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
>  		NETIF_F_HW_TC;
>  	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
>  
> -	eth_hw_addr_gen(dev, ocelot->base_mac, port);
> +	err = of_get_mac_address(portnp, dev->dev_addr);

of_get_ethdev_address() maybe, so that this gets routed through Jakub's fancy
new eth_hw_addr_set() infrastructure?

> +	if (err)
> +		eth_hw_addr_gen(dev, ocelot->base_mac, port);
> +
>  	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
>  			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
>  
> 

