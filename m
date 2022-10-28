Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1361144C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJ1OQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJ1OQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:16:37 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF8E1D639E;
        Fri, 28 Oct 2022 07:16:35 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SDVcBv032409;
        Fri, 28 Oct 2022 14:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=dUwCBBBVioqpv4W9fJp7HCTTNgfmZzayTqkqExmwh8I=;
 b=XB1kcbbyNTtE+cla4nTuuHFIH4v5Jbu191f1H9Y41OKPKmY6hw4LP2vlofpj3al+rUPf
 sMdqaUvQlz8xD1nn9xgJJc6Sqv666nTr8BWZ/BTmisq13TLwX0isoap5zEf4n/FB7gBF
 WVvFrDxdtgJh4JrqZvRmstp71+1FuH51CHyXZLBLueW+fQFMpZ8l3rkdtWUB2gIQamlo
 VwAVhpv33RCFfH8VpGpWy2vNJCZgGs5DnUMEYTWolIGEdpcOiiXBujk1/A3WQiHELabp
 I65d0bQT9WXBBrUzybDvF6Hz+EdNntQyEipLAxOd7Gfz8gKo6SQdmwT1LNQiulqYmT56 tw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kg9tys325-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 14:15:40 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 29SE7t27017934;
        Fri, 28 Oct 2022 14:14:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3kf9vsghn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 14:14:49 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29SEEmT9024560;
        Fri, 28 Oct 2022 14:14:48 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 29SEEmQX024559
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 14:14:48 +0000
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 28 Oct
 2022 07:14:45 -0700
Message-ID: <a8df4485-36f0-171f-5569-9e6bac190a1b@quicinc.com>
Date:   Fri, 28 Oct 2022 08:14:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 2/2] dt-bindings: clock: qcom: cleanup
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Martin Botka <martin.botka@somainline.org>,
        Taniya Das <tdas@codeaurora.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Stephan Gerhold" <stephan@gerhold.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        krishna Lanka <quic_vamslank@quicinc.com>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Del Regno <angelogioacchino.delregno@somainline.org>,
        Robert Foss <robert.foss@linaro.org>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-renesas-soc@vger.kernel.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
 <20221028140326.43470-3-krzysztof.kozlowski@linaro.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20221028140326.43470-3-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: tpV2KDS-qvlbojaReTiHGCklDeoD7ZM2
X-Proofpoint-GUID: tpV2KDS-qvlbojaReTiHGCklDeoD7ZM2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0 mlxlogscore=820
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280089
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/2022 8:03 AM, Krzysztof Kozlowski wrote:
> Clean the Qualcomm SoCs clock bindings:
> 1. Drop redundant "bindings" in title.
> 2. Correct language grammar "<independent clause without verb>, which
>     supports" -> "provides".
> 3. Use full path to the bindings header, so tools can validate it.
> 4. Drop quotes where not needed.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---

For 8998 bits -
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>

For MMCC bit -
Acked-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
