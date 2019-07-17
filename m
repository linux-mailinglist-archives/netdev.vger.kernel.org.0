Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56896B2DD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389021AbfGQA3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:29:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQA3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:29:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0TCTd192582;
        Wed, 17 Jul 2019 00:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Z9d7/R2pt+qt0C+nr9mtLsT1ZKFiWFaM+qgoUJWriPc=;
 b=ybDpmhcdLola+EZvUviRQvmZP1E+wgmsfo7QZwYo51eiwTPrCT4j7FgAEIm3vmuRLcMI
 +Rp1O+qT/uPg6J1lvI0pzqjXrK4TT+4xI2BfiLTlgtgveu7QgorejEQHEYI87wW6gNVd
 efrOS/tSZwkAqqe0vui5VGDHUiXO2qxWUcPvFGQ3zVrpSyBYDW33297qXAWGx1zEdI00
 ssEpmzQkMxbWTEE3fbwa7AdS7/9WjpAgtZTXOMWPLRx2kIOYbsl3285Av8/CCYIJm8CA
 wUxPHyUMcrCw3S+cDfPgCBR7oLvjoed3Iyj9JRpRjD2nxvmzoCVUKbOVUfl7DJ1Qb6/p qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtqjwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:29:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0SAJE052775;
        Wed, 17 Jul 2019 00:29:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tsctwm22s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:29:11 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0TAPI054475;
        Wed, 17 Jul 2019 00:29:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tsctwm22k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:29:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6H0T9YU010151;
        Wed, 17 Jul 2019 00:29:09 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:29:09 +0000
Subject: Re: [PATCH net v3 7/7] net/rds: Initialize ic->i_fastreg_wrs upon
 allocation
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <94bc1575-1772-3619-e8d5-b74463308e0f@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <72e9f436-c690-9d4d-136a-ccb14ee8e4e0@oracle.com>
Date:   Tue, 16 Jul 2019 17:29:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <94bc1575-1772-3619-e8d5-b74463308e0f@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=931 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170004
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/19 3:29 PM, Gerd Rausch wrote:
> Otherwise, if an IB connection is torn down before "rds_ib_setup_qp"
> is called, the value of "ic->i_fastreg_wrs" is still at zero
> (as it wasn't initialized by "rds_ib_setup_qp").
> Consequently "rds_ib_conn_path_shutdown" will spin forever,
> waiting for it to go back to "RDS_IB_DEFAULT_FR_WR",
> which of course will never happen as there are no
> outstanding work requests.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
