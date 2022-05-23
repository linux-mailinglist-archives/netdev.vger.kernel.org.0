Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED64F5308A4
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 07:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344808AbiEWFYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 01:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiEWFYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 01:24:43 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3865215800;
        Sun, 22 May 2022 22:24:40 -0700 (PDT)
Received: from [192.168.0.6] (ip5f5aedde.dynamic.kabel-deutschland.de [95.90.237.222])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4D2C061EA1928;
        Mon, 23 May 2022 07:24:37 +0200 (CEST)
Message-ID: <71292e14-fe6c-f475-009d-1ea8cde0ea46@molgen.mpg.de>
Date:   Mon, 23 May 2022 07:24:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [Intel-wired-lan] [PATCH] drivers/net/ethernet/intel: fix typos
 in comments
Content-Language: en-US
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220521111145.81697-50-Julia.Lawall@inria.fr>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220521111145.81697-50-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Julia,


Thank you for your patch.

I noticed, that the maintainer Tony wasn’t in the Cc: list.

Am 21.05.22 um 13:11 schrieb Julia Lawall:
> Spelling mistakes (triple letters) in comments.
> Detected with the help of Coccinelle.

I’d be interested in the script you used.

> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 

Nit: One unneeded blank line.

> ---
>   drivers/net/ethernet/intel/fm10k/fm10k_mbx.c   |    2 +-
>   drivers/net/ethernet/intel/ice/ice_lib.c       |    2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
> index 30ca9ee1900b..f2fba6e1d0f7 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
> @@ -1825,7 +1825,7 @@ static void fm10k_sm_mbx_process_error(struct fm10k_mbx_info *mbx)
>   		fm10k_sm_mbx_connect_reset(mbx);
>   		break;
>   	case FM10K_STATE_CONNECT:
> -		/* try connnecting at lower version */
> +		/* try connecting at lower version */
>   		if (mbx->remote) {
>   			while (mbx->local > 1)
>   				mbx->local--;
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 454e01ae09b9..70961c0343e7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -2403,7 +2403,7 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
>   				agg_id);
>   			return;
>   		}
> -		/* aggregator node is created, store the neeeded info */
> +		/* aggregator node is created, store the needed info */
>   		agg_node->valid = true;
>   		agg_node->agg_id = agg_id;
>   	}
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> index 3e74ab82868b..3f5ef5269bb2 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> @@ -77,7 +77,7 @@ static int __ixgbe_enable_sriov(struct ixgbe_adapter *adapter,
>   	IXGBE_WRITE_REG(hw, IXGBE_PFDTXGSWC, IXGBE_PFDTXGSWC_VT_LBEN);
>   	adapter->bridge_mode = BRIDGE_MODE_VEB;
>   
> -	/* limit trafffic classes based on VFs enabled */
> +	/* limit traffic classes based on VFs enabled */
>   	if ((adapter->hw.mac.type == ixgbe_mac_82599EB) && (num_vfs < 16)) {
>   		adapter->dcb_cfg.num_tcs.pg_tcs = MAX_TRAFFIC_CLASS;
>   		adapter->dcb_cfg.num_tcs.pfc_tcs = MAX_TRAFFIC_CLASS;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
