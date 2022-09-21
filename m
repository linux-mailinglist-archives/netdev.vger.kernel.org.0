Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B475C00C1
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiIUPIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIUPIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:08:19 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D70F79686;
        Wed, 21 Sep 2022 08:08:19 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LEYhNq003482;
        Wed, 21 Sep 2022 15:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=C4RzQqA/HRGvFOgdv5t44witcXEdQq/ZDQHfjhXfWGA=;
 b=dVSpcLl9PGV0MkOeqo9to2wsOvZBIFwRsLvqyrI4sNTgUoRfhK3XcSbcW2qhXUS2BZ6N
 MW/UJsGlvaLZBEDk9Kl9o3HsvI60r29mss/ztvYz+MMX0hT4cJXKst3fYj+/1lnl2rpI
 luYk5RBM6nwwg7xSrS7SNBXN8AWX7St/W/Cx44vlQyrSzrHDgWnwOQJ6UCEa3Bj4tOco
 /iWL7avnrGDsc+p6bD7B/be16n5PJa7gj99YNhuOr27Ftkih+q6PvR93SUXAMGtgskIv
 xOhxOHbtm41Haq4cgpAwCeH64KxWY4ljCsosiR3E5y2PCQTSV+pQS0+SLt/GlQlxezKz pQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jr4ge02kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:07:55 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28LF7QgR028117;
        Wed, 21 Sep 2022 15:07:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3jnqr7x6hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:07:54 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28LF4QUZ024758;
        Wed, 21 Sep 2022 15:07:53 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 28LF7rY4028732
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 15:07:53 +0000
Received: from [10.110.44.78] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 21 Sep
 2022 08:07:51 -0700
Message-ID: <73a16853-d6fc-8a14-8050-d78c8fcd0e3a@quicinc.com>
Date:   Wed, 21 Sep 2022 08:07:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/5] mt76: Remove unused inline function
 mt76_wcid_mask_test()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <nbd@nbd.name>,
        <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
 <20220921090455.752011-3-cuigaosheng1@huawei.com>
 <20220921061111.6d960cc3@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220921061111.6d960cc3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: r70nx2ycLn7VRL4wpk2BqUvT91ezUXo8
X-Proofpoint-ORIG-GUID: r70nx2ycLn7VRL4wpk2BqUvT91ezUXo8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_08,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=720 adultscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210103
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/2022 6:11 AM, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 17:04:52 +0800 Gaosheng Cui wrote:
>> All uses of mt76_wcid_mask_test() have
>> been removed since commit 8950a62f19c9 ("mt76: get rid of
>> mt76_wcid_hw routine"), so remove it.
> 
> This should go via the wireless tree, please take it out of this series
> and send it to linux-wireless separately.

And when you do that add wifi: prefix to the subject
