Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2FE84A53
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 13:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfHGLFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 07:05:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfHGLFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 07:05:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x77B4aEJ010731;
        Wed, 7 Aug 2019 11:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+jU+hkuie9yP8XEiBvhE5hja72DYo/HF1oIOUxCq/6Y=;
 b=RfeGUizYtX7YjDmw6IcBOoDm8Xk5qQ3smjLmW3xhrkLCdJLvFRUMhNv9Hxr/ocifuVts
 iOOZLoz29GpSSPuh99+hMq5IzavlD0gAzaTulp2X++ImkDTt06vrAS1328YXgWUCGIV3
 eqG78yoLUcfNBznIzS9YqjoLFfo/Xup6PRMJhydPDkcgUnyy8fcnAyJxB5OZxbrZ9Ajo
 XUd3vxWlTNqwtimiyyBNZM68tKpqej3UCcW1JM3UR8fCM/gqV0DC3DIAWEOSYvTIU/Kn
 kN2KQOS8RaosxF0VfK/Euqo2pB9YzGQYE7ebdJRPRxjvVryC3gjZJ0uZnYJw2QUz103W Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pujuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 11:05:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x77B3Qde083420;
        Wed, 7 Aug 2019 11:05:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u7667gugs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 11:05:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x77B5VfA030034;
        Wed, 7 Aug 2019 11:05:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 04:05:31 -0700
Date:   Wed, 7 Aug 2019 14:05:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giridhar Prasath R <cristianoprasath@gmail.com>
Cc:     isdn@linux-pingi.de, devel@driverdev.osuosl.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] staging: isdn: hysdn_procconf_init() remove parantheses
 from return value
Message-ID: <20190807110523.GN1974@kadam>
References: <20190807020331.19729-1-cristianoprasath@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807020331.19729-1-cristianoprasath@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=737
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=799 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908070123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is going to be deleted soon so we aren't accepting cleanups.

Thanks!

regards,
dan carpenter

