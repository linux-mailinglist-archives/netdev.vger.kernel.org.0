Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0B168CF98
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjBGGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjBGGkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:40:52 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B08237B59;
        Mon,  6 Feb 2023 22:40:33 -0800 (PST)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3176COwI022435;
        Tue, 7 Feb 2023 06:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=GZq7550o3hV/zZ6fBo1m7XvSv7PhPhTDoWFMEIh09Dw=;
 b=daf5GUTt9qUJ4Yh+SG20S5p9Lemk37fwuE8OTNwxHWSHIDp8CHnDoS4zOLQZIOC0/zIM
 oogaJhPA7YZQRXvZyXdMdaxzIznRf9K7oTAcCS8rDjdh04y2IfeKQFshGbhLNvi8OU3R
 ZY7KoVa83NbbDeiG4x2zLYwPK460Hi5CKrJmh/YEn5CvRXjPDv2bjG0JHeVr9gc201ku
 qXRayV2Nqwjh7HIhnZlWGLbsUrl1bEKS15OAuFUefa/ZRvgct0lW7Vvlwb7yNgYzWPah
 LA0pXScMZBSwjn5R+nKmPd0Xcc+fy7R2iVPf5dwNhI0pIe4PO5THNNJy430it0yJprot EQ== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nkfes89m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 06:40:22 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3176eLBf015285
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Feb 2023 06:40:21 GMT
Received: from [10.50.24.106] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 22:40:16 -0800
Message-ID: <7fe7eedc-97ee-e5fc-a458-193e556d3174@quicinc.com>
Date:   Tue, 7 Feb 2023 12:10:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/2] dt: bindings: add dt entry for XO calibration
 support
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230131140345.6193-1-quic_youghand@quicinc.com>
 <20230131140345.6193-2-quic_youghand@quicinc.com>
 <622ef51f-643e-5eb5-3884-3f22bf4fa9be@linaro.org>
Content-Language: en-US
From:   "Youghandhar Chintala (Temp)" <quic_youghand@quicinc.com>
In-Reply-To: <622ef51f-643e-5eb5-3884-3f22bf4fa9be@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: U8gb2KESa60EQ4sSWCohkjVTNrBq8vWy
X-Proofpoint-ORIG-GUID: U8gb2KESa60EQ4sSWCohkjVTNrBq8vWy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070060
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/31/2023 11:32 PM, Krzysztof Kozlowski wrote:
> On 31/01/2023 15:03, Youghandhar Chintala wrote:
>> Add dt binding to get XO calibration data support for Wi-Fi RF clock.
> Use subject prefixes matching the subsystem (which you can get for
> example with `git log --oneline -- DIRECTORY_OR_FILE` on the directory
> your patch is touching).
> Hint: dt-bindings: net: qcom,ath11k:
>
>> Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
>> ---
>>   .../devicetree/bindings/net/wireless/qcom,ath11k.yaml         | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> index f7cf135aa37f..205ee949daba 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> @@ -41,6 +41,10 @@ properties:
>>           * reg
>>           * reg-names
>>   
>> +  xo-cal-data:
>> +    description:
>> +      XO cal offset to be configured in XO trim register
> Missing type. I also do not understand what's this and why some register
> offset should be stored in DT. Please give us some justification why
> this is suitable for DT.
>
> Best regards,
> Krzysztof
>
Hi Krzysztof,

I will address you comments in next version of patch.

Regards,

Youghandhar


