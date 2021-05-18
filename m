Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8607B387B14
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhERO1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhERO1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 10:27:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE0EC061573;
        Tue, 18 May 2021 07:26:31 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h4so10430521wrt.12;
        Tue, 18 May 2021 07:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MUVP8LsE0iw8+0u+vJIBUv1GW/ywRRaVM+fcJxCDmRE=;
        b=EDWnNuCJamSLYbnxNE+MsFKyWRqm7sbdF8UdIu/N0Id7p/z+MRb9JSGRECReY/Y7iX
         5tjEkE7MAT/KBuj9IzrE+xsR8ayssjVfgdBl9hxY5uJ7HQCV5M3uuEfwfOE0SelcvmGH
         0IOxXntssZhfq/RCLZeGHzY6dL7GXzpKo/nvErRISKZZs+ItzQ9pcK8QoIXB0hWFqwwf
         nuQNWmOd6JRSXtV+VmjCbZw3TP+iR4SGJhQS1CXj1sgp0kRYsYFVRGuzRp/zDdgCJlNf
         BF2xAgaBFgGELoUHIoaK2GPmLTLBMJnOL5c3i12Ye8vu8yCtXyl9PD5kt6JKTPTolfza
         Q++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MUVP8LsE0iw8+0u+vJIBUv1GW/ywRRaVM+fcJxCDmRE=;
        b=b3/kyAHfrxFrS8objN9dB2XoU/XR14Tz/tpmrqtR5YrJg8Sg3INVRjVdcHABu83ffl
         EZK2K3O6ShvxwgorXpEZA508g629knfktyIcwRb4g0I4emn8WgKeXUqFQ8NkaNCmSvKI
         5oIi/FM8HkMDU+2YNAmocvAxMJY8EhVAUMt7VGzVUawG0AW1vhfpDyuLZHZCVVBavQ4S
         FZPiyiSNjA3haYR6G5sOnLqhffoP1sWgghQ0RobWgfAn5DWbxNUEDPT2NK/ZJGZ3/qZ5
         LPAPRIHqbEQ2Bj3KX20nG1J+32xr7jj/Wk/i7PtryrzlNOaAOU8q+VFS5ZKt/NvPOSBZ
         SD3Q==
X-Gm-Message-State: AOAM532en54zefx6F1looEtiD3pN4qlQ/G37mfkoinfff529FvpViqw0
        pgKJtLpPVOJ57nNxEnD6YHMKabz3vMEN3w==
X-Google-Smtp-Source: ABdhPJw674HTmrQtbGS0j+i1ZCL9v3VV5AQFVriNnIQ1NTYbFXeENN3c3E2AaRXE3/Nw/476RfuQtg==
X-Received: by 2002:adf:ce02:: with SMTP id p2mr7466320wrn.156.1621347989893;
        Tue, 18 May 2021 07:26:29 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id h14sm27139750wrq.45.2021.05.18.07.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 07:26:28 -0700 (PDT)
Subject: Re: [PATCH net-next] sfc: farch: fix compile warning in
 efx_farch_dimension_resources()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20210518131711.1311363-1-yangyingliang@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <471fea0e-fac0-3d05-b182-4aec57579b4b@gmail.com>
Date:   Tue, 18 May 2021 15:26:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210518131711.1311363-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2021 14:17, Yang Yingliang wrote:
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
> index 49df02ecee91..0bd879bd73c7 100644
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
> +	unsigned buftbl_min;
>  	struct siena_nic_data *nic_data = efx->nic_data;
>  #endif
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

