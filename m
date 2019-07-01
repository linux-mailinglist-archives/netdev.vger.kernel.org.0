Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BD35C1B9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfGARGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:06:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfGARGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:06:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GnVHE184109;
        Mon, 1 Jul 2019 17:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=//kE3HGevotjRzBV/hriCcx6l0RZ4zY4VASBxVowuG4=;
 b=wZPvpwY5ofow4evX/Z0MUQ8r5j3X441WpVI2gpBvZcseE7xZljDJgjsU4EsDfdJVlQBi
 JZSnr4CG92WsFJVWgXyMCEP3wFDM5CQ1OzRsqoZEeXQXxc8mzNPSfeWHJyGVvCJyurv0
 DTyDeJr4zo7WDQxXIo+fHLXqu5ImvDqK71luJ3HfmOi6Jr0TpwuooitdaIpKd8jKyDrS
 nrFXK4py4sytsrSDlhmUI/5KzXIJXpAYATMjNXetNBoTvHywCb135CbejrSm+9fOtiq4
 M/GQ8KDJjJkjuJYXCZ/weRML7ou20KU26R4TDOIa99j8tld/NrMJametKCFK2xCUu89c Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dxuv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 17:06:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GmMTc183150;
        Mon, 1 Jul 2019 17:06:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tebktsr6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 17:06:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61H65hR011799;
        Mon, 1 Jul 2019 17:06:05 GMT
Received: from [10.209.242.19] (/10.209.242.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 10:06:05 -0700
Subject: Re: [PATCH net-next 0/7] net/rds: RDMA fixes
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <f1f5ca90-a98a-4c7a-c918-ef26f02f6ee7@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <75993ceb-e7f8-24e9-a77a-d949b3f1a574@oracle.com>
Date:   Mon, 1 Jul 2019 10:06:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f1f5ca90-a98a-4c7a-c918-ef26f02f6ee7@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010201
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:39 AM, Gerd Rausch wrote:
> A number of net/rds fixes necessary to make "rds_rdma.ko"
> pass some basic Oracle internal tests.
> 
> Gerd Rausch (7):
>    net/rds: Give fr_state a chance to transition to FRMR_IS_FREE
>    net/rds: Get rid of "wait_clean_list_grace" and add locking
>    net/rds: Wait for the FRMR_IS_FREE (or FRMR_IS_STALE) transition after
>      posting IB_WR_LOCAL_INV
>    net/rds: Fix NULL/ERR_PTR inconsistency
>    net/rds: Set fr_state only to FRMR_IS_FREE if IB_WR_LOCAL_INV had been
>      successful
>    net/rds: Keep track of and wait for FRWR segments in use upon shutdown
>    net/rds: Initialize ic->i_fastreg_wrs upon allocation
> 
Will apply these on top of earlier few fixes after going through them.
Thanks for posting them out.

Regards,
Santosh
