Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1DD4EFFFA
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 11:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiDBJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 05:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239643AbiDBJJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 05:09:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FF81B0BDD
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 02:07:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id pv16so10522157ejb.0
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 02:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vfxOVX3tgVzvnJ1lWoRt+g4cy0L/1V+jrzPQEjbERtA=;
        b=Qj4FCzYb6eDoS/RSw5Zm53N/RGRRBs8TIlXaVN8m5Nqb5BaQnt9R4zJIyIhaMMJHSB
         FXXUDQSpqiks0NoO1CA51fyn/aHyoTztLNRfYPwxUoqyGeCDR8Aq0S5jmbRhzkOfZsbP
         LlLtuV5bm4/reWo32wFOsbyOWHdJPqHbV9UR0IEk6ED4BZNeNNHVgQ/AimBoZD+faKnq
         bK7h+ReCGeWrwObkphnYdLef/mgJp3DgHF2+mbqMn4iNcRgNv/jEMIlRM1Ifhs0AFu0S
         LIsobHkUNhNI4ti764PiR6cVHbqXsjdyibHRW88dwjFvP8bhKlwhXYq+4uD4NhChCMGP
         /gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vfxOVX3tgVzvnJ1lWoRt+g4cy0L/1V+jrzPQEjbERtA=;
        b=j1AGMNRmUvK038zIyIKxfDtqxHVdQHLrWBbHTWAi8sYRmxwDj6t+e/apfoMPQPutPO
         jTA1g29ozEFCRrOuBmaHAuMjcQoT4Awn4gIdNPNXVDfat6ZeI2S6M5QxL4q3G3+gvhmK
         b75TJbY/Yr42IY+ZdV33cIbOTuLeuSmhJ7B7r18wYuBVK6Z9wwJKbV9Ny8Ai+E93CuXr
         C10xV98aeRYyAJaQWw/DZn44FeoFYUHwYmxDUleuSKrkrKhdOqdV45k0XBbXuCj7V4Ju
         vH2ixVKm+tVmhBm5i5p8ARCaaYrM0HoGky9Oc4b/6E1ygfDzD42arhblF9S7cfmTEcqM
         T9aA==
X-Gm-Message-State: AOAM5320gQIMtGYGTWV148ypmvhx+JX4PHin84yTpLWpx7poDKOLQFn3
        twg1BmIFWwxlD813AOswyIkBrA==
X-Google-Smtp-Source: ABdhPJxDmf6JlzGfAirrBgcDkLe4YHXYlcWnbNtFKkz/qAsg+csko3PIIXju00RkjjXQQVTSFx9XJQ==
X-Received: by 2002:a17:906:9751:b0:6e0:5cdd:cabf with SMTP id o17-20020a170906975100b006e05cddcabfmr3206181ejy.38.1648890475789;
        Sat, 02 Apr 2022 02:07:55 -0700 (PDT)
Received: from [192.168.0.170] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id f15-20020a50e08f000000b004134a121ed2sm2226811edl.82.2022.04.02.02.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 02:07:55 -0700 (PDT)
Message-ID: <a57e1e2f-f7e3-0f19-9a38-584f4a83fe48@linaro.org>
Date:   Sat, 2 Apr 2022 11:07:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/3] Split "nfc: st21nfca: Refactor EVT_TRANSACTION"
 into 3
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@chromium.org>, netdev@vger.kernel.org,
        kuba@kernel.org, christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
References: <20220401180939.2025819-1-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401180939.2025819-1-mfaltesek@google.com>
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

On 01/04/2022 20:09, Martin Faltesek wrote:
> Changes in v2:
>         -- Split the original patch into 3 patches, so that each one solves
>            a single issue. The original patch indicated 4 bugs, but two are
>            so closely related that I feel it makes sense to keep them
>            together.
> 

Please thread your patchset. git send-email does it by default, so just
`format-patch -3 --cover-letter -v2` and then `git send-email ... v2*`

In the Cc list, you missed the linux-nfc mailing list, probably because
it requires subscription.

Best regards,
Krzysztof
