Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E919E5536FD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352261AbiFUP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352441AbiFUP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:58:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61258B60
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 08:58:08 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z17so7754376wmi.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 08:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=8bGIi/65SNf1gUCizJJAA/uyPpaT7iiHXEa0Yre3OLs=;
        b=qc78xzPKYmrdcuYQ1ne6Hu8H1BSHHtXY0kD3g+N7e0SwghvQN3cw/qoAboUgUrs+Ck
         +iwQJ1AJ10Btc0VTT9f6WHOgo8D1M44NtYEiybmDF8Qw1nuDngA9JskQuGCbrE3tO6nl
         eOC4eyyo/f5SFvf9KgmRv+CDRnTziQhvDBCEM5t7Y86dYYU5K3O1Rl6sZVi1kpPAVOvC
         Mm5VwD38GAGomFJPcHYSHlYRYekmhbWFD6Ok/DiaZrz5oqAr5y0B65kbUBRp1g5dzbcn
         hGDJpk81SwmFxFBSKHm447D3o18Ami9ckEnNWJFVwbBjwjxjpvgRktuW+I3Y1jnfs+DD
         k+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8bGIi/65SNf1gUCizJJAA/uyPpaT7iiHXEa0Yre3OLs=;
        b=pkrfG7+GVG0APAlAUx0SSo9o6W4yYZ8osH5zKKJfWGNlCPAk+5t8CMArYIjfVaHa3x
         /R7W1AK/wnoL7mIsJzGS5cZAImvLUSruw5fPPfMPwegDhrh8enFSuPmBg6J6nuicpFAb
         b2s4+Ujs3WMS1InnVrhIT4B5ct/BC7/sjXX+6jAO83cq8d1r7EAR2BG79DQlbcbwpKbe
         JF3FVmU4ln3/mU9/OgW+8zfjZZjtbJ18Iu9cIQsxjj+9s3K6sAJ+qUoxQ/S8WiwfMFQx
         OUHwREhWmQ/lo5DkACiMka/efgldSowkphrIH7pZUXSuGbg+r+0aKLz1l6Ag+KTNCCvi
         brLA==
X-Gm-Message-State: AOAM530mAagExCrmDJ5o/XcqFbdYnCMFHHJBfy6sfdFYMJ8TuEKboDx9
        nsaALi098j6nHjdTk/jw2yybFA==
X-Google-Smtp-Source: ABdhPJzfQtcmGS9lGGD/a74+uwozsMtxNFYclUUgKl5wNK5vG+XpP16pmsEjUM4CRShV7wvaWru3eQ==
X-Received: by 2002:a05:600c:3b88:b0:39c:55b2:3d1 with SMTP id n8-20020a05600c3b8800b0039c55b203d1mr42734848wms.64.1655827086597;
        Tue, 21 Jun 2022 08:58:06 -0700 (PDT)
Received: from [192.168.0.221] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id i187-20020a1c3bc4000000b0039ee52c1345sm12581252wma.4.2022.06.21.08.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 08:58:06 -0700 (PDT)
Message-ID: <a194d4c5-8e31-ecd9-ecd0-0c96af03485b@linaro.org>
Date:   Tue, 21 Jun 2022 17:58:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry
 for board ID
Content-Language: en-US
To:     Robert Marko <robimarko@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220621135339.1269409-1-robimarko@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220621135339.1269409-1-robimarko@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/06/2022 15:53, Robert Marko wrote:
> bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
> used for identifying the correct board data file.
> 
> This however is sometimes not enough as all of the IPQ8074 boards that I
> have access to dont have the qmi-board-id properly fused and simply return
> the default value of 0xFF.
> 
> So, to provide the correct qmi-board-id add a new DT property that allows
> the qmi-board-id to be overridden from DTS in cases where its not set.
> This is what vendors have been doing in the stock firmwares that were
> shipped on boards I have.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>

Thank you for your patch. There is something to discuss/improve.

> ---
>  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml     | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> index a677b056f112..fe6aafdab9d4 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> @@ -41,6 +41,14 @@ properties:
>          * reg
>          * reg-names
>  
> +  qcom,ath11k-board-id:

The "board" a bit confuses me because in the context of entire system it
means the entire hardware running Qualcomm SoC. This is sometimes
encoded as qcom,board-id property.

Is your property exactly the same?

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Board ID to override the one returned by the firmware or the default
> +      0xff if it was not set by the vendor at all.
> +      It is used along the ath11k-calibration-variant to mach the correct
> +      calibration data from board-2.bin.
> +
>    qcom,ath11k-calibration-variant:
>      $ref: /schemas/types.yaml#/definitions/string
>      description:


Best regards,
Krzysztof
