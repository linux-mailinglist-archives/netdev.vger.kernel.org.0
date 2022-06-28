Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FDD55EAA9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiF1RJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiF1RJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:09:09 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F272C126;
        Tue, 28 Jun 2022 10:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656436148; x=1687972148;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U85zC74FglfaUgTtPENvXAGKtODUMugCZKKLb7eNRJc=;
  b=oxRAHogzZHLpvrUQWGYcAafW3o1BpJFT7u/MyUi2yTpeXzKZV8V9gUPL
   iFM4/kT4WrhjE4F55tlpt2HuwH1IWGE83uLsGOVJGczhyOqMDvzJvOGym
   Hgrq8cvUkmu7brMEYemPzYEEnJm1AGZ3YBPcq3lpDBrPXk8Nv2rcLKgG3
   Y=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 28 Jun 2022 10:09:08 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 10:09:08 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 28 Jun 2022 10:09:07 -0700
Received: from [10.110.50.59] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 28 Jun
 2022 10:09:06 -0700
Message-ID: <fa624172-2aee-1d10-cbdb-398681002fdc@quicinc.com>
Date:   Tue, 28 Jun 2022 10:09:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 02/22] net: mac80211: add a missing comma at kernel-doc
 markup
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <cover.1656409369.git.mchehab@kernel.org>
 <11c1bdb861d89c93058fcfe312749b482851cbdb.1656409369.git.mchehab@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <11c1bdb861d89c93058fcfe312749b482851cbdb.1656409369.git.mchehab@kernel.org>
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

On 6/28/2022 2:46 AM, Mauro Carvalho Chehab wrote:
> The lack of the comma makes it to not parse the function parameter:

nit: s/comma/colon/

> 	include/net/mac80211.h:6250: warning: Function parameter or member 'vif' not described in 'ieee80211_channel_switch_disconnect'
> 
> Fix it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH 00/22] at: https://lore.kernel.org/all/cover.1656409369.git.mchehab@kernel.org/
> 
>   include/net/mac80211.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 27f24ac0426d..c0557142343f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -6238,7 +6238,7 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
>   
>   /**
>    * ieee80211_channel_switch_disconnect - disconnect due to channel switch error
> - * @vif &struct ieee80211_vif pointer from the add_interface callback.
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
>    * @block_tx: if %true, do not send deauth frame.
>    *
>    * Instruct mac80211 to disconnect due to a channel switch error. The channel

