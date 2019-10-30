Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F6AE9597
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfJ3EMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:12:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfJ3EMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:12:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9U446GZ034274;
        Wed, 30 Oct 2019 04:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rpY829B1vUUiizc8OvX760jvzuSL3WOytTrKJiTgr4k=;
 b=icidYlDEgKcn+N5dokgUNe7eKefwBaexDkL0KOkoyyRCkPIPenEOeTX6gqLppw2b7OrZ
 6M8uKvfsOZnVEYJJae2E8fClf207UhwU3QE234QavW7g71skcM7a/63K3SJuSIycldD6
 oJe/G1kZIxQA3CePBLDD7M0m6OcPHew1fmRBlTyYbyy4RdD4W7B2K8zEVwC7Bk13bbpn
 jhdH0VeHGcVCxE2mFJ7cfWghIDkMEXyCaXjMssZU2Gt+4g+K4/bO+eV/1N5M+8sEFFqx
 1KqHT9uvhRJrPE9/HEvpGOHxb/elLHrpZ7r/gzC9PsY6yemVMLsqcmY0iNN+U5L6fhLL yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhfh7ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 04:12:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9U48fOE177907;
        Wed, 30 Oct 2019 04:12:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vxwj5kuk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 04:12:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9U4CNKE025944;
        Wed, 30 Oct 2019 04:12:24 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 21:12:23 -0700
Subject: Re: [PATCHv3 1/1] net: forcedeth: add xmit_more support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
 <20191029103244.3139a6aa@cakuba.hsd1.ca.comcast.net>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <068ef3ce-eb72-b5db-1845-1350dfad3019@oracle.com>
Date:   Wed, 30 Oct 2019 12:18:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029103244.3139a6aa@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300041
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/30 1:32, Jakub Kicinski wrote:
> On Mon, 28 Oct 2019 23:30:12 -0400, Zhu Yanjun wrote:
>> This change adds support for xmit_more based on the igb commit 6f19e12f6230
>> ("igb: flush when in xmit_more mode and under descriptor pressure") and
>> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
>> were made to igb to support this feature. The function netif_xmit_stopped
>> is called to check whether transmit queue on device is currently unable to
>> send to determine whether we must write the tail because we can add no further
>> buffers.
>> When normal packets and/or xmit_more packets fill up tx_desc, it is
>> necessary to trigger NIC tx reg.
>>
>> CC: Joe Jin <joe.jin@oracle.com>
>> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
>> Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Acked-by: Rain River <rain.1986.08.12@gmail.com>
> I explained to you nicely that you have to kick on the DMA error cases.
As I mentioned, this commit is based on the igb commit 6f19e12f6230
("igb: flush when in xmit_more mode and under descriptor pressure") and

commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data").

If igb does not handle DMA error, it is not appropriate for us to handle 
DMA error.

After igb fixes this DMA error, I will follow.;-)

Sorry.

Zhu Yanjun

>
> Please stop wasting everyone's time by reposting this.
>
