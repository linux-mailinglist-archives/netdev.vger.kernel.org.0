Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F2656572
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 23:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiLZWhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 17:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiLZWgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 17:36:16 -0500
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E86D29A;
        Mon, 26 Dec 2022 14:36:06 -0800 (PST)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1441d7d40c6so13803707fac.8;
        Mon, 26 Dec 2022 14:36:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd7h3ftOlRZgWS17O9lpNRf7y+BcCuyyNMntDSSxUI8=;
        b=4AuHOH/niwFm4B5TcdR1/MiGttA9/4VdACzNGKSgYbPXkcwq0BqNOhyIBOs3fsml1z
         BJHjOzAcaq01RmyU2RoTOLB9a943fqnjJ4B/SlbE2c9Jf7hdwwbVvRC5x/Vr1QLmfkBM
         jqgVikRIY4tsndp0/PMBz3DuGlvO7mk7UfJCUK2IpGL8Ekb3Ec4rXe+aOhPIsvazWdwd
         0w7dGrSEAwkiCrD6uIzgnUbIzofI+weSxUH5SRumkuAhpdt+T6o6LW65oRWXyI7y73ha
         KyLfkG78aTOmSGEY2Q4vDYC5cYLwEf5raHRVZI9qet2h4IND7xcMY51cV/PXvur8ybNB
         N05g==
X-Gm-Message-State: AFqh2kpcLjhesc3EbLLamIr7YVnt0iun6DMd6uIj8+FK27IXKZwEV4yA
        fYX/3N9ySBNNpZdBuIQcFX15/0xyxA==
X-Google-Smtp-Source: AMrXdXvlImhitnYDbaRz3WRGUTuHJKfOVSDWrP/aMMwNqrnB5QrRh0QVVvlpZXvPyB6tchgNZ0o7pg==
X-Received: by 2002:a05:6870:a54c:b0:14c:4479:84a6 with SMTP id p12-20020a056870a54c00b0014c447984a6mr9439484oal.52.1672094165689;
        Mon, 26 Dec 2022 14:36:05 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:80e8:2792:eb0e:539f:f657:547b])
        by smtp.gmail.com with ESMTPSA id w9-20020a056871060900b0012763819bcasm5418018oan.50.2022.12.26.14.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 14:36:05 -0800 (PST)
Received: (nullmailer pid 76410 invoked by uid 1000);
        Mon, 26 Dec 2022 22:01:20 -0000
Date:   Mon, 26 Dec 2022 16:01:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anand Moon <anand@edgeble.ai>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        linux-rockchip@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        David Wu <david.wu@rock-chips.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jagan Teki <jagan@edgeble.ai>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
Message-ID: <167209208042.76358.12497793083674238127.robh@kernel.org>
References: <20221226063625.1913-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226063625.1913-1-anand@edgeble.ai>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 26 Dec 2022 06:36:19 +0000, Anand Moon wrote:
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> fix below warning
> $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> 		 compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> 
> Fixes: b36fe2f43662 ("dt-bindings: net: rockchip-dwmac: add rv1126 compatible")
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> ---
> v2: drop SoB of Jagan Teki
>     added Fix tags and update the commit message of the warning.
> ---
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
