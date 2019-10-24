Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E65E2C6E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfJXIrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:47:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730201AbfJXIrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 04:47:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O8hTNO077857;
        Thu, 24 Oct 2019 08:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RfrRaJR/ahcgDoFWrwiWyd18m7gro65Gj0xa2vHPqAI=;
 b=H7hU1GOa/YMyPthCNnuriytW00qqgcxZVlTveDy8v0CocFyuou45lLAdFIs/LOGSC0sf
 4gZYsCyATGaRoqZn8Z+Vui2ISaZe/caSH3vNKDqarduKLZ8TZVY6Y7v3EOZkFtpnkCv3
 VjhStC8ugo3ZJUw8LIKZ6rXMpeDuJLdlxJyaF1vqabK6aOflAo6RPOjE+vDLPbZXCQWY
 iojgh64Arhx1CZ4Tecsubfkt3IfxIxOsD7y6CqHfQa9aVu5qVsZ+uoWl4Qpb9iKbhbli
 IXKIBQ5od+a82jCFHAq5Ep2SfsFWcXe1JtY8V+m8E0KBsXqeuN0K/Ei1u0RDWz33d1y0 Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteq25ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 08:46:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O8cshv191023;
        Thu, 24 Oct 2019 08:46:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vtjkj17nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 08:46:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9O8kn3H021468;
        Thu, 24 Oct 2019 08:46:49 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 01:46:48 -0700
Date:   Thu, 24 Oct 2019 11:46:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
Message-ID: <20191024083744.GE17535@kadam>
References: <20191022011817.29183-1-andrew@lunn.ch>
 <20191023.191320.2221170454789484606.davem@davemloft.net>
 <20191024024935.GM5707@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024024935.GM5707@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 04:49:35AM +0200, Andrew Lunn wrote:
> On Wed, Oct 23, 2019 at 07:13:20PM -0700, David Miller wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Tue, 22 Oct 2019 03:18:17 +0200
> > 
> > > Before this change of_get_phy_mode() returned an enum,
> > > phy_interface_t. On error, -ENODEV etc, is returned. If the result of
> > > the function is stored in a variable of type phy_interface_t, and the
> > > compiler has decided to represent this as an unsigned int, comparision
> > > with -ENODEV etc, is a signed vs unsigned comparision.
> > > 
> > > Fix this problem by changing the API. Make the function return an
> > > error, or 0 on success, and pass a pointer, of type phy_interface_t,
> > > where the phy mode should be stored.
> > > 
> > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > So now we have code that uses the 'interface' value without checking
> > the error return value which means it's potentially uninitialized.
> 
> Hi David
> 
> If it did not check before, it was passing -ENODEV to something. So it
> was already broken. But an uninitialized value is worse. I can see
> about adding error checking where there are none.
> 

We could make it __must_check.  We don't use that annotation much
outside of core functions, but I don't see a downside to it.  Smatch and
0day bot will hopefully catch most of the uninitialized variables as is.

regards,
dan carpenter

