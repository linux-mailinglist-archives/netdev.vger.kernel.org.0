Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504CB5B5FB5
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiILR7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiILR7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:59:35 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0F5261F;
        Mon, 12 Sep 2022 10:59:33 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id i15so7331288qvp.5;
        Mon, 12 Sep 2022 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=CHO9Oub3AWfaHbTOpsrzZ/pzJ9xYr1AJ+giPFPn+MDc=;
        b=J9B8zEU7+ett8TMV8ZXNPGPVLYXOcNXPmnAnX41l/9CGeTLHcl6JtxRpGeROo9oRcw
         KMuev5+nvz1u8Eq5sQPseBMb/axiCNXJRXXpW8LEOYLh86K2md0Xkkw5P0X+oAVHbWoV
         Opu4MXvr3sQfznIj9ZaTp2j989/+s26ryhgiKCnXcRukG2BQEr7eyeP4wTKD1FJLhLaA
         hthhKBc1VD/1soBjEvcNVS7JuWz84iODX6BWJQgCeAI43APmmiHdjiUzxfGc72Ip7PRB
         NgWoa6orDQYkjwmPOA3q+hrsTm1sVveha2n3o4IKJHwuxXmv1d5XRe3D+MWFo1h8yjLm
         2P/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CHO9Oub3AWfaHbTOpsrzZ/pzJ9xYr1AJ+giPFPn+MDc=;
        b=PezQyhbOf0Lu65wOYTzP55RmxD2swV021XUxQbuYHdOlCNeFltRqQounNVynHDklI2
         QxdcKb1xrS3S/QDdGA5eZnTZE99IIIbzI+aSsgJ8ABomdWHpLezxeLZYsQ4Gy+4RV4ja
         azUolHJ6tpHX31xISSMPr4aCnUkudzs90EKw3zOIXpLFZI1rkBZhTjH98sxyjm/Tfxz0
         4Ivj2TbfwA4eQ2L6xMRgC2Xz7MHyHDfW/gz5lnmFf3sJJ0N4f+1HnQCVYQxKsO5cjjYP
         Ikb+q9TVAr/OrhJDzHIcTxoH/291Nn2VxnMtE6FGY6fjnJyUL1CIIy9yqHRdk4DE2r3d
         dOyA==
X-Gm-Message-State: ACgBeo3PBL6D7CTwMYHvfAkiAKAETkWIRbOPVR0+5yhacOIv1dOulcQ+
        q+9ed/r8dNKGTPuDuWsha1u2Y5zCbMk=
X-Google-Smtp-Source: AA6agR4Z11EbeI0t6KZTwNsIwAisWHJpNPfYOW2De1jkWsiY73doZY5h2vh1cU7a2aVkj/2Q0FIBTg==
X-Received: by 2002:ad4:5941:0:b0:47b:5b81:e329 with SMTP id eo1-20020ad45941000000b0047b5b81e329mr23750234qvb.24.1663005572129;
        Mon, 12 Sep 2022 10:59:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d24-20020ac84e38000000b003445b83de67sm6909654qtw.3.2022.09.12.10.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 10:59:31 -0700 (PDT)
Message-ID: <d406b917-9d01-0f97-8d29-24008f27d379@gmail.com>
Date:   Mon, 12 Sep 2022 10:59:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace label
 = "cpu" with proper checks
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
 <20220912175058.280386-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220912175058.280386-2-vladimir.oltean@nxp.com>
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
> The fact that some DSA device trees use 'label = "cpu"' for the CPU port
> is nothing but blind cargo cult copying. The 'label' property was never
> part of the DSA DT bindings for anything except the user ports, where it
> provided a hint as to what name the created netdevs should use.
> 
> DSA does use the "cpu" port label to identify a CPU port in dsa_port_parse(),
> but this is only for non-OF code paths (platform data).
> 
> The proper way to identify a CPU port is to look at whether the
> 'ethernet' phandle is present.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
