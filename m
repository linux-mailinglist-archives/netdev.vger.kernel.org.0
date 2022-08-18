Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67CC597F2C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiHRHXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243538AbiHRHXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:23:15 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2815FB2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:23:12 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso2121176wmh.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=uvXm0RZumj0mZgTh7JDm1cAJdvIkjg/M0gZNRFsBcbE=;
        b=WctPc8ihRxgLEWgb8uuHyWvfBh9syJKPte5nZSCDHMMvQjY4s0tCWphV0veBT2KQDI
         r6bJVpXK3Gr3Swbbn7Q125sT7V7X/nFvF0RiX9S+mADB59V13sdKcruTgbCP7f3KXEdn
         kboE0EwDAX1uEHWrdor2e15L6NbvYQiI1SG4Uhf2hxblkKyaux+ovasAZdNLe41L4zpr
         mUGApu6cMNMCW1jdtodNm1VZohGK1BaaeWoWMeOWs98rBKlYHFnJ9MjfI3UDK5vaZ56n
         O/n/+HoUlA6GWeqsZzBvBfo4fuQ6K+fE6/3Mo5zSkgLFlP8fY0ZbTpg6AHCFthZPQkCE
         P7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uvXm0RZumj0mZgTh7JDm1cAJdvIkjg/M0gZNRFsBcbE=;
        b=OiOWGzPwPfnqn9mV0oFUJ7pigVgTOcNkPCh+5WqLNrOOAwuPAn0u6LO9mLP3hxK81d
         9gDUN+xt9QA6QZjeqKMyZeQU0vTw5SNuGOOfPWcoJOawMUi2zNZ9taWpR7IE1DHkKW2n
         JEEi3BMCTupfJk86IZTNaFpQ4BmuUXkEAvR0cfJPWkSOokaNT++SNjGMMzUw0qmOdS0g
         c68fcfq1h3OvNu3nCrLYBNBfAr8XegMYBWTWCG4H7L7Q9WSbZXtFgv6AAPygnMDI5UVm
         95ge/ull5KLBkFfirH+13O+htlMlXxzIRPu4tGrd1TTt+pRK0bINksSgmbTuhJbU3O1W
         pjCA==
X-Gm-Message-State: ACgBeo3OBvW0kyG882szm7kIJ0XIJ/q0KbFjnqJplH8y57mR8GWgkc9g
        +lOjG7PtxHLPSmqPd3/4JRem4w==
X-Google-Smtp-Source: AA6agR6nObt5E7+iDPx/bOg98ioOd1CfUD4q5gu+vTlcSGOcSpqZzeCm7LadDRmozdqUZ0oNlPTFlw==
X-Received: by 2002:a7b:c5c5:0:b0:3a5:3e42:fa18 with SMTP id n5-20020a7bc5c5000000b003a53e42fa18mr943938wmk.178.1660807390890;
        Thu, 18 Aug 2022 00:23:10 -0700 (PDT)
Received: from [192.168.42.79] ([37.171.155.54])
        by smtp.googlemail.com with ESMTPSA id r14-20020a056000014e00b00223678fe95asm732216wrx.18.2022.08.18.00.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 00:23:10 -0700 (PDT)
Message-ID: <5008ef00-6e64-ca89-7ff0-0bcf85bd4b54@linaro.org>
Date:   Thu, 18 Aug 2022 09:23:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@nvidia.com>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, pabeni@redhat.com
References: <20220817153040.2464245-1-daniel.lezcano@linaro.org>
 <Yv0TIH0LsjFJwV0L@shredder> <20220817112110.6ad4c3ef@kernel.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20220817112110.6ad4c3ef@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2022 20:21, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 19:11:12 +0300 Ido Schimmel wrote:
>> Jakub, Daniel wants to route this patch via his tree. Do you mind?
>> I spoke with Vadim earlier this week and we do not expect changes to
>> this file during the current cycle.
> 
> I don't understand why this couldn't have gotten in during the merge
> window for 6.0, avoiding the risk of conflicts. But yeah, you said
> conflicts are unlikely here anyway, so no objections:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
