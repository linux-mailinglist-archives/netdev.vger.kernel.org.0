Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C6CA5057
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfIBHwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:52:54 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:40030 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729408AbfIBHwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 03:52:54 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i4h8g-0003aF-Cr; Mon, 02 Sep 2019 10:52:38 +0300
Message-ID: <c22d4775fdad4e34fdc386e2cf728b63dfe13ffe.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Krzysztof Wilczynski <kw@linux.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 02 Sep 2019 10:52:36 +0300
In-Reply-To: <20190831220108.10602-1-kw@linux.com>
References: <20190831220108.10602-1-kw@linux.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: mvm: Move static keyword to the front of
 declarations
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-09-01 at 00:01 +0200, Krzysztof Wilczynski wrote:
> Move the static keyword to the front of declarations of
> he_if_types_ext_capa_sta and he_iftypes_ext_capa, and
> resolve the following compiler warnings that can be seen
> when building with warnings enabled (W=1):
> 
> drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:427:1: warning:
>   ‘static’ is not at beginning of declaration [-Wold-style-declaration]
> 
> drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:434:1: warning:
>   ‘static’ is not at beginning of declaration [-Wold-style-declaration]
> 
> Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
> ---
> Related: https://lore.kernel.org/r/20190827233017.GK9987@google.com
> 
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> index d6499763f0dd..937a843fed56 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> @@ -424,14 +424,14 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
>  	return ret;
>  }
>  
> -const static u8 he_if_types_ext_capa_sta[] = {
> +static const u8 he_if_types_ext_capa_sta[] = {
>  	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
>  	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
>  	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
>  	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
>  };
>  
> -const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
> +static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
>  	{
>  		.iftype = NL80211_IFTYPE_STATION,
>  		.extended_capabilities = he_if_types_ext_capa_sta,

Thanks for your patch! Though we already have this change in our
internal tree (submitted by YueHaibing) and it will reach the mainline
soon.

--
Cheers,
Luca.

