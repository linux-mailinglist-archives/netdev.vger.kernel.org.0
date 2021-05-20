Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA538AE81
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhETMkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbhETMjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 08:39:42 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FA5C061349;
        Thu, 20 May 2021 04:52:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso5233808wmm.3;
        Thu, 20 May 2021 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2uxlfCGHHwNI4ZnaJxgkqdm0moe7gBXz5cgv/osHn+M=;
        b=I7+coE1bfp5TvXVTEtyKW0TU2MdfTfPrX5imocNbnoN2awek4D8qoMVfl99S2n8824
         +bXnOXfu2kKZJygRhAy/32GnO96xYSsHGCuH/J+kMd+SzEG1T4OqF0eeWuFTkEwwAbuu
         9nlBdVnJdMY2p7/u5KEVkYExg9Whe4tKZ+TO0E5wPRoLrl9YfQb9uiJrn6MLVWHeeke0
         doCSkuUo1W6QWolMhDmBqu7W08lBH6qhDZIrDJdu682mgcf0IKjgjzPFydvlrt2j/8Ib
         9wbh0QlcHgmtbwyiPqnLVVbBMWU6hAAyWmtWPsgpIHhzChXrZPlcRnCTCcVTpZxLpwCk
         52/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2uxlfCGHHwNI4ZnaJxgkqdm0moe7gBXz5cgv/osHn+M=;
        b=Y02fRsKORU4cqVqToCOb2pqf79gCSQZ/av+OCN8iVBGQxISePFzaNkZpR7dhOpwo5n
         F0IqoH1uNq7KrT/v06ToizvENtX5fM++Hm2wvKNEZDDsrveh4uhVEBFshuFPImrtRHRm
         KV3neMQKZvfsdpRaprzxrfxkvfxZP7BjGMPSEgnTBHQu6TpE8eckod33hMMC17g2gucw
         XiFdVMMu/gB3OCearGK4qhYMnc1LinIHO3TbnrLXxGSQwC/LHWIw1PsxqPstOVWyik9X
         02BpXAvWRNHjHPUfX0Gbrd5lZ89uhOhbtf/SzEMvLKDbfhgRgt1wxALqJhy1jkZKia8S
         rbIQ==
X-Gm-Message-State: AOAM5330F1wmdWgKXMzmnySbni0MoDGz6a6+s7RMDzqSaLktZBhk1OXb
        8R/FHoq0owdX9QCMubEcXdBpEjXvZVaGzQ==
X-Google-Smtp-Source: ABdhPJwSAxCffJXfSmLtWiyjzZyOXX2v6MdmXu+QLssp6jMoFRaRmrwUhM7vHd2mcpSVuIATEg/3Jw==
X-Received: by 2002:a1c:67c1:: with SMTP id b184mr3642327wmc.33.1621511529880;
        Thu, 20 May 2021 04:52:09 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id b7sm2734585wri.83.2021.05.20.04.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 04:52:09 -0700 (PDT)
Subject: Re: [PATCH -next resend] sfc: farch: fix compile warning in
 efx_farch_dimension_resources()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20210519021136.1638370-1-yangyingliang@huawei.com>
 <d90bd556-efd0-1b75-7708-7217fe490cf2@gmail.com>
 <3bf4adf0-ed98-ab86-cd5a-efca3ea856bc@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ae7d9137-af9f-7434-a1ea-f390765a73eb@gmail.com>
Date:   Thu, 20 May 2021 12:52:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <3bf4adf0-ed98-ab86-cd5a-efca3ea856bc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2021 03:13, Yang Yingliang wrote:
> On 2021/5/19 22:40, Edward Cree wrote:
>> As I said the first time you sent this:
>> Reverse xmas tree is messed up here, please fix.
>> Apart from that, LGTM.
> 
> Do you mean like this:
That's one way to do it.  But, a couple of nits:

> diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
> 
> index 6048b08b89ec..b16f04cf7223 100644
> --- a/drivers/net/ethernet/sfc/farch.c
> +++ b/drivers/net/ethernet/sfc/farch.c
> @@ -1668,10 +1668,10 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
>   */
>  void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>  {
> -    unsigned vi_count, total_tx_channels;
> +    unsigned total_tx_channels, vi_count;
No need to change the order of decls within a line.
> 
Probably this blank line should be removed while we're at it.
>  #ifdef CONFIG_SFC_SRIOV
> -    struct siena_nic_data *nic_data = efx->nic_data;
> +    struct siena_nic_data *nic_data;
>      unsigned buftbl_min;
>  #endif
> 
> @@ -1679,6 +1679,7 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>      vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
> 
>  #ifdef CONFIG_SFC_SRIOV
> +    nic_data = efx->nic_data;
>      /* Account for the buffer table entries backing the datapath channels
>       * and the descriptor caches for those channels.
>       */
Otherwise, looks fine.
-ed
