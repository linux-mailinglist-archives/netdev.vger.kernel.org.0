Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D6A407012
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhIJQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIJQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:58:58 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54CC061574;
        Fri, 10 Sep 2021 09:57:46 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t19so5289854lfe.13;
        Fri, 10 Sep 2021 09:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KigKFT5R1DxFkjz0kfipXNyWumwkd21XrYlMRDlSUkg=;
        b=azN7jo+EzudnR0M0ozgDgkVky6ElgMzVIoItARXCC+hkSpuP3/wHqtH/18Xm9k3qJC
         Vxl9WOHu6A0S275zRvI3NPU3vRykx8D3rNnHZFHzabQ/LrCkmW27NRmeNN3t/gx+aaZd
         fsSQsCB0Opk0bGjAhL+bhYeGkVTkkEPs/WDuGNU/T2fvClpBNSf55IwXWyTQcSLxx+XV
         8ff56bJv4qMcUU1zOg+v+HKqSYV76/M5ETkKgNwaRt0zpsBzPcQFES3KGNGb8P+eCKz3
         MyEELO0Vqb6rcUCGs2hezUI2KKnfTjXkpSAj/eMasEmkitCrWft0ymEcOGqnsymnXrJb
         Ec1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KigKFT5R1DxFkjz0kfipXNyWumwkd21XrYlMRDlSUkg=;
        b=wo4NN0G9Z4X+ldl2XGVshgMZCMCPlka7XeoD57Z96PibXB8fFRq5dcV51gVEXEunZk
         oPV4dOLDQsIOdKDNxAHI0XwJkAWBuVnY4NlT8HU0SvosStME69XprLw/dsQ1r7nkBpZu
         oC6OgvkoZ2PCcZh54B9GEWHlzcC2LVv2EXp3E+OHzYNqdEIatqhMnfWZLwGM0T9i0scc
         c5G29muaRP4+BEoVMLj/E8Ykz1cQuVDmWhl9H3mGYX5wz4GJem3/cNNmRjWBC8qb77DN
         OWHqCpZk3qoa87H8/PAlbMn+1dNSb8+EYAPgBvJh60QTykWvBn86cyqNs7ROnRGW761h
         E3Ww==
X-Gm-Message-State: AOAM5303NV61MYY8UFIysLJ7BbSl/VUFEPe5peUDjtyVOua8fL+4Vq4k
        eHKAycTvilHc5cyerluhCsPu3TfuFzxJUQ==
X-Google-Smtp-Source: ABdhPJzmhGvGwPHJL2r+6t2hno1TGXqNQgDOvbpHHgK5p/Z0sx/BWkHI7cZBxLOv4xoGaFhcwvsQZA==
X-Received: by 2002:a05:6512:238b:: with SMTP id c11mr4597902lfv.413.1631293065053;
        Fri, 10 Sep 2021 09:57:45 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id h4sm607074lft.184.2021.09.10.09.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:57:44 -0700 (PDT)
Date:   Fri, 10 Sep 2021 19:57:43 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 31/31] staging: wfx: indent functions arguments
Message-ID: <20210910165743.jm7ssqak7gouyl5j@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-32-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-32-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:05:04PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Function arguments must be aligned with left parenthesis. Apply that
> rule.

To my eyes something still go wrong with this patch. Might be my email
fault, but every other patch looks ok. Now these are too left. Also it
should alight with first argument not left parenthesis?

> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_tx_mib.c |  2 +-
>  drivers/staging/wfx/key.c        | 26 +++++++++++++-------------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/wfx/hif_tx_mib.c b/drivers/staging/wfx/hif_tx_mib.c
> index 45e531d996bd..97e961e6bcf6 100644
> --- a/drivers/staging/wfx/hif_tx_mib.c
> +++ b/drivers/staging/wfx/hif_tx_mib.c
> @@ -75,7 +75,7 @@ int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
>  	} else {
>  		return hif_read_mib(wdev, vif_id,
>  				    HIF_MIB_ID_EXTENDED_COUNTERS_TABLE, arg,
> -				sizeof(struct hif_mib_extended_count_table));
> +				    sizeof(struct hif_mib_extended_count_table));
>  	}
>  }
>  
> diff --git a/drivers/staging/wfx/key.c b/drivers/staging/wfx/key.c
> index 51a528102016..65134a174683 100644
> --- a/drivers/staging/wfx/key.c
> +++ b/drivers/staging/wfx/key.c
> @@ -31,7 +31,7 @@ static void wfx_free_key(struct wfx_dev *wdev, int idx)
>  }
>  
>  static u8 fill_wep_pair(struct hif_wep_pairwise_key *msg,
> -			     struct ieee80211_key_conf *key, u8 *peer_addr)
> +			struct ieee80211_key_conf *key, u8 *peer_addr)
>  {
>  	WARN(key->keylen > sizeof(msg->key_data), "inconsistent data");
>  	msg->key_length = key->keylen;
> @@ -41,7 +41,7 @@ static u8 fill_wep_pair(struct hif_wep_pairwise_key *msg,
>  }
>  
>  static u8 fill_wep_group(struct hif_wep_group_key *msg,
> -			      struct ieee80211_key_conf *key)
> +			 struct ieee80211_key_conf *key)
>  {
>  	WARN(key->keylen > sizeof(msg->key_data), "inconsistent data");
>  	msg->key_id = key->keyidx;
> @@ -51,7 +51,7 @@ static u8 fill_wep_group(struct hif_wep_group_key *msg,
>  }
>  
>  static u8 fill_tkip_pair(struct hif_tkip_pairwise_key *msg,
> -			      struct ieee80211_key_conf *key, u8 *peer_addr)
> +			 struct ieee80211_key_conf *key, u8 *peer_addr)
>  {
>  	u8 *keybuf = key->key;
>  
> @@ -68,9 +68,9 @@ static u8 fill_tkip_pair(struct hif_tkip_pairwise_key *msg,
>  }
>  
>  static u8 fill_tkip_group(struct hif_tkip_group_key *msg,
> -			       struct ieee80211_key_conf *key,
> -			       struct ieee80211_key_seq *seq,
> -			       enum nl80211_iftype iftype)
> +			  struct ieee80211_key_conf *key,
> +			  struct ieee80211_key_seq *seq,
> +			  enum nl80211_iftype iftype)
>  {
>  	u8 *keybuf = key->key;
>  
> @@ -93,7 +93,7 @@ static u8 fill_tkip_group(struct hif_tkip_group_key *msg,
>  }
>  
>  static u8 fill_ccmp_pair(struct hif_aes_pairwise_key *msg,
> -			      struct ieee80211_key_conf *key, u8 *peer_addr)
> +			 struct ieee80211_key_conf *key, u8 *peer_addr)
>  {
>  	WARN(key->keylen != sizeof(msg->aes_key_data), "inconsistent data");
>  	ether_addr_copy(msg->peer_address, peer_addr);
> @@ -102,8 +102,8 @@ static u8 fill_ccmp_pair(struct hif_aes_pairwise_key *msg,
>  }
>  
>  static u8 fill_ccmp_group(struct hif_aes_group_key *msg,
> -			       struct ieee80211_key_conf *key,
> -			       struct ieee80211_key_seq *seq)
> +			  struct ieee80211_key_conf *key,
> +			  struct ieee80211_key_seq *seq)
>  {
>  	WARN(key->keylen != sizeof(msg->aes_key_data), "inconsistent data");
>  	memcpy(msg->aes_key_data, key->key, key->keylen);
> @@ -114,7 +114,7 @@ static u8 fill_ccmp_group(struct hif_aes_group_key *msg,
>  }
>  
>  static u8 fill_sms4_pair(struct hif_wapi_pairwise_key *msg,
> -			      struct ieee80211_key_conf *key, u8 *peer_addr)
> +			 struct ieee80211_key_conf *key, u8 *peer_addr)
>  {
>  	u8 *keybuf = key->key;
>  
> @@ -129,7 +129,7 @@ static u8 fill_sms4_pair(struct hif_wapi_pairwise_key *msg,
>  }
>  
>  static u8 fill_sms4_group(struct hif_wapi_group_key *msg,
> -			       struct ieee80211_key_conf *key)
> +			  struct ieee80211_key_conf *key)
>  {
>  	u8 *keybuf = key->key;
>  
> @@ -143,8 +143,8 @@ static u8 fill_sms4_group(struct hif_wapi_group_key *msg,
>  }
>  
>  static u8 fill_aes_cmac_group(struct hif_igtk_group_key *msg,
> -				   struct ieee80211_key_conf *key,
> -				   struct ieee80211_key_seq *seq)
> +			      struct ieee80211_key_conf *key,
> +			      struct ieee80211_key_seq *seq)
>  {
>  	WARN(key->keylen != sizeof(msg->igtk_key_data), "inconsistent data");
>  	memcpy(msg->igtk_key_data, key->key, key->keylen);
> -- 
> 2.33.0
> 
