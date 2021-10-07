Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B24442519C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240487AbhJGLC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:02:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62300 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240599AbhJGLCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 07:02:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1979aNfX021276;
        Thu, 7 Oct 2021 06:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jOJ33YjEn/VRMnsqj2+ffjTRn0vZYsJ/XCDQ0GiGnls=;
 b=jr+8GLibaHwM1kjWjATXF0cYfbeacTlie4xgKxlJ7bDH0gRKe2V8CRPS1H4fDyF0/L/g
 YIdDIHwL5HS9ETSZn+E9tWI0vqQjAry5apqmf0d4M+mlbN+uY7xyq6pXMiKxSdetUJAX
 QZmevIeuEBhYMZqWx5L5ZIVU09N8fm2pPXl/BRUEJclX+xeSuoMphowjwPnTNyXfFOSx
 ffQ8ZscPllw84WFaciDWrZFR5YUDQUTPuWETRpzREShITo0PumB7v8vnqvjdD0CCHIBZ
 yqDzVfjza6e9++HDJz7oSRWGG0fn2/68TydTHcuKUhHgAjHVov0RlRPXnU9OVAfzxAnb qQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhksy6j8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 06:59:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 197Au2xF019413;
        Thu, 7 Oct 2021 10:59:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepd002r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 10:59:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 197AxWgC45613416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 10:59:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4973AE074;
        Thu,  7 Oct 2021 10:59:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E49E6AE070;
        Thu,  7 Oct 2021 10:59:31 +0000 (GMT)
Received: from [9.171.95.81] (unknown [9.171.95.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 10:59:31 +0000 (GMT)
Message-ID: <fd4a2d8d-3f9d-51f3-1c86-8009ad50e6a1@linux.ibm.com>
Date:   Thu, 7 Oct 2021 12:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210518125443.34148-1-someguy@effective-light.com>
 <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
 <20210914154504.z6vqxuh3byqwgfzx@skbuf>
 <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
 <20211001145256.0323957a@thinkpad> <20211006151043.61fe9613@thinkpad>
 <4a96b583-1119-8b26-cc85-f77a6b4550a2@arm.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <4a96b583-1119-8b26-cc85-f77a6b4550a2@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kDPanIe3NO7XqJurDB-cWKBky-zO4U2A
X-Proofpoint-ORIG-GUID: kDPanIe3NO7XqJurDB-cWKBky-zO4U2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_01,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110070072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10/2021 16:23, Robin Murphy wrote:
> On 2021-10-06 14:10, Gerald Schaefer wrote:
>> On Fri, 1 Oct 2021 14:52:56 +0200
>> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
>>
>>> On Thu, 30 Sep 2021 15:37:33 +0200
>>> Karsten Graul <kgraul@linux.ibm.com> wrote:
>>>
>>>> On 14/09/2021 17:45, Ioana Ciornei wrote:
>>>>> On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
>>>>>> +DPAA2, netdev maintainers
>>>>>> Hi,
>>>>>>
>>>>>> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
>>>>>>> Since, overlapping mappings are not supported by the DMA API we should
>>>>>>> report an error if active_cacheline_insert returns -EEXIST.
>>>>>>
>>>>>> It seems this patch found a victim. I was trying to run iperf3 on a
>>>>>> honeycomb (5.14.0, fedora 35) and the console is blasting this error message
>>>>>> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, which
>>>>>> is attached below.
>>>>>>
>>>>>
>>>>> These frags are allocated by the stack, transformed into a scatterlist
>>>>> by skb_to_sgvec and then DMA mapped with dma_map_sg. It was not the
>>>>> dpaa2-eth's decision to use two fragments from the same page (that will
>>>>> also end un in the same cacheline) in two different in-flight skbs.
>>>>>
>>>>> Is this behavior normal?
>>>>>
>>>>
>>>> We see the same problem here and it started with 5.15-rc2 in our nightly CI runs.
>>>> The CI has panic_on_warn enabled so we see the panic every day now.
>>>
>>> Adding a WARN for a case that be detected false-positive seems not
>>> acceptable, exactly for this reason (kernel panic on unaffected
>>> systems).
>>>
>>> So I guess it boils down to the question if the behavior that Ioana
>>> described is legit behavior, on a system that is dma coherent. We
>>> are apparently hitting the same scenario, although it could not yet be
>>> reproduced with debug printks for some reason.
>>>
>>> If the answer is yes, than please remove at lease the WARN, so that
>>> it will not make systems crash that behave valid, and have
>>> panic_on_warn set. Even a normal printk feels wrong to me in that
>>> case, it really sounds rather like you want to fix / better refine
>>> the overlap check, if you want to report anything here.
>>
>> Dan, Christoph, any opinion?
>>
>> So far it all looks a lot like a false positive, so could you please
>> see that those patches get reverted? I do wonder a bit why this is
>> not an issue for others, we surely cannot be the only ones running
>> CI with panic_on_warn.
> 
> What convinces you it's a false-positive? I'm hardly familiar with most of that callstack, but it appears to be related to mlx5, and I know that exists on expansion cards which could be plugged into a system with non-coherent PCIe where partial cacheline overlap *would* be a real issue. Of course it's dubious that there are many real use-cases for plugging a NIC with a 4-figure price tag into a little i.MX8 or whatever, but the point is that it *should* still work correctly.
> 
>> We would need to disable DEBUG_DMA if this WARN stays in, which
>> would be a shame. Of course, in theory, this might also indicate
>> some real bug, but there really is no sign of that so far.
> 
> The whole point of DMA debug is to flag up things that you *do* get away with on the vast majority of systems, precisely because most testing happens on those systems rather than more esoteric embedded setups. Say your system only uses dma-direct and a driver starts triggering the warning for not calling dma_mapping_error(), would you argue for removing that warning as well since dma_map_single() can't fail on your machine so it's "not a bug"?
> 
>> Having multiple sg elements in the same page (or cacheline) is
>> valid, correct? And this is also not a decision of the driver
>> IIUC, so if it was bug, it should be addressed in common code,
>> correct?
> 
> According to the streaming DMA API documentation, it is *not* valid:
> 
> ".. warning::
> 
>   Memory coherency operates at a granularity called the cache
>   line width.  In order for memory mapped by this API to operate
>   correctly, the mapped region must begin exactly on a cache line
>   boundary and end exactly on one (to prevent two separately mapped
>   regions from sharing a single cache line).  Since the cache line size
>   may not be known at compile time, the API will not enforce this
>   requirement.  Therefore, it is recommended that driver writers who
>   don't take special care to determine the cache line size at run time
>   only map virtual regions that begin and end on page boundaries (which
>   are guaranteed also to be cache line boundaries)."
> 
>>> BTW, there is already a WARN in the add_dma_entry() path, related
>>> to cachlline overlap and -EEXIST:
>>>
>>> add_dma_entry() -> active_cacheline_insert() -> -EEXIST ->
>>> active_cacheline_inc_overlap()
>>>
>>> That will only trigger when "overlap > ACTIVE_CACHELINE_MAX_OVERLAP".
>>> Not familiar with that code, but it seems that there are now two
>>> warnings for more or less the same, and the new warning is much more
>>> prone to false-positives.
>>>
>>> How do these 2 warnings relate, are they both really necessary?
>>> I think the new warning was only introduced because of some old
>>> TODO comment in add_dma_entry(), see commit 2b4bbc6231d78
>>> ("dma-debug: report -EEXIST errors in add_dma_entry").
> 
> AFAICS they are different things. I believe the new warning is supposed to be for the fundementally incorrect API usage (as above) of mapping different regions overlapping within the same cacheline. The existing one is about dma-debug losing internal consistency when tracking the *same* region being mapped multiple times, which is a legal thing to do - e.g. buffer sharing between devices - but if anyone's doing it to excess that's almost certainly a bug (i.e. they probably intended to unmap it in between but missed that out).

Thanks for the explanation Robin. 

In our case its really that a buffer is mapped twice for 2 different devices which we use in SMC to provide failover capabilities. We see that -EEXIST is returned when a buffer is mapped for the second device. Since there is a maximum of 2 parallel mappings we never see the warning shown by active_cacheline_inc_overlap() because we don't exceed ACTIVE_CACHELINE_MAX_OVERLAP.

So how to deal with this kind of "legal thing", looks like there is no way to suppress the newly introduced EEXIST warning for that case?


Karsten
