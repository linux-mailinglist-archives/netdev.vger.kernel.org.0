Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC06EF7A5
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbjDZPSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjDZPSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:18:49 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2748530E5;
        Wed, 26 Apr 2023 08:18:48 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QESoFJ013333;
        Wed, 26 Apr 2023 15:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=lyLd73rOYX6D/T3Cq7pt01Tu2asK7sYLqHdQV7bwk/k=;
 b=mSNXHohmKtf/18bPTTzOW7q0jSWEjFEQGsDeQqLdx7gH8OBnFzuxUk/2/HoCDA7gt71q
 jgh9P35iiRDbBmQXPB8gHog0KGWNOtvjRVwE76tpjcUf2q6sUesStT9s0r5AnUFy/CLQ
 dqdQk6qGp1JWQByKsmROn/3PXQ0hfwI7rclRM5XEYBPFH424xx/EL4WPAhplABy/NlKX
 C+13J8HPH8uMll0DrdhxzMYF8LWp3rdqQwXQem0vMJ2S1njQ47tv8aOnopcrUPTruy5T
 Dc/zMAwRZ586X/OcJ/dsK5AhLak54WiehuD3AUjraB4BYeFRWyK232saidWzxsh51Wd3 cA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q6brdv00h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 15:18:41 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33QFIdxR021866
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 15:18:39 GMT
Received: from [10.216.40.251] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 26 Apr
 2023 08:18:34 -0700
Message-ID: <66158251-6934-a07f-4b82-4deaa76fa482@quicinc.com>
Date:   Wed, 26 Apr 2023 20:48:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 2/2] pinctrl: qcom: Add SDX75 pincontrol driver
Content-Language: en-US
To:     <andy.shevchenko@gmail.com>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <linus.walleij@linaro.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <manivannan.sadhasivam@linaro.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1682327030-25535-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682327030-25535-3-git-send-email-quic_rohiagar@quicinc.com>
 <ZEk9lySMZcrRZYwX@surfacebook>
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <ZEk9lySMZcrRZYwX@surfacebook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: tedJ_-rvDmxLiF3hjxWieccxITAYulzR
X-Proofpoint-GUID: tedJ_-rvDmxLiF3hjxWieccxITAYulzR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 phishscore=0 clxscore=1011 malwarescore=0
 mlxlogscore=770 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260136
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/26/2023 8:34 PM, andy.shevchenko@gmail.com wrote:
> Mon, Apr 24, 2023 at 02:33:50PM +0530, Rohit Agarwal kirjoitti:
>> Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
>> with pinctrl framework for SDX75 SoC.
>> While at it, reordering the SDX65 entry.
> ...
>
>> +#define FUNCTION(fname)							\
>> +	[msm_mux_##fname] = {						\
>> +		.name = #fname,						\
>> +		.groups = fname##_groups,				\
>> +	.ngroups = ARRAY_SIZE(fname##_groups),				\
>> +	}
> PINCTRL_PINFUNCTION() ?
Ok, Will update this. Shall I also update "PINGROUP" to "PINCTRL_PINGROUP"?
>
> ...
>
>> +static const struct of_device_id sdx75_pinctrl_of_match[] = {
>> +	{.compatible = "qcom,sdx75-tlmm", .data = &sdx75_pinctrl}, {},
> One entry per line.
> And drop comma in the terminator one.
>
>> +};
> No MODULE_DEVICE_TABLE()?
Sure Will update both.

Thanks,
Rohit.
>
