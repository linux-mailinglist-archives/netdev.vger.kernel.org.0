Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7421B13F7
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfILRqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:46:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfILRp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:45:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B126960790; Thu, 12 Sep 2019 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568310357;
        bh=NomiIUWIpO7zNfhNi0Mb4r3uO+M77AU+yjjx24sAiq8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DlWQWB/360decLVvnZky0qgtHvQeXw/VnQ86Gyv/WeHioD1+n+8zteHAkmfgeUcqZ
         bMhMgWLdmfWbpK0sdyJFaERqtzYNuzBeJQh5GUWWeba35LpNonenBKtztSrMXdEHhH
         rJ6kXZakHnFESy2gccxnjGq3Wy4Di9nGIp+A9QBk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7FC906055A;
        Thu, 12 Sep 2019 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568310356;
        bh=NomiIUWIpO7zNfhNi0Mb4r3uO+M77AU+yjjx24sAiq8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h7ePW9OEn0yiyJi3BH2aeADPm8dq8yIXP3/UbtX/+zlWu9VDU7O+Pt/pxUpEJwYBg
         HEmrU9TjMrpNKGCis3GVaPh38QNrsyUU88NUz17sHoEOSjfofNM2qy+1HhmkBML3T0
         AWIq3GMMFlBowi0ZFGF7je/0J+Hmv20isubG9up0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7FC906055A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] wlegacy: Remove unneeded variable and make function to be void
References: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
        <1568306492-42998-3-git-send-email-zhongjiang@huawei.com>
Date:   Thu, 12 Sep 2019 20:45:52 +0300
In-Reply-To: <1568306492-42998-3-git-send-email-zhongjiang@huawei.com> (zhong
        jiang's message of "Fri, 13 Sep 2019 00:41:31 +0800")
Message-ID: <87h85hh0hb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> writes:

> il4965_set_tkip_dynamic_key_info  do not need return value to
> cope with different ases. And change functon return type to void.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> index ffb705b..a7bbfe2 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> @@ -3326,12 +3326,11 @@ struct il_mod_params il4965_mod_params = {
>  	return il_send_add_sta(il, &sta_cmd, CMD_SYNC);
>  }
>  
> -static int
> +static void
>  il4965_set_tkip_dynamic_key_info(struct il_priv *il,
>  				 struct ieee80211_key_conf *keyconf, u8 sta_id)
>  {
>  	unsigned long flags;
> -	int ret = 0;
>  	__le16 key_flags = 0;
>  
>  	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
> @@ -3367,8 +3366,6 @@ struct il_mod_params il4965_mod_params = {
>  	memcpy(il->stations[sta_id].sta.key.key, keyconf->key, 16);
>  
>  	spin_unlock_irqrestore(&il->sta_lock, flags);
> -
> -	return ret;
>  }
>  
>  void
> @@ -3483,8 +3480,7 @@ struct il_mod_params il4965_mod_params = {
>  		    il4965_set_ccmp_dynamic_key_info(il, keyconf, sta_id);
>  		break;
>  	case WLAN_CIPHER_SUITE_TKIP:
> -		ret =
> -		    il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
> +		il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
>  		break;
>  	case WLAN_CIPHER_SUITE_WEP40:
>  	case WLAN_CIPHER_SUITE_WEP104:

To me this looks inconsistent with the rest of the cases in the switch
statement. And won't we then return the ret variable uninitalised?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
