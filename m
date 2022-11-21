Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C67F632E01
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiKUUeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKUUeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:34:08 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FAA73BA7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:34:07 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 140so12391471pfz.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EjyTrelXKksUexO5tNJu8pab9wcxght+cLhEoxIhtIA=;
        b=CkN+p+bicweiNLseE2uQHhuIPl2a9Iza/W3DD0z/JidIbolUmnWRpisUBgDNis9WLC
         05wevCZl2xtM8J1GtcAWuj15C1Lchj1m9fRbKJC1ZjAOROCKl1/J5iR8+XVzMxBznBYt
         anYROTjynPBz0W8hsb7fN6t5TKqz2h3s2sZ8YJ+kTLxiTU1tWtY+aM/Gay1+P6rfWRQd
         NsxkL9e4PPeoH5jzcL/uzUvhAFzUTJtH+/WwcQAqa5Eps1nusGUrIoRWiSMVeVzlFGyG
         EVqTyJO8ABDcSQ8jR8ji1u+aImUpoxVwfmA3PHMKVLo1Ej+hK8pqfQSg+cyOAUPTfxZz
         rg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EjyTrelXKksUexO5tNJu8pab9wcxght+cLhEoxIhtIA=;
        b=OmX9lp3C50Q2HZr4iNqiGQWhSj7hWKMMbo1GtBz2O4cEz/C9L1nkwwMiZR/2x1UKKx
         Cr/KcuoX23d2J+KHbPtUVG1HuUt1HPDNNWzK3WbWMO709YHhV4nBq+Io+HoeWolOi9U5
         hSv5xxIomnjWxKcSzRSvf6O694NE1JICRJIho1Lx3D3gFdF0sgVkgs8u6FXLgGxMMZGh
         ivNqEP/9nnq3easmWCpkb7e0dwd5xANS8k5wIrr2xuivVr6kb0YNInybzCwH5UagOB7t
         /z+r/D9O7WqUZW4+/ln6fGp8pmzZMz2kOpcN/4By/y2YA/XRKuyNR2NALryHNgyjwwIr
         Md7A==
X-Gm-Message-State: ANoB5pmISVHla3lpKPZyWBHU3Qi8+7cXousVMZZB2px03x8BAGvbPGpr
        H7NkYKo4IGdSyz8wltkC9P0=
X-Google-Smtp-Source: AA0mqf5sTiWyvjFebiddjyNTCYfnBEaO7SZUBJrImkQHmZdgtrAOPejcnWBTEoLhAtSoMnxkeAKJMw==
X-Received: by 2002:a63:5762:0:b0:45f:97e8:d8a7 with SMTP id h34-20020a635762000000b0045f97e8d8a7mr19174071pgm.426.1669062847015;
        Mon, 21 Nov 2022 12:34:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c16-20020a170902d49000b0018699e6afd8sm10230819plg.265.2022.11.21.12.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:34:06 -0800 (PST)
Message-ID: <77e463f7-4167-0ee8-3c77-0cc8f52ef91b@gmail.com>
Date:   Mon, 21 Nov 2022 12:34:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 10/17] net: dsa: move headers exported by
 switch.c to switch.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-11-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> Reduce code bloat in dsa_priv.h by moving the prototypes exported by
> switch.h into their own header file.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

