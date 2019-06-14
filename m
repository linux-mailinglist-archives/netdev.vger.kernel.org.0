Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E0A453AE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfFNEoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:44:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNEoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:44:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5E4ZH0g059549;
        Fri, 14 Jun 2019 04:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=q04xRDu6igdpOSRMxde5qEAa3x6Mql9CiEYVvoEPLv4=;
 b=sScqjVT5hx7Oh8HF6jjYSH/EfqsP4/BLhSoaU+nHIqsI81OSTBAac+kjwB7AHqte0vEF
 6TRHYX0vtUVsk+L92veVHdE8rXcWTnNtk/nt+8Sk/oKKA3imYHYfbltF54nlH72kSXNH
 eaZlEoWKtQbAE3CcKPmBfmJaJBUoEk3A1/ljMBcoeB1BRQ8OoRjdgOB/g7t/qwmrgA9w
 dVlci04l1sKBlkSRwOh8T/0+Ev0yZn1ixJaoDGvcg6Cm+eOpCAeF6D26GdUYOmGt5mBp
 CeQJL1wM+Urk7CgLH9X7aObFOVxXDkFIjDUdbdeSYg8gsVoTUBP4ZGh4Rvta1HSxBaA7 AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nr54df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 04:43:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5E4h5R2064914;
        Fri, 14 Jun 2019 04:43:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t0p9ssrkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 04:43:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5E4ha3f023423;
        Fri, 14 Jun 2019 04:43:36 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Jun 2019 21:43:35 -0700
Date:   Fri, 14 Jun 2019 07:43:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ruslan Babayev <ruslan@babayev.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: sfp: clean up a condition
Message-ID: <20190614044320.GI1893@kadam>
References: <20190613065102.GA16334@mwanda>
 <20190613180016.ekg55vzkuczapfpl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180016.ekg55vzkuczapfpl@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9287 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906140039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9287 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906140038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 07:00:16PM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Jun 13, 2019 at 09:51:02AM +0300, Dan Carpenter wrote:
> > The acpi_node_get_property_reference() doesn't return ACPI error codes,
> > it just returns regular negative kernel error codes.  This patch doesn't
> > affect run time, it's just a clean up.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/phy/sfp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index a991c80e6567..8a99307c1c39 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -1848,7 +1848,7 @@ static int sfp_probe(struct platform_device *pdev)
> >  		int ret;
> >  
> >  		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
> > -		if (ACPI_FAILURE(ret) || !is_acpi_device_node(args.fwnode)) {
> > +		if (ret || !is_acpi_device_node(args.fwnode)) {
> >  			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
> >  			return -ENODEV;
> 
> If "ret" is a Linux error code, should we print its value when reporting
> the error so we know why the failure occurred, and propagate the error
> code?

We can't propagate the error code because we might have failed because
acpi_node_get_property_reference() succeeded but it's not a device node.

regards,
dan carpenter

