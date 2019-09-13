Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C41B16F5
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 03:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfIMBMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 21:12:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbfIMBMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 21:12:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8D18kAV153694;
        Fri, 13 Sep 2019 01:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kdAcJUnQVExJl0z20Ougle6p5vacyq5LoTbqQZHwWiY=;
 b=A6kwJtyou9I8SgXgxT+3LVQcELAthToEG8k3wz91ck+/mxsiikQ8ziaE7bCzl2199dFg
 KvWA0YpxDVwFYL2H5+BIh0PU2Fvp3tHn1U+udgJCzXzKKtIPQqG8xiyfeC/cqIb4769U
 6LUrDsgo0Q43tmCUw/Mj1KpKK8YWlRmim/WAFF3UP30mrilec+tWT4UH34H9pUCO9g21
 DcX5i2VCuL62x3trcrCouZ+gNSTzyAxqQ3myG+Bprapc2JXX4Rh/r/Hd53nqcsDSaI+9
 zxeJuKNfSm4B8/PDy/tzPUWMbHvzxd7kIEgP4fQ1dP0GEIZvOyryDBJBKYccMHSHYUV3 CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uytd3hq7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 01:12:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8D18qd0101486;
        Fri, 13 Sep 2019 01:10:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2uytdhme7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Sep 2019 01:10:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8D1APC9107203;
        Fri, 13 Sep 2019 01:10:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uytdhme7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 01:10:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8D1AOcL009280;
        Fri, 13 Sep 2019 01:10:24 GMT
Received: from [192.168.86.205] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Sep 2019 18:10:24 -0700
Subject: Re: [PATCH net] net/rds: Fix 'ib_evt_handler_call' element in
 'rds_ib_stat_names'
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <914b48be-2373-5b38-83f5-e0d917dd139d@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <4e9659ef-56d4-d48f-a762-e0708f5bd323@oracle.com>
Date:   Thu, 12 Sep 2019 18:10:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <914b48be-2373-5b38-83f5-e0d917dd139d@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909130009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 1:49 PM, Gerd Rausch wrote:
> All entries in 'rds_ib_stat_names' are stringified versions
> of the corresponding "struct rds_ib_statistics" element
> without the "s_"-prefix.
> 
> Fix entry 'ib_evt_handler_call' to do the same.
> 
> Fixes: f4f943c958a2 ("RDS: IB: ack more receive completions to improve performance")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Thanks Gerd !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
