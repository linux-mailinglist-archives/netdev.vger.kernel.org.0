Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912A22AB43B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgKIKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:02:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgKIKCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:02:06 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A99WLno165058;
        Mon, 9 Nov 2020 05:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7KmqLtkv4n+qon/WOA1vGB76k4Z2CvysOh+6wFr0wlk=;
 b=Pg5jYoF5MDJ0UAEsPDTRC6oIgorWqtGngT3O8Yq0WHOtOSKZt0FJ6nwW+9TlEH2Nke16
 uNJ9q6zEo1W8a3zLai4mUyHIZnxH6XKYp8eaJN5/XhdvjPsGlZ6u2GgBCVvSqh05mSqt
 TxKL3E3MEF0fIUy6pUARZ0Lnd/+7gyLFpnFXoeB06b5K3H3YrOJLaWTsT2D+8CiN3M5Y
 ddbPZF9gedKkzrsEkY61/VH0JvT9WfvQPfe5iOB0+I7L38z/qRmPEIwV7xxnCd7SHwny
 ZBx+WRjJ6aS65wIenJIvJdUsw2L73q8bX2trGOzubOzlsNw0/nMO0NKha3W9sesAWicw ow== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nryaqx3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 05:02:02 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9A1r7U024323;
        Mon, 9 Nov 2020 10:02:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 34p26phaty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:02:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9A1v9e25362800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 10:01:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D732DA4066;
        Mon,  9 Nov 2020 10:01:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80EC5A4062;
        Mon,  9 Nov 2020 10:01:57 +0000 (GMT)
Received: from [9.171.82.206] (unknown [9.171.82.206])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 10:01:57 +0000 (GMT)
Subject: Re: [PATCH net-next v3 15/15] net/smc: Add support for obtaining
 system information
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
 <20201107125958.16384-16-kgraul@linux.ibm.com>
 <20201107095540.0f45b572@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <22bd2535-4057-12a2-ae6b-fefd33129e98@linux.ibm.com>
Date:   Mon, 9 Nov 2020 11:01:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201107095540.0f45b572@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=976 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/11/2020 18:55, Jakub Kicinski wrote:
> On Sat,  7 Nov 2020 13:59:58 +0100 Karsten Graul wrote:
>> From: Guvenc Gulce <guvenc@linux.ibm.com>
>>
>> Add new netlink command to obtain system information
>> of the smc module.
>>
>> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
>> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> 
> Checkpatch says:
> 
> CHECK: Please don't use multiple blank lines
> #62: FILE: include/uapi/linux/smc_diag.h:140:
>  
> +
> 
> WARNING: line length of 84 exceeds 80 columns
> #172: FILE: net/smc/smc_diag.c:687:
> +	smcd_dev = list_first_entry_or_null(&dev_list->list, struct smcd_dev, list);
> 

The checkpatch.pl script in net-next does not bring up this length warning.
We will address it in a v4.

-- 
Karsten

(I'm a dude)
