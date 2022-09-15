Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0B5BA1BB
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiIOUHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIOUHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:07:24 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E149C3F312
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:07:21 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id o7so10534937qkj.10
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=5jwloPh4Sqk0YjhoCLgoPodRjI5VIwaALppMtDD8Piw=;
        b=hoadBzKaHKwZG33hSh3y0V3oYUAKBN9LgV9PEDC6PMsjyFqBNqkocnV8Y9MCAN5Ski
         Su0Itxgs4brWyBJiU4zVFGQTMMFCH1uy8zr9dzGeLhCIK1/Ugi30ytnMe85jLfGTlysl
         4Yt2uiP90p3bYowY9vIA3AHBL7WyT22VkPEGe99n3GDzBQRDmwoi5GqPiUiOLY+9WgD4
         wvBo6hDD11TS0ymEqHwU1WnVNRvYjgC/hJhnvB+mk+Q0a8HEPWM4csyNrzfTynhol1x4
         TJ9OGgzNKB8XgwD2fRICpvUalBnM2t1OvfzFZoWen8jRppQoZQioAMGV2zPY/hUEnicT
         BcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5jwloPh4Sqk0YjhoCLgoPodRjI5VIwaALppMtDD8Piw=;
        b=rLul99tPGX3DAutyOMK5YeDIdPk+bhG9Er6MWfc/+hDKkIN0hK5oGMzaci6NXjmj99
         S+H4JrUVi8g1EcvJDmLmEi4Tv0WL0NSSr/zkYqq+Ze7mIlCzPQb7KEzax1LhaQ1JD+5K
         rSqqoOG3jjVc/WEFMjXMCYONJ37wB5VolWfsr1PNQrhKcYDNTyoAhsyvotvXmj7fF15x
         PnqED/fzGztEk+LIwdpb0ndr/Jy2XszxwqcZmG8MvAc4LAJNgyJtLPMfhG+KBIo3q2vK
         V+FDh7W4OF0LXAOsVrvjRe35eJoHYv6V6/o7/lTyAb6eNB243eK9j47kLFeXzhfOgVks
         rSuw==
X-Gm-Message-State: ACrzQf2BBUFpyuJVRDbAUm/Q+Ij0klCwn5AbtKPoVvNo//dAeebT4GQS
        KzOUgT6+jkuN9nuJ4UNgrdY=
X-Google-Smtp-Source: AMsMyM6ceZhvO/b1JL/s5HBuhnyKO8kivloFPjU3htpjifM+NcfJqcrMJPxaHpbrM9aWSqsMpMZcTA==
X-Received: by 2002:a37:ad0a:0:b0:6ce:1769:6f51 with SMTP id f10-20020a37ad0a000000b006ce17696f51mr1499329qkm.522.1663272441006;
        Thu, 15 Sep 2022 13:07:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o22-20020a05620a2a1600b006b9bf03d9c6sm5100850qkp.104.2022.09.15.13.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 13:07:20 -0700 (PDT)
Message-ID: <b81fd068-ffe2-f26d-3360-2c083d88b16a@gmail.com>
Date:   Thu, 15 Sep 2022 13:07:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v12 6/6] net: dsa: qca8k: Use new convenience
 functions
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-7-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220915143658.3377139-7-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 07:36, Mattias Forsblad wrote:
> Use the new common convenience functions for sending and
> waiting for frames.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
