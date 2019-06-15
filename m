Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065FB46EAA
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 09:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfFOHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 03:10:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfFOHKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 03:10:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5F79t0r018786;
        Sat, 15 Jun 2019 07:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Jk075PwM81R3A0PbapUfwNgkRm9/kUVtWd6WglwwUNE=;
 b=LGrn7veXH5Dgj3GGY1SEZpprO1bJcq6Gc0qe6GNytBq9sQyjiUzq74vdJPjl7PisQpyH
 bail1QQQ944yVwZ8WiaIgo77fVXeTKvVRKn8CCKxQ5PwaOUT59KwaOpeUs2sohadHyCL
 JBqSpdAqcUIkB39jxich6GoSwARHrHlBUUsK6tf/TPjLlcsQe4NYN1vcyAOKvAx2cLkC
 Jo5AqcJ66uoQ4NqEgVp6KVNbhPsogkc1ZeuxswfrKvQbeQtTQU1gYzRUqNZ2qhgJQcNt
 W21MrpJt5pBO3YIhchgmwYM/JBM2cABIra4K3nBkMmlNtwFre/ME2J4Wmly4mKFZJc6m dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t4saq086q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jun 2019 07:09:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5F792V3134106;
        Sat, 15 Jun 2019 07:09:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t4pqakfh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jun 2019 07:09:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5F79ifH027182;
        Sat, 15 Jun 2019 07:09:44 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 15 Jun 2019 00:09:43 -0700
Date:   Sat, 15 Jun 2019 10:09:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux@armlinux.org.uk, ruslan@babayev.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: sfp: clean up a condition
Message-ID: <20190615070935.GM1893@kadam>
References: <20190613065102.GA16334@mwanda>
 <20190614.192148.1227986231677887217.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614.192148.1227986231677887217.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9288 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906150065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9288 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906150065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 07:21:48PM -0700, David Miller wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Thu, 13 Jun 2019 09:51:02 +0300
> 
> > The acpi_node_get_property_reference() doesn't return ACPI error codes,
> > it just returns regular negative kernel error codes.  This patch doesn't
> > affect run time, it's just a clean up.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Applied to net-next.

I meant to say net-next but I made a typo.  :/

regards,
dan carpenter
