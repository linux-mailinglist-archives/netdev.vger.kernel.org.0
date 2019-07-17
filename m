Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C854F6B2DB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388985AbfGQA2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:28:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45290 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQA2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:28:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0P66I084454;
        Wed, 17 Jul 2019 00:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Rif1OJTuKMe/Qi5s4eqYYMR2qBdRmDpkH+v7EEzRgDU=;
 b=e57/b7yt1uWHnNg7Jv2zCX0heisXzydemJAVzWAsV/f7C2DHJCyPsyxCytWZ1CyQO17b
 npWVEgOWXjT+njXxQYIpKRQHDL0YQZSj42ZzsIC2tNBKMx9orzzQl4l5JvWird2zvfP+
 8RkPKAuD5HVuC2jSwVQaSYEPxfNiAsNwU3P5h76GkkuRTMQGsxvPT+KkITCU9TkyGK4X
 /pIcXJGOFI6xwoR0QFBhk9KojctNr5d2P5oL6uFvQC3Mp6FrkuWpLJQgFzzWT9GgY9HX
 gR6yru6hPx7Xlqe+jUurFOyutlE0BSweaFHofLSRtUMwoujmPqL94jbdTt0w528wzE21 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tq78pqf9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:28:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0SJkk053082;
        Wed, 17 Jul 2019 00:28:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tsctwm1s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:28:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0STAZ053311;
        Wed, 17 Jul 2019 00:28:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tsctwm1rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:28:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6H0SSR0012560;
        Wed, 17 Jul 2019 00:28:28 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:28:28 +0000
Subject: Re: [PATCH net v3 5/7] net/rds: Set fr_state only to FRMR_IS_FREE if
 IB_WR_LOCAL_INV had been successful
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <78bfebd7-c445-bd41-c5c5-d49e6ed51230@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <08888605-4037-d3fd-dfae-b3e57293de67@oracle.com>
Date:   Tue, 16 Jul 2019 17:28:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <78bfebd7-c445-bd41-c5c5-d49e6ed51230@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/19 3:29 PM, Gerd Rausch wrote:
> Fix a bug where fr_state first goes to FRMR_IS_STALE, because of a failure
> of operation IB_WR_LOCAL_INV, but then gets set back to "FRMR_IS_FREE"
> uncoditionally, even though the operation failed.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
