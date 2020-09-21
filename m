Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43B27312F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgIURvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:51:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgIURvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:51:43 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHkj9P116599;
        Mon, 21 Sep 2020 13:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i9lgxr9Kamu8IasZTG+RAxb2X1/wliAmumu0R/2V44E=;
 b=fgyymzksYdno4Hlz0XxeTyBPD5PNiC1PoC+TtWTccXXTw2lJqutpZVUPtMUjOFHnBVTh
 Wg1IiTyBpJGoUv5U2jBZMARaZHkrqUeZSVvfDK1z3dHhiCPjIcZk23hMK7jBm40uEHBb
 pvW9yl+6ZAn0MjTIeoa9CYS2mya4lS3kvyp8FPx5921Z2KOIhXUGV2EVwoQBeHAW5e94
 osXaunZY7S5KIGSyrm1vT2L5f8CGqUvwoK2Vy4fiDQXcpjqrY2GXLW1YjCRe/93LO15P
 JnpEl+blkAj9kIvGjfaCCUJaz8pfWqfqKnJvBVgPbwk9gSHnwPouLerPxi8pTBL9tVMZ dw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33q0ug04bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 13:51:40 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LHWevN009539;
        Mon, 21 Sep 2020 17:51:38 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 33n9m8ryw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 17:51:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LHpbPN59441424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 17:51:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D37FEC6059;
        Mon, 21 Sep 2020 17:51:37 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C42C6055;
        Mon, 21 Sep 2020 17:51:37 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.104.79])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 17:51:36 +0000 (GMT)
Subject: Re: Exposing device ACL setting through devlink
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
 <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
 <20200918072054.GA2323@nanopsycho.orion>
 <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
 <20200920152136.GB2323@nanopsycho.orion>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <cf32abfa-62e9-1d5a-942d-764affbb2536@linux.ibm.com>
Date:   Mon, 21 Sep 2020 12:51:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200920152136.GB2323@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=896 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/20/20 10:21 AM, Jiri Pirko wrote:
> Sat, Sep 19, 2020 at 01:20:34AM CEST, tlfalcon@linux.ibm.com wrote:
>> On 9/18/20 2:20 AM, Jiri Pirko wrote:
>>> Thu, Sep 17, 2020 at 10:31:10PM CEST, tlfalcon@linux.ibm.com wrote:
>>>> On 9/10/20 2:00 AM, Jiri Pirko wrote:
>>>>> Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>>>>>> On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>>>>>>> On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>>>>>>>> Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>>>>>>>>> Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>>>>>>>>> VNIC devices to administrators through devlink (originally through
>>>>>>>>> sysfs files, but that was rejected in favor of devlink). Could you
>>>>>>>>> give any tips on how you might go about doing this?
>>>>>>>> Tom, I believe you need to provide more info about what exactly do you
>>>>>>>> need to setup. But from what you wrote, it seems like you are looking
>>>>>>>> for bridge/tc offload. The infra is already in place and drivers are
>>>>>>>> implementing it. See mlxsw for example.
>>>>>>> I think Tom's use case is effectively exposing the the VF which VLANs
>>>>>>> and what MAC addrs it can use. Plus it's pvid. See:
>>>>>>>
>>>>>>> https://www.spinics.net/lists/netdev/msg679750.html
>>>>>> Thanks, Jakub,
>>>>>>
>>>>>> Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>>>>>> the VF's PVID. Other use-cases may be explored later on though.
>>>>> Who is configuring those?
>>>>>
>>>>> What does mean "allowed MAC address"? Does it mean a MAC address that VF
>>>>> can use to send packet as a source MAC?
>>>>>
>>>>> What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
>>>>> some VIDs are allowed.
>>>>>
>>>>> Pardon my ignorance, this may be routine in the nic world. However I
>>>>> find the desc very vague. Please explain in details, then we can try to
>>>>> find fitting solution.
>>>>>
>>>>> Thanks!
>>>> These MAC or VLAN ACL settings are configured on the Power Hypervisor.
>>>>
>>>> The rules for a VF can be to allow or deny all MAC addresses or VLAN ID's or
>>>> to allow a specified list of MAC address and VLAN ID's. The interface allows
>>>> or denies frames based on whether the ID in the VLAN tag or the source MAC
>>>> address is included in the list of allowed VLAN ID's or MAC addresses
>>>> specified during creation of the VF.
>>> At which point are you doing this ACL? Sounds to me, like this is the
>>> job of "a switch" which connects VFs and physical port. Then, you just
>>> need to configure this switch to pass/drop packets according to match.
>>> And that is what there is already implemented with TC-flower/u32 + actions
>>> and bridge offload.
>>>
>> Yes, this the filtering is done on a virtual switch in Power firmware. I am
>> really just trying to report the ACL list's configured at the firmware level
>> to users on the guest OS.
> We have means to model switches properly in linux and offload to them.
> I advise you to do that.

I will look into that, thank you!

Tom


>
>
>> Tom
>>
>>>> Thanks for your help,
>>>>
>>>> Tom
>>>>
