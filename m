Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88077572E9C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiGMG6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiGMG6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:58:34 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC71D75
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:58:32 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 19so12438953ljz.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/MQepqgjmqiG49N2KhiJ6nP4i5QciV/Ki58GkTH2hGQ=;
        b=DEd+dmHarAHJNvZXiNrlmXYSLAjPKKH+dmFAT5X/+amo+3GOSGScN25EBfeI6sdr07
         Z4hlz8co+PWBQ/C5yC0gYqeemxvvQhsnsr6QUCki85tNNgYpAHynRQrBD3RNEve3jY3E
         Q7mjSdIeN56XUiR5lVlh56rx196jucNSsU/sv4NZrNbd9G/J95iC0B94p2z1Ca8Bqzxe
         wtv8niB0YMjPb9zmW+6QOTOuZVD/NVNraffVpyhiUUkXLPDvvskAYWqJducJeQnCxXop
         +C6dW4CV0VO9EXQfbUC6hL6ZCuYA9ONpA+bSsDs1NF1ofWdop5JeESuJnYm9vQC9MduT
         Vo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/MQepqgjmqiG49N2KhiJ6nP4i5QciV/Ki58GkTH2hGQ=;
        b=ZAmLAPzTihNqONsJsT50l91Tpd/Klxi4W+0VzFx6n56XVAbjFzYXTiJxWlgD1OwOGP
         YImMpFZonPyArOm3f1uUmln119dXstdcjMrmSw1oKFCN5i/6cAX8zAZlePdu0xQRzo2J
         o0uq7uHx9A6zjS/+FwXp4/2QBD2aJpvSriNcqzIbnP6zQJVD2HZg3DfHzi0/S30th1lq
         nzquKqv1VwnoZisM/AuSvbjw00QilKwua1g8SAGHhYGnwszbVmAhmxbdfxtQBRKO+88A
         y3FvcHyl/Nvj1GqRrdEzIiebWpz1aYokofjldrda72Jcivt+NYyMsf2k2NYbxLQVTORz
         QClw==
X-Gm-Message-State: AJIora/D9hykOi2PCrbgubvkyAdMTHB0tYM2aWjJ4mm0wTWF1NSWCfC3
        KCeonYYNBEK9XgLMmKIpzrModw==
X-Google-Smtp-Source: AGRyM1sMlrXETF6/g48DfuDjz72Lp68LFT43gkJVp0kP3+Yxi0OD2YzN7osU4IGY5TjKEhfarbgLwA==
X-Received: by 2002:a05:651c:19ab:b0:25a:9407:95e8 with SMTP id bx43-20020a05651c19ab00b0025a940795e8mr904239ljb.382.1657695510572;
        Tue, 12 Jul 2022 23:58:30 -0700 (PDT)
Received: from [10.0.0.8] (fwa5da9-171.bb.online.no. [88.93.169.171])
        by smtp.gmail.com with ESMTPSA id be35-20020a05651c172300b0025d67756939sm2444146ljb.82.2022.07.12.23.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 23:58:29 -0700 (PDT)
Message-ID: <de3fc010-bfa3-cfac-c8cb-20ce2bdc829e@linaro.org>
Date:   Wed, 13 Jul 2022 08:58:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] NFC: nxp-nci: add error reporting
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20220712170011.2990629-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220712170011.2990629-1-michael@walle.cc>
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

On 12/07/2022 19:00, Michael Walle wrote:
> The PN7160 supports error notifications. Add the appropriate callbacks.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
