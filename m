Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C2D3DDC
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfJKLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 07:00:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfJKLAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 07:00:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9BAwqRu041513;
        Fri, 11 Oct 2019 11:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RU6H+u3W39wz6yAaxIiIbW2yjZ/yh1LsvlPU+bZjROg=;
 b=MuWL7oGHEXrLsuUyyIEUiZNUPGnntbBNgjYDTnj+opzbl0ww0EbjHrQFZ7N47eJ140UB
 k4kWd7wZxq/9oU5RlavY/dSNVB+REVwZ1sA4+jc2MViCFEBdRU8aOYlk5PIg8Zd8yuY9
 UvrlvUuNmXgkyZyYcgCAQNGXRcVvli0dBrvZZhaAY60r3pNhINV4siUy1EACmSRwxFRt
 FibTfKtoIrRf6pZpC2O7M9OQKUu6PyVJaX30S18uVBpFGTk5ZldsL2ZeSHln4ovh7viT
 L7n+/qhxdMurKJocp48sgz9+juQnx4lLUA7ULMxDM06i4a78le22hOCBhBvykLl5iuK2 mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vekts0m1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 11:00:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9BAxSAo171121;
        Fri, 11 Oct 2019 11:00:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vjdykryvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 11:00:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9BB0RDr004965;
        Fri, 11 Oct 2019 11:00:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 11:00:26 +0000
Date:   Fri, 11 Oct 2019 14:00:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wambui Karuga <wambui.karugax@gmail.com>
Cc:     outreachy-kernel@googlegroups.com, devel@driverdev.osuosl.org,
        isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] staging: isdn: remove assignment in if conditionals
Message-ID: <20191011110019.GC4774@kadam>
References: <20191011072044.7022-1-wambui.karugax@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011072044.7022-1-wambui.karugax@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9406 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910110105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9406 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910110105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This ISDN stuff is going to be deleted soon.  Just leave it as is.

regards,
dan carpenter

