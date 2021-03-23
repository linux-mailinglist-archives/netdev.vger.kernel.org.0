Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11E346592
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhCWQnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:43:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233296AbhCWQmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:42:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NGdVAv178714;
        Tue, 23 Mar 2021 12:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mugoxLLbXbcCAQMII62c4xjbwDS55dhHLbfQ3PvyHxc=;
 b=lbxBkZHaKDzw/81D3zpyhVKsSF5lcRceKMlZ4EhcsE/VbtvB/EeBcEX9qcybc0I0GZOT
 zgXqUDyfUkYVTGqE6hr35Ab0QCBlViPBDO7PqOO02DcR+75q70IEEQ9wf8lh5nmwONu+
 garixp8pn/Qfcdv+u47xNCWxAZMT9ysTKvwthO81fCwrGwoGIwHuYRRfaBt9Tf6rfjnu
 z7vMZDGx1UpQ7AU6327SZncjQZ/T41n1sOSHYMS2UObBfMWDootckN2Lkl7gFIsu3Xjy
 Xk/kjCen9D9Fw+v+Drvdtwsee7Dk2H+1McYL/TLx0aNNMipUa1bIKmWRgP+1unVRF8dr eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fktw0ayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 12:42:41 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NGdciq179484;
        Tue, 23 Mar 2021 12:42:40 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fktw0axn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 12:42:40 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NGX3jP003981;
        Tue, 23 Mar 2021 16:42:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rbhwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 16:42:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NGgZR039584006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 16:42:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B847BAE051;
        Tue, 23 Mar 2021 16:42:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E090AE04D;
        Tue, 23 Mar 2021 16:42:35 +0000 (GMT)
Received: from [9.171.52.65] (unknown [9.171.52.65])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 16:42:35 +0000 (GMT)
Subject: Re: [PATCH] net/smc: Simplify the return expression
To:     zuoqilin1@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
References: <20210323020509.1499-1-zuoqilin1@163.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <412763fa-f4d6-f0fc-283b-2998be0e0f12@linux.ibm.com>
Date:   Tue, 23 Mar 2021 17:42:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323020509.1499-1-zuoqilin1@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_07:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 03:05, zuoqilin1@163.com wrote:
> From: zuoqilin <zuoqilin@yulong.com>
> 
> Simplify the return expression of smc_ism_signal_shutdown().
> 
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>
> ---
>  net/smc/smc_ism.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index 9c6e958..c3558cc 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -344,7 +344,6 @@ static void smcd_handle_sw_event(struct smc_ism_event_work *wrk)
>  
>  int smc_ism_signal_shutdown(struct smc_link_group *lgr)
>  {
> -	int rc;
>  	union smcd_sw_event_info ev_info;
>  
>  	if (lgr->peer_shutdown)
> @@ -353,11 +352,10 @@ int smc_ism_signal_shutdown(struct smc_link_group *lgr)
>  	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
>  	ev_info.vlan_id = lgr->vlan_id;
>  	ev_info.code = ISM_EVENT_REQUEST;
> -	rc = lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
> +	return lgr->smcd->ops->signal_event(lgr->smcd, lgr->peer_gid,
>  					  ISM_EVENT_REQUEST_IR,
>  					  ISM_EVENT_CODE_SHUTDOWN,
>  					  ev_info.info);

I agree with the code change but after I applied your patch the 3 lines above
are no longer correctly indented, please correct that and resend the patch.
Thanks.

> -	return rc;
>  }
>  
>  /* worker for SMC-D events */
> 

-- 
Karsten

(I'm a dude)
