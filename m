Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0131F5638EC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 20:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGAR6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiGAR6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:58:50 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7F73C738
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 10:58:49 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id ck6so966735qtb.7
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zgZDYtTSlKVziWyU0L1sluwcOOiPVoWeZ5xijMqHLIg=;
        b=T/xV/JBjO4EC10Gxys1rsN78KhGrs5w/utMbVChWtYQpz8bwNWU7oVkQCq7ZdUP12q
         e9xk1bbbDkop/l8rfcnZQPuwQONUfeDfypAF12rXQV+DxUSCKZzHET254jrJy7qax2Tl
         lSkVnvYOHtgD+MO7v4YYv9GT1c2c8ibjiDYbje0uDFGVjrePJp7z0ZEpWvTdHSTG2GZc
         cDDJfOH0OgeWoOcEOirlad54cIxX4NpbG+V0zXVUxnYoiip/9XVoZd9Nkp1xskZYUT1r
         6bmMkwH4uVNCnnZvsoyTdAubOTwCFIjXq7RIxBIhq3uz8kECi/mdIVz1Ayxa9yoM8sRD
         0GTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zgZDYtTSlKVziWyU0L1sluwcOOiPVoWeZ5xijMqHLIg=;
        b=mn/J4CLpZlRPN8Mv/esRB864WmnBuJnTJ7b2u33OeR15/c2pbcX14QhI0p23lw67xK
         Bqa0aS/kPwMfrhHDapSWlAkkm/Wuczi1Bx+RyacLm5ren/WT1YQOfgEig1Mv6dw7n+m1
         j70cGnqDJ5jI/E7wBAlUbKavV3VnvjR8sTSTn8O4c76TyBsMuSn/YGsyODqYoq8cDtKt
         rcS8Rby/K44c2dk9X+uk98PO3QkMPWAMvgd/KF6Y9uILR+Eo9g636UpyXLH3lQOyZuqW
         g4qD9QWxelamumagkBotBMnRcoxrMl99w6TKV4FxTqcbbq4PQ+0BHjCNpX+I47QA2S8Y
         KHQQ==
X-Gm-Message-State: AJIora9SHjCFVUr0SCnAfdUm5LoXQuyor6kdIN48/roNZ2FFigvtpUdB
        BJjTRUMcSHLPbM6A5qPZELw=
X-Google-Smtp-Source: AGRyM1tELC+8nIthpa0BTE0FX1J81omOyTu3wAA8tsuj+qIfzJ6jtiF7syJBG1GKkDdIpWSUPAv0Fg==
X-Received: by 2002:ac8:774c:0:b0:31d:2a36:29e1 with SMTP id g12-20020ac8774c000000b0031d2a3629e1mr10365680qtu.501.1656698328522;
        Fri, 01 Jul 2022 10:58:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f10-20020a05620a280a00b006a69d7f390csm18399302qkp.103.2022.07.01.10.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 10:58:48 -0700 (PDT)
Message-ID: <2cf86f79-0318-3a30-1ca4-67c683389eff@gmail.com>
Date:   Fri, 1 Jul 2022 10:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] net: phy: broadcom: Add support for BCM53128
 internal PHYs
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220701175606.22586-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220701175606.22586-1-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 10:56, Kurt Kanzenbach wrote:
> Add support for BCM53128 internal PHYs. These support interrupts as well as
> statistics. Therefore, enable the Broadcom PHY driver for them.
> 
> Tested on BCM53128 switch using the mainline b53 DSA driver.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
