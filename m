Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35C76B2D7
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbfGQA1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:27:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQA1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:27:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0Nb0q083610;
        Wed, 17 Jul 2019 00:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=haiAXbGn1uoplGyo70XigaV5C0JLddwoKjoJAZcoaSI=;
 b=Jz2HLwnwN9cZitlkJ0MwelhdHsZMp9mxy/GrQ3tj0bBiHMuIj3b7OnfDjV7bcCpEEMN4
 +Li+EgjQ5o5txvR01sa6LEEnRfBoJEFtw0EyYDY4KxXIIUPaQ1FQ77oZPORhyc+jbNnv
 KHwCJ3ouj1KbGCqWxoachAPLTRN4JLnmYmoQbZvqSpmxdi5xZtTb2DACTwx77GrCKFa0
 frto41P4DTDj977oYt/k1ltizG5PdjtkzjIPB1dvB8Rd9JyxcjjFvOSX2/bzhIBE2BGv
 oJQ1aTCG6/rczUEpS4U33q5bOSEllTlDPx1oHB3kenQu6b4u5oHUZay8beHJTnvH5agf Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tq78pqf8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:27:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0NArQ110286;
        Wed, 17 Jul 2019 00:27:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq19w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:27:39 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0RcZO116348;
        Wed, 17 Jul 2019 00:27:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq19s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:27:38 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6H0RbvZ009374;
        Wed, 17 Jul 2019 00:27:37 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:27:37 +0000
Subject: Re: [PATCH net v3 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <59304e3c-e15f-6a3b-a8d2-63de370ed847@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <7b2f5433-b289-dc4a-47f9-33df8d5b5503@oracle.com>
Date:   Tue, 16 Jul 2019 17:27:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <59304e3c-e15f-6a3b-a8d2-63de370ed847@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=844 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 3:29 PM, Gerd Rausch wrote:
> In order to:
> 1) avoid a silly bouncing between "clean_list" and "drop_list"
>     triggered by function "rds_ib_reg_frmr" as it is releases frmr
>     regions whose state is not "FRMR_IS_FREE" right away.
> 
> 2) prevent an invalid access error in a race from a pending
>     "IB_WR_LOCAL_INV" operation with a teardown ("dma_unmap_sg", "put_page")
>     and de-registration ("ib_dereg_mr") of the corresponding
>     memory region.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Thanks for updated version.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
