Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4512C4C371B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiBXUyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiBXUyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:54:45 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C3D1C6EE4
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:54:15 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id 12so4887591oix.12
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfMYjK+50fw94rDD8AQ09+CpZqxJl1X7Nhy87XvsxjQ=;
        b=c0xUO/Sd9SGT/EDOKNVonLQdJ9oakdj7NbdGUhdM20OJqpfFHFXa/jn0zcVvdlMJNn
         dJpZxbLFh5iocMQcR9wuPn8zGvYLQitkGIPz4kQMRDGGwrYI9xMA0glPYdEbjfnkQCQH
         6+jfGV82jux9aNzTwyDNJTWhQBKUUaJBM8dfM2wEPvNS/XGz+gtFSGEbZFSnCZh7xOp1
         NLSXCO4KL/RdnXLgbscjfyttT+10VWP4UGrpqBSIdOkb5DrEhVXms7RKPuAmSiJLHusC
         PXRvOr1xdKgOp6HZoGtvIBAHRkGWlhjJ0BPjODV0a2zmzX8rWfSBYKvjQQX+1Vva0z0z
         QlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SfMYjK+50fw94rDD8AQ09+CpZqxJl1X7Nhy87XvsxjQ=;
        b=JkB2ia7juXf53ttccIa4BiaM7ItWZi8FPvzwejFdGAj+MFMRXO/JX6qbG9UmC/yTqU
         aaC5lYpQwKjaoHWtKTu3NEJD2jojoTf6JVydJWaL+58S7lRD+mcW4T/M3oJG6vQWWJA0
         tqBjybhtS7KhPNPpjq+JLM8Wtc/JBGM7G3H+Meh+1+5+4UN5NKRZZA1SNlSQ1i/vVXnv
         DruD9xCEoTClDpUypZNvhEfe9BYNWgw1ksJR+W3vVYe7obqj/W8yzHYnsoMuDUtBMFAY
         lB6kbqBAjK22ZfFPR6+xFDdmpFLDztmiIKZLYZ8jPiQC5wDxB8FoYg4toDboXozA2GzR
         UILQ==
X-Gm-Message-State: AOAM532bFRNLkR8sqb6luMfkyvP3VhSyUWEhRNVs5Qr/oyjtrxxR8ktI
        9o50wizkd+6QwrO49sHFwNJ53Q==
X-Google-Smtp-Source: ABdhPJzzAVIp3uEnEAWpsNCodGfe1KfuXcOoOdPofq8pk28A2tLDnfnHxn0n7TJXb0wFfzg9s+ol8A==
X-Received: by 2002:a05:6808:23d0:b0:2d5:408c:9caf with SMTP id bq16-20020a05680823d000b002d5408c9cafmr2305248oib.301.1645736054909;
        Thu, 24 Feb 2022 12:54:14 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id c8-20020a4ad788000000b0031ce69b1640sm191259oou.10.2022.02.24.12.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 12:54:14 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Luca Weiss <luca@z3ntu.xyz>, linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        phone-devel@vger.kernel.org, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: (subset) [PATCH 0/5] Wifi & Bluetooth on LG G Watch R
Date:   Thu, 24 Feb 2022 14:54:01 -0600
Message-Id: <164573604161.1471031.17588136959240779844.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220216212433.1373903-1-luca@z3ntu.xyz>
References: <20220216212433.1373903-1-luca@z3ntu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 22:24:27 +0100, Luca Weiss wrote:
> This series adds the BCM43430A0 chip providing Bluetooth & Wifi on the
> LG G Watch R.
> 
> Luca Weiss (5):
>   dt-bindings: bluetooth: broadcom: add BCM43430A0
>   Bluetooth: hci_bcm: add BCM43430A0
>   ARM: dts: qcom: msm8226: Add pinctrl for sdhci nodes
>   ARM: dts: qcom: apq8026-lg-lenok: Add Wifi
>   ARM: dts: qcom: apq8026-lg-lenok: Add Bluetooth
> 
> [...]

Applied, thanks!

[2/5] Bluetooth: hci_bcm: add BCM43430A0
      (no commit info)
[3/5] ARM: dts: qcom: msm8226: Add pinctrl for sdhci nodes
      commit: a5683471b68d81898db14e1dee347bfe7469540d
[4/5] ARM: dts: qcom: apq8026-lg-lenok: Add Wifi
      commit: 81ecc39d0dd3fbbcc3c8505d0eefe511eb422d03
[5/5] ARM: dts: qcom: apq8026-lg-lenok: Add Bluetooth
      commit: e8880a10f970d86d1b3fdd8bc36400e0e01ba4a9

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
