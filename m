Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581A85B93DF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIOFOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIOFOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:14:09 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CA88A1F6;
        Wed, 14 Sep 2022 22:14:08 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F53oDc016130;
        Thu, 15 Sep 2022 05:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=O1T5Rv/IOA3EgvUgCYRv4xkjxw1fabI14/nllGEHE8g=;
 b=AgNBHA6AVpi5v9OPaMQs4jpt+Xu+0IR2l7Pzh/tf5BHaI4QpmZao0j342vJDFkomH/KU
 /SZ7S8Hfm0Ul1mVYCBwS66qQkshGyrWvdD3sPBIep6bpu2Q9NL3iZppJE60CN6xvu7dY
 G244qD+DksEe+JzAPhKiihxOympgwOiJj/z5jMwUks1OiaHhxCPu4ByTQpQ+7g/wavvQ
 c2fsP7I2bsqQvdhkir9kndc6w+ku41u1A6rptGZeR0dGAPuJI1p0jJzLFXzlJdlY5C4l
 F55bKpjkN24nzc8tjAMaNO6sDQXWOUiE0VWchUDiWUBuvGdpjj3VpD40LXSiwD079XAF Jw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jkwjer0r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 05:14:01 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28F5BNxc015481;
        Thu, 15 Sep 2022 05:14:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3jh45krfmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 05:14:00 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28F5E0s4020104;
        Thu, 15 Sep 2022 05:14:00 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 28F5DxuG020100
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 05:14:00 +0000
Received: from [10.110.52.115] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 22:13:58 -0700
Message-ID: <4fe4736d-ccc2-de00-8bb0-992382644fe6@quicinc.com>
Date:   Wed, 14 Sep 2022 22:13:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] orinoco: fix repeated words in comments
Content-Language: en-US
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220915030201.35984-1-yuanjilin@cdjrlc.com>
 <caf04e03-6cf3-5f56-da0b-ab68d58e7409@quicinc.com>
In-Reply-To: <caf04e03-6cf3-5f56-da0b-ab68d58e7409@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: A7Z2T8GWv3D9DdZdbO0lBd0FSyCUOatQ
X-Proofpoint-GUID: A7Z2T8GWv3D9DdZdbO0lBd0FSyCUOatQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_02,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=750 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150026
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/2022 8:54 PM, Jeff Johnson wrote:
> On 9/14/2022 8:02 PM, Jilin Yuan wrote:
>> Delete the redundant word 'this'.
>>
>> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
>> ---
>>   drivers/net/wireless/intersil/orinoco/main.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intersil/orinoco/main.h 
>> b/drivers/net/wireless/intersil/orinoco/main.h
>> index 5a8fec26136e..852e1643dad2 100644
>> --- a/drivers/net/wireless/intersil/orinoco/main.h
>> +++ b/drivers/net/wireless/intersil/orinoco/main.h
>> @@ -12,7 +12,7 @@
>>   /* Compile time configuration and compatibility stuff               */
>>   /********************************************************************/
>> -/* We do this this way to avoid ifdefs in the actual code */
>> +/* We do this way to avoid ifdefs in the actual code */
> 
> In this case the two instances of "this" are not a repetition, they are 
> different parts of speech.
> 
> The existing sentence is correct English; the modified sentence is not.
> 
> If the repeated word really bothers you then insert "in": We do this in 
> this way...
> 
> 
>>   #ifdef WIRELESS_SPY
>>   #define SPY_NUMBER(priv)    (priv->spy_data.spy_number)
>>   #else
> 
In addition the patch subject of all files in drivers/net/wireless 
should now begin with "wifi: "
