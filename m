Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2281F526253
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380428AbiEMMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241962AbiEMMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:50:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53A4A3C9;
        Fri, 13 May 2022 05:50:04 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so4231149wma.4;
        Fri, 13 May 2022 05:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X+Fu1OR5S2PYLzwd+6DYojojG2kI3ta4tOqVsSeXxJU=;
        b=Q+XQFyWlzXYICNidKTsLmvX9o2iZWVqjo1/bbYEonqDYAeByo5hzqa2I9iuSw2goWP
         mpkVjiBZTD3lFvF/eTuT8MubKjot116fUsQ+wruG616Y/YL09i0bxOBVHhsQg28WjFaG
         UsPzNFlkHc5SEa5F0j6w2CWhJro9xnIbpOlc5+/ytdI4CToVZUdHzkfNjJVNxM7WusA0
         DnBs1ZGYSQu/3yN432j0N7rFXv159EEjPRJgMX1QrH0xodavnAIoitHG8+m2XewPy18U
         YDRJKR1yYLB+ux+J1ZbbQvKO/bN+EXiUsseI8Qu4N5ybSqfbSaePD8wxEA/nlv92u7C0
         AY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=X+Fu1OR5S2PYLzwd+6DYojojG2kI3ta4tOqVsSeXxJU=;
        b=Bl099rBylrixg39VyyoUnRxaeBBTUWEP6o3P7VuxWrmPDO0LRBxpB77NYFT5OUjovQ
         idcf43UtWHQ0Is1tx9JDpaJJ0Wyb+ZNzoILWRP4NXOdLtg8qdHEE6Ym94kZl1xQvnW9X
         9B7t0u9wOgrBt31bkNPL0vv3gBR2CcCbgpheXvirTnJQZdHkSx7+QGbnzoUpGxzpg6Rc
         D4L1fzYf/XiNrgs91lpCIMmGLLpG3TdCd5Mpwt0EbzoJPwvbx+Wi0D6wF9y0o3VxdeBQ
         +h2QRg0UVRKhha9HAR5XNxO08B2xSbkoFVubLMCPFZS683x0T1nhJpR6Pqi5+Wqd6Xve
         ClIA==
X-Gm-Message-State: AOAM53227xG7NjkvFLFPhmqoBOGMPVJfIzq9Jw2gVEtCp6jVUftB3LAM
        m48ikCSr/Z9QD5FPwF/A2pI=
X-Google-Smtp-Source: ABdhPJwzJaRvNoKqgGpnRdUR9AXbWS6S0DLdaWfuhrwazzuavk/j3O24iMEE2ohRc+taV7I43969GQ==
X-Received: by 2002:a05:600c:a45:b0:346:5e67:cd54 with SMTP id c5-20020a05600c0a4500b003465e67cd54mr15121985wmq.127.1652446203201;
        Fri, 13 May 2022 05:50:03 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id u13-20020adfa18d000000b0020c5253d913sm2030167wru.95.2022.05.13.05.50.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 May 2022 05:50:02 -0700 (PDT)
Date:   Fri, 13 May 2022 13:50:00 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ren Zhijie <renzhijie2@huawei.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] sfc: siena: Fix Kconfig dependencies
Message-ID: <20220513125000.xcc5mce2f3gwzcnw@gmail.com>
Mail-Followup-To: Ren Zhijie <renzhijie2@huawei.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220513012721.140871-1-renzhijie2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513012721.140871-1-renzhijie2@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nit: the subject should have net-next in stead of -next.

On Fri, May 13, 2022 at 09:27:21AM +0800, Ren Zhijie wrote:
> If CONFIG_PTP_1588_CLOCK=m and CONFIG_SFC_SIENA=y, the siena driver will fail to link:
> 
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_remove_channel':
> ptp.c:(.text+0xa28): undefined reference to `ptp_clock_unregister'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_probe_channel':
> ptp.c:(.text+0x13a0): undefined reference to `ptp_clock_register'
> ptp.c:(.text+0x1470): undefined reference to `ptp_clock_unregister'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_pps_worker':
> ptp.c:(.text+0x1d29): undefined reference to `ptp_clock_event'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_siena_ptp_get_ts_info':
> ptp.c:(.text+0x301b): undefined reference to `ptp_clock_index'
> 
> To fix this build error, make SFC_SIENA depends on PTP_1588_CLOCK.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: d48523cb88e0("sfc: Copy shared files needed for Siena (part 2)")
> Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/siena/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
> index 3d52aee50d5a..3675233e963a 100644
> --- a/drivers/net/ethernet/sfc/siena/Kconfig
> +++ b/drivers/net/ethernet/sfc/siena/Kconfig
> @@ -2,6 +2,7 @@
>  config SFC_SIENA
>  	tristate "Solarflare SFC9000 support"
>  	depends on PCI
> +	depends on PTP_1588_CLOCK
>  	select MDIO
>  	select CRC32
>  	help
> -- 
> 2.17.1
