Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D26A089
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbfGPC1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:27:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389175AbfGPC1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:27:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6G2NN07121902;
        Tue, 16 Jul 2019 02:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=4q/tR0CDQreA8oPieWpnL4ddckx77OE/YYibaD5siEQ=;
 b=CnSZTBwu83n2U942g1lirkFOrdxNLjAQTnF2Shvb7sZy63u+l0yipKfXkD08dKRrM1dN
 HbeaHBcbdWfhtuZz+coaIUvHZwBjcDv9bbGol3dxjUEAOGGb1svqg7Wc20dMJTTgQR/7
 py2bAaWNSipkHwoREoUfx1zvI+nDFYL7B/hSOO7tIu2cocB2ifWlEOBfFTSYRP+RX2Gl
 hz8RVxMkWbR+6P74/hUDow7il7URgfpGrQzo0cklDoRVzDq58GuI4pdP8A75eq69dEvK
 lb5awL6NwDxKTYimyH/+c5wTlfpfZur1cgs/K9S2NSKZoi2YTFkvoq6iijXWK7ZeGpX3 hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tq7xqsnb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 02:26:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6G2NE6Z117328;
        Tue, 16 Jul 2019 02:24:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tq742vsd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 02:24:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6G2Oviv015061;
        Tue, 16 Jul 2019 02:24:57 GMT
Received: from [10.159.138.226] (/10.159.138.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 19:24:57 -0700
Subject: Re: [PATCH net-next v2 0/7] net/rds: RDMA fixes
To:     David Miller <davem@davemloft.net>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
References: <510cd678-67d6-bd53-1d8e-7a74c4efb14a@oracle.com>
 <20190715.190547.2251732138126894888.davem@davemloft.net>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <fab1fb9a-13e3-9f10-5abe-bd4154505c9a@oracle.com>
Date:   Mon, 15 Jul 2019 19:24:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715.190547.2251732138126894888.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=824
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=891 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This was a followup to the patch-series that I had already sent.
I'll re-write the Subject-prefix and re-submit it for "net".

Sorry for the noise,

  Gerd

On 15/07/2019 19.05, David Miller wrote:
> 
> net-next is closed, and why are you submitting bug fixes for net-next
> when 'net' is the appropriate tree to target for that purpose?
> 
