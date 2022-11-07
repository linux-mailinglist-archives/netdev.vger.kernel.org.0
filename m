Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1305861FA0C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiKGQhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiKGQhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:37:01 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EF6E58;
        Mon,  7 Nov 2022 08:36:55 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A7GMjje016916;
        Mon, 7 Nov 2022 16:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=m1DwnOv3KX4c+wIm1QqS50QRxpR691x13I+8VR79ZW8=;
 b=pmNQu1M2rda5uDRUj2KofZcUq7TjOwq7IizmtgHVPPyc3CMapoHoKNdpxu9ULJpWo0+7
 8sfDIF81u67NxZnufqTwGE7eiXWig/c87+otO2a/p2q2ZM0GS4JtN5z7TiWEHmJwPTit
 XG1UfEdLh7ZUIYgHc+E2KfLhW+3IwzWZMK7K5D1UWA1D4mHmpxwBX19jBmtKcMxULZBE
 dURjahLknisLEUEYTZdxrOwgeXnjc/FQN4aaSWrCPmKGtSmioS4cyOFZiq8MQTff4JhH
 dIHY4tyjpk9/k0kBJKc0efvsMb2iza1aPJB13lwG7MeJXcsgoo6he1eDUhFzgtywj6zB Hw== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kq5g0814u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 16:36:43 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2A7Gagh1024128
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 7 Nov 2022 16:36:42 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 7 Nov 2022
 08:36:41 -0800
Message-ID: <5e8b3ff3-edee-f4d0-925c-545d0a801e1f@quicinc.com>
Date:   Mon, 7 Nov 2022 09:36:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: MHI DTR client implementation
Content-Language: en-US
To:     Daniele Palmas <dnlplm@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>
CC:     Manivannan Sadhasivam <mani@kernel.org>, <mhi@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <CAGRyCJGWQagceLhnECBcpPfG5jMPZrjbsHrio1BvgpZJhk0pbA@mail.gmail.com>
 <20221107115856.GE2220@thinkpad>
 <CAMZdPi-=AkfKnyPRBgV-7RxczePnB4shLq2bdj+q3kh+7Web3w@mail.gmail.com>
 <CAGRyCJG_FzzjEWtpc=FQX=gO1s=DM2cV3XFB4Y0vq4UM_MP1KQ@mail.gmail.com>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <CAGRyCJG_FzzjEWtpc=FQX=gO1s=DM2cV3XFB4Y0vq4UM_MP1KQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 5vXZBqjqzefR-LuAplYv-5Up88vHQLaX
X-Proofpoint-ORIG-GUID: 5vXZBqjqzefR-LuAplYv-5Up88vHQLaX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/2022 9:28 AM, Daniele Palmas wrote:
> Hi Loic,
> 
> Il giorno lun 7 nov 2022 alle ore 14:47 Loic Poulain
> <loic.poulain@linaro.org> ha scritto:
>>
>> On Mon, 7 Nov 2022 at 12:59, Manivannan Sadhasivam <mani@kernel.org> wrote:
>>>
>>> + Loic
>>>
>>> On Tue, Sep 20, 2022 at 04:23:25PM +0200, Daniele Palmas wrote:
>>>> Hello all,
>>>>
>>>> I'm looking for some guidance related to  a possible MHI client for
>>>> serial ports signals management implementation.
>>>>
>>>> Testing the AT channels with Telit modems I noted that unsolicited
>>>> indications do not show: the root cause for this is DTR not set for
>>>> those ports through MHI channels 18/19, something that with current
>>>> upstream code can't be done due to the missing DTR client driver.
>>>>
>>>> I currently have an hack, based on the very first mhi stack submission
>>>> (see https://lore.kernel.org/lkml/1524795811-21399-2-git-send-email-sdias@codeaurora.org/#Z31drivers:bus:mhi:core:mhi_dtr.c),
>>>> solving my issue, but I would like to understand which would be the
>>>> correct way, so maybe I can contribute some code.
>>>>
>>>> Should the MHI DTR client be part of the WWAN subsystem?
>>>
>>> Yes, since WWAN is going to be the consumer of this channel, it makes sense to
>>> host the client driver there.
>>
>> Agree.
>>
>>>
>>>> If yes, does it make sense to have an associated port exposed as a char
>>>> device?
>>>
>>> If the goal is to control the DTR settings from userspace, then you can use
>>> the "AT" chardev node and handle the DTR settings in this client driver.
>>> Because at the end of the day, user is going to read/write from AT port only.
>>> Adding one more ctrl port and have it configured before using AT port is going
>>> to be a pain.
>>>
>>> Thanks,
>>> Mani
>>>
>>>> I guess the answer is no, since it should be used just by the AT ports
>>>> created by mhi_wwan_ctrl, but I'm not sure if that's possible.
>>>>
>>>> Or should the DTR management be somehow part of the MHI stack and
>>>> mhi_wwan_ctrl interacts with that through exported functions?
>>
>> Is this DTR thing Telit specific?
>>
> 
> I'm still not 100% sure, but I believe it is Telit specific.
> 
>> Noticed you're using the IP_CTRL channel for this, do you have more
>> information about the protocol to use?
>>
> 
> No, Qualcomm documents I have about mhi does not telly anything about
> this protocol: all I know is coming from previously sent patches and
> code available at
> https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/17a10f4c879c9f504a0d279f03e924553bcf2420
> 
>> At first glance, I would say you can create a simple driver for
>> IP_CTRL channel (that could be part of mhi_wwan_ctrl), but instead of
>> exposing it rawly to the user, simply enable DTR unconditionally at
>> probe time?
>>
> 
> Yes, this is what I'm currently doing in custom patches and it's
> working fine since I just need to "turn on" indications. Not sure,
> however, if this works fine for other use cases (e.g. dial-up, as
> mentioned in commit description at
> https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/17a10f4c879c9f504a0d279f03e924553bcf2420
> though I'm not sure how much having a dial-up connection with this
> kind of modems makes sense...)

Its my understanding DUN is still used for carrier 
validation/certification and also to support a number of legacy 
services.  A niche thing, but still in use.

