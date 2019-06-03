Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3755B335E1
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfFCRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:02:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfFCRCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:02:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53Gsvmi093408;
        Mon, 3 Jun 2019 17:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xz2HJFnT8wb9SqHyooxFX4/olf0IgzBYli9hToZDbmU=;
 b=dp3Ts72oc3GQ5cN6XivE76EpBVX+lmNBS9Ys4dJK29oHjSEBDA/SxD0VittXhj8RgkRP
 skadeqK177zq8s6m/1VzcSUeUtJZv5flnvt6jg3gytQJo61+oJt+8cbmVX/7F5gJGPx4
 RgtyR5Pdu/84sobcw4FfuD8cssIcY90riCfgrKamX2ia5eUiprPgiy/qzmpNhIF6unXT
 Wc9yUO2wgLbQmqr6UEER6tGYTv6YOT8BJJpJR1BI9eO81KdUv5+IgtBm3G9Q6YoALup2
 jw+vwMt/fO2chq7AGjpkWc8CgD/4u2ljsKkIS3TktAtJP5bbEr6aloe2iUQLf5RzKioH 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0q87a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 17:02:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53H1ZOv162043;
        Mon, 3 Jun 2019 17:02:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2svbbv7vgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 17:02:11 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x53H2BXN163471;
        Mon, 3 Jun 2019 17:02:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2svbbv7vgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 17:02:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x53H2ADY030727;
        Mon, 3 Jun 2019 17:02:10 GMT
Received: from [10.11.0.40] (/10.11.0.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 10:02:10 -0700
Subject: Re: [PATCHv2 1/1] net: rds: add per rds connection cache statistics
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
References: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f90dcef6-aa80-b31a-c999-2b7224960600@oracle.com>
Date:   Mon, 3 Jun 2019 10:02:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/19 9:28 PM, Zhu Yanjun wrote:
> The variable cache_allocs is to indicate how many frags (KiB) are in one
> rds connection frag cache.
> The command "rds-info -Iv" will output the rds connection cache
> statistics as below:
> "
> RDS IB Connections:
>        LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
>        1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
>        send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
>        rdma_mr_size=257, cache_allocs=12
> "
> This means that there are about 12KiB frag in this rds connection frag
> cache.
> Since rds.h in rds-tools is not related with the kernel rds.h, the change
> in kernel rds.h does not affect rds-tools.
> rds-info in rds-tools 2.0.5 and 2.0.6 is tested with this commit. It works
> well.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: RDS CI is removed.

Thanks for testing compatibility.

FWIW, Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
