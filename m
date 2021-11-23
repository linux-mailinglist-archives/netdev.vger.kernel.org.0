Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B23459F28
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhKWJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:29:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235244AbhKWJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 04:29:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN7lIHe007548;
        Tue, 23 Nov 2021 09:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tpSjHmSJe+tSuNBZQQQq17WheCJO8kTDOKvEy2gXslE=;
 b=fk8ZMGMS7gPdl7Gd9wPKltDruwz4HWAhB8T8lOrZ+nTzXkQNJS3pgduHIUauVUaJd+XG
 YSa944oZuwm8by7s8ksvmUOPCc1bTSxlZsxjsXXNjICmu2U/t8aOPKHW+GssjLRZ1gFo
 IfTp8VOTUnybcyiY6dQDiRaAkdCba1b4cp30j7fP14Oh6adHVpDBa9A1Mk0GxMfRpaXN
 R9HNt9VgF/+PuJvr/MlcX24vaSFfvm+yQQN0nuvdabHzEmLR3xSZBDeufvF4n2hYxhsb
 haNZxcdRjXHLaIbiVF81eV0AimkFZVXFsg7Cui4vY8qpUxyfbOjanYbN3nHhVaQ+ugii IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgv7fhr6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:26:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AN9EnhD022498;
        Tue, 23 Nov 2021 09:26:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgv7fhr5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:26:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AN9H0Q9025776;
        Tue, 23 Nov 2021 09:26:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9jp00u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:26:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AN9QKkL47776066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 09:26:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8A11A4054;
        Tue, 23 Nov 2021 09:26:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62C68A4066;
        Tue, 23 Nov 2021 09:26:20 +0000 (GMT)
Received: from [9.145.60.43] (unknown [9.145.60.43])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 09:26:20 +0000 (GMT)
Message-ID: <d83109fe-ae25-def0-b28e-f8695d4535c7@linux.ibm.com>
Date:   Tue, 23 Nov 2021 10:26:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211116033011.16658-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B4ScFv03nlg1NzwlWZXmMu4SQJnwWhNi
X-Proofpoint-ORIG-GUID: rcZqsL_69nfgyarezTjennvioNhyNxqU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/11/2021 04:30, Tony Lu wrote:
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index 0f9ffba07d26..04620b53b74a 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -228,6 +228,12 @@ int smc_close_active(struct smc_sock *smc)
>  			/* send close request */
>  			rc = smc_close_final(conn);
>  			sk->sk_state = SMC_PEERCLOSEWAIT1;
> +
> +			/* actively shutdown clcsock before peer close it,
> +			 * prevent peer from entering TIME_WAIT state.
> +			 */
> +			if (smc->clcsock && smc->clcsock->sk)
> +				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
>  		} else {

While integrating this patch I stumbled over the overwritten rc, which was
already set with the return value from smc_close_final().
Is the rc from kernel_sock_shutdown() even important for the result of this 
function? How to handle this in your opinion?
