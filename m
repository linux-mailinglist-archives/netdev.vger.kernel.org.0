Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A314A748
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgA0Pgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:36:55 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43417 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgA0Pgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 10:36:55 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so7006890oif.10;
        Mon, 27 Jan 2020 07:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RTwkN+1nsK3Tbd6o0pbrLO1yGQq+UJG41x5hJujk/8A=;
        b=WU+dimbV5pvEKQM7QR6lgBxCvou6rPpDpsHtokCaUoOXlhODLpu8QPscK5lY1qEHfW
         XB0IAekwWLvMLeWW6AuAKT6SI0/p8dzkz8ndFE6HUreyh66tSnE68TP91A7KZiExic+X
         Fhkj3aFYi9hb3YZmNxd/DrVebMjdIGACkEliFog4Hb6qkMC5XL+0rmnmyUA9OXccNIQr
         5e0L/lN6mFHRPa2FM+JngG+lVEGx2ZZIJj60EuPPVMifeaX9jft3a0d2KDfw0oiP47X8
         xV69lZ21oV04RUipcckS1J8nmwn2ijoL/MiPB5ASYPwOGEu9lgllMRsD8hgNoPSCnnED
         HSXA==
X-Gm-Message-State: APjAAAV0xFlaZ7SUHKJ1V/UpoU5o+ZSIsMokRbxvgS61BXWMKVpbGA+G
        ZcAgNQhY8wcHMp/kQPmrhw==
X-Google-Smtp-Source: APXvYqx5tKEVzlvNIbjMUMTAI82thP8Ra2rKVGkItgc9MD6ZFnXKNKE7x5hPgxINh4EsrLRo3aEoRg==
X-Received: by 2002:aca:cf58:: with SMTP id f85mr7934927oig.6.1580139413880;
        Mon, 27 Jan 2020 07:36:53 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k17sm4925460oic.45.2020.01.27.07.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 07:36:53 -0800 (PST)
Received: (nullmailer pid 32751 invoked by uid 1000);
        Mon, 27 Jan 2020 15:36:52 -0000
Date:   Mon, 27 Jan 2020 09:36:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH v3 1/2] DTS: bindings: wl1251: mark ti,power-gpio as
 optional
Message-ID: <20200127153652.GA32638@bogus>
References: <cover.1580068813.git.hns@goldelico.com>
 <d34183026b1a46a082f73ab3d0888c92cf6286ec.1580068813.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d34183026b1a46a082f73ab3d0888c92cf6286ec.1580068813.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 21:00:13 +0100, "H. Nikolaus Schaller" wrote:
> It is now only useful for SPI interface.
> Power control of SDIO mode is done through mmc core.
> 
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.
