Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDA71C6A93
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgEFH4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:56:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728280AbgEFH4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:56:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0467WTl4069872;
        Wed, 6 May 2020 03:56:46 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hptbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 03:56:46 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0467nk8M030470;
        Wed, 6 May 2020 07:56:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g5bhj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 07:56:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0467ufAX38666492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 07:56:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1E45A4065;
        Wed,  6 May 2020 07:56:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68A57A4060;
        Wed,  6 May 2020 07:56:41 +0000 (GMT)
Received: from [9.145.79.19] (unknown [9.145.79.19])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 07:56:41 +0000 (GMT)
Subject: Re: [PATCH net-next 10/11] s390/qeth: allow reset via ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
 <20200505162559.14138-11-jwi@linux.ibm.com>
 <20200505102149.1fd5b9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a19ccf27-2280-036c-057f-8e6d2319bb28@linux.ibm.com>
 <20200505112940.6fe70918@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
 <20200505142855.24b7c1bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <104f8e57-42d2-8853-d540-76b8516043d5@linux.ibm.com>
Date:   Wed, 6 May 2020 09:56:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505142855.24b7c1bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.20 23:28, Jakub Kicinski wrote:
> On Tue, 5 May 2020 21:57:43 +0200 Julian Wiedmann wrote:
>>> This is the comment from the uAPI header:
>>>
>>> /* The reset() operation must clear the flags for the components which
>>>  * were actually reset.  On successful return, the flags indicate the
>>>  * components which were not reset, either because they do not exist
>>>  * in the hardware or because they cannot be reset independently.  The
>>>  * driver must never reset any components that were not requested.
>>>  */
>>>
>>> Now let's take ETH_RESET_PHY as an example. Surely you're not resetting
>>> any PHY here, so that bit should not be cleared. Please look at the
>>> bits and select the ones which make sense, add whatever is missing.
>>>   
>>
>> It's a virtual device, _none_ of them make much sense?! We better not be
>> resetting any actual HW components, the other interfaces on the same
>> adapter would be quite unhappy about that.
> 
> Well, then, you can't use the API in its current form. You can't say
> none of the sub-options are applicable, but the sum of them does.
> 

Agreed, that's my take as well. So we'll basically need a ETH_RESET_FULL bit,
for devices that don't fit into the fine-grained component model.

>> Sorry for being dense, and I appreciate that the API leaves a lot of room
>> for sophisticated partial resets where the driver/HW allows it.
>> But it sounds like what you're suggesting is
>> (1) we select a rather arbitrary set of components that _might_ represent a
>>     full "virtual" reset, and then
>> (2) expect the user to guess a super-set of these features. And not worry
>>     when they selected too much, and this obscure PHY thing failed to reset.
> 
> No, please see the code I provided below, and read how the interface 
> is supposed to work. I posted the code comment in my previous reply. 
> I don't know what else I can do for you.
> 
> User can still pass "all" but you can't _clear_ all bits, 'cause you
> didn't reset any PHY, MAC, etc.
> 
>> So I looked at gve's implementation and thought "yep, looks simple enough".
> 
> Ugh, yeah, gve is not a good example.
> 
>> But if we start asking users to interpret HW bits that hardly make any
>> sense to them, we're worse off than with the existing custom sysfs trigger...
> 
> Actually - operationally, how do you expect people to use this reset?
> Some user space system detects the NIC is in a bad state? Does the
> interface communicate that via some log messages or such?
> 
> The commit message doesn't really explain the "why".
> 

Usually the driver will detect a hung condition itself, and trigger an
automatic reset internally (eg. from the TX watchdog).
But if that doesn't work, you'll hopefully get enough noisy log warnings
to investigate & reset the interface manually.
Besides that, it's just an easy way to exercise/test the reset code.

Integration with a daemon / management layer definitely sounds like an
option, and I'd much rather point those people towards ethtool instead
of sysfs.

>>> Then my suggestion would be something like:
>>>
>>>   #define QETH_RESET_FLAGS (flag | flag | flag)
>>>
>>>   if ((*flags & QETH_RESET_FLAGS) != QETH_RESET_FLAGS))
>>> 	return -EINVAL;
>>>   ...
>>>   *flags &= ~QETH_RESET_FLAGS;

