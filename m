Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70A12B9C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfECKht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:37:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35240 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfECKhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:37:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43AXxGJ011376;
        Fri, 3 May 2019 10:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=kNlNIR9Fo8ESlQnZzVfciYR2PSzGbl848JM9YPcBKYo=;
 b=SNWtejo0Pn5WyY8kfzS5pBy0rXnkeaePknhO5TudvQjauk3QuFK79+iawq49XVppmJmF
 V9pPPx4oabYneoc/h9ZFYqxQqj2kgpMXJaFPZUeFSQqW7pg/3w7deTYhjhL7K0GMPIfi
 xGCnFsiOhWSbwtNawnamBh628dYflZsP7q7CYZI9cy7NvoZud4lvNSAZ2g2AtcnDKFBO
 mY+VkeronehCITjGqFoPBiiw+qH9656hGKKcEmeklLaZ0yUd4pp0V4BfMQiTP7wQ+ueQ
 gcqD+0snD0LZD2zX1TNSvC1dQtIWwDhk4m1NHHJPUrNZbab50vBrSH2XaudOzaLGy8qq vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2s6xhynw4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 10:37:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43AXhUc024411;
        Fri, 3 May 2019 10:35:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2s7p8a8va6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 10:35:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43AZ9n3014091;
        Fri, 3 May 2019 10:35:10 GMT
Received: from kadam (/196.104.111.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 03:35:09 -0700
Date:   Fri, 3 May 2019 13:34:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 08/10] staging: octeon-ethernet: support
 of_get_mac_address new ERR_PTR error
Message-ID: <20190503103456.GF2269@kadam>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
 <1556870168-26864-9-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556870168-26864-9-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=933
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030067
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=955 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 09:56:05AM +0200, Petr Štetiar wrote:
> There was NVMEM support added to of_get_mac_address, so it could now
> return NULL and ERR_PTR encoded error values, so we need to adjust all
> current users of of_get_mac_address to this new fact.

Which commit added NVMEM support?  It hasn't hit net-next or linux-next
yet...  Very strange.

Why would of_get_mac_address() return a mix of NULL and error pointers?
In that situation, then NULL is a special kind of success like when you
request feature and the feature works but it's disabled by the user.  We
don't want to treat it as an error but we still can't return a pointer
to a feature we don't have...  It's hard for me to imagine how that
makes sense for getting a mac address.

At the very least, this patch needs a Fixes tag.

regards,
dan carpenter

