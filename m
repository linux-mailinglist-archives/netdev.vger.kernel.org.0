Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787AD41DB6F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349993AbhI3NuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:50:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234439AbhI3NuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:50:07 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UD3gFh008494;
        Thu, 30 Sep 2021 09:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ifFbtQrXFMPKpUqGD7Z7Xhv2STHF8prapnmKPedf4fQ=;
 b=DhA2DjDG0uzFsxbwU23RZzPxpkmUanamfI/lqtU2VhDqyoaG2vmTTvlbXMOnlMgZCC3N
 2AcUnF2L7qXoD/FQx8ttKhPppdpWOd8hnEbHI2783AAofACUFIWd8q0C+4ZD2DPw8T+B
 wZTTk93g2KZs1sx2Gd52LJLay+TXabtsP6kmyaAdEr7ah50A4V/iHwVC3eqX0qvy7aTo
 lVLcKxwtxYXK5wjKGtFIfZ3YKZcLtjrPBeVDcNO76x2wOjiE65zkY/T+UYxpkWDf7XKn
 SMAa19fUmj0CO7vgj5qLb/ct8rW7/9TRmVIfWEtnhHZK8fGcndefklmo7q6pv5N/Z9ZG jw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bd9ssfb2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 09:47:54 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18UDbW9Q028722;
        Thu, 30 Sep 2021 13:37:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3b9uda9bab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 13:37:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18UDbYlU62194094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 13:37:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3992AA4065;
        Thu, 30 Sep 2021 13:37:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E8CFA405B;
        Thu, 30 Sep 2021 13:37:33 +0000 (GMT)
Received: from [9.171.46.1] (unknown [9.171.46.1])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Sep 2021 13:37:33 +0000 (GMT)
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210518125443.34148-1-someguy@effective-light.com>
 <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
 <20210914154504.z6vqxuh3byqwgfzx@skbuf>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
Date:   Thu, 30 Sep 2021 15:37:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210914154504.z6vqxuh3byqwgfzx@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3gt7taqy6SRFTXTkypA70uhi7pupShe5
X-Proofpoint-ORIG-GUID: 3gt7taqy6SRFTXTkypA70uhi7pupShe5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_04,2021-09-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2021 17:45, Ioana Ciornei wrote:
> On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
>> +DPAA2, netdev maintainers
>> Hi,
>>
>> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
>>> Since, overlapping mappings are not supported by the DMA API we should
>>> report an error if active_cacheline_insert returns -EEXIST.
>>
>> It seems this patch found a victim. I was trying to run iperf3 on a
>> honeycomb (5.14.0, fedora 35) and the console is blasting this error message
>> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, which
>> is attached below.
>>
> 
> These frags are allocated by the stack, transformed into a scatterlist
> by skb_to_sgvec and then DMA mapped with dma_map_sg. It was not the
> dpaa2-eth's decision to use two fragments from the same page (that will
> also end un in the same cacheline) in two different in-flight skbs.
> 
> Is this behavior normal?
> 

We see the same problem here and it started with 5.15-rc2 in our nightly CI runs.
The CI has panic_on_warn enabled so we see the panic every day now.

Its always the same pattern: module SMC calls dma_map_sg_attrs() which ends
up in the EEXIST warning sooner or later.

It would be better to revert this patch now and start to better understand the 
checking logic for overlapping areas.

Thank you.


The call trace for reference:

[  864.189864] DMA-API: mlx5_core 0662:00:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
[  864.189883] WARNING: CPU: 0 PID: 33720 at kernel/dma/debug.c:570 add_dma_entry+0x208/0x2c8
...
[  864.190747] CPU: 0 PID: 33720 Comm: smcapp Not tainted 5.15.0-20210928.rc3.git0.a59bf04db7bb.300.fc34.s390x+debug #1
[  864.190758] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
[  864.190766] Krnl PSW : 0704d00180000000 00000000fa6239fc (add_dma_entry+0x20c/0x2c8)
[  864.190783]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
[  864.190795] Krnl GPRS: c0000000ffffbfff 0000000080000000 0000000000000061 0000000000000000
[  864.190804]            0000000000000001 0000000000000001 0000000000000001 0000000000000001
[  864.190813]            0700000000000001 000000000020ff00 00000000ffffffff 000000008137b300
[  864.190822]            0000000020020100 0000000000000001 00000000fa6239f8 00000380074536f8
[  864.190837] Krnl Code: 00000000fa6239ec: c020007a4964	larl	%r2,00000000fb56ccb4
                          00000000fa6239f2: c0e5005ef2ff	brasl	%r14,00000000fb201ff0
                         #00000000fa6239f8: af000000		mc	0,0
                         >00000000fa6239fc: ecb60057007c	cgij	%r11,0,6,00000000fa623aaa
                          00000000fa623a02: c01000866149	larl	%r1,00000000fb6efc94
                          00000000fa623a08: e31010000012	lt	%r1,0(%r1)
                          00000000fa623a0e: a774ff73		brc	7,00000000fa6238f4
                          00000000fa623a12: c010008a9227	larl	%r1,00000000fb775e60
[  864.202949] Call Trace:
[  864.202959]  [<00000000fa6239fc>] add_dma_entry+0x20c/0x2c8 
[  864.202971] ([<00000000fa6239f8>] add_dma_entry+0x208/0x2c8)
[  864.202981]  [<00000000fa624988>] debug_dma_map_sg+0x140/0x160 
[  864.202992]  [<00000000fa61eadc>] __dma_map_sg_attrs+0x9c/0xd8 
[  864.203002]  [<00000000fa61eb3a>] dma_map_sg_attrs+0x22/0x40 
[  864.203012]  [<000003ff80483bde>] smc_ib_buf_map_sg+0x5e/0x90 [smc] 
[  864.203036]  [<000003ff80486b44>] smcr_buf_map_link.part.0+0x12c/0x1e8 [smc] 
[  864.203053]  [<000003ff80486cb6>] _smcr_buf_map_lgr+0xb6/0xf8 [smc] 
[  864.203071]  [<000003ff8048b91c>] smcr_buf_map_lgr+0x4c/0x90 [smc] 
[  864.211496]  [<000003ff80490ac2>] smc_llc_cli_add_link+0x152/0x420 [smc] 
[  864.211522]  [<000003ff8047acbc>] smcr_clnt_conf_first_link+0x124/0x1e0 [smc] 
[  864.211537]  [<000003ff8047bfb2>] smc_connect_rdma+0x25a/0x2e8 [smc] 
[  864.211551]  [<000003ff8047da4a>] __smc_connect+0x38a/0x650 [smc] 
[  864.211566]  [<000003ff8047de70>] smc_connect+0x160/0x190 [smc] 
[  864.211580]  [<00000000faf10c70>] __sys_connect+0x98/0xd0 
[  864.211592]  [<00000000faf12e9a>] __do_sys_socketcall+0x16a/0x350 
[  864.211603]  [<00000000fb216752>] __do_syscall+0x1c2/0x1f0 
[  864.211616]  [<00000000fb229148>] system_call+0x78/0xa0 

-- 
Karsten
