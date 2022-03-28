Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D50D4EA2C4
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiC1WN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiC1WN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:13:26 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0977C12AA7;
        Mon, 28 Mar 2022 15:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648504935; x=1680040935;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V6wj85aktAy4zchSrB2TRXjLBQSa81RFSvjg7s60U4c=;
  b=xaCJZ3oZZcyngJ53hxm1SqqHPlKf7ee30yaHC/aN9RDSuAeOqZv1hU9C
   GaoZqXLUkhAL/KhKN1NlAcSFAu+v3fmj0hGtFQonE1ggLA6/7quCwhN6A
   sRwTuHSFWORiKziTLdqTb9X3ZNVpybcZjc9QMMk1QMFU1CxPXjmDzKHvi
   I=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 28 Mar 2022 14:49:11 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 14:49:11 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 28 Mar 2022 14:49:11 -0700
Received: from [10.110.35.108] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 14:49:10 -0700
Message-ID: <798bfcaa-eb73-9395-02d1-fa4de2eee396@quicinc.com>
Date:   Mon, 28 Mar 2022 14:49:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] wcn36xx: Improve readability of wcn36xx_caps_name
Content-Language: en-US
To:     =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>,
        <loic.poulain@linaro.org>
CC:     <kvalo@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <wcn36xx@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220328212912.283393-1-benni@stuerz.xyz>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220328212912.283393-1-benni@stuerz.xyz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/2022 2:29 PM, Benjamin Stürz wrote:
> Use macros to force strict ordering of the elements.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>   drivers/net/wireless/ath/wcn36xx/main.c | 126 ++++++++++++------------
>   1 file changed, 65 insertions(+), 61 deletions(-)
> 

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
