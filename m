Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E27F68BF36
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBFODE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBFOCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:02:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92035597;
        Mon,  6 Feb 2023 06:02:47 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ba1so6396964wrb.5;
        Mon, 06 Feb 2023 06:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWtgR15Dd2RZZwx7STJllW1tQKQ2lefgplDZNMM6hTY=;
        b=eNZNwiPYIOkrhxXbQF2Xmoh6IXdHBNp0xT/QIMHzA3OcKtI4qdyoh72Md9PtLhUbGR
         CeuknzIo4FUez/GoIGukJMWY5OidHHAwUWzgThv0swBi4SVGw6y4dmDUDIvCNmROEXjP
         cqixWc6ZHIBDbREQ/w6zmJ+u6SRQAOhhdgX5JDcBzzxny9QFsbaQ6X9PEC9xeCdlxzd+
         h5NZAWalezr6O/6Hb5pdqGBybtQS8wfVU5v/yRg239pzGorzVuZUZQ414DNk87g/jNoc
         sL1CunWCqmBg+f/VOJ/2LG/Mkd8iRENnZToCYeJCx+4PsBrMPHD6z113/LY+PnYIBpWK
         Twww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mWtgR15Dd2RZZwx7STJllW1tQKQ2lefgplDZNMM6hTY=;
        b=WCs4cylrZcGaKG6a7po7PpH76wPcdMws9kK9887Z1S50b/esebxewm4vcFMCZgfW22
         igif3YYwq9lWImwAjgq54ZTq+bAKKQPXcwXHI6TCpHKrB8jsqvOo0CpN9K6Sq8G0cON5
         769o6k5OwZEujQwxeCUikiy/Ao7cwdLMV/gU8WAR2FZKeKGfSEO96Uh90dkMgIqqZPCZ
         +DaIFH23FbdyRHujfjvmNslfFfi1DtSvCcT4i7cM7Zo5Vh73wW6pf4qya3EMGIyEeaiL
         YDDiPGeDovA4WeUzteq/kKzn1gEEwhtJgaQ7Hd7gJ4dEDoRG8FmnAxwoyrWhnf8WHr/k
         TrSg==
X-Gm-Message-State: AO0yUKUoC/JzEC0YxvvpVQwYOT6PLzFF8vNiTRkv+ORsm0YO/E2b0pF1
        yOjfvwoIhIlzwZdhzw3D+54=
X-Google-Smtp-Source: AK7set92dHcmph1gDr0bNzk+nW3rAUt5DHbswTESGObH4RWxk/Y/SzSkbu4RXtV65Z4X56DB+Ha0QA==
X-Received: by 2002:a05:6000:10c2:b0:2c3:dd96:d5f2 with SMTP id b2-20020a05600010c200b002c3dd96d5f2mr7872109wrx.35.1675692166371;
        Mon, 06 Feb 2023 06:02:46 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d5084000000b002c3db0eec5fsm7207993wrt.62.2023.02.06.06.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 06:02:45 -0800 (PST)
Subject: Re: [PATCH v5 net-next 5/8] sfc: add devlink port support for ef100
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-6-alejandro.lucero-palau@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a2be6feb-609a-5af4-123a-750a24104e47@gmail.com>
Date:   Mon, 6 Feb 2023 14:02:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230202111423.56831-6-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 11:14, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the data when enumerating mports, create devlink ports just before
> netdevs are registered and remove those devlink ports after netdev has
> been unregistered.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
...
> @@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>  			i, rc);
>  		goto fail1;
>  	}
> +	ef100_rep_set_devlink_port(efv);
>  	rc = register_netdev(efv->net_dev);
>  	if (rc) {
>  		pci_err(efx->pci_dev,
> @@ -308,6 +310,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>  		efv->net_dev->name);
>  	return 0;
>  fail2:
> +	ef100_rep_unset_devlink_port(efv);
>  	efx_ef100_deconfigure_rep(efv);
>  fail1:
>  	efx_ef100_rep_destroy_netdev(efv);
> @@ -323,6 +326,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
>  		return;
>  	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
>  	unregister_netdev(rep_dev);
> +	ef100_rep_unset_devlink_port(efv);
>  	efx_ef100_deconfigure_rep(efv);
>  	efx_ef100_rep_destroy_netdev(efv);
>  }

Would it make sense to move these calls into
 efx_ef100_[de]configure_rep()?  It's responsible for other
 MAE/m-port related stuff (and is also common with remote reps
 when they arrive).
