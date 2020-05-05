Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD21C616F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgEET5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:57:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728584AbgEET5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:57:52 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045JW6Xj125508;
        Tue, 5 May 2020 15:57:48 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s3186ng6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 15:57:48 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045Jtb5j024305;
        Tue, 5 May 2020 19:57:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g5b42b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 19:57:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045Jviqp45219904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 19:57:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B63A52050;
        Tue,  5 May 2020 19:57:44 +0000 (GMT)
Received: from [9.145.75.123] (unknown [9.145.75.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 411EF5204E;
        Tue,  5 May 2020 19:57:44 +0000 (GMT)
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
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
Date:   Tue, 5 May 2020 21:57:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505112940.6fe70918@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.20 20:29, Jakub Kicinski wrote:
> On Tue, 5 May 2020 20:23:31 +0200 Julian Wiedmann wrote:
>> On 05.05.20 19:21, Jakub Kicinski wrote:
>>> On Tue,  5 May 2020 18:25:58 +0200 Julian Wiedmann wrote:  
>>>> Implement the .reset callback. Only a full reset is supported.
>>>>
>>>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
>>>> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
>>>> ---
>>>>  drivers/s390/net/qeth_ethtool.c | 16 ++++++++++++++++
>>>>  1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
>>>> index ebdc03210608..0d12002d0615 100644
>>>> --- a/drivers/s390/net/qeth_ethtool.c
>>>> +++ b/drivers/s390/net/qeth_ethtool.c
>>>> @@ -193,6 +193,21 @@ static void qeth_get_drvinfo(struct net_device *dev,
>>>>  		 CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
>>>>  }
>>>>  
>>>> +static int qeth_reset(struct net_device *dev, u32 *flags)
>>>> +{
>>>> +	struct qeth_card *card = dev->ml_priv;
>>>> +	int rc;
>>>> +
>>>> +	if (*flags != ETH_RESET_ALL)
>>>> +		return -EINVAL;
>>>> +
>>>> +	rc = qeth_schedule_recovery(card);
>>>> +	if (!rc)
>>>> +		*flags = 0;  
>>>
>>> I think it's better if you only clear the flags for things you actually
>>> reset. See the commit message for 7a13240e3718 ("bnxt_en: fix
>>> ethtool_reset_flags ABI violations").
>>>   
>>
>> Not sure I understand - you mean *flags &= ~ETH_RESET_ALL ?
>>
>> Since we're effectively managing a virtual device, those individual
>> ETH_RESET_* flags just don't map very well...
>> This _is_ a full-blown reset, I don't see how we could provide any finer
>> granularity.
> 
> This is the comment from the uAPI header:
> 
> /* The reset() operation must clear the flags for the components which
>  * were actually reset.  On successful return, the flags indicate the
>  * components which were not reset, either because they do not exist
>  * in the hardware or because they cannot be reset independently.  The
>  * driver must never reset any components that were not requested.
>  */
> 
> Now let's take ETH_RESET_PHY as an example. Surely you're not resetting
> any PHY here, so that bit should not be cleared. Please look at the
> bits and select the ones which make sense, add whatever is missing.
> 

It's a virtual device, _none_ of them make much sense?! We better not be
resetting any actual HW components, the other interfaces on the same
adapter would be quite unhappy about that.

Sorry for being dense, and I appreciate that the API leaves a lot of room
for sophisticated partial resets where the driver/HW allows it.
But it sounds like what you're suggesting is
(1) we select a rather arbitrary set of components that _might_ represent a
    full "virtual" reset, and then
(2) expect the user to guess a super-set of these features. And not worry
    when they selected too much, and this obscure PHY thing failed to reset.

So I looked at gve's implementation and thought "yep, looks simple enough".
But if we start asking users to interpret HW bits that hardly make any
sense to them, we're worse off than with the existing custom sysfs trigger...

> Then my suggestion would be something like:
> 
>   #define QETH_RESET_FLAGS (flag | flag | flag)
> 
>   if ((*flags & QETH_RESET_FLAGS) != QETH_RESET_FLAGS))
> 	return -EINVAL;
>   ...
>   *flags &= ~QETH_RESET_FLAGS;
> 

