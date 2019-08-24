Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A2B9BA11
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfHXBZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:25:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34292 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHXBZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:25:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O1NgHR035260;
        Sat, 24 Aug 2019 01:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VajAlk3DhGVLXoPxquAgc0wsi/e89rnPPxSFpDfUG1M=;
 b=lvsvfe9kc5ZHwaXzvl7t6BNHXwkE6JgMNwkwUVzD+wgnrnk6RtfeoBpjmbCCWTE9nLWM
 WM2cY3b85kompAk6sF09WSQxdC0Gy3OqMStlhUE9YvfJIR/mEK9QzjtlIudFgnfRyDhq
 GLKILI+ToCpOkTj/DXQVfYpxcK+zZSxuPZY0hHp/z9fhqZrKLqYNwrGyTTdvnJYbGcJI
 IWx0+tRTjY7JEMSUQnhkwX5zYa0xg4sTwDE26FoPCncLqtp4L5X6vrd4FcmSOPgQKGCZ
 JzlewypNNcGjBx+Kvx0OxngSRk28RTIbqmjgoAY0uBqznjWf/pZpfKioElVnX0R3Is/l Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ue9hq7j55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 01:25:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O1NSTK097695;
        Sat, 24 Aug 2019 01:25:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ujtbu1j8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Aug 2019 01:25:41 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7O1PfJu102010;
        Sat, 24 Aug 2019 01:25:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ujtbu1j8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 01:25:41 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7O1Pd7s029285;
        Sat, 24 Aug 2019 01:25:39 GMT
Received: from [10.11.38.58] (/10.11.38.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 18:25:38 -0700
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
To:     Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, gerd.rausch@oracle.com
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <6e5bc371-d613-e8f7-7b57-0b1bc2e10e9d@oracle.com>
Date:   Fri, 23 Aug 2019 18:25:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908240013
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 6:04 PM, Zhu Yanjun wrote:
>  From IB specific 7.6.5 SERVICE LEVEL, Service Level (SL)
> is used to identify different flows within an IBA subnet.
> It is carried in the local route header of the packet.
> 
> Before this commit, run "rds-info -I". The outputs are as
> below:
> "
> RDS IB Connections:
>   LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
> 192.2.95.3  192.2.95.1  2   0  fe80::21:28:1a:39  fe80::21:28:10:b9
> 192.2.95.3  192.2.95.1  1   0  fe80::21:28:1a:39  fe80::21:28:10:b9
> 192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39  fe80::21:28:10:b9
> "
> After this commit, the output is as below:
> "
> RDS IB Connections:
>   LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
> 192.2.95.3  192.2.95.1  2   2  fe80::21:28:1a:39  fe80::21:28:10:b9
> 192.2.95.3  192.2.95.1  1   1  fe80::21:28:1a:39  fe80::21:28:10:b9
> 192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39  fe80::21:28:10:b9
> "
> 
> The commit fe3475af3bdf ("net: rds: add per rds connection cache
> statistics") adds cache_allocs in struct rds_info_rdma_connection
> as below:
> struct rds_info_rdma_connection {
> ...
>          __u32           rdma_mr_max;
>          __u32           rdma_mr_size;
>          __u8            tos;
>          __u32           cache_allocs;
>   };
> The peer struct in rds-tools of struct rds_info_rdma_connection is as
> below:
> struct rds_info_rdma_connection {
> ...
>          uint32_t        rdma_mr_max;
>          uint32_t        rdma_mr_size;
>          uint8_t         tos;
>          uint8_t         sl;
>          uint32_t        cache_allocs;
> };
> The difference between userspace and kernel is the member variable sl.
> In the kernel struct, the member variable sl is missing. This will
> introduce risks. So it is necessary to use this commit to avoid this risk.
> 
> Fixes: fe3475af3bdf ("net: rds: add per rds connection cache statistics")
> CC: Joe Jin <joe.jin@oracle.com>
> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
> Suggested-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: fix typos in commit logs.
> ---
I did ask you when ypu posted the patch about whether you did
backward compatibility tests for which you said, you did all the
tests and said "So do not worry about backward compatibility.  This
commit will work well with older rds-tools2.0.5 and 2.0.6."

https://www.spinics.net/lists/netdev/msg574691.html

I was worried about exactly such issue as described in commit.

Anyways thanks for the fixup patch. Should be applied to stable
as well.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Regards,
Santosh

