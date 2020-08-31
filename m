Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28011258217
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgHaTvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:51:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729436AbgHaTvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:51:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VJX374061512;
        Mon, 31 Aug 2020 15:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ibg2ebrpNKeT5k+92FbeSNmHDMyn6xI4xroB48b2eFQ=;
 b=kCdHeFPwy/3E06Sl8OVsH/Ns6AZliDrpwjRfhXXhBRNm4k5r20tu2qmbGDuJ1+FIltbc
 prmw7xr0c2KReeSxQ9XCrB7J290oHaNVduFOZUg+EbnYKQ3NFnxBi1RN3jyF1NnqELHY
 9vg9OAsEffe6lGXO1WF9GDH9uHq+eaUmtEyLICKZvMf7KQaQS9mP0v9pX1Mc/nFjNjsQ
 TEGNJrawoA1Nc5d55pQZd7zGaMZzUmjJVOuv3rXCtgCh6248gwPSJyVH/slhVyg3ginz
 S/CuHom20tzgTTNZci6zSsn3AjA4yaHvBdj5YcFjTk2sYCpTTq0z9b0L4omiZkiCKt9v BA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3395wntwaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 15:51:52 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VJg58l019737;
        Mon, 31 Aug 2020 19:51:51 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 337en9f6rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 19:51:51 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VJpono50528722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:51:50 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D49A92805C;
        Mon, 31 Aug 2020 19:51:50 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50DE62805A;
        Mon, 31 Aug 2020 19:51:50 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 19:51:50 +0000 (GMT)
Subject: Re: [PATCH net-next 2/5] ibmvnic: Include documentation for ibmvnic
 sysfs files
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
 <1598893093-14280-3-git-send-email-tlfalcon@linux.ibm.com>
 <20200831120732.2fa09746@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <c4a785ea-d5bc-4178-994f-e426e6512496@linux.ibm.com>
Date:   Mon, 31 Aug 2020 14:51:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831120732.2fa09746@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_09:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/20 2:07 PM, Jakub Kicinski wrote:
> On Mon, 31 Aug 2020 11:58:10 -0500 Thomas Falcon wrote:
>> Include documentation for existing ibmvnic sysfs files,
>> currently only for "failover," which is used to swap
>> the active hardware port to a backup port in redundant
>> backing hardware or failover configurations.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>>   Documentation/ABI/testing/sysfs-driver-ibmvnic | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-driver-ibmvnic
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-ibmvnic b/Documentation/ABI/testing/sysfs-driver-ibmvnic
>> new file mode 100644
>> index 0000000..7fa2920
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-driver-ibmvnic
>> @@ -0,0 +1,14 @@
>> +What:		/sys/devices/vio/<our device>/failover
>> +Date:		June 2017
>> +KernelVersion:	4.13
>> +Contact:	linuxppc-dev@lists.ozlabs.org
>> +Description:	If the ibmvnic device has been configured with redundant
>> +		physical NIC ports, the user may write "1" to the failover
>> +		file to trigger a device failover, which will reset the
>> +		ibmvnic device and swap to a backup physical port. If no
>> +		redundant physical port has been configured for the device,
>> +		the device will not reset and -EINVAL is returned. If anything
>> +		other than "1" is written to the file, -EINVAL will also be
>> +		returned.
>> +Users:		Any users of the ibmvnic driver which use redundant hardware
>> +		configurations.
> Could you elaborate what the failover thing is? Is it what net_failover
> does or something opposite? (you say "backup physical port" which
> sounds like physical port is a backup.. perhaps some IBM nomenclature
> there worth clarifying?)

Hi Jakub,

When creating a SRIOV VNIC device on a Power system, the user will 
specify one or more ports to use from physical NIC's available to the 
Power Hypervisor. These aren't visible to the Linux OS. In a failover 
configuration, the VNIC will have one active port and at least one other 
port in backup or standby mode. It's similar to the bonding driver's 
active-backup mode. If the hypervisor detects a problem with the active 
port, it will swap in the backup port and send a signal to the VNIC 
driver that it should reset, which is needed to activate the new port. 
There is also a mechanism through which the driver can force this 
operation in case the hypervisor does not detect an issue with the 
active port. This mechanism can be triggered by an administrator or with 
userspace tools through the 'failover' device file in sysfs.

Tom

