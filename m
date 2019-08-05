Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B947581F7B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfHEOu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:50:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbfHEOu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:50:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x75EnCKA117512;
        Mon, 5 Aug 2019 14:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=o4Sx2x0eXTgf73+qaizMv0IXsCIax7sEnso5HFnT7vM=;
 b=HrG6ci9f4uSNhpivnGhN7aEX86wc/rvDklCeeFgyI6YTFBvbU+h/o1C41hsi+gu0Spqa
 CrgrhhlEN8Pw3bWnsQtLSdIPK0JR24YDMNRXyakQQcgSW7KwEyPqXv49M4x4jTyE2Zen
 I9alPxpPAq1dMwUUMXgV2UU3XAPcfNd1PwPxKFdhPX+yoI81jwwOTY2mwJuTxGOPhihi
 E3mSfDNt7UAUhW82a4CUjTH5LPW/7UnvDQJXn7jFP84aa9CXW8mQ65vRT8EBEAJ+yLMg
 qvsdhkJQ5WHQPIAqZTV5TJwnRBTQ/P3/K/Kaogns6luhuQEtpmvPI6QetOJNh3kps56V Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u52wqyp9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Aug 2019 14:50:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x75EmCQd121081;
        Mon, 5 Aug 2019 14:50:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u4ycu3t7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Aug 2019 14:50:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x75EogFg003623;
        Mon, 5 Aug 2019 14:50:43 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Aug 2019 07:50:42 -0700
Date:   Mon, 5 Aug 2019 17:50:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Thiago Bonotto <thbonotto@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org
Subject: Re: [PATCH] staging: isdn: remove unnecessary parentheses
Message-ID: <20190805145020.GE1974@kadam>
References: <20190802202323.27117-1-thbonotto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802202323.27117-1-thbonotto@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9340 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=787
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9340 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=840 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is obselete so we're just keeping it around for a couple
kernel releases and then deleting it.  We're not taking cleanups for it.

regards,
dan carpenter

