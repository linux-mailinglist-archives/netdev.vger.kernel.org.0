Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDAE56CB37
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 21:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiGITHQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 9 Jul 2022 15:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGITHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 15:07:15 -0400
Received: from relay3.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A1111A2F
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 12:07:14 -0700 (PDT)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay12.hostedemail.com (Postfix) with ESMTP id CC1DB120311;
        Sat,  9 Jul 2022 19:07:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 0DA9420032;
        Sat,  9 Jul 2022 19:07:10 +0000 (UTC)
Message-ID: <b47293b4b8874c0ae32868533bd0df94e08b8706.camel@perches.com>
Subject: Re: [PATCH] wifi: wcn36xx: fix repeated words in comments
From:   Joe Perches <joe@perches.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 09 Jul 2022 12:07:10 -0700
In-Reply-To: <20220709124356.52543-1-yuanjilin@cdjrlc.com>
References: <20220709124356.52543-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 0DA9420032
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: zjeymh5t1ywdjs75snkez43foa6p6gra
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18ENkg52OUH3RO+NWHMWJrFQPA9iNDLJHg=
X-HE-Tag: 1657393630-573364
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-09 at 20:43 +0800, Jilin Yuan wrote:
>  Delete the redundant word 'the'.
[]
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
[]
> @@ -1961,7 +1961,7 @@ struct wcn36xx_hal_config_bss_params {
>  
>  	/* HAL should update the existing BSS entry, if this flag is set.
>  	 * UMAC will set this flag in case of reassoc, where we want to
> -	 * resue the the old BSSID and still return success 0 = Add, 1 =
> +	 * resue the old BSSID and still return success 0 = Add, 1 =


s/resue/reuse/

>  	 * Update */
>  	u8 action;
>  
> @@ -2098,7 +2098,7 @@ struct wcn36xx_hal_config_bss_params_v1 {
>  
>  	/* HAL should update the existing BSS entry, if this flag is set.
>  	 * UMAC will set this flag in case of reassoc, where we want to
> -	 * resue the the old BSSID and still return success 0 = Add, 1 =
> +	 * resue the old BSSID and still return success 0 = Add, 1 =

here too

>  	 * Update */
>  	u8 action;
>  
> @@ -4142,7 +4142,7 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
>  	/* Length of the responce message */
>  	u32 rsp_length;
>  
> -	/* FIXME: Currently considering the the responce will be less than
> +	/* FIXME: Currently considering the responce will be less than

s/responce/response/

>  	 * 100bytes */
>  	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
>  } __packed;

