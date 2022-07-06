Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F54568003
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiGFHhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiGFHhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:37:46 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B18C22BEC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:37:39 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id j23so646925lji.13
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 00:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iIAexuesD3/xg7eAmfqotEatXDt1HRkHyqYMg7E1hxw=;
        b=DXVjfULjCWw5Z1vRiZi9Ql0gEoa7/pXv4U6zLgZB3jGi97QNeq8qDbpcnUtLpJ/KhR
         IcbOoNKlLuNmqE+YC5f+PZB1LvUYU7fmFPcFXREw2xWVrnxhyvI6d0z+nxIBPIZxzIKP
         baHtIZLMgXH837hQHQiX6E0GRoG/uWAAbmG0BPztxsKYc0qKyG7aVdGiwAbbhdmBQANq
         ofaEK+Jauc6Ln9ZWAcWz/tNR6LgJzVuUePnC64hNCS/6qMn2VrFPKUJss/O9LDXlJzVK
         2TLckA5adTw5TIyf4tkdIdIixrmnaaLFahND29e+bHX4Y6esl2kkpG/5lV5Qn6jg3PRF
         Yh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iIAexuesD3/xg7eAmfqotEatXDt1HRkHyqYMg7E1hxw=;
        b=HKJdXZ4DHAbwg6zeqtqzscQb/3L0gWlZMuXnD54cayKS1oZmH9prmottrgsiiEktRU
         6p5lCBfsq3vT8YyIro4INI0qtMkeJGruiLiC7/ZsU8FfKQj5lxwTl97mW3FeX0pgfAQB
         +EoaiANqMlYEMqy9HJEscDLZxYQkfRq2NF3mJROpADX2CwuenTxx5pn1adySNGF7pHPb
         vpmLOVSdU2EhUizmgxlr07aq0FWVScQLUF88T47qUPOpbHNMHBogUvf9nfhFvUv89qLV
         AFp6ONg4PMZcEhYBI5qJibTMxNoaN8hWjRXyi4PruPgSf2wDtCXBg/kn3y5ZobNv+QVC
         3nFQ==
X-Gm-Message-State: AJIora+wFt19jASTurmwZ4nDpNHS6jYnQYUkAiO7a7FpcmfCP5Yy6+vj
        owL2I12hwzZ1SvTCCbnDUdljSg==
X-Google-Smtp-Source: AGRyM1vkuazYe0AkchqV44aLB4Vax9ic8gKK1wKl/wCnwX1ibxBSEdHS6fJVKl/RSluEcPGnSKo8+Q==
X-Received: by 2002:a2e:8217:0:b0:25a:7232:b3d6 with SMTP id w23-20020a2e8217000000b0025a7232b3d6mr21029432ljg.463.1657093057259;
        Wed, 06 Jul 2022 00:37:37 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id d3-20020ac241c3000000b00478fe3327aasm6110131lfi.217.2022.07.06.00.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 00:37:36 -0700 (PDT)
Message-ID: <0493d71a-0fbf-699a-f9ed-523dbe454d76@linaro.org>
Date:   Wed, 6 Jul 2022 09:37:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 3/9] dt-bindings: memory: Add Tegra234 MGBE
 memory clients
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com,
        Thierry Reding <treding@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
 <20220706031259.53746-4-vbhadram@nvidia.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220706031259.53746-4-vbhadram@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2022 05:12, Bhadram Varka wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the memory client and stream ID definitions for the MGBE hardware
> found on Tegra234 SoCs.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> ---

Eh? What happened with the tag?


Best regards,
Krzysztof
