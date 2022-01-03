Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7206648375F
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiACTHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiACTHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 14:07:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB3DC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 11:07:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b13so139348231edd.8
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 11:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=t4bdSzQEbDc5RMA3HLsRIUR9HsGmC1Pq3+nBop/4AtQ=;
        b=IXxULUYA8Qeo85qx0jTHKV+E2jg0JTQQ8lsq2j0CpcQdvXn8yE2CmlTAVI16TqXgTL
         PvDVbPfJNgxhKQrUpHtxgHbx0dFQaLo/RQ62SDcPVgPQbzeNEhqijhAEYRrGwIUrLEyv
         mPTPjEz2vT+sX00icUnyxjtnw9rKw/2wb/lr1FZrZ2J+3gHuF2PD1n4ZcwtsMaovYNca
         D4kQ4OQ8ZuwXsWSkO5USm0ldZ3JZQS1b3RIX95i/ExyMO8M3tD3KG/CVk9YAD3brU44L
         ovuk/8HwSzLo6BU4bVj6ytaoc4yR1PggkpixEhaFhuz+xOcjRCp0DLXKr2xMSI/cFN/G
         tYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=t4bdSzQEbDc5RMA3HLsRIUR9HsGmC1Pq3+nBop/4AtQ=;
        b=ejdS0j5GjGbgHP2rhcQlhwmWKUr6hOrQLsFhMIP8YDphtzxfd0dBGnODkXxF75YDpE
         HUq+siv2a9EXjmZVTx5NBi3WXZAfXQnt69nE+8ppQ8QRlgd3Nb4muwLMH5eSQo49wwdg
         z0pPfSe00sTo2GGJisui3ybemgzqgAr7EnuM9GND6WLeJFDVccYl1ay4cBQX6bsXmN1r
         0mrd9oylHt/WtxGGzFlMXub5AEZ6cOw1dJCI8PWD42jNXm7Arxh6YwQ5mSb3IZnmj9vV
         RFOUve3vXx+H53kE81CeVxa1t69YC9Jw+GjXD5665eRxQGovMxlG9+gIFuZr8XI8eA2i
         aplw==
X-Gm-Message-State: AOAM532CRwuquauyYH3OHZ58qcYpXRHwyzWbhKF9FiY8ysQlHE5e0d7U
        Yt3/eU1+gKY42JSpb0n3lPg=
X-Google-Smtp-Source: ABdhPJyYfSL5edxPNeUKgS7SaQhWxihJe4+OSysnNSkzuQYW3eMgSJK2t3bI8YGwat9OVdhsMUOvyw==
X-Received: by 2002:aa7:d4d3:: with SMTP id t19mr45948979edr.289.1641236824260;
        Mon, 03 Jan 2022 11:07:04 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id jg38sm10892146ejc.154.2022.01.03.11.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 11:07:03 -0800 (PST)
Date:   Mon, 3 Jan 2022 21:07:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v3 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Message-ID: <20220103190701.pvd7ixfcomlqlbgm@skbuf>
References: <20211231043306.12322-1-luizluca@gmail.com>
 <20211231043306.12322-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211231043306.12322-3-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 01:32:57AM -0300, Luiz Angelo Daros de Luca wrote:
> In preparation to adding other interfaces, the private data structure
> was renamed to priv.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> @@ -385,76 +385,76 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
>  
>  static int realtek_smi_probe(struct platform_device *pdev)
>  {
> -	const struct realtek_smi_variant *var;
> +	const struct realtek_variant *var;

Undocumented change.

>  	struct device *dev = &pdev->dev;
> -	struct realtek_smi *smi;
> +	struct realtek_priv *priv;
>  	struct device_node *np;
>  	int ret;
>  /**
> - * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
> + * struct realtek_ops - vtable for the per-SMI-chiptype operations
>   * @detect: detects the chiptype
>   */
> -struct realtek_smi_ops {

Undocumented name change.
