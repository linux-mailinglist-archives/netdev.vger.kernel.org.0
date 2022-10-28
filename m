Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89F3610EA2
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJ1KgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiJ1Kf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:35:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C835A2F4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:35:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v1so6029317wrt.11
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eW+CheCgTRxR9IJaYLmabSPx9MLYwwluxXfEL45JuW0=;
        b=PTlvwzFMv+M4KoMLrkFiKCrO5iiKS3EToeUs5TMkZsoHe2BmRV43pWqa2DrGJuJIXu
         RMgR5a536mdSmo0V0fosDG8IipXYvvpSX1OFCoBMvl5U/Af1xbGpsLnaLRht/K+YgERy
         A9JQiP9bZXWa7SeoP71SeR8DEJ96Tr97y/FV/+ytYVey52qAsVWIpaugBYu/uVE1aB2n
         aCUEGjq6RCeRjFW4oJG5o8q8BU5nszNArkJWjNlRr+fB9Zr6YY8yeKA+R+gfqB6Lmvjo
         +qxmiVXAvGi23o7ueo78YRK1mM1r0jkXF8uZ+F0iS614jaa/V8RGrQx4FQNXt79pLnOP
         xHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eW+CheCgTRxR9IJaYLmabSPx9MLYwwluxXfEL45JuW0=;
        b=15Of1cW9wiDf5Tk6DMArqbrwlGpm5bBNh1AjcScqb/bYs9LEhr7gtovpIp+7RxVTSN
         Iu5cHpJaWQWAjqsmnU/KFRFnkH888k3drXmGnGaPalcFzVosLzKC5AZZhNIGx+Itjhb5
         ryz0kK+pci7atfSLWw/DAqlxKJFV9w+LyqusWhrpq5Tyf5fF8ZW48zR/iRQfq79yPmQ5
         pICTfgbxxw9EYghTw6enDTzHBFsiWWIh2NByWzZwcON97t5uy9IIsd2iKebd+4SNpyzX
         3pe2SzzHB4QswQdj9GWv7V20Np/Gsj9woU8tiEIOtBVzDbAQJ7Ts+xheRWHi5ht01tSM
         nCVQ==
X-Gm-Message-State: ACrzQf1j/Lsggbrwa+XlzY0RZv92KYw8nB572V33tM1sLX/vanrJujg5
        6bB/G8BRpdGPf0DE1cMWBuiVK5HiGZd9MoyJGQCRJQ==
X-Google-Smtp-Source: AMsMyM6a0UQQ8Urjjkv/+ywgUkYaAmaLGec3U2m6pfzVPXj+Fh9uLUX39E72d0UmENG/+74HmL38PKDYNT4zXNKvdkA=
X-Received: by 2002:a05:6000:510:b0:235:e5de:8da0 with SMTP id
 a16-20020a056000051000b00235e5de8da0mr28495611wrf.416.1666953338015; Fri, 28
 Oct 2022 03:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221028003128.514318-1-shaneparslow808@gmail.com>
In-Reply-To: <20221028003128.514318-1-shaneparslow808@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 28 Oct 2022 12:35:01 +0200
Message-ID: <CAMZdPi-tz4_vxum8SYbYVuv71UYhe4QUGO6_w8TPFBcw9oydfQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: iosm: add rpc interface for xmm modems
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 at 02:37, Shane Parslow <shaneparslow808@gmail.com> wrote:
>
> Add a new iosm wwan port that connects to the modem rpc interface. This
> interface provides a configuration channel, and in the case of the 7360, is
> the only way to configure the modem (as it does not support mbim).

Doesn't the AT channel offer that possibility? what is the status of
7360 support without this change?

> The new interface is compatible with existing software, such as
> open_xdatachannel.py from the xmm7360-pci project [1].
>
> [1] https://github.com/xmm7360/xmm7360-pci
>
> Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 2 +-
>  drivers/net/wwan/wwan_core.c              | 4 ++++
>  include/linux/wwan.h                      | 2 ++
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> index 128c999e08bb..91e3e83fc47b 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> @@ -39,7 +39,7 @@ static struct ipc_chnl_cfg modem_cfg[] = {
>         /* RPC - 0 */
>         { IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
>           IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
> -         IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_UNKNOWN },
> +         IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_RPC },
>         /* IAT0 */
>         { IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
>           IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 62e9f7d6c9fe..cf16a2704914 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -319,6 +319,10 @@ static const struct {
>                 .name = "FIREHOSE",
>                 .devsuf = "firehose",
>         },
> +       [WWAN_PORT_RPC] = {
> +               .name = "RPC",
> +               .devsuf = "rpc",
> +       },

RPC sounds more like a generic method than an actual XMM-specific
protocol, isn't there a more precise name for that protocol? if not,
maybe XMMRPC is more appropriate?

>  };
>
>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> index 5ce2acf444fb..3cf2182ad4e9 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -15,6 +15,7 @@
>   * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
>   * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
>   * @WWAN_PORT_FIREHOSE: XML based command protocol
> + * @WWAN_PORT_RPC: Control protocol for Intel XMM modems
>   *
>   * @WWAN_PORT_MAX: Highest supported port types
>   * @WWAN_PORT_UNKNOWN: Special value to indicate an unknown port type
> @@ -26,6 +27,7 @@ enum wwan_port_type {
>         WWAN_PORT_QMI,
>         WWAN_PORT_QCDM,
>         WWAN_PORT_FIREHOSE,
> +       WWAN_PORT_RPC,
>
>         /* Add new port types above this line */
>
> --
> 2.38.1
>

Reagrds,
Loic
