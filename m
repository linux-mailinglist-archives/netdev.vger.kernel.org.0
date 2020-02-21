Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12C91687C2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBUTtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:49:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54948 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBUTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:49:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LJn7Z6069735;
        Fri, 21 Feb 2020 19:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=43KHsRYRj69Ap9URntU4TCKhlnu6ax6ePecgc0f+HMQ=;
 b=axX+Se5KrSphJ5Ov+7UcduRBCAo8izFzyBwL/T7Tja0ZfG5NVoPvolT5t1ianD8BapyC
 e3D2+5uybmUbYwnaUOnMchND81z5Ob+nKfAvyJF9YfP6hlFkKnV5QySuSCPIWwZarJqM
 qZkGgtqFwbxk0v3lxfUS2atQ7d5LUvLP2qZYa2S9DpfPkcQHW9Vuf/3gQSKHbh0WDVS5
 G2Vpi8EBBba3V8ym4kipvz5ukHplXmAzmvb2HXeQwKGTvFUgIHHaVtENKY69z+b6tUs3
 pYnIas/OWDeqMGk+yCtnyN7R3Wm5GYQ27dGNph8Ei6k09qaE70U+BjdRNh5dgKp5b+df Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8uddjk7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 19:49:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LJm19b177477;
        Fri, 21 Feb 2020 19:49:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8udpwh6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 19:49:08 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LJn7vo030087;
        Fri, 21 Feb 2020 19:49:07 GMT
Received: from [10.159.238.51] (/10.159.238.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 11:49:07 -0800
Subject: Re: vsock CID questions
To:     =?UTF-8?Q?J=c3=a1n_Tomko?= <jtomko@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     sgarzare@redhat.com, netdev@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
 <20200219154317.GB1085125@stefanha-x1.localdomain>
 <20200220160912.GL3065@lpt>
From:   ted.h.kim@oracle.com
Organization: Oracle Corporation
Message-ID: <b08eda42-9cc7-7a9a-b5b1-5adc44050896@oracle.com>
Date:   Fri, 21 Feb 2020 11:49:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220160912.GL3065@lpt>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jan,

Thanks for responding - let me see if I am understanding correctly.


I think you are saying on migration the process of determining the CID 
assigned is the same as when you start a domain.

<cid auto='yes'> means assignment to the first available value.
It also seems for auto='yes' that any address='<value>' part of the CID 
definition is ignored, even as a suggested value.
(I always get CID 3 when starting auto='yes' and no other domains have 
started, even if there is an specific address in the definition, e.g. 
address='12'.)

But if auto='no', either the domain gets the address field value or if 
the value is already assigned, the domain will fail to start/migrate.

Is that right?


In cases, where auto='yes', it does not seem that the host/hypervisor 
can find out what CID value was assigned to a domain. Even parsing the 
XML only reveals that it was auto-assigned and no specific value can be 
determined.

Is this correct?

If this is the case, I would advocate for a specific API which can 
lookup the current CID of a domain.
Otherwise the host/hypervisor cannot tell which  auto='yes' domain is on 
the other end of the connected socket, when there is more than one.


Thanks.
-ted


On 2/20/20 8:09 AM, Ján Tomko wrote:
> On Wed, Feb 19, 2020 at 03:43:17PM +0000, Stefan Hajnoczi wrote:
>> On Tue, Feb 18, 2020 at 02:45:38PM -0800, ted.h.kim@oracle.com wrote:
>>> 1. Is there an API to lookup CIDs of guests from the host side (in 
>>> libvirt)?
>>
>> I wonder if it can be queried from libvirt (at a minimum the domain XML
>> might have the CID)?  I have CCed Ján Tomko who worked on the libvirt
>> support:
>>
>> https://libvirt.org/formatdomain.html#vsock
>>
>
> Yes, libvirt has to know the CIDs of the guest and presents them in the
> domain XML:
> <domain type='kvm'>
>   <name>test</name>
>   ...
>   <devices>
>     ...
>     <vsock model='virtio'>
>       <cid auto='no' address='4'/>
>       <address type='pci' domain='0x0000' bus='0x00' slot='0x07' 
> function='0x0'/>
>     </vsock>
>   </devices>
> </domain>
>
>>> 2. In the vsock(7) man page, it says the CID might change upon 
>>> migration, if
>>> it is not available.
>>> Is there some notification when CID reassignment happens?
>>
>> All established connections are reset across live migration -
>> applications will notice :).
>>
>> Listen sockets stay open but automatically listen on the new CID.
>>
>>> 3. if CID reassignment happens, is this persistent? (i.e. will I see 
>>> updated
>>> vsock definition in XML for the guest)
>>
>> Another question for Ján.
>
> Depends on the setting.
> For <cid auto='yes'/>, libvirt will try to acquire the first available 
> CID
> for the guest and pass it to QEMU.
> For <cid auto='no'/>, no reassignment should happend and the CID
> requested in the domain XML on the source will be used (or fail to be
> used) on the destination.
>
> Jano
>
>>
>>> 4. I would like to minimize the chance of CID collision. If I 
>>> understand
>>> correctly, the CID is a 32-bit unsigned. So for my application, it 
>>> might
>>> work to put an IPv4 address. But if I adopt this convention, then I 
>>> need to
>>> look forward to possibly using IPv6. Anyway, would it be hard to 
>>> potentially
>>> expand the size of the CID to 64 bits or even 128?
>>
>> A little hard, since the struct sockaddr_vm that userspace applications
>> use has a 32-bit CID field.  This is because the existing VMware VMCI
>> vsock implementation has 32-bit CIDs.
>>
>> virtio-vsock is ready for 64-bit CIDs (the packet header fields are
>> already 64-bit) but changes to net/vmw_vsock/ core code and to the
>> userspace ABI would be necessary.
>>
>> Stefan
>
>
-- 
Ted H. Kim, PhD
ted.h.kim@oracle.com
+1 310-258-7515


