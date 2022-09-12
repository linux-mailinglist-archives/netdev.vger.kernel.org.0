Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DFF5B5FE1
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiILSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiILSHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:07:52 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597EA40E0D;
        Mon, 12 Sep 2022 11:07:46 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h21so6851321qta.3;
        Mon, 12 Sep 2022 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=lQtHmdymRkBmerXzn40vH/gbxlQTSF1+Xj0FQ10cpzI=;
        b=pShthJ/cr5irBOubNxXcPwaiRunxAF+tNPHCFo9+aBuUE2MdRqk8gJg83jqJGU4irt
         LBcMgNXPaIbPcti4hOe1rZXv7UoPzUHHiNpSAUfL1VX3XtEqlrk0VwnkuzU9ORkLQV3S
         t9LX/iGgbjHWZmQJaoy2UdNMgOVymohv4jpp5b+6F9ghJn2H8Nvf/Lhs08D6ffZ1HrGX
         tLsGqDEAank1i7TfYyvDG5geZMYt893ytTbpZF/hHyeCqJOl3+6fvOnv3Sole+OzZp/f
         xSlP1sDaLbzm2oR50sr6ZfZnFgy4OZJAFqGg5aVixhsCoLlQuFcUPxrEg0fSk96OOOxP
         dylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lQtHmdymRkBmerXzn40vH/gbxlQTSF1+Xj0FQ10cpzI=;
        b=TPXkZ9tL6X4KHDDG+d5GZ6IOaoEck8fDZd/cc64e22l/+721va8ALoZ2kl5yAbca13
         cqUqQCqmwyI3hxB4WPAuDfw+wcfNeKP+RD/TLKpqgT0eF4fguxqqqsUH2X5czvE/B+v1
         ztKne3SLK3rJ0w/hJjoQ2AqGj17BG8Y34aXK6Ndv8Ry4zZ66asrcQc9kn2pVvTtWOGPs
         b/fNkeg8lCbp9Qgm0k4lo+2Mho9Bwn+k0vNcYJFc6hV6Q30VqYJzhYFjg7oeX5VvB5UX
         /mfL2RF1Ldp+SWksxqinth54XOb1BRZBPv0s3+Px2zONCITF1R4/MF82P9eXbCgd5g7q
         Vv6A==
X-Gm-Message-State: ACgBeo2sznncrkiUlT2xi7KXWpbdyxsfSBn6dKX0V5/70od6RjltOTDa
        w8jwuP2vVpCHq5KYpwUzuxM=
X-Google-Smtp-Source: AA6agR53uiIhgcty3BD/2Ymi486R3A1bjk5LjIdQ159ktZPMsFAli5ZnpZpURisIP1zemMQqeBYjhw==
X-Received: by 2002:a05:622a:13ca:b0:35b:a248:c8c2 with SMTP id p10-20020a05622a13ca00b0035ba248c8c2mr14068787qtk.407.1663006065587;
        Mon, 12 Sep 2022 11:07:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f8-20020a05620a408800b006bc192d277csm8575137qko.10.2022.09.12.11.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:07:45 -0700 (PDT)
Message-ID: <cb4e3c49-1216-2b61-3766-9507e523973e@gmail.com>
Date:   Mon, 12 Sep 2022 11:07:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: dsa: mt7530: stop
 requiring phy-mode on CPU ports
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220912175058.280386-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 10:50, Vladimir Oltean wrote:
> The common dsa-port.yaml does this (and more) since commit 2ec2fb8331af
> ("dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
> ports").
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
