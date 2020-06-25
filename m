Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C779E20A3F6
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406760AbgFYR1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:27:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404701AbgFYR13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:27:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PHCDZh099646;
        Thu, 25 Jun 2020 17:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+pvB/A8LWwdNByzI7FsKbhm1/eHEC5HuhI3A2agb8qs=;
 b=rFqrCb5gOv7q5OJvCCXmCzWMafM4bXqiFGBMS0Xz+DHnlOFOxj4fwipdBrcnBl5A3zCd
 yexlparAYDXT4ROTAma7KWCCTTMYWbOzmz1pa2z+HSL33j3jM51wkdNf3KWonAIybGfX
 ZJvvA9JoELLphNhMDuvaH7Y5QorDK47CsEL3WVilmXxv+Jzsqa/WCS+78CH35jH7Nvrb
 0P60KYV9U9Q9qOfpMTRYcxUBdsxt6Rb9ZIwGNFRr3SKocyO+EdsKUa9cIpnNC0TkVg52
 BatkBb+QhNs5oj667P8tzPS6cg20Xidhf76+CIG4YOIhW3YDrksgsae5VeTznOyxWG7x 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uuststvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 17:27:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PHDRuc033781;
        Thu, 25 Jun 2020 17:25:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uursv9bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 17:25:18 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PHPHAu004095;
        Thu, 25 Jun 2020 17:25:17 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 17:25:17 +0000
Date:   Thu, 25 Jun 2020 20:25:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] fix trailing */ in block comment
Message-ID: <20200625172510.GF2549@kadam>
References: <20200625153614.63912-1-coiby.xu@gmail.com>
 <20200625153614.63912-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625153614.63912-2-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject isn't right (no subsystem prefix) and we need a commit
message.

regards,
dan carpenter

