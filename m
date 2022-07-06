Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EDB568005
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiGFHh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiGFHhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:37:22 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4751022BD0
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:37:19 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id l7so16617078ljj.4
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 00:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wLYIn0NItelgAXJCwbM/q0ny/IBo5bW15RcTBf0gD1c=;
        b=W+6Z3LONPK5Ra0z4gntAAtuDAffOwqyAsxR4AWvSIWc/YTOgzf/LbdPEU63qy4XgI9
         VzpkAqTC8qOhM0yktec60aOOZFTI3LJUUB0Q5T3fTr5OrAC4FP6peAYuazdrWJzUujTO
         C7scBcPjWY+2I8QK3G/CyzhR7FF6WUwfe14imXbSbhfK8GK0Qsdeqt11dBvDegCumsKF
         33xGLkEtUhAJxzUN52Tqbako3dDm4nSZHsbSQfyffaD79DWiKg9VnidPbikak+NJZ2Ib
         YkM1f50x6dx2jrz9fPWdfBR0U6Mj2CX5k0tQSS5OmmPmzUD90Zk+Ph/GGTR+l4MEDiEV
         tjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wLYIn0NItelgAXJCwbM/q0ny/IBo5bW15RcTBf0gD1c=;
        b=ClVCIx6oxK//4dzq8+NyrLygmDVLt8/fSZ0QvKer4jw4I/RXv5kOJnTz/1B/Y1n8wg
         lPcMXtdtLAsihD59LmBrJ7UI5PfjQVvcOgi0l0+EHRflB2aocfWy2RxDTTY5cr+PFOwP
         wUIqco6QMufKf8JzD925VXcwJdY6aWmv9EK4g8aLAlRNMtXJF0qUxiFWEGaGXqE50Zp+
         FLU0xp7DZA73d28wOT5I3vtJwjL8lcCIWv0bM7vAbSFYWU45+aiIQtRMrCXtkYNj941k
         HMMmeZ7lg7cPuV2UWLDmKHdZpjqN91Y7GRwyOxiSk+ESrUSv+GfBIIfteOrPO7CKSmPe
         FvkQ==
X-Gm-Message-State: AJIora8n+dcGQiJNsHX6qOQMa2Sw3PmcvhhrDRKN/cQ24UatbuvP1Qvt
        rIO3sula9xcJ77Ix03vM2GX1Xg==
X-Google-Smtp-Source: AGRyM1sgyFI4TrauOfkHKFmiUcxJfEwLMSwt/lf0cmYz3yqs/Bie2Q0Qc0fJrVea82hBhXpNy/SafQ==
X-Received: by 2002:a05:651c:d4:b0:25a:91c6:d9b1 with SMTP id 20-20020a05651c00d400b0025a91c6d9b1mr21881129ljr.400.1657093037642;
        Wed, 06 Jul 2022 00:37:17 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id h2-20020a2ea482000000b002556a17e193sm6035809lji.38.2022.07.06.00.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 00:37:16 -0700 (PDT)
Message-ID: <b74b66f1-f354-9eb9-357b-753bf81cde16@linaro.org>
Date:   Wed, 6 Jul 2022 09:37:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 0/9] tegra: Add support for MGBE controller
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com
References: <20220706031259.53746-1-vbhadram@nvidia.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
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

On 06/07/2022 05:12, Bhadram Varka wrote:
> This series adds the support for MGBE ethernet controller
> which is part of Tegra234 SoC's.
> 

Where is the changelog?

Best regards,
Krzysztof
