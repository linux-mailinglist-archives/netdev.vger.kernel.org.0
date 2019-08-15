Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A68F048
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfHOQRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:17:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35836 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbfHOQRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:17:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDU5E011972;
        Thu, 15 Aug 2019 16:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TgNXYs87ZJUv98/IC0S1pdM+SV3b33hARCJdpKIPEqc=;
 b=jvqUuT9aU7PHrGtQF1F7rIiyt0PaMtDXvqkNNuLVACWPBs6V3reap9IY/oAEvYITgFMA
 mSEnSKpHN0KEp5VjryVDDXX1OjMCs/QKatbbsAdfym0hUc0kaEt8EWBN1CcItbHMI/nn
 9Opdrr0VdH7GCsQuY7GPxMYDAdSAbxZv4tuq89ZRMsI6+68tyMALGMKhtIjd+FKJBzAF
 kz4kLAc3OY6y0KKJ0tng4ba1XT9wfb1fXo4rB7C1dbIdhsupz1vBgcFUgV8kmC7tSfKE
 uyGj7hq/PxZxhtM+Jm7lQs0GXGCXUgRA0xWeWGcRtWDEs7m7yDCHbc/lrZXa27owPTjY Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvpkr7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:17:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDWJQ145847;
        Thu, 15 Aug 2019 16:17:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ucmwjvdnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:17:47 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FGHlnj163459;
        Thu, 15 Aug 2019 16:17:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ucmwjvdna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:17:47 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FGHkmq009675;
        Thu, 15 Aug 2019 16:17:46 GMT
Received: from [10.159.249.63] (/10.159.249.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:17:46 -0700
Subject: Re: [PATCH net-next v2 3/4] net/rds: Add a few missing rds_stat_names
 entries
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
 <2d604055-a49e-637f-a1e6-afefa8482316@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <42546172-894b-0451-5a49-9eb5196e1487@oracle.com>
Date:   Thu, 15 Aug 2019 09:17:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2d604055-a49e-637f-a1e6-afefa8482316@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 7:42 AM, Gerd Rausch wrote:
> From: Gerd Rausch <gerd.rausch@oracle.com>
> Date: Thu, 11 Jul 2019 12:15:50 -0700
> 
> In a previous commit, fields were added to "struct rds_statistics"
> but array "rds_stat_names" was not updated accordingly.
> 
> Please note the inconsistent naming of the string representations
> that is done in the name of compatibility
> with the Oracle internal code-base.
> 
> s_recv_bytes_added_to_socket     -> "recv_bytes_added_to_sock"
> s_recv_bytes_removed_from_socket -> "recv_bytes_freed_fromsock"
> 
> Fixes: 192a798f5299 ("RDS: add stat for socket recv memory usage")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
