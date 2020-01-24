Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660A9147994
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgAXIqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:46:34 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:52023 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729604AbgAXIqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 03:46:33 -0500
Received: from [109.168.11.45] (port=51208 helo=[192.168.101.73])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <luca@lucaceresoli.net>)
        id 1iuubk-0004bC-SO; Fri, 24 Jan 2020 09:46:28 +0100
Subject: Re: [PATCH] iwlwifi: fix config variable name in comment
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20191202101339.24265-1-luca@lucaceresoli.net>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <bcf538ea-cfbd-c6b7-5fbe-dd647b6a7e9c@lucaceresoli.net>
Date:   Fri, 24 Jan 2020 09:46:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202101339.24265-1-luca@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 02/12/19 11:13, Luca Ceresoli wrote:
> The correct variable name was replaced here by mistake.
> 
> Fixes: ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules")
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
> index 317eac066082..fb6838527e28 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
> @@ -636,6 +636,6 @@ extern const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0;
>  extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
>  extern const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0;
>  extern const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0;
> -#endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
> +#endif /* CONFIG_IWLMVM */

A gentle ping about this patch.

Thanks,
-- 
Luca
