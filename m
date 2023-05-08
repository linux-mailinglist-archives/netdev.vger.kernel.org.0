Return-Path: <netdev+bounces-833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E726FAA51
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99FE71C2095D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920EF13AE0;
	Mon,  8 May 2023 11:01:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81068168C7
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:01:28 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE092E80E;
	Mon,  8 May 2023 04:01:25 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3486Eqs2025662;
	Mon, 8 May 2023 11:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=30YV3GSfUJH7uuAX8OaPEaPxhsD0B30A4xbCT71CEQo=;
 b=WGHVlF3BsyIuV/3SBrU26+mSJHJfuxCpxS0A4EPFCSIZPqVCmu2edkCUpANl261nQVDH
 IJKmmANwNZ2pWLDEwsGtr4OKjv/o5iPw/wWd56LwUGXjAhHaf5X5IY9GUfxY6ASRZ3m4
 S7VeeZMEx/2JaEV6u7tCLCLPL5fh10l2IXG1QMBk7b7gBL+rWaVfmeyX0jx029Uvhpo2
 oaV9CEdyxq5IbyNTvk1eM7ogRngQ2qIkQtKWrUafeBrHBRF/W8T80mvbJMvq9rFoKIuS
 +4wlbkvPEuvB6I/mHdNz7kKo1Oeaz+uzMy/4CCUpc/frjFVMKz7t+9SHL7Sxln39tOqz Lg== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qdf4b3ce1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 May 2023 11:01:20 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 348B1J0P008879
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 8 May 2023 11:01:19 GMT
Received: from [10.216.33.39] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Mon, 8 May 2023
 04:01:14 -0700
Message-ID: <62a80dec-91ff-8a07-9818-7207a08a35b3@quicinc.com>
Date: Mon, 8 May 2023 16:31:11 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 1/4] clk: qcom: branch: Extend the invert logic for
 branch2 clocks
Content-Language: en-US
To: Stephen Boyd <sboyd@kernel.org>, Andy Gross <agross@kernel.org>,
        "Bjorn
 Andersson" <andersson@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette
	<mturquette@baylibre.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob
 Herring" <robh+dt@kernel.org>
CC: <quic_skakitap@quicinc.com>, Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_rohiagar@quicinc.com>, <netdev@vger.kernel.org>
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
 <20230419133013.2563-2-quic_tdas@quicinc.com>
 <0dc457cbd13ea76a3aa3c70b2a31a537.sboyd@kernel.org>
From: Taniya Das <quic_tdas@quicinc.com>
In-Reply-To: <0dc457cbd13ea76a3aa3c70b2a31a537.sboyd@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: kQ3XYs3uLOipgrKCKIHyYStYliBRUIOY
X-Proofpoint-GUID: kQ3XYs3uLOipgrKCKIHyYStYliBRUIOY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305080075
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Stephen,

Thanks for your review.

On 4/20/2023 3:07 AM, Stephen Boyd wrote:
> Quoting Taniya Das (2023-04-19 06:30:10)
>> From: Imran Shaik <quic_imrashai@quicinc.com>
>>
>> Add support to handle the invert logic for branch2 clocks.
>> Invert branch halt would indicate the clock ON when CLK_OFF
>> bit is '1' and OFF when CLK_OFF bit is '0'.
>>
>> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
>> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
>> ---
>>   drivers/clk/qcom/clk-branch.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/clk/qcom/clk-branch.c b/drivers/clk/qcom/clk-branch.c
>> index f869fc6aaed6..4b24d45be771 100644
>> --- a/drivers/clk/qcom/clk-branch.c
>> +++ b/drivers/clk/qcom/clk-branch.c
>> @@ -48,6 +48,7 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
>>   {
>>          u32 val;
>>          u32 mask;
>> +       bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
>>   
>>          mask = BRANCH_NOC_FSM_STATUS_MASK << BRANCH_NOC_FSM_STATUS_SHIFT;
>>          mask |= BRANCH_CLK_OFF;
>> @@ -56,9 +57,16 @@ static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
>>   
>>          if (enabling) {
>>                  val &= mask;
>> +
>> +               if (invert)
>> +                       return (val & BRANCH_CLK_OFF) == BRANCH_CLK_OFF;
>> +
>>                  return (val & BRANCH_CLK_OFF) == 0 ||
>>                          val == BRANCH_NOC_FSM_STATUS_ON;
> 
> Do these clks have a NOC_FSM_STATUS bit? I think it would be better to
> make a local variable for the val we're looking for, and then test for
> that. We may need a mask as well, but the idea is to not duplicate the
> test and return from multiple places.
> 

Clocks which has invert status doesn't have NOC_FSM_STATUS bit.
Will remove the multiple returns in next patch.

>>          } else {
>> +               if (invert)
>> +                       return (val & BRANCH_CLK_OFF) == 0;
>> +
>>                  return val & BRANCH_CLK_OFF;
>>          }
> 
> While at it, I'd get rid of this else and de-indent the code because if
> we're 'enabling' we'll return from the function regardless.


Yes, Stephen, will take care in the next patch.

-- 
Thanks & Regards,
Taniya Das.

