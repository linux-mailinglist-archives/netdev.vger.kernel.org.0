Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F40048F7FC
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 17:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiAOQrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 11:47:12 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:50758 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiAOQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 11:47:11 -0500
Received: by mail-wm1-f41.google.com with SMTP id w26so11969117wmi.0;
        Sat, 15 Jan 2022 08:47:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f8++v/QtotaNfkwsEXb7nZ3NB0t7MyK+LUfHsrn7rZ0=;
        b=YAxPf9ZNBOpxbH4jlDDOZeHT44f+ZWFne+OLFdjQDXDkaHRxrmibmqbeiOgrXK1Jb3
         o/FfDtwS7C9DXosPLXJ1Msp6X4P6DxO0XGakFF2DJfLUBNRRFBldqLEcluGsxxGgYRMT
         BSipczWGGOVkNsjs4xtRckTFbedkmWE7P8tP87zLw0PieQrfarzMe9LENPhgGfrxXAvN
         uKZBpHlXnq7aXkI4GldgdPHUhs8XCIqzT1NaDHEJF0MjDJ3tLjmSbTURQ/bYYt9hRHz8
         gJn+onPC+zQe5KXT1Tb5jkBDYfCre9/W+6k2+SVrUmiMDK7VEHCfhV4Zm8GveMU8G5i8
         s7sw==
X-Gm-Message-State: AOAM5300oGxNQq4fJnhIzulDkpy2Rqmtp+FuPOnFOQqiOOHcy9jtqMYg
        7fm7hYRK3lMWiLsNEGT9RmM=
X-Google-Smtp-Source: ABdhPJxLy0WYIHlAH0r1oBP3dkDCUOAzMprUTas+tNykvw+GVUdUniFRRphWV2H5uOi4gDsDc9IERQ==
X-Received: by 2002:adf:e68b:: with SMTP id r11mr13043802wrm.568.1642265229905;
        Sat, 15 Jan 2022 08:47:09 -0800 (PST)
Received: from [192.168.0.35] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.googlemail.com with ESMTPSA id bg19sm15202256wmb.47.2022.01.15.08.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jan 2022 08:47:08 -0800 (PST)
Message-ID: <a23661a4-0f49-858d-811c-0b9bfbeff4ad@kernel.org>
Date:   Sat, 15 Jan 2022 17:47:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 06/11] arm64: defconfig: enable bpf/cgroup firewalling
Content-Language: en-US
To:     Marcel Ziswiler <marcel@ziswiler.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>, Will Deacon <will@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220114141507.395271-1-marcel@ziswiler.com>
 <20220114141507.395271-7-marcel@ziswiler.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220114141507.395271-7-marcel@ziswiler.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2022 15:15, Marcel Ziswiler wrote:
> From: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> 
> This avoids the following systemd warning:
> 
> [    2.618538] systemd[1]: system-getty.slice: unit configures an IP
>  firewall, but the local system does not support BPF/cgroup firewalling.
> [    2.630916] systemd[1]: (This warning is only shown for the first
>  unit using IP firewalling.)
> 
> Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> ---
> 
> Changes in v2:
> - Add Song's acked-by tag.
> 
>  arch/arm64/configs/defconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 

Make sense.
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
