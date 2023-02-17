Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC7469B02C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjBQQGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBQQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:06:11 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A98168E75;
        Fri, 17 Feb 2023 08:06:10 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id z1-20020a1c4c01000000b003e206711347so1239586wmf.0;
        Fri, 17 Feb 2023 08:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HueOvbuw31YRgxQXQPlUUdJnio1mzAYCQ45ZzyihROk=;
        b=CkVK5N8OXTdHE3TIk5MnvI3qb985NhzvKBNNrzemPAVRmJkLcXV9QAO1GKhYjbwmSf
         K/Hc7V1hLIWgwa6TWLRl1yjpp9F5Z1ET4FcsFz/gSTNO4pX4KrIpSr/w/EvbbaG79r+z
         1ChGswfwUchX4Kvdpv1PatAoWeql6s1SQm0t0Pp+cxkx+T5acb5/CRJX3y0ERjDGKDJw
         +RA4107z7OBf9MUBjxurkqfd4x0vYuEbtGRXZSAIasGiTN2uK4KqaFD8w+5yvQz9jhKR
         1PnWokQ168L96Q3hih1aRoIXd7TORAn2hhNewIXQ783I7FUsl3Bg0ovikMlmRHzZfy8c
         d8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HueOvbuw31YRgxQXQPlUUdJnio1mzAYCQ45ZzyihROk=;
        b=fRL78lul1IR1bO3FwShasMGf/NTHo68F/Rhjhkufib4HN649HyrYZe/SIQisFO5kw9
         p45GbGdMD+xZK/QNusoHmcSf3krM089zkDMtBRq1hwJIGu24KuPbWW6Oc5lUCHeJ/JKs
         ulA7ZJncFVOXWnSmdtkbMS6trrlw3qnjqak4NTuXE4WzfyNtLxCwWsPPlPKh66OIhUGT
         bMD/AKTzCZt1SLmnyzOmlZqiLP4WNHRS2R+TZxZv3YFapuZ+u4QsFQ0ep3XkNFfcAY2z
         KAmWfQYONrb1YPnmx8O16jFFKMeSGsBzHCI0/4pyReHRIFj75M2nYQhKDpOPt1VQm7bs
         c2AQ==
X-Gm-Message-State: AO0yUKWKJTJ5XGWYmZz5MstShbsVkaN7IdTwFQ+w5RN69w4eEWdbXS2K
        /K1NsT7p8+0sSm0ckCdtyAqvF3RCmo0=
X-Google-Smtp-Source: AK7set/QLoueyR8Cqypop8wEPM7PizTLim+/KHniFgO0wtCy1O5/5PfulSZiBjwyd70LMkl/Fe/KLQ==
X-Received: by 2002:a05:600c:4fc4:b0:3dc:50c2:cc1 with SMTP id o4-20020a05600c4fc400b003dc50c20cc1mr1000602wmq.23.1676649968417;
        Fri, 17 Feb 2023 08:06:08 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id bi23-20020a05600c3d9700b003e200d3b2d1sm5486983wmb.38.2023.02.17.08.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 08:06:07 -0800 (PST)
Subject: Re: [PATCH][next][V2] sfc: Fix spelling mistake "creationg" ->
 "creation"
To:     Colin Ian King <colin.i.king@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>,
        linux-kernel@vger.kernel.org
References: <20230217143753.599629-1-colin.i.king@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <405e95d4-a29f-07ff-d9bf-7562ef8faff5@gmail.com>
Date:   Fri, 17 Feb 2023 16:06:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230217143753.599629-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2023 14:37, Colin Ian King wrote:
> There is a spelling mistake in a pci_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Reviewed-by:  Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
> V2: Fix subject to match the actual spelling mistake fix
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index d2eb6712ba35..52fe2b2658f3 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -655,7 +655,7 @@ static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>  				 "devlink port creation for PF failed.\n");
>  		else
>  			pci_warn(efx->pci_dev,
> -				 "devlink_port creationg for VF %u failed.\n",
> +				 "devlink_port creation for VF %u failed.\n",
>  				 idx);
>  		return NULL;
>  	}
> 

