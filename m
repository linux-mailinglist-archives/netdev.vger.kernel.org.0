Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BCE553F7C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 02:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355092AbiFVAZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 20:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiFVAZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 20:25:27 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D814085;
        Tue, 21 Jun 2022 17:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655857526; x=1687393526;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fcSXuxcmBUKzH1pGjoFkD8VHpLx66A6hiO3pyVdSCNo=;
  b=qMAg8mq6zsgzsmWowVqjcNPNXX388hQgPB11nvrdzLZggyyqgOueXEqd
   8v9buF+kzReumoEJPjAMOZYlvF4gwY594pso7Fg3GefMvHXa3g5a0jNbf
   CsCMtndEgMuR0N48DhAC4OWNAuiKivLajnfnuOX7xIfQKPv7lc3S12Lm4
   8=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 21 Jun 2022 17:25:26 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 17:25:25 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:25:25 -0700
Received: from [10.110.9.85] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 21 Jun
 2022 17:25:24 -0700
Message-ID: <0d2c8da3-083d-ed5e-9d47-f2e1aa96a0c3@quicinc.com>
Date:   Tue, 21 Jun 2022 17:25:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] wcn36xx: remove unexpected word "the"
Content-Language: en-US
To:     Jiang Jian <jiangjian@cdjrlc.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <loic.poulain@linaro.org>, <wcn36xx@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220621084018.56335-1-jiangjian@cdjrlc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220621084018.56335-1-jiangjian@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
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

On 6/21/2022 1:40 AM, Jiang Jian wrote:
> there is an unexpected word "the" in the comments that need to be removed
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>   drivers/net/wireless/ath/wcn36xx/hal.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 46a49f0a51b3..a36d9af69225 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -1961,7 +1961,7 @@ struct wcn36xx_hal_config_bss_params {
>   
>   	/* HAL should update the existing BSS entry, if this flag is set.
>   	 * UMAC will set this flag in case of reassoc, where we want to
> -	 * resue the the old BSSID and still return success 0 = Add, 1 =
> +	 * resue the old BSSID and still return success 0 = Add, 1 =

please also s/resue/reuse/ since you are touching

>   	 * Update */

and move */ to a separate line to conform to the 'net' commenting style

>   	u8 action;
>   

