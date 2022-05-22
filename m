Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F995301A8
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 09:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbiEVHkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiEVHki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 03:40:38 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754753ED37
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 00:40:36 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id m6so13905856ljb.2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 00:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MqYU9S7JkHqQG35qsg1cXHBVp6joleLMgpUOh0cBEdc=;
        b=KWg35Bsff0IHTOK8jUYC5I+zCna5NpKHGnQDEQKGejmNPCt26wKiC36x8NKy8iwKPi
         Tjdnhix4QOzEZflQy81Bd3f3QYcRhgDUjsMJe2cE+gnpw//IP3VpgyXRGVvUH1DLQ3ML
         s6knDLCVmBuc8teN5vOK7+J/91AInk/5AJuyb6xnBk86qsqKIMMZ/vZTLIaSU2UyrqQr
         2F4dpBkmykZB3Oo8peNvTFFLDo9WOn85ah+lEEBnBN/XJHI/6PjC39DYGFLY6Ogd2ZLg
         znS5tIrA1ysu7g/iRXjTEZCCoyImk5KQyD7NVbxW1oQX3SDtH/JBUcwB3wlU6YL2Gvym
         hFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MqYU9S7JkHqQG35qsg1cXHBVp6joleLMgpUOh0cBEdc=;
        b=fQuWf3Y6OEmmCxztqvYvVMBaYQyJcSDGVDLLkCbNBKBYpBr6t/ocTvn3gu1Dw/80xL
         aNIUtMKHP9OS0NNP5UAeEv5KB9Z9pKQHjvwfj2JMRlESIzA7O7R95sIBf78zeLNajx56
         4YeAjmx6DW74Evm3K9Oam5639S1Bd5Zp2hHBG7QcbEOjnmPptYwuw6Uy5s3it7rVVTi4
         24zdsIRZRl1ykHBepvsLxveWEXkjfObqndR25earMP9Ddh+YEWXCd8lI6AHl3vdX6WP4
         sGp//M5bksswmtVE7x75KFtzxRXktzXaQ9GqJpkdsGfUZspAk7EJVkhT0IMBd0B/sOQJ
         HheQ==
X-Gm-Message-State: AOAM530trfP3vuIvhOzW0flEja6Yk9zfewc253VMiP2mUrxzSR8WVLRW
        1j/YPsPMgMa1QuGMGn28cKR/vQ==
X-Google-Smtp-Source: ABdhPJx8nmCytCMhi7OeQpFqjd8RKUyUG9or/MT2HM2HZF0iO/oyaMpw5VRKMPUFrjRM8cVoXHy38g==
X-Received: by 2002:a2e:9e95:0:b0:253:e17f:4037 with SMTP id f21-20020a2e9e95000000b00253e17f4037mr3884922ljk.523.1653205234708;
        Sun, 22 May 2022 00:40:34 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u17-20020a05651220d100b0047255d2119csm1353054lfr.203.2022.05.22.00.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 00:40:34 -0700 (PDT)
Message-ID: <d08f12b0-d3fa-07ed-ea29-27a70a78a545@linaro.org>
Date:   Sun, 22 May 2022 09:40:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/2] dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT
 binding
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org
References: <20220521200734.421223-1-a.fatoum@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220521200734.421223-1-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/2022 22:07, Ahmad Fatoum wrote:
> The BCM4349B1 chip is a single-chip Bluetooth 5.0 controller and
> Transceiver. It is contained in the CYW/BCM89359 WiFi+BT package.
> Extend the binding with its DT compatible.
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
