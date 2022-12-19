Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592BD650CCA
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 14:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiLSNqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 08:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSNqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 08:46:04 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416A8641F;
        Mon, 19 Dec 2022 05:46:04 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJBEEPv022254;
        Mon, 19 Dec 2022 13:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=lQyNqYU9KnNtnUHjNhcP6N/pp/vK2lVT3JKv/+bbuvs=;
 b=oF5RELd7d87pMU/8XXwuZ9ZgVpxXL5vxG562UxRm0xZEExcrllIfUEnwbuFOwZkrogl2
 aNx1rmAPX0yXVY93zurbNSeGt0hf3cwcBfaOuKf5qhAihvAVsCpYyldYEJwZ3BSdXR9M
 BO84nRSiQY39y65CZr9bWTTucFbmysK67VUcY90hXF4kPs0bdY/zC7o7042OJQLV/+tO
 mfTEruGViW92qZTrXZA70TxJj6JvIS3M2JDaGrZTSeBJIPjWpBh6+mEO3PFOaOrIH1LV
 kn1JU/KHTPt4qiFtlXK+V4+Y8fULbysh46cJ8xAZpI9XbtdORM8LAfs7uDhY4gAA9jYu nA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mh4secgbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:45:53 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BJDjq7P017587
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:45:52 GMT
Received: from [10.216.40.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 19 Dec
 2022 05:45:47 -0800
Message-ID: <773848af-c11e-2a9f-00b8-085d98147de3@quicinc.com>
Date:   Mon, 19 Dec 2022 19:15:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] dt: bindings: add dt entry for XO calibration support
Content-Language: en-US
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        <ath11k@lists.infradead.org>,
        "kvalo@kernel.org >> Kalle Valo" <kvalo@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20221214121818.12928-1-quic_youghand@quicinc.com>
 <20221214121818.12928-2-quic_youghand@quicinc.com>
 <f39cd52f-94d4-fe3b-a5be-8b27017028ed@kernel.org>
From:   "Youghandhar Chintala (Temp)" <quic_youghand@quicinc.com>
In-Reply-To: <f39cd52f-94d4-fe3b-a5be-8b27017028ed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: D3a8YjalaZ3M25Wo2h0jwwG54-uzrKe1
X-Proofpoint-ORIG-GUID: D3a8YjalaZ3M25Wo2h0jwwG54-uzrKe1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=833
 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190122
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/19/2022 4:19 PM, Krzysztof Kozlowski wrote:
> On 14/12/2022 13:18, Youghandhar Chintala wrote:
>> Add dt binding to get XO calibration data support for Wi-Fi RF clock. 	 	
>>
>> Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.
>
> You skipped all of them, so this has to be fixed.
>
> Best regards,
> Krzysztof
Thank you Krzysztof.
