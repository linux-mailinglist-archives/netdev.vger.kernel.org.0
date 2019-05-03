Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4D13419
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfECTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 15:40:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfECTkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 15:40:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43JYGAQ072123;
        Fri, 3 May 2019 19:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=zFFPkeKwSl9qs1Gf/nl1E27H+7M/jhvO857WLR2q3z8=;
 b=DpzPTdixPg6Pvz4oxVTvXpjKc9fMHYkTYdnN/3EvhgQl9oc7m7+7zwpvacbG2Pvt9Gqp
 wbsiOQFJ+dGnW2iAlZkAmnr/SnJCy47E0fG3+koASSJTXJb1tecoiA7Q8qHVebMExiAV
 01GSQyjKN1QVJSSeiZj7gDWDmuyNOPVMnJfLmwpr1sr2B9YxHhq8ewd/pMvtzfxngigL
 EWvJ5huXM/tztCh99qYfnZNGjDi6jS0lmrnwY/We66Jn4+wGsF8kEsbAQSPu5rUt1Ak3
 DeHo0E1e3j6KAvOlB8hxyW2IfNGW8hV9h2JDOUhOLNRCyDMFdDYXokdP1JQ1oXMQbYrw RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2s6xhyrv9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:40:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43JcoHT142847;
        Fri, 3 May 2019 19:40:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s7rtcfb6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:40:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43JeCdp003869;
        Fri, 3 May 2019 19:40:14 GMT
Received: from kadam (/196.104.111.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 12:40:12 -0700
Date:   Fri, 3 May 2019 22:40:01 +0300
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
Message-ID: <20190503194001.GP2239@kadam>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
 <1556870168-26864-9-git-send-email-ynezz@true.cz>
 <20190503103456.GF2269@kadam>
 <20190503190730.GH71477@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503190730.GH71477@meh.true.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030128
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 09:07:30PM +0200, Petr Štetiar wrote:
> Dan Carpenter <dan.carpenter@oracle.com> [2019-05-03 13:34:56]:
> 
> Hi,
> 
> > On Fri, May 03, 2019 at 09:56:05AM +0200, Petr Štetiar wrote:
> > > There was NVMEM support added to of_get_mac_address, so it could now
> > > return NULL and ERR_PTR encoded error values, so we need to adjust all
> > > current users of of_get_mac_address to this new fact.
> > 
> > Which commit added NVMEM support?  It hasn't hit net-next or linux-next
> > yet...  Very strange.
> 
> this patch is a part of the patch series[1], where the 1st patch[2] adds this
> NVMEM support to of_get_mac_address and follow-up patches are adjusting
> current of_get_mac_address users to the new ERR_PTR return value.

Basically all the patches need to be folded together otherwise you're
breaking git bisectibility.  Imagine that we just apply patch #1 right?
Then all the callers will be broken.  It's not allowed.

regards,
dan carpenter

