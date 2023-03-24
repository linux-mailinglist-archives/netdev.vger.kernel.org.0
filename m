Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562026C877C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjCXVaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjCXVaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:30:01 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC82199D7
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:30:00 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w25so2761441qtc.5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679693399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CvGeS3a8Ds/5xO6TadltHgK3hgM0JuMXbgz10+zDYI=;
        b=Cwhwg40Au5EcAepk8RhfmaxJt1uzgrxfX4o79olsT6mVGiLVZcjE9fn2x26OlqRdra
         1W0vKDPuaeGs4hJxQevaI62cXDoifU1haZUzN3lWRtUr2Y/ehuzLys1YhVomBYq3N7cD
         lk1PaaxQpOzQFHoqbBR3U8TtA6wit5Ux5JKwMOTy2LgoLp7fN2S7McrHu2w0gOqOOwpk
         DGM/2DKyXtJmzIHPk9e7uL8rGItI9j2zVJ253mClhg3jgXq+3car1hT9s95Yt+jjfgx0
         sb1m1lsDnMCzg4HBGtYP2ol8zaE0J+6ezLvKInik8KDHY1uiPBoLwUmWHA0N/7SSI6Wj
         uWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679693399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CvGeS3a8Ds/5xO6TadltHgK3hgM0JuMXbgz10+zDYI=;
        b=q/JQaM0EJa3obC8qsxxF2ufCRP/v0c2PkbV7ci2FQF01gX3hXS+/074G8jVhjjz3Sj
         HkbNdPsT4ihZxI9cUMi32Q9N3HB51IMvXk3r73SqLqbnIJC+cWYewdpTz4A5KXc5czbx
         bXr2VVGCYFu+lCctaa41NVBk+8cZ4653tnbraY/vYy0J31xhSI8ibGElUYb/qMgecK7k
         x0UREpPqJCVTUyGzMMJgs81DSiQn38QPKfiMvFghvubatxxsbbIBwP+gZfeYXkzcHjVg
         Yh3+Hb8RO7MJZ7Jsv33x1011geuBR4XsH/qKi9v0f6TAUBg6tRER2DrILWsU2jNZ2eCe
         DEwg==
X-Gm-Message-State: AO0yUKWWHn5acaLka9xzoiI+nquJhaoGcWbdqPZmPycl/2tNSvkR64h+
        /j5bqog5C2QLd9jARYpM0k8=
X-Google-Smtp-Source: AK7set8Ed2yFErik8jqWoE6wCgRnUyF3p54g7wlu8yzwVashiPbK7k0Jfmmb2pDL6wDcOIqIGmLoUA==
X-Received: by 2002:ac8:5704:0:b0:3e3:93ca:42c8 with SMTP id 4-20020ac85704000000b003e393ca42c8mr7897294qtw.67.1679693399749;
        Fri, 24 Mar 2023 14:29:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b14-20020a05620a270e00b0073b7f2a0bcbsm14823070qkp.36.2023.03.24.14.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 14:29:59 -0700 (PDT)
Message-ID: <aa596b41-4c88-e395-f9ab-143601ddccc7@gmail.com>
Date:   Fri, 24 Mar 2023 14:29:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] net: phy: bcm7xxx: use
 devm_clk_get_optional_enabled to simplify the code
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5603487f-3b80-b7ec-dbd2-609fa8020e58@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5603487f-3b80-b7ec-dbd2-609fa8020e58@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 14:23, Heiner Kallweit wrote:
> Use devm_clk_get_optional_enabled to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

