Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C964F2227EE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgGPQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:00:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23948 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728126AbgGPQAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:00:14 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFWxH3110454;
        Thu, 16 Jul 2020 12:00:05 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 327u1ktp3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 12:00:04 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GG02eq017976;
        Thu, 16 Jul 2020 16:00:02 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 327529mdpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 16:00:02 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFxwt061145592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:59:58 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBC506A05D;
        Thu, 16 Jul 2020 16:00:00 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D44FC6A04D;
        Thu, 16 Jul 2020 15:59:59 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.26.83])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:59:59 +0000 (GMT)
Subject: Re: [PATCH net-next] ibmvnic: Increase driver logging
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com
References: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
 <20200715170632.11f0bf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200715.182956.490791427431304861.davem@davemloft.net>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <9c9d6e46-240b-8513-08e4-e1c7556cb3c8@linux.ibm.com>
Date:   Thu, 16 Jul 2020 10:59:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715.182956.490791427431304861.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 suspectscore=2 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/15/20 8:29 PM, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 15 Jul 2020 17:06:32 -0700
>
>> On Wed, 15 Jul 2020 18:51:55 -0500 Thomas Falcon wrote:
>>>   	free_netdev(netdev);
>>>   	dev_set_drvdata(&dev->dev, NULL);
>>> +	netdev_info(netdev, "VNIC client device has been successfully removed.\n");
>> A step too far, perhaps.
>>
>> In general this patch looks a little questionable IMHO, this amount of
>> logging output is not commonly seen in drivers. All the the info
>> messages are just static text, not even carrying any extra information.
>> In an era of ftrace, and bpftrace, do we really need this?
> Agreed, this is too much.  This is debugging, and thus suitable for tracing
> facilities, at best.

Thanks for your feedback. I see now that I was overly aggressive with 
this patch to be sure, but it would help with narrowing down problems at 
a first glance, should they arise. The driver in its current state logs 
very little of what is it doing without the use of additional debugging 
or tracing facilities. Would it be worth it to pursue a less aggressive 
version or would that be dead on arrival? What are acceptable driver 
operations to log at this level?

Thanks,

Tom

