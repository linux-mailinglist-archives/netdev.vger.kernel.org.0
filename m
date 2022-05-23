Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2553168F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiEWSep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241274AbiEWSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:34:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFA81EAF2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:11:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ds11so14784524pjb.0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GwxaWwPPP9fHqCIAGpem4vr4xRJf1NoaEQBEH+8qTQY=;
        b=TcLS/IkEMguzwPBytxW5jNqn1jgNqZ7y1nOXyPSoTkAs8783h0jrydg1nZvIUAQc0g
         D7MqVuZh9x42AFq50NUtbuunqYcTi4/RDNlHWIdVvDxtA+tPb910koWiHYP2MHc5RE2d
         mUWmTAw+LaTtSUZ2gSP/rTNp7bD7MeUVpBRnD0+Jk7Lxve5HLjAHcqRSeI76BRB3S9SX
         i934br4zgMOmF0MjrkOk+TpWt5b8igS65B4ZrwoP/t7WZrCb6sB+osv1/F46HlU8d9bh
         bsLJC5Lum4FK4/SXGyaJBJtSPvIUHabGdVRgXbRfGMGFrDK4uHzmvV1nZJskRiuuBk5p
         5U9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GwxaWwPPP9fHqCIAGpem4vr4xRJf1NoaEQBEH+8qTQY=;
        b=y8vbuxTx8vpw5sRHZXlbuSua9GhvB85NUgjNo/LxBOZUg7mK1MJlHFubx0OE3klqKn
         JnHf9N4kajaI2AGFcmezz1RakuMAKqUXX3Zc83304qFeJJJbq4AEGGm9e27ngPSyPWtc
         /YeWndpsLiI7o0h8g+bPWIaRNsg7xy2H7krNiXk9VQLdvuOosbnJxi+pDr0bf+M+hx18
         q0xcupwYRDSodj8eB5oCYMjhpnE2owB1jA5atSBJklClTvJz+90LyIuEEIAyHbughBtQ
         LJHWvr1OvDP21qN3BVBybmyGyeHfVEl63MAMOzwwxinInGaI+E9+o/03xevKjpeHfKaI
         A/Bw==
X-Gm-Message-State: AOAM531Dc63/t7Tc0qg1bd0uVgMalPix0BWdiYvSrD6khTVOhsdxI7dm
        PDkqoNs8fiNodDsXjYDTN5I=
X-Google-Smtp-Source: ABdhPJwQUH178HnM0psHWJjnDJGeQ58wDDxIUq8mbdZP0ppX9RP8WbUWRf3eIFjr4gNEUcbvatz6Iw==
X-Received: by 2002:a17:90a:69a7:b0:1e0:50ef:3ff2 with SMTP id s36-20020a17090a69a700b001e050ef3ff2mr264510pjj.104.1653329464555;
        Mon, 23 May 2022 11:11:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y16-20020a62b510000000b0051843980605sm7501164pfe.181.2022.05.23.11.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:11:03 -0700 (PDT)
Message-ID: <76977b89-23d8-be5e-dd74-1cefd8af3188@gmail.com>
Date:   Mon, 23 May 2022 11:11:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 02/12] net: dsa: walk through all changeupper
 notifier functions
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-3-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Traditionally, DSA has had a single netdev notifier handling function
> for each device type.
> 
> For the sake of code cleanliness, we would like to introduce more
> handling functions which do one thing, but the conditions for entering
> these functions start to overlap. Example: a handling function which
> tracks whether any bridges contain both DSA and non-DSA interfaces.
> Either this is placed before dsa_slave_changeupper(), case in which it
> will prevent that function from executing, or we place it after
> dsa_slave_changeupper(), case in which we will prevent it from
> executing. The other alternative is to ignore errors from the new
> handling function (not ideal).
> 
> To support this usage, we need to change the pattern. In the new model,
> we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
> if there is nothing to do. This allows the sub-functions to be
> relatively free-form and independent from each other.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
