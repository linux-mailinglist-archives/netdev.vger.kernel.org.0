Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A99F35A4EC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhDIRtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:49:39 -0400
Received: from p3plsmtpa06-01.prod.phx3.secureserver.net ([173.201.192.102]:56085
        "EHLO p3plsmtpa06-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234133AbhDIRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:49:38 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id UvFrlzuk8srAFUvFrl1qW4; Fri, 09 Apr 2021 10:49:24 -0700
X-CMAE-Analysis: v=2.4 cv=JsM0EO0C c=1 sm=1 tr=0 ts=607093a4
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=PX1acq3kDUdj2LhQN3AA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
Date:   Fri, 9 Apr 2021 13:49:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2021 12:27 PM, Haakon Bugge wrote:
> 
> 
>> On 9 Apr 2021, at 17:32, Tom Talpey <tom@talpey.com> wrote:
>>
>> On 4/9/2021 10:45 AM, Chuck Lever III wrote:
>>>> On Apr 9, 2021, at 10:26 AM, Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>> On 4/6/2021 7:49 AM, Jason Gunthorpe wrote:
>>>>> On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
>>>>>   
>>>>>> We need to get a better idea what correctness testing has been done,
>>>>>> and whether positive correctness testing results can be replicated
>>>>>> on a variety of platforms.
>>>>> RO has been rolling out slowly on mlx5 over a few years and storage
>>>>> ULPs are the last to change. eg the mlx5 ethernet driver has had RO
>>>>> turned on for a long time, userspace HPC applications have been using
>>>>> it for a while now too.
>>>>
>>>> I'd love to see RO be used more, it was always something the RDMA
>>>> specs supported and carefully architected for. My only concern is
>>>> that it's difficult to get right, especially when the platforms
>>>> have been running strictly-ordered for so long. The ULPs need
>>>> testing, and a lot of it.
>>>>
>>>>> We know there are platforms with broken RO implementations (like
>>>>> Haswell) but the kernel is supposed to globally turn off RO on all
>>>>> those cases. I'd be a bit surprised if we discover any more from this
>>>>> series.
>>>>> On the other hand there are platforms that get huge speed ups from
>>>>> turning this on, AMD is one example, there are a bunch in the ARM
>>>>> world too.
>>>>
>>>> My belief is that the biggest risk is from situations where completions
>>>> are batched, and therefore polling is used to detect them without
>>>> interrupts (which explicitly). The RO pipeline will completely reorder
>>>> DMA writes, and consumers which infer ordering from memory contents may
>>>> break. This can even apply within the provider code, which may attempt
>>>> to poll WR and CQ structures, and be tripped up.
>>> You are referring specifically to RPC/RDMA depending on Receive
>>> completions to guarantee that previous RDMA Writes have been
>>> retired? Or is there a particular implementation practice in
>>> the Linux RPC/RDMA code that worries you?
>>
>> Nothing in the RPC/RDMA code, which is IMO correct. The worry, which
>> is hopefully unfounded, is that the RO pipeline might not have flushed
>> when a completion is posted *after* posting an interrupt.
>>
>> Something like this...
>>
>> RDMA Write arrives
>> 	PCIe RO Write for data
>> 	PCIe RO Write for data
>> 	...
>> RDMA Write arrives
>> 	PCIe RO Write for data
>> 	...
>> RDMA Send arrives
>> 	PCIe RO Write for receive data
>> 	PCIe RO Write for receive descriptor
> 
> Do you mean the Write of the CQE? It has to be Strongly Ordered for a correct implementation. Then it will shure prior written RO date has global visibility when the CQE can be observed.

I wasn't aware that a strongly-ordered PCIe Write will ensure that
prior relaxed-ordered writes went first. If that's the case, I'm
fine with it - as long as the providers are correctly coded!!

>> 	PCIe interrupt (flushes RO pipeline for all three ops above)
> 
> Before the interrupt, the HCA will write the EQE (Event Queue Entry). This has to be a Strongly Ordered write to "push" prior written CQEs so that when the EQE is observed, the prior writes of CQEs have global visibility.
> 
> And the MSI-X write likewise, to avoid spurious interrupts.

Ok, and yes agreed the same principle would apply.

Is there any implication if a PCIe switch were present on the
motherboard? The switch is allowed to do some creative routing
if the operation is relaxed, correct?

Tom.

> Thxs, Håkon
> 
>>
>> RPC/RDMA polls CQ
>> 	Reaps receive completion
>>
>> RDMA Send arrives
>> 	PCIe RO Write for receive data
>> 	PCIe RO write for receive descriptor
>> 	Does *not* interrupt, since CQ not armed
>>
>> RPC/RDMA continues to poll CQ
>> 	Reaps receive completion
>> 	PCIe RO writes not yet flushed
>> 	Processes incomplete in-memory data
>> 	Bzzzt
>>
>> Hopefully, the adapter performs a PCIe flushing read, or something
>> to avoid this when an interrupt is not generated. Alternatively, I'm
>> overly paranoid.
>>
>> Tom.
>>
>>>> The Mellanox adapter, itself, historically has strict in-order DMA
>>>> semantics, and while it's great to relax that, changing it by default
>>>> for all consumers is something to consider very cautiously.
>>>>
>>>>> Still, obviously people should test on the platforms they have.
>>>>
>>>> Yes, and "test" be taken seriously with focus on ULP data integrity.
>>>> Speedups will mean nothing if the data is ever damaged.
>>> I agree that data integrity comes first.
>>> Since I currently don't have facilities to test RO in my lab, the
>>> community will have to agree on a set of tests and expected results
>>> that specifically exercise the corner cases you are concerned about.
>>> --
>>> Chuck Lever
> 
