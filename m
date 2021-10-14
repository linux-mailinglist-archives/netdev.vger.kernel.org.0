Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2D442DF31
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhJNQey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:34:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhJNQeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:34:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EFicAj032432;
        Thu, 14 Oct 2021 12:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KK2u8WdR1B+7QuzxPI5SyQPFbK5W+cd5cU/ZFriISYo=;
 b=N71M+qMYc0b5wLHU3KsQWS0u8fJtm5yLeYSV/Nu3HdWiFiX6+cYW0M/7NobPPVCT+cv1
 +RjSLdPpseDwM+sgrn7i2kLuKYfCEsUIdUYtY2sltENtlGSITWxSvFcSLh6y0TwjreR5
 mu1wHb741Zs9f5UNvdn71rEPUeFooZMAEegg5waKdZSRzEQjZjUkiOdciK9lBHP4q1a+
 02tZGoPAWOCZEfD384URDXNxrAiizMKR4ZjstkLpcgSRbjCejNsj2TtlL+scxWfVR6DN
 rwmWRhSnoTE335MaoP6vwji3eCzJ3AB83I75F2s0ZXYTuAfhBuyhVMQ+cwKQBcQQ2fpC zQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnr7ak5vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:32:43 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EGJXcg006777;
        Thu, 14 Oct 2021 16:32:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2qa7bmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 16:32:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EGWciZ20447732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 16:32:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B6765205F;
        Thu, 14 Oct 2021 16:32:38 +0000 (GMT)
Received: from [9.171.89.192] (unknown [9.171.89.192])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D88C452051;
        Thu, 14 Oct 2021 16:32:37 +0000 (GMT)
Message-ID: <7d3e762e-12e9-bb5c-f242-785047087783@linux.ibm.com>
Date:   Thu, 14 Oct 2021 18:32:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next 00/11] net/smc: introduce SMC-Rv2 support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
 <20211014090951.592e1d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211014090951.592e1d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k1aF0PF7wpLGOdvrxKpSWHeyjdT3A-w3
X-Proofpoint-ORIG-GUID: k1aF0PF7wpLGOdvrxKpSWHeyjdT3A-w3
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110140095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2021 18:09, Jakub Kicinski wrote:
> On Tue, 12 Oct 2021 12:17:32 +0200 Karsten Graul wrote:
>> Please apply the following patch series for smc to netdev's net-next tree.
>>
>> SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
>> provides routable RoCE support for SMC-R, eliminating the current
>> same-subnet restriction, by exploiting the UDP encapsulation feature
>> of the RoCE adapter hardware.
>>
>> Patch 1 ("net/smc: improved fix wait on already cleared link") is
>> already applied on netdevs net tree but its changes are needed for
>> this series on net-next. The patch is unchanged compared to the
>> version on the net tree.
> 
> This series as marked as "Needs ACK" in patchwork, I think my Dave.
> Maybe it is because of the RoCE part, is there a reason not to CC
> linux-rdma on it?

There is no reason for that, I was not aware that I should CC linux-rdma.
I can send a v2 with an extended CC list.
