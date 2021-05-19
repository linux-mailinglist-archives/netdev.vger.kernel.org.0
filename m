Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AC389199
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354451AbhESOms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354378AbhESOm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:42:29 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EBDC061344;
        Wed, 19 May 2021 07:40:14 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o127so7428706wmo.4;
        Wed, 19 May 2021 07:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=siaJh1nJto0dvvaAdmUW7enGPuoUcB3Nw0RE+elDk1k=;
        b=jRXKUH0Av6zCrqKxBYUpKT23DI6Npf84WcrCXYVFpMV5Guj0UuRPinoBMyjG0ostyY
         pAyEEAdXDmaU9YRtpRGsdtZsoIg8843cJCjOTYzzio6Csr7WCUiAD8l2jCI/uH4NkyZR
         SacOCSRGsZ89pr55EcZ/NprKnI/YNkeIOfRAdcKeo0wLISGNPuGjXFS9Wcl/KG4zqqNI
         Bdj7uzAadbiwThYFGKiZ75d0GgzanLmfaj7sOkW1w100fxY0Eq/N5nq6cqW6+CC0KTTS
         P/guD4qaDpu0rZqAYcT/9EaS0IlxOCldVBtdbQwBJBxW5j76p74hVt+qaLaHHNZrylHv
         YImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siaJh1nJto0dvvaAdmUW7enGPuoUcB3Nw0RE+elDk1k=;
        b=ErFDHWByyK39OHmPVcqaYecDGdY3h1cx4U3svs+hIga5DxofzJWZks/llOorYRy0IK
         fwZ/utvdPn2VpcTyMf9c41rijLExbPa6J8XuDJv9rF26Quqpglihu6oLg8JIaLCNCA9P
         CFgxTpOYcW8FDQE6smlIVSC3tQKRkF8IdxcGAfPtK15zU0Fkzuxg18nKZCa9ACFOf1/1
         V0GoCl7DXDBiHVTkkaXABqtqpkco80y/x3KZXpJutjAWrlsfcBiF9Vl9j6wt0v5vHyF2
         Q5GQE2TkSE142sYG+5Ojm/VKzZASKEJBryQVZaN0pDtHJRZQQf/YjEJxCoMImKhWLZtI
         0Rpw==
X-Gm-Message-State: AOAM531/rokksPkw8Mr7TlbX4Z9U9xtFB7Pwj88ZJfsDIk+SoL2dbUTD
        Q9mz/r6IeLMvWorhquwmUDM=
X-Google-Smtp-Source: ABdhPJwdJiFzJ+4ZODRYgIGP8E8Bc6SiwRkbRDYhVBB0dAPgfsAZXVk6g52y7I6k3mhs/CUZVNrdKA==
X-Received: by 2002:a1c:3186:: with SMTP id x128mr10902659wmx.167.1621435213427;
        Wed, 19 May 2021 07:40:13 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id x13sm15788624wro.31.2021.05.19.07.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 07:40:12 -0700 (PDT)
Subject: Re: [PATCH -next resend] sfc: farch: fix compile warning in
 efx_farch_dimension_resources()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20210519021136.1638370-1-yangyingliang@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d90bd556-efd0-1b75-7708-7217fe490cf2@gmail.com>
Date:   Wed, 19 May 2021 15:40:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210519021136.1638370-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2021 03:11, Yang Yingliang wrote:
> Fix the following kernel build warning when CONFIG_SFC_SRIOV is disabled:
> 
>   drivers/net/ethernet/sfc/farch.c: In function ‘efx_farch_dimension_resources’:
>   drivers/net/ethernet/sfc/farch.c:1671:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
>     unsigned vi_count, buftbl_min, total_tx_channels;
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/sfc/farch.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
> index 49df02ecee91..6048b08b89ec 100644
> --- a/drivers/net/ethernet/sfc/farch.c
> +++ b/drivers/net/ethernet/sfc/farch.c
> @@ -1668,13 +1668,17 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
>   */
>  void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>  {
> -	unsigned vi_count, buftbl_min, total_tx_channels;
> +	unsigned vi_count, total_tx_channels;
>  
>  #ifdef CONFIG_SFC_SRIOV
>  	struct siena_nic_data *nic_data = efx->nic_data;
> +	unsigned buftbl_min;
>  #endif
As I said the first time you sent this:
Reverse xmas tree is messed up here, please fix.
Apart from that, LGTM.

-ed

>  
>  	total_tx_channels = efx->n_tx_channels + efx->n_extra_tx_channels;
> +	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
> +
> +#ifdef CONFIG_SFC_SRIOV
>  	/* Account for the buffer table entries backing the datapath channels
>  	 * and the descriptor caches for those channels.
>  	 */
> @@ -1682,9 +1686,6 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>  		       total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_DMAQ_SIZE +
>  		       efx->n_channels * EFX_MAX_EVQ_SIZE)
>  		      * sizeof(efx_qword_t) / EFX_BUF_SIZE);
> -	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
> -
> -#ifdef CONFIG_SFC_SRIOV
>  	if (efx->type->sriov_wanted) {
>  		if (efx->type->sriov_wanted(efx)) {
>  			unsigned vi_dc_entries, buftbl_free;
> 

