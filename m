Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D79335F61C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhDNOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:24:23 -0400
Received: from p3plsmtpa12-07.prod.phx3.secureserver.net ([68.178.252.236]:52157
        "EHLO p3plsmtpa12-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233619AbhDNOYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:24:21 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 10:24:21 EDT
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id WgJgl1TYe83tOWgJgl6gLC; Wed, 14 Apr 2021 07:16:32 -0700
X-CMAE-Analysis: v=2.4 cv=ONniYQWB c=1 sm=1 tr=0 ts=6076f940
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=mjHj8f7IP-_Ssy1yzXMA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Haakon Bugge <haakon.bugge@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
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
References: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
 <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
 <20210412224843.GQ7405@nvidia.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
Date:   Wed, 14 Apr 2021 10:16:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210412224843.GQ7405@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfGTyGI9FgMZueN/VuVEHG2FaOth4D6Soi4vPPlQrukhtlPXD1VwQcCjhABcx0A4Q/VTAukiSy8/ZZk942NNDeFgYcoH86GtEkHYxV4AcwZpVkzGBjVe7
 ijdyR1xc775B1NkeoelBVwdDzIVTl/8yvQZv6xCGeRw7f5Lde7x90IZ1IOzne9HesCjB6pW5YGXiBCY5JteAaF9MimnBpfqY0vS4SKeL2ES7A+8cjRkB4JaL
 KIXoGWkLrgSb168gHFEI1P4NWEHGM9fRN6DA1DpykdtDiECdsoPFPiYNCcMxD2oK5jpOhzXo4LCbwrcFJUWSxlxHW72MJ4HLQooqz+TJ5aX6LOSN19O5paY2
 Vel9ybw8O0svi06qNN+V6G+pil9VODqJEzaZVFto+iWmuzZJ4UsIlZKsJVpE/hpI/bAhXqTPQLZvmOzSABGNU7NQtwG37iLZ0was7NkTbqwRuMOU2vJeZwKU
 YITf0lQscdb2xvk2EXRRY3Jo3UrEX927JL3iVVSPCRbePKlrnFjoAi5w8T60CMNvdDewjOsGEWQsJa19WCIiwcw9x/mv4DD/yHK7uEYLWi9mX4Ruyk427z/i
 I4aQwVYMzp07F5BPeflA7pjPiABEa7mzFG8mgV4pmGCrgl98iohPUYGFWvJ7b131z0aOjFGpKUTdBn3WyroQe5Ejv0SJ/rf28Dx8qUB0oMgDOfMnGNVy/XCh
 FakYzqeBYfziwZ8WitWqHh9UUEgcYqQV1G0/yUEoshb2X31VzXqovYCgqkkLYin8zlsm/hJwKsGT1aB/+fH98CeWqeriPN42Gy9VZmheKxAtxah9Kjtqyk5F
 r/5hjWLybbywTEK8kIE7pThLcim1fVuV/Zl0NfKSlVcYOdsCZn3ianYWsUAsWd//SAFpMq5ok6/Du78X7al4oIKo8yXxk4CfcwYKxVV3Ge4KB9wFcPxoNngw
 cyC1aGjItRCrX0cmbYIOfKZziEpxve8Y1M11AVA6hUwm+It54Pm5MRWQmEQjIsCOKmn9a27JUNhP2F90oHhUUkh2TQeeLb2zuvwZFj9tikIX8oAjxIeBljN8
 4l29IbiROTn+f//gjdERoityx3y4xqB8G8g4WuKReDVPg2eLJumqwPAjaEyF6NP+wHqFEHf/PurD9TW4aDtaxLHFuF1HU0hlERT4iVuenz0RO6DRnY86Ai2s
 ISxsBRUsajZYRgalSQFW8ZE3SEUH69ZpaCR84Pr0jtdrKstzjTZz3npWb4vRtTr9ZB71na011rCZ6gzt7BFrRuiBI5LujjOpDbCsh7dw6t9wF4bxfuETMnLT
 ucctoX45vpR7LRRmo6YvtfhE6M5AMUvaxN5lwgA4AXTQVT/c6qSn7vMxewMWKwkdmCu2+Tr0sdMvy+cJkz9CqEwdXe8QJFgwh5AUevoHpfBvXXC6FIL/vbYX
 dHPOffudtZjHIjWWmQ0dgQgKSP3R0Ibtb0RE7E4eebhLJG4H3h3Mn3Fof+3xlv32K6MyXqVs8v7/3KZpV3zxDNvfn3yxMZ4g8m07BRc9C2oKmGOXhIu2mIrS
 Cr2RM9MPK/8tQhw+swUbpfZmuNMZzd2CN5wvWOBwkqEeJa5w5Ar/R1iGhzzBnpSCaL/JxQfP0m58zf1i4bc6GA/tGXAX4D9+PtFHQiG6jKN8BwyZfnv2c489
 N3EHczWWG5RkewHGmo2cLErRO00K3yGI6IfKO9TVGBUuOYo7xSbY6WOP37GsuXRnze6ciW+YF/tCoZc+79WNTuhhvHUcHjyR4SwRmbexCD402S8Rk9kwzjWG
 EP/zKkjMuDk0KLdQaVg1csPQlPpx4Qn3YVTsOriiZdL92VucgwPYzID7Dq0Bp7tBuD7pY5TRuPZZnQGxb5tm7ycoWIUNXlO+D21WmuVvxKeuuVH1Wkx0e0v4
 lTHu7foEGNcaJ336A1yUypMPjZhiC3B575bI2Q9qlninmEanDWDLzrb5nEEsowncVowpu7P+leg1koYnVA8fD6O7GGvvqx3M/7gTkW2yh2/ZqMya
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/2021 6:48 PM, Jason Gunthorpe wrote:
> On Mon, Apr 12, 2021 at 04:20:47PM -0400, Tom Talpey wrote:
> 
>> So the issue is only in testing all the providers and platforms,
>> to be sure this new behavior isn't tickling anything that went
>> unnoticed all along, because no RDMA provider ever issued RO.
> 
> The mlx5 ethernet driver has run in RO mode for a long time, and it
> operates in basically the same way as RDMA. The issues with Haswell
> have been worked out there already.
> 
> The only open question is if the ULPs have errors in their
> implementation, which I don't think we can find out until we apply
> this series and people start running their tests aggressively.

I agree that the core RO support should go in. But turning it on
by default for a ULP should be the decision of each ULP maintainer.
It's a huge risk to shift all the storage drivers overnight. How
do you propose to ensure the aggressive testing happens?

One thing that worries me is the patch02 on-by-default for the dma_lkey.
There's no way for a ULP to prevent IB_ACCESS_RELAXED_ORDERING
from being set in __ib_alloc_pd().

Tom.


