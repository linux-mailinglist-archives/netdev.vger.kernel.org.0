Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED226742C8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjAST0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjAST0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:26:17 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0BD966F2;
        Thu, 19 Jan 2023 11:26:16 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id 187so3261951vsv.10;
        Thu, 19 Jan 2023 11:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=31+1HnBidgAci8B3LJ+m4Np7ElNOJOKvMA21iUDPQvk=;
        b=E6AdBjQa5zkq66qIx3XRbjsPhP0Kg+IacP/L2/lBeA/lsQnlQ5bZyrkZOisfI4XIIm
         qqG/0DjfMVflpDwqUqt1leL19Kia7GMkGvZ7hdzxR1QwBUnEBe2ZPO+Aib5rRWDRzNMr
         zyOq5OLHkEIIx+AFYc5UlKOCJmVXQwKByz8vdHx0CpYAQlAg2zIl3kwZD7h4EGm0cPKN
         Z4xk5nNFc81mEVeoj45lAqnkpfsscoGw0N09aCZY6bGifB2xrr+EHsYtiRVhbqc1NoXz
         atF54azjXEEopBtnFzvctOQPo180UIs10q6jom882mt5bn+mXXetA0aD7rGqRnUfeAym
         y7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31+1HnBidgAci8B3LJ+m4Np7ElNOJOKvMA21iUDPQvk=;
        b=Agn1rV7Nv8mM+PKnkIGN6OoLLtPkA7r7HlWjz3NcIQmYAxekTZFUm9L3m415nKnpMN
         BTGQKdqYSIDgfPs0RL2rxTbMC9foVdeOBbIz3ONtv8ztMbDE+m6uFv5JTLoYP0OTQMNt
         CX9oqLyj2ZyBZ/rk3eYKZll0VT9H0KueBAa45bTSqPIPug9dnWYf+w+X7XaXuNbDEkWY
         tU4juygw4X0UZKQ2dIpvrTOfbNNdrVc/wmwj5aLrquY2f2WOBD3dolT+6aVHUa+a9lbC
         8xcnNQSghFptVITKdEXff4n00hvsYZYGe84WG/C3xyD7ASK03vFwAEjkEAhfnVcjR+B0
         bx1A==
X-Gm-Message-State: AFqh2krst1ocHhDX1Bbn0QISjuEWLVVXzk2QWJLZYQJI81Z2nty/oaTJ
        kDe9SlDQkiyJTizHuy+wfFxnJkDpEwo=
X-Google-Smtp-Source: AMrXdXvLIsMfMqerDx7v4tabcY95A58JYXXfHfGS9OEGCV+yi0xYVGYFzAvW9JAl/EMRhOgpCoVECw==
X-Received: by 2002:a67:ef1c:0:b0:3d3:c7d1:171e with SMTP id j28-20020a67ef1c000000b003d3c7d1171emr8564701vsr.28.1674156375426;
        Thu, 19 Jan 2023 11:26:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o5-20020a05620a2a0500b006f9e103260dsm25128142qkp.91.2023.01.19.11.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 11:26:14 -0800 (PST)
Message-ID: <6a02c93f-e854-bb8e-2172-2c2537f9d800@gmail.com>
Date:   Thu, 19 Jan 2023 11:25:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230119131821.3832456-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 05:18, Oleksij Rempel wrote:
> KSZ9477 variants of PHYs are not completely compatible with generic
> phy_ethtool_get/set_eee() handlers. For example MDIO_PCS_EEE_ABLE acts
> like a mirror of MDIO_AN_EEE_ADV register. If MDIO_AN_EEE_ADV set to 0,
> MDIO_PCS_EEE_ABLE will be 0 too. It means, if we do
> "ethtool --set-eee lan2 eee off", we won't be able to enable it again.
> 
> With this patch, instead of reading MDIO_PCS_EEE_ABLE register, the
> driver will provide proper abilities.

We have hooks in place already for PHY drivers with the form of the 
read_mmd and write_mmd callbacks, did this somehow not work for you?

Below is an example:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb

(here the register location is non-standard but the bit definitions 
within that register are following the standard).
-- 
Florian

