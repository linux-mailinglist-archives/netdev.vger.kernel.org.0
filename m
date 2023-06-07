Return-Path: <netdev+bounces-8875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A84EA726298
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66A41C20CA0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8547C370CE;
	Wed,  7 Jun 2023 14:20:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6A34448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:20:13 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB7A1BCA;
	Wed,  7 Jun 2023 07:20:11 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357DQGOx019196;
	Wed, 7 Jun 2023 14:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=jt/7L4v4EiEJBGCv1kf/QGiKB7+gAcvXfpJHw1kCJz4=;
 b=OZSYTAZQ6zVI8dy/33OWhYGd1CN2ZTK9EGtfxfGmBkm92fGRDcBdpYiS5LsrYhtx8NCk
 qrdlUCmFihtpzigpq/v/lA00G6VqF4xJ3wXBtvnnEQxWrcTGB5yw1E3R/2lDE2q17uSS
 9RIZ79apa+ZTY6xicP+2MQUTb8OrtjAVlmjxjXVd1DnDPTfcVn0inLjh+FB+5cfuXWn9
 XrBFcR/ltC+KcrXak3KZvFWwYJxO6yJVxaJrRr6RzVg9UKBt/0rOGhwI2E1uzwMs2dDK
 5bXtG25QTqAsElrtFxNGlUEb6IKS7OsR0cU0IKQvc4RcgvBMsiBDmGrx6kXRIh4eI7vF Rw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3r2a71a2sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 14:19:52 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 357EJqWg010994
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 7 Jun 2023 14:19:52 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 7 Jun 2023
 07:19:51 -0700
Message-ID: <f27064a6-c792-55d1-5fe9-c5fbd432a88f@quicinc.com>
Date: Wed, 7 Jun 2023 08:19:50 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 0/3] Add MHI Endpoint network driver
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain
	<loic.poulain@linaro.org>
CC: Andrew Lunn <andrew@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <mhi@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <c769c95d-e8cb-4cf6-a41a-9bef5a786bb1@lunn.ch>
 <20230607065652.GA5025@thinkpad>
 <CAMZdPi-xJAj_eFvosVTmSzA99m3eYhrwoKPfBk-qH87yZzNupQ@mail.gmail.com>
 <20230607074118.GD5025@thinkpad>
From: Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20230607074118.GD5025@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: AQvPgQUdBU1GiP7JR0VvuMz3JotwfZ-D
X-Proofpoint-ORIG-GUID: AQvPgQUdBU1GiP7JR0VvuMz3JotwfZ-D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=566 suspectscore=0 malwarescore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070121
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/2023 1:41 AM, Manivannan Sadhasivam wrote:
> On Wed, Jun 07, 2023 at 09:12:00AM +0200, Loic Poulain wrote:
>> On Wed, 7 Jun 2023 at 08:56, Manivannan Sadhasivam
>> <manivannan.sadhasivam@linaro.org> wrote:
>>>
>>> On Tue, Jun 06, 2023 at 02:59:00PM +0200, Andrew Lunn wrote:
>>>> On Tue, Jun 06, 2023 at 06:01:16PM +0530, Manivannan Sadhasivam wrote:
>>>>> Hi,
>>>>>
>>>>> This series adds a network driver for the Modem Host Interface (MHI) endpoint
>>>>> devices that provides network interfaces to the PCIe based Qualcomm endpoint
>>>>> devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
>>>>> devices to establish IP communication with the host machines (x86, ARM64) over
>>>>> MHI bus.
>>>>>
>>>>> On the host side, the existing mhi_net driver provides the network connectivity
>>>>> to the host.
>>>>>
>>>>> - Mani
>>>>>
>>>>> Manivannan Sadhasivam (3):
>>>>>    net: Add MHI Endpoint network driver
>>>>>    MAINTAINERS: Add entry for MHI networking drivers under MHI bus
>>>>>    net: mhi: Increase the default MTU from 16K to 32K
>>>>>
>>>>>   MAINTAINERS              |   1 +
>>>>>   drivers/net/Kconfig      |   9 ++
>>>>>   drivers/net/Makefile     |   1 +
>>>>>   drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
>>>>>   drivers/net/mhi_net.c    |   2 +-
>>>>
>>>> Should we add a drivers/net/modem directory? Maybe modem is too
>>>> generic, we want something which represents GSM, LTE, UMTS, 3G, 4G,
>>>> 5G, ... XG etc.
>>>>
>>>
>>> The generic modem hierarchy sounds good to me because most of the times a
>>> single driver handles multiple technologies. The existing drivers supporting
>>> modems are already under different hierarchy like usb, wwan etc... So unifying
>>> them makes sense. But someone from networking community should take a call.
>>
>>
>> Yes, so there is already a drivers/net/wwan directory for this, in
>> which there are drivers for control and data path, that together
>> represent a given 'wwan' (modem) entity. So the generic mhi_net could
>> be moved there, but the point is AFAIU, that MHI, despite his name, is
>> not (more) used only for modem, but as a generic memory sharing based
>> transport protocol, such as virtio. It would then not be necessarily
>> true that a peripheral exposing MHI net channel is actually a modem?
>>
> 
> Agree, mhi_*_net drivers can be used by non-modem devices too as long as they
> support MHI protocol.

I know of at-least 1 non-modem product in development that would benefit 
from these drivers.

