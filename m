Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0194D41D08E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346619AbhI3AaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3AaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:30:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343CEC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:28:27 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s17so14976681edd.8
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8+qosVdYu9vYyF2S82snp3nSj7AWyA9q8+YcISC3TE0=;
        b=UhD4rXK2HbO1iJLo9ef2cTg0dtAqsP0NUStlnl3U2VvuTdD2AQwvD2M9aLknKvx4Ci
         rMAyb16oSbp6ftJ89HbPaeCEybn4h5LX7/hPtgG4zs3FmitmjiVO0C+blzt2vs6bD8ST
         +MUgaFKgIMYeko/FDJ8RVVZYX5vVJIJIta10NXf5BdBVCtk+F/E1HkSFGWEOHbnPRXFx
         ae4b4FpEJ5O/ALUlXnem0EaS1z7eh0kCXlhIeeeSDlbX1WxBPZ3/vbnQjVmTN09orTw5
         7uLR6La3mmyhrZuyJNuPaFMACAT0jCoPBCEo1G4dvzMEzzKU3kvTRA1W7SVLjfgFbj1E
         YsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+qosVdYu9vYyF2S82snp3nSj7AWyA9q8+YcISC3TE0=;
        b=A7EryPsklI8r4nTbD9EDm8eIq8C0f/g6VJKn1Um4V4/3NJKmyZVS22m7vk2WnApOaU
         mNW7zI2MxbzmokhwXs/QyEq4w47B2FF+xUOFjzRhic2noiPuyXwNqZ89Fo/757olfX7r
         vux1xFCJl0Hq6O1YTcy5tV9iOdc31/xa7aEf9z77dit9rsJW/TElPbSqffhl8pP0fPGV
         igXz9US6VL1DYHzmNkfzJDi8qebt4FB0yJTp49rgX8ljG2yvO4rYjpYRl1vept80NTGe
         +rgB6A+x2wADc81hIfb0SOH2HyrPTsFkC1llCQOKyUaOIddQAok21/VWIwCLG6pHE+0k
         7/MQ==
X-Gm-Message-State: AOAM533sxYfBSFjhWpMmYr59yAHYCyTCj8c4LTETuN5vI5dAKR2qUQ8v
        ZaNYBRKLnI4xFfUlrRXIGPU=
X-Google-Smtp-Source: ABdhPJyKPGYrq84qdNImb54JEdBLPOPOdXd4tN7Yew3hxtqY0Iknq/5K8eANDF1d4GJ2VLrxSOC7Kw==
X-Received: by 2002:a50:d9cc:: with SMTP id x12mr3624078edj.44.1632961705767;
        Wed, 29 Sep 2021 17:28:25 -0700 (PDT)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id lb20sm665104ejc.40.2021.09.29.17.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 17:28:25 -0700 (PDT)
Subject: Re: [RFCv2 net-next 019/167] net: sfc: convert the prototype of
 xxx_supported_features
To:     Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linuxarm@openeuler.org
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <20210929155334.12454-20-shenjian15@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <db183d34-e74a-aac9-57d6-81c35727787b@gmail.com>
Date:   Thu, 30 Sep 2021 01:28:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210929155334.12454-20-shenjian15@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2021 16:51, Jian Shen wrote:
> For the origin type for netdev_features_t would be changed to
> be unsigned long * from u64, so changes the prototype of
> xxx_supported_features for adaption.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/net/ethernet/sfc/falcon/net_driver.h | 5 +++--
>  drivers/net/ethernet/sfc/mcdi_filters.c      | 5 ++++-
>  drivers/net/ethernet/sfc/net_driver.h        | 5 +++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
> index a381cf9ec4f3..6fabfe7f02f5 100644
> --- a/drivers/net/ethernet/sfc/falcon/net_driver.h
> +++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
> @@ -1298,11 +1298,12 @@ static inline struct ef4_rx_buffer *ef4_rx_buffer(struct ef4_rx_queue *rx_queue,
>   * If a feature is fixed, it does not present in hw_features, but
>   * always in features.
>   */
> -static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx)
> +static inline void ef4_supported_features(const struct ef4_nic *efx,
> +					  netdev_features_t *supported)

Looks like this function isn't used anywhere in the Falcon
 code anyway, so you could just delete it instead.

-ed
