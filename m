Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D9022D18C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 23:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGXV6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 17:58:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXV6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 17:58:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OLq4sm002221;
        Fri, 24 Jul 2020 21:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1oBpwicAEdCFtd8cODZuHTMOvYVeTmLh/YcPQDEdJNc=;
 b=ayj+gGQxh8t1wRDZ0NHcmvj5ruFMbbhoDIRWrhsqiGKOUFwzCcusI1w27U7G0Y5jxmCA
 r2uI2s/O6DEG1E2Jl8yPoVf/sHteiPufnJEN814y47ye91X2IuGXI33Ee27YztDnx+Mw
 2d0HddH9jHUDZInOXi5meqUhKYZHeYLw0vn75uuLvFCP4Fz2OZwkAoXOLy85kQCSLLQG
 8Caju+WksZUvF5QicYL45BhtkehuUz6Rnb7yciNseGcrCOpaBy+9iN9dhedKAqi3UkFh
 UCrdDbgGqY78R1fjPEVoThYPMg7OVXGZlwzizbdpzt7YN2BVWVmxMgu74Xd3Ac5/yxlf rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32d6kt5ka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 21:57:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OLrC0K071765;
        Fri, 24 Jul 2020 21:55:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32g7xv0208-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 21:55:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06OLtMWK017794;
        Fri, 24 Jul 2020 21:55:22 GMT
Received: from dhcp-10-159-245-90.vpn.oracle.com (/10.159.245.90)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 14:55:22 -0700
Subject: Re: [RESEND PATCH] ARM: dts: keystone-k2g-evm: fix rgmii phy-mode for
 ksz9031 phy
To:     "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20200724214221.28125-1-grygorii.strashko@ti.com>
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <a91d2bad-b794-fe07-679a-e5096aa5ace8@oracle.com>
Date:   Fri, 24 Jul 2020 14:55:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200724214221.28125-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=3 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd, Olof,

On 7/24/20 2:42 PM, Grygorii Strashko wrote:
> Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
> KSZ9031 PHY") the networking is broken on keystone-k2g-evm board.
> 
> The above board have phy-mode = "rgmii-id" and it is worked before because
> KSZ9031 PHY started with default RGMII internal delays configuration (TX
> off, RX on 1.2 ns) and MAC provided TX delay by default.
> After above commit, the KSZ9031 PHY starts handling phy mode properly and
> enables both RX and TX delays, as result networking is become broken.
> 
> Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
> behavior.
> 
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Philippe Schenker <philippe.schenker@toradex.com>
> Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Fix for one more broken TI board with KSZ9031 PHY.
Can you please apply this patch to your v5.8 fixes branch and send it 
upstream ? Without the fix K2G EVM board is broken with v5.8.

Am hoping you can pick this up with pull request since it just one
patch.

Regards,
Santosh

