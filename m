Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E6431D22
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhJRNsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:48:46 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37909 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232806AbhJRNqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:46:19 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2380B61E5FE33;
        Mon, 18 Oct 2021 15:44:06 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: compact the file ice_nvm.c
To:     Yanjun Zhu <yanjun.zhu@linux.dev>
References: <20211018131713.3478-1-yanjun.zhu@linux.dev>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <c1903730-9508-1fef-4232-3a5b62f28d7c@molgen.mpg.de>
Date:   Mon, 18 Oct 2021 15:44:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018131713.3478-1-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Yanjun,


Am 18.10.21 um 15:17 schrieb yanjun.zhu@linux.dev:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> The function ice_aq_nvm_update_empr is not used, so remove it.

Thank you for the patch. Could you please make the commit message 
summary more descriptive? Maybe:

> ice: Remove unused `ice_aq_nvm_update_empr()`

If you find out, what commit removed the usage, that would be also good 
to document, but it’s not that important.


Kind regards,

Paul


> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>   drivers/net/ethernet/intel/ice/ice_nvm.c | 16 ----------------
>   drivers/net/ethernet/intel/ice/ice_nvm.h |  1 -
>   2 files changed, 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> index fee37a5844cf..bad374bd7ab3 100644
> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> @@ -1106,22 +1106,6 @@ enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags)
>   	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
>   }
>   
> -/**
> - * ice_aq_nvm_update_empr
> - * @hw: pointer to the HW struct
> - *
> - * Update empr (0x0709). This command allows SW to
> - * request an EMPR to activate new FW.
> - */
> -enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)
> -{
> -	struct ice_aq_desc desc;
> -
> -	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_update_empr);
> -
> -	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
> -}
> -
>   /* ice_nvm_set_pkg_data
>    * @hw: pointer to the HW struct
>    * @del_pkg_data_flag: If is set then the current pkg_data store by FW
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
> index c6f05f43d593..925225905491 100644
> --- a/drivers/net/ethernet/intel/ice/ice_nvm.h
> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
> @@ -39,7 +39,6 @@ enum ice_status
>   ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd);
>   enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
>   enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags);
> -enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw);
>   enum ice_status
>   ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
>   		     u16 length, struct ice_sq_cd *cd);
> 
