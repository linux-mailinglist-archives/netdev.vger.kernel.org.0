Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AD01C07D7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgD3UZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42196 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgD3UZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UK3vod150475;
        Thu, 30 Apr 2020 16:25:20 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r5cm8haw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 16:25:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UKFMON004891;
        Thu, 30 Apr 2020 20:25:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5u9av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 20:25:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UKPGhf30671028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:25:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15DD7A4060;
        Thu, 30 Apr 2020 20:25:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C4B5A4054;
        Thu, 30 Apr 2020 20:25:15 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.152.63])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 20:25:15 +0000 (GMT)
Subject: Re: [PATCH 0/1] net/mlx5: Call pci_disable_sriov() on remove
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
References: <20200430120308.92773-1-schnelle@linux.ibm.com>
 <08d0c332f3cfa034dddc2e3321bf7649ab718701.camel@mellanox.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <a280da2d-b5d4-bfa2-34cd-19444612b71c@linux.ibm.com>
Date:   Thu, 30 Apr 2020 22:25:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <08d0c332f3cfa034dddc2e3321bf7649ab718701.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_12:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/20 6:13 PM, Saeed Mahameed wrote:
> On Thu, 2020-04-30 at 14:03 +0200, Niklas Schnelle wrote:
>> Hello,
>>
>> I'm currently working on improvements in PF-VF handling on s390. One
>> thing that
>> may be a bit special for us is that the s390 hotplug code supports
>> shutting
>> down a single PF of a multi-function device such as a ConnectX-5.
>> During testing I found that the mlx5_core driver does not call
>> pci_disable_sriov() in its remove handler which is called on the PF
>> via
>> pci_stop_and_remove_bus_device() on an orderly hot unplug.
> 
> Actually what happens if you call pci_disable_sriov() when there are
> VFs attached to VMs ? 
So the scenario I looked at was that the admin does a

echo 0 > /sys/bus/pci/slots/<pfslot>/power

for the relevant PFs (Note that on our systems
PFs of a single card could be passed through to different LPARs).
And then physically removes the adapter or moves the PF(s) to a different LPAR.
In this scenario the orderly shutdown would hopefully help QEMU/libvirt to
trigger whatever orderly shutdown it can do but that testing is still on my todo list.
I assumed that because the pci_disable_sriov() call is basically the only
thing the example shows for the remove case it would trigger the intended actions
in the common code including for vfio-pci, udev events and so on.
> 
>>
>> Following is a patch to fix this, I want to point out however that
>> I'm not
>> entirely sure about the effect of clear_vfs that distinguishes
>> mlx5_sriov_detach() from mlx5_sriov_disable() only that the former is
>> called
>> from the remove handler and it doesn't call pci_disable_sriov().
>> That however is required according to Documentation/PCI/pci-iov-
>> howto.rst
>>
> 
> The Doc doesn't say "required", so the question is, is it really
> required ? 
Yes but as I wrote above it is about the only thing the example shows
for the removal procedure so there is definitely a clash between
what the mlx5 driver does and what the documentation suggests.
So I think even though I agree my patch definitely wasn't ready, this
is surely worth thinking about for a second or two.
> 
> because the way i see it, it is the admin responsibility to clear out
> vfs before shutting down the PF driver.
> 
> as explained in the patch review, mlx5 vf driver is resilient of such
> behavior and once the device is back online the vf driver quickly
> recovers, so it is actually a feature and not a bug :)
> 
> There are many reasons why the admin would want to do this:
> 
> 1) Fast Firmware upgrade
> 2) Fast Hyper-visor upgrade/refresh
> 3) PF debugging 
> 
> So you can quickly reset the PF driver without the need to wait for all
> VFs or manually detach-attach them.
So the behavior I was seeing that triggered looking into this is that the VF drivers
weren't just spewing error messages. After hitting some relatively small timeout
the VFs would then start to disappear (maybe 20 seconds or so) and in my testing
I didn't manage to reactivate them.
That might have been due to some error on my part though and I didn't try very
hard because I did not assume that this should work. So thank you for
pointing out that something like that is actually a scenario you have in mind.
Now that I know that I'll definitely look into this a bit more.

So thank you for your input I'm still not sure what the right approach for the
shutdown really is but this is certainly interesting.
> 
> 
>> I've only tested this on top of my currently still internal PF-VF
>> rework so
>> I might also be totally missing something here in that case excuse my
>> ignorance.
>>
>> Best regards,
>> Niklas Schnelle
>>
>> Niklas Schnelle (1):
>>   net/mlx5: Call pci_disable_sriov() on remove
>>
>>  drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
