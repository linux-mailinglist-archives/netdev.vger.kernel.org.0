Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE78C8C414
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfHMWHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:07:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfHMWHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:07:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM48gA111801;
        Tue, 13 Aug 2019 22:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vPuUc0h3vK5zVqKaZYdb4Ne/kI/hUa07gTPp83ZFA6g=;
 b=m+/wlw9M6IHGa6Eq2DKZJMgfRvY6xIsfETBI2y6EwK/OMgiChYX05sk7LyPY3/0+KQsk
 pxf/PQ7Lmcp/G+8BPr/PA5TBg3JT2gVh6IWB+FvFTFyO813YGapc6z0Fi5MAdvh2YJ8G
 KV9A9zQ4KaxH3tzpV4OfgjtykxK+hQV+y3uJ7MYnw0ojgCJZ3za0Z/hFev4txesKp5PA
 C8APN+hFF7U9ne4guxgyHocuY/S/pUTkLNyRVlHd/RXMV+VL98VPxHbBJerteYlANQZd
 8RHIpiQnLKoRLnQXpnqj/qLJ+/NNW/omE0ivyBSMJqu3xLxqjJJQEcz4POIbMiVo9P9s 2A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp9513-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:07:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM4QX0158524;
        Tue, 13 Aug 2019 22:07:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ubwrrv77j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 22:07:31 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DM7VW6166715;
        Tue, 13 Aug 2019 22:07:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ubwrrv779-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:07:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DM7UGI001312;
        Tue, 13 Aug 2019 22:07:30 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 15:07:30 -0700
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <922a394d-8e80-c176-06c0-b35348cf564c@oracle.com>
Date:   Tue, 13 Aug 2019 15:07:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130207
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 11:20 AM, Gerd Rausch wrote:
> From: Andy Grover <andy.grover@oracle.com>
> Date: Tue, 24 Nov 2009 15:35:51 -0800
> 
> Although RDS has an official PF_RDS value now, existing software
> expects to look for rds sysctls to determine it. We need to maintain
> these for now, for backwards compatibility.
> 
> Signed-off-by: Andy Grover <andy.grover@oracle.com>
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>
