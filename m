Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAE02583BD
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 23:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgHaVoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 17:44:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41698 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgHaVoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 17:44:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VLVxqf144381;
        Mon, 31 Aug 2020 17:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ssxexQhZQ2EUzPzKPytyMNxF4dGkVQkuEeqUBliP3vA=;
 b=fqJwGckSgWGKPczb+wUA4UNwOIE0QeyQp+R6owMh2NRq3BPKxfMn54LRL8y0U049BCQM
 E6t3K6EcKA9S02tmbeJvs2zf6DmicutJPmU2m8ApxSuak3b3mWKAjlzgLNULyZHqCUlB
 3lFo5ssM/vIWlHq/T4COCbITgE7LKM/msG8hioc+OQeJj+mjSeXHjlf5TxKbvq3i/Gtm
 W248NJaq/8q0yyAI479WYsLHfL+3zBQ18Df2ufciYrryIsmRq5YoMYYqx+eFA74Z65jj
 4Nck50jqcdadn5nZBEE3gkPEGxaMU+qHXlDPSTODnkWC+EbbjCqhZZXqYaCydNvTLcxA dQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33984wstu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 17:44:08 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VLhMBW027566;
        Mon, 31 Aug 2020 21:44:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 337en97x9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 21:44:08 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VLi7fA25886984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 21:44:07 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38D1D2805C;
        Mon, 31 Aug 2020 21:44:07 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99C8028058;
        Mon, 31 Aug 2020 21:44:06 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 21:44:06 +0000 (GMT)
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL sysfs
 files
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
 <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
 <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d88edd04-458e-b5a5-4cc0-e91c4931d1af@linux.ibm.com>
 <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <fa1d1efb-d799-a1e1-5e1e-8795d5d6cda7@linux.ibm.com>
Date:   Mon, 31 Aug 2020 16:44:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/20 3:11 PM, Jakub Kicinski wrote:
> On Mon, 31 Aug 2020 14:54:06 -0500 Thomas Falcon wrote:
>> On 8/31/20 2:26 PM, Jakub Kicinski wrote:
>>> On Mon, 31 Aug 2020 11:58:13 -0500 Thomas Falcon wrote:
>>>> Provide documentation for ibmvnic device Access Control List
>>>> files.
>>> What API is used to set those parameters in the first place?
>>>   
>> These parameters are specified in the system's IBM Hardware Management
>> Console (HMC) when the VNIC device is create.
> The new attributes are visible in the "guest" OS, correct?

Correct.

>
> This seems similar to normal SR-IOV operation, but I've not heard of
> use cases for them VM to know what its pvid is. Could you elaborate?
It's provided for informational purposes.
