Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56C02A191A
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgJaR7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:59:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59354 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgJaR7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 13:59:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09VHWD89100747;
        Sat, 31 Oct 2020 13:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=imjr18hPoV4KOYhBiN8UzTInoo1Dy1DxmnpOiVnJdQc=;
 b=q8oOUADehGbsg4mZ/pP8rAbhgbV4DwmjwdZI+n8kzxPNpDyTWgJxwtrfU0cthoCEaWF0
 rRgqBmJcwf1AM+q9cx9ow/sQoaue3q/puwhFcIlniCpTdgD21QEAxXIXSxv3oZ4UwHgj
 ufN6l4ylMY7lntyb+Y3r07M4+HAqkh4w1EV3QJuh2hGfB0R++I/3TK/aBnXW3I+Qo+j1
 0oAaDCtvWBV0yk3xs9SZuwRJKDxyHO+39eR5cBeWRMcrCi5KwR+iHIZEE5eR09Qxtr9u
 hZUsFEH/vV1hEiyV/rtxWrDImHl/uzsX6dQL9YbgHisEB/vOrV5ZlATpIjGCKOq3PGeh bQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34h2rg2y5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 13:59:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09VHwRHo005924;
        Sat, 31 Oct 2020 17:59:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 34h01tr820-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 17:59:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09VHx9cI64487824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Oct 2020 17:59:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB899A405F;
        Sat, 31 Oct 2020 17:59:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12773A405B;
        Sat, 31 Oct 2020 17:59:09 +0000 (GMT)
Received: from [9.171.23.114] (unknown [9.171.23.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 31 Oct 2020 17:59:08 +0000 (GMT)
Subject: Re: [PATCH net-next] net/smc: improve return codes for SMC-Dv2
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
References: <20201028110039.33645-1-kgraul@linux.ibm.com>
 <20201030201845.6be9722e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <de52a36a-e45f-c731-29e7-8689ad93bca3@linux.ibm.com>
Date:   Sat, 31 Oct 2020 18:59:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030201845.6be9722e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-31_06:2020-10-30,2020-10-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 malwarescore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010310143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/10/2020 04:18, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 12:00:39 +0100 Karsten Graul wrote:
>> To allow better problem diagnosis the return codes for SMC-Dv2 are
>> improved by this patch. A few more CLC DECLINE codes are defined and
>> sent to the peer when an SMC connection cannot be established.
>> There are now multiple SMC variations that are offered by the client and
>> the server may encounter problems to initialize all of them.
>> Because only one diagnosis code can be sent to the client the decision
>> was made to send the first code that was encountered. Because the server
>> tries the variations in the order of importance (SMC-Dv2, SMC-D, SMC-R)
>> this makes sure that the diagnosis code of the most important variation
>> is sent.
>>
>> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
>> ---
>>  net/smc/af_smc.c   | 61 +++++++++++++++++++++++++++++++---------------
>>  net/smc/smc_clc.h  |  5 ++++
>>  net/smc/smc_core.h |  1 +
>>  3 files changed, 47 insertions(+), 20 deletions(-)
>>
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index 82be0bd0f6e8..5414704f4cac 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
>> @@ -1346,6 +1346,7 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
>>  {
>>  	struct smc_clc_smcd_v2_extension *pclc_smcd_v2_ext;
>>  	struct smc_clc_v2_extension *pclc_v2_ext;
>> +	int rc;
>>  
>>  	ini->smc_type_v1 = pclc->hdr.typev1;
>>  	ini->smc_type_v2 = pclc->hdr.typev2;
>> @@ -1353,29 +1354,30 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
>>  	if (pclc->hdr.version > SMC_V1)
>>  		ini->smcd_version |=
>>  				ini->smc_type_v2 != SMC_TYPE_N ? SMC_V2 : 0;
>> +	if (!(ini->smcd_version & SMC_V2)) {
>> +		rc = SMC_CLC_DECL_PEERNOSMC;
>> +		goto out;
>> +	}
>>  	if (!smc_ism_v2_capable) {
>>  		ini->smcd_version &= ~SMC_V2;
>> +		rc = SMC_CLC_DECL_NOISM2SUPP;
>>  		goto out;
>>  	}
>>  	pclc_v2_ext = smc_get_clc_v2_ext(pclc);
>>  	if (!pclc_v2_ext) {
>>  		ini->smcd_version &= ~SMC_V2;
>> +		rc = SMC_CLC_DECL_NOV2EXT;
>>  		goto out;
>>  	}
>>  	pclc_smcd_v2_ext = smc_get_clc_smcd_v2_ext(pclc_v2_ext);
>> -	if (!pclc_smcd_v2_ext)
>> +	if (!pclc_smcd_v2_ext) {
>>  		ini->smcd_version &= ~SMC_V2;
>> +		rc = SMC_CLC_DECL_NOV2DEXT;
>> +	}
>>  
>>  out:
>> -	if (!ini->smcd_version) {
>> -		if (pclc->hdr.typev1 == SMC_TYPE_B ||
>> -		    pclc->hdr.typev2 == SMC_TYPE_B)
>> -			return SMC_CLC_DECL_NOSMCDEV;
>> -		if (pclc->hdr.typev1 == SMC_TYPE_D ||
>> -		    pclc->hdr.typev2 == SMC_TYPE_D)
>> -			return SMC_CLC_DECL_NOSMCDDEV;
>> -		return SMC_CLC_DECL_NOSMCRDEV;
>> -	}
>> +	if (!ini->smcd_version)
>> +		return rc;
> 
> Is rc guaranteed to be initialized? Looks like ini->smcd_version could
> possibly start out as 0, no?
> 

Per protocol it should not happen that neither v1 nor v2 is set, but its good
to harden the code so initializing the rc really makes sense, thank you.
I will send a v2 with such a change.

>>  
>>  	return 0;
>>  }
>> @@ -1473,6 +1475,12 @@ static void smc_check_ism_v2_match(struct smc_init_info *ini,
>>  	}
>>  }
> 
>> @@ -1630,10 +1647,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
>>  		return 0;
>>  
>>  	if (pclc->hdr.typev1 == SMC_TYPE_D)
>> -		return SMC_CLC_DECL_NOSMCDDEV; /* skip RDMA and decline */
>> +		/* skip RDMA and decline */
>> +		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
>>  
>>  	/* check if RDMA is available */
>> -	return smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
>> +	rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
>> +	smc_find_ism_store_rc(rc, ini);
>> +
>> +	return (!rc) ? 0 : ini->rc;
> 
> Since I'm asking questions anyway - isn't this equivalent to 
> 
> 	return ini->rc; 
> 
> since there's call to
> 
> 	smc_find_ism_store_rc(rc, ini);
> 
> right above?
> 

ini->rc could be set due to a previous error in a called function, 
but finally another initialization was successful when rc == 0, 
so ignore ini->rc in that case.

-- 
Karsten

(I'm a dude)
