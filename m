Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5F54B5CD
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiFNQSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiFNQS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:18:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551051BEA3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:18:23 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o6so8166813plg.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hxn5WlI4UqTuRgC6sLunwEvnYgHvVkEBNB8Y/V7uKlQ=;
        b=GVLB4NdosSS9+VUeTZEud3zfDtuqsPPX/ullVwnkFIKmtzc46asl6gCr2S9S41GqIC
         K5G5IUEAjyICJN2lBf0tLx5MVsP3n7CGD9BYSh/rmly3HPjmNPElbIXFhl+Gz2y5YlKX
         /byyBjXAKNqi0WpSQkD/4J3xL8UzkAiox7av5OdeLVnP6QOUoj/6WQ2trsV2ev6wUP5L
         KbhYXGu+wqdr02sYvjq/7iimdV7SD9YpVO9QK9iCpMG1WTSiSlyotzzTiSWaZuuLMCO6
         lyvmvjl4d+/6UQtv/TvGWV+mVrpCzuvmiFyRqtbdTM9rhVWnevJuJAGXA+glXdjlopK/
         mX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hxn5WlI4UqTuRgC6sLunwEvnYgHvVkEBNB8Y/V7uKlQ=;
        b=4GKJuQeNYGY0+IOe9y0X2WFUKqMADVwwAQkEPIZR/pmTCMHKWyNGPk9GcHazpJF828
         uoSdad3bc7dPozeUwbxGkgzwLo9bW1yMbXrXbjpyEiLctTKQICDi8Uk/e2mqoZwxGYC4
         FEZPh7Pom3s7/8PABS0ZtsFf0fF1L86TrkC86ikI8o59FovpmSY6cgnAxgAWIHdefjfi
         Ic/bNWgkB1BWOnll8U0c19Z/kIFTJ5r/L7SsdGwIifOyOZzJ+AOQhjvEIDaaZ2OsOlIT
         p2PfhwRnbI2TibaGLbL5cGaM11JqsX/Fo9MV3EDPtmuSzY4zeADDyMjBMQWZlj35uESI
         NbKw==
X-Gm-Message-State: AJIora8uq4CkpYLWNW2JQkDb4xQszOWDo11p031gKe5ZtBhhK71CczDb
        6swsqwvQuJMfc9hJXzskrPE=
X-Google-Smtp-Source: AGRyM1ur3WBN/zucRiMrWVafUwd559gNdxmjGAhAcGnFqeLIhPtgRrmUeRGjiTXoQePDle33eVnewA==
X-Received: by 2002:a17:902:f314:b0:165:ddfc:5d84 with SMTP id c20-20020a170902f31400b00165ddfc5d84mr5296746ple.171.1655223502816;
        Tue, 14 Jun 2022 09:18:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v10-20020a170902b7ca00b0016363b15acasm7428898plz.112.2022.06.14.09.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:18:22 -0700 (PDT)
Message-ID: <93346bd8-1e34-0b61-b158-e2e4a4266d18@gmail.com>
Date:   Tue, 14 Jun 2022 09:18:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v7 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-team@fb.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
References: <20220614050810.54425-1-jonathan.lemon@gmail.com>
 <20220614050810.54425-3-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614050810.54425-3-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 22:08, Jonathan Lemon wrote:
> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> tested on that hardware.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
