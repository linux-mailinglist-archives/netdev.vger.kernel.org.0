Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A554397AB
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhJYNh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:37:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230137AbhJYNh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:37:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PCM7Rb027995;
        Mon, 25 Oct 2021 13:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fHHD9B8mtynP5WXDmVFBLONkqPX/iz1PqWtIiJuk6Mo=;
 b=LtXbwlSyQx9lueQWlhpRkfFGyBgppwZp9JK7NlW5roEvcpVFUO3j4dgJMZi3SAdPpmkh
 Ny9IPI1WgI3K9UD/b7d2UodHlFhPtzTMn5x9/wuonmh+WF89YrV/Lk+wtfBjbwpMbMgP
 oCnnW93i4xTTiiLKPXFa9U/ohT+YyvpTtmG3Z9MZw7n2SnSgUdVKRNu4TwsufkuhRnFs
 BrkK00cXTkWj3yNrvwJsPDb14n1cKi9oFltA1rqC7V9CVfkKq+9Fdnq231CaMcrvyLcO
 jyh+XGvLu6iLwezG9Sb+CwZLMAg/VAzdms6LeoHan/g0GYYU8HOh5IwhX1iD6QhSo2Wx Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt6sdhjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 13:35:32 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19PDUCDc004274;
        Mon, 25 Oct 2021 13:35:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt6sdhjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 13:35:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19PDX41v030819;
        Mon, 25 Oct 2021 13:35:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3bva18wmuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 13:35:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19PDZRrZ37880274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 13:35:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31596A4059;
        Mon, 25 Oct 2021 13:35:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FEC7A4057;
        Mon, 25 Oct 2021 13:35:26 +0000 (GMT)
Received: from [9.171.63.35] (unknown [9.171.63.35])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 13:35:26 +0000 (GMT)
Message-ID: <1285bc39-b3fc-55b1-5422-a1474cd31c28@linux.ibm.com>
Date:   Mon, 25 Oct 2021 15:35:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next 6/9] s390/qeth: fix various format strings
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
 <20211025095658.3527635-7-jwi@linux.ibm.com>
 <20211025132229.4opytunnnqnhxzdf@skbuf>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211025132229.4opytunnnqnhxzdf@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _bZlejI_RvJJATZs2hw1ngJxHg6I4qnO
X-Proofpoint-ORIG-GUID: MCwoo5l6AKVcjCE-UF9urisHKUS3mjE4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_05,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.10.21 15:22, Vladimir Oltean wrote:
> On Mon, Oct 25, 2021 at 11:56:55AM +0200, Julian Wiedmann wrote:
>> From: Heiko Carstens <hca@linux.ibm.com>
>>
>> Various format strings don't match with types of parameters.
>> Fix all of them.
>>
>> Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
>> ---
>>  drivers/s390/net/qeth_l2_main.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
>> index adba52da9cab..0347fc184786 100644
>> --- a/drivers/s390/net/qeth_l2_main.c
>> +++ b/drivers/s390/net/qeth_l2_main.c
>> @@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
>>  					 card->dev, &info.info, NULL);
>>  		QETH_CARD_TEXT(card, 4, "andelmac");
>>  		QETH_CARD_TEXT_(card, 4,
>> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
>> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));
>>  	} else {
>>  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
>>  					 card->dev, &info.info, NULL);
>>  		QETH_CARD_TEXT(card, 4, "anaddmac");
>>  		QETH_CARD_TEXT_(card, 4,
>> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
>> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));
> 
> You can print MAC addresses using the "%pM" printf format specifier, and
> the ntfy_mac as argument.
> 

Unfortunately not - no pointers allowed in such s390 dbf trace entries. See
e19e5be8b4ca ("s390/qeth: sanitize strings in debug messages").
