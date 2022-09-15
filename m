Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EE35B9365
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIODyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIODys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:54:48 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D744A1B0;
        Wed, 14 Sep 2022 20:54:45 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F3XNIi018894;
        Thu, 15 Sep 2022 03:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=+SSNqP72octFUA+37yYcG5PPIm6HgfHM+lYoLy86hnE=;
 b=b9HQeoBE6f2wM0j9tOYicLuxZRjNs7G7d3cjfJ1k3Slbnx0azA0XNmw0CuxtfOJaf7NK
 g/HzzkwJsHt0jLkTMssKjBjSDV/0K0gI8ecBH0G6n+y5PjRfLqC08H2YV6yTtcD6mjHK
 O7XRlCFPIbQek4k1ZZFJhxOU6yqcn4byIx7tPdu4UNaEizeNZ2XefAwKthc2/KaF8T8m
 41w8hfmozQGQvyN5hfKm5jJUCMZyiUowvjnTTjv5cfw0cill+ufPTV6IN/Zv6l4YZA4i
 1DXIDVSCQ0/JZnK/swI0PEYEDWBypTzGli8jnz5waFW54zS6DKHt229RUehp28Jr6JOj 8w== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxys527c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:54:36 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28F3pxYB002443;
        Thu, 15 Sep 2022 03:54:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3jk8x6m644-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:54:36 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28F3sZQF004943;
        Thu, 15 Sep 2022 03:54:35 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 28F3sZL6004932
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:54:35 +0000
Received: from [10.110.52.115] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 20:54:34 -0700
Message-ID: <caf04e03-6cf3-5f56-da0b-ab68d58e7409@quicinc.com>
Date:   Wed, 14 Sep 2022 20:54:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] orinoco: fix repeated words in comments
Content-Language: en-US
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220915030201.35984-1-yuanjilin@cdjrlc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220915030201.35984-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: -AT-sRmiecKlRExNRgegAMqxgV7sQrLS
X-Proofpoint-GUID: -AT-sRmiecKlRExNRgegAMqxgV7sQrLS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_02,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 adultscore=0 mlxlogscore=818 spamscore=0 clxscore=1011 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150018
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/2022 8:02 PM, Jilin Yuan wrote:
> Delete the redundant word 'this'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>   drivers/net/wireless/intersil/orinoco/main.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/orinoco/main.h b/drivers/net/wireless/intersil/orinoco/main.h
> index 5a8fec26136e..852e1643dad2 100644
> --- a/drivers/net/wireless/intersil/orinoco/main.h
> +++ b/drivers/net/wireless/intersil/orinoco/main.h
> @@ -12,7 +12,7 @@
>   /* Compile time configuration and compatibility stuff               */
>   /********************************************************************/
>   
> -/* We do this this way to avoid ifdefs in the actual code */
> +/* We do this way to avoid ifdefs in the actual code */

In this case the two instances of "this" are not a repetition, they are 
different parts of speech.

The existing sentence is correct English; the modified sentence is not.

If the repeated word really bothers you then insert "in": We do this in 
this way...


>   #ifdef WIRELESS_SPY
>   #define SPY_NUMBER(priv)	(priv->spy_data.spy_number)
>   #else

