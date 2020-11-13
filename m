Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990832B1E47
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgKMPIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:08:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57958 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbgKMPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:08:46 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADF1mgN114964;
        Fri, 13 Nov 2020 10:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KvmFHrYAG3NM1GPNZodIHODE6AE7QmndipPM4Z6GgeM=;
 b=LWql9hveRZM8U+eUKTOJpIvTQ6puXZg2ijDgf1EEYDdf2amtWU4MNtKt80CN13epsR19
 pQbsqkVY0APpXmqGJL19KfSV0A90DCS/2PcQXHkIrGI8LFUdMBgi+JKyIMmOPABg1wR/
 D3IuZ9NQmaekUuWPsg8tgg6rcHHOUw56dyX/OW8EXfXYSS1w+DjoEPROF1gtp8TTDPMd
 Yl2UQTRNYBJMnqzZ2cFZa28zL6NX4D2iiXfgsRDpIvuorKbqdYYh+EFPW24eIwd2dycY
 wWZKAx57I1xbVlS7qTTqpTkYyBBGUnHrc5vH4WkeAMRK9UL6x+ZZ0yPx3Pvq9WcH7IXF 7Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sve5r94p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 10:08:42 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADF7ia2002398;
        Fri, 13 Nov 2020 15:08:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 34p26pny2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 15:08:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADF8cUQ7471716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 15:08:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E8A8AE045;
        Fri, 13 Nov 2020 15:08:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10B29AE04D;
        Fri, 13 Nov 2020 15:08:38 +0000 (GMT)
Received: from [9.171.64.119] (unknown [9.171.64.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 15:08:37 +0000 (GMT)
Subject: Re: [PATCH net-next v4 09/15] net/smc: Introduce SMCR get linkgroup
 command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
 <20201109151814.15040-10-kgraul@linux.ibm.com>
 <20201111143405.7f5fb92f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <3be40d64-3952-3de9-559b-2ee55449b54c@linux.ibm.com>
Date:   Fri, 13 Nov 2020 16:08:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201111143405.7f5fb92f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2020 23:34, Jakub Kicinski wrote:
> On Mon,  9 Nov 2020 16:18:08 +0100 Karsten Graul wrote:
>> @@ -295,6 +377,14 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>  
>>  static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
>>  {
>> +	struct smc_diag_req_v2 *req = nlmsg_data(cb->nlh);
>> +
>> +	if (req->cmd == SMC_DIAG_GET_LGR_INFO) {
>> +		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
>> +			smc_diag_fill_lgr_list(smc_diag_ops->get_lgr_list(),
>> +					       skb, cb, req);
>> +	}
>> +
>>  	return skb->len;
>>  }
> 
> IDK if this is appropriate for socket diag handler.
> 
> Is there precedent for funneling commands through socket diag instead
> of just creating a genetlink family?
> 

Thank you for your valuable comments. We are looking into a better way
to retrieve the various information from the kernel into user space, 
and we will come up with a v5 for that.

-- 
Karsten


