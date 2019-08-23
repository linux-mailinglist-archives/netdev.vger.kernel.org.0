Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB3A9B629
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405270AbfHWSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:18:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404909AbfHWSSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:18:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NI9DZH111071;
        Fri, 23 Aug 2019 18:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qw/+dBxi0xaQHO0HdiHxHCSOHZ9NpH1CDedfvIfubgQ=;
 b=aR6zyseqqygJLIcScad8RF7DHuGpgXG8TzisC+VvKKvrTruISeDuIhWfKxal5I7s6Fez
 Is35lFGaIb6MTEA4nPDDLts6UCUD3qFAczueK5tFywtJJGOTihmheISibPDCf8GOw8LZ
 gtIW8nmDDO/qkxJzdKrLScE8eHdxrMHNM0tWRuZLPAKvGCLRauP3CZfvftfJ0bGtuFKF
 6r24yfBDyaJtQPXHkrLplxBRYsdPhgm+6clb/nJPuyThYsLfX/efYWCgGtz2GUK+QN27
 DxtaxIohKTIWCLGARQPyt8pPT7+YmW7M8xr6OqSGDe3m5mcRnVqKBd3mTm+fXsa/5JMS Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7recdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 18:18:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NI84lV176247;
        Fri, 23 Aug 2019 18:18:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ujhvcfu47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Aug 2019 18:18:01 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7NII1dW010963;
        Fri, 23 Aug 2019 18:18:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ujhvcfu3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 18:18:01 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NII0lR014780;
        Fri, 23 Aug 2019 18:18:00 GMT
Received: from [10.209.243.58] (/10.209.243.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 11:18:00 -0700
Subject: Re: [PATCH net-next] net/rds: Whitelist rdma_cookie and rx_tstamp for
 usercopy
To:     Dag Moxnes <dag.moxnes@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     davem@davemloft.net
References: <1566568998-26222-1-git-send-email-dag.moxnes@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d304ac22-1b04-6ff0-c36d-cd6605f341f8@oracle.com>
Date:   Fri, 23 Aug 2019 11:17:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1566568998-26222-1-git-send-email-dag.moxnes@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 7:03 AM, Dag Moxnes wrote:
> Add the RDMA cookie and RX timestamp to the usercopy whitelist.
> 
> After the introduction of hardened usercopy whitelisting
> (https://lwn.net/Articles/727322/), a warning is displayed when the
> RDMA cookie or RX timestamp is copied to userspace:
> 
> kernel: WARNING: CPU: 3 PID: 5750 at
> mm/usercopy.c:81 usercopy_warn+0x8e/0xa6
> [...]
> kernel: Call Trace:
> kernel: __check_heap_object+0xb8/0x11b
> kernel: __check_object_size+0xe3/0x1bc
> kernel: put_cmsg+0x95/0x115
> kernel: rds_recvmsg+0x43d/0x620 [rds]
> kernel: sock_recvmsg+0x43/0x4a
> kernel: ___sys_recvmsg+0xda/0x1e6
> kernel: ? __handle_mm_fault+0xcae/0xf79
> kernel: __sys_recvmsg+0x51/0x8a
> kernel: SyS_recvmsg+0x12/0x1c
> kernel: do_syscall_64+0x79/0x1ae
> 
> When the whitelisting feature was introduced, the memory for the RDMA
> cookie and RX timestamp in RDS was not added to the whitelist, causing
> the warning above.
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> Tested-by: jenny.x.xu@oracle.com
> ---
Thanks Dag to get this out on list.
You might have to fix the Tested-by tag.
Tested-by: Jenny <jenny.x.xu@oracle.com

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>



