Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981BB29D8B8
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgJ1WgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:36:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387678AbgJ1WeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:34:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SAYjhV164632;
        Wed, 28 Oct 2020 10:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ozdXlFYXaQsb4RcCSPg5tS7ML5aca7VnqAE1SSL3wjA=;
 b=P1GfKVVuy2PBBO0yBlQ5B+bLVaz7tvTTRCvaaknjaUQEA7DlW4ozyJz5VqACPiBu6lZU
 a3606LFOJZq6rlaI8QQCLWynTslU3zc6nJbl+Bi3yWSr/rVWtJhCj4xFBe9QeV6kNfcn
 arlcsL69M7tNHqpEVGU/QVRsYXhqUvV1Rmb+sAL2CsNq7Bq+rLcKkKX2CB8nOnan32rh
 sI+FCxbK8iSZRgY32flh4lhxmpGhDn930X3FSRgC3GaIHlxgyamYN4bbu3QMOv+2+3t5
 /wCxd0+1Xm2JnqzrwQXVh2jnKo7pZrYYovphfQ2nVOJFTO/4LOERRxeWWm8PqcMEysoL Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm44698-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 10:35:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09SAQ5vv072316;
        Wed, 28 Oct 2020 10:35:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5y6073-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 10:35:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09SAZ5PP007506;
        Wed, 28 Oct 2020 10:35:05 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 03:35:03 -0700
Date:   Wed, 28 Oct 2020 13:34:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] wimax: move out to staging
Message-ID: <20201028103456.GB1042@kadam>
References: <20201027212448.454129-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027212448.454129-1-arnd@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280070
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:20:13PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are no known users of this driver as of October 2020, and it will
> be removed unless someone turns out to still need it in future releases.
> 
> According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
> have been many public wimax networks, but it appears that these entries
> are all stale, after everyone has migrated to LTE or discontinued their
> service altogether.

Wimax is still pretty common in Africa.  But you have to buy an outdoor
antenae with all the software on it and an ethernet cable into your
house.  I don't know what software the antennaes are using.  Probably
Linux but with an out of tree kernel module is my guess.

regards,
dan carpenter

