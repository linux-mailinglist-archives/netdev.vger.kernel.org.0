Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8F63B2F2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiK1UXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiK1UXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:23:18 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A51CB37;
        Mon, 28 Nov 2022 12:23:12 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 82so3501982pgc.0;
        Mon, 28 Nov 2022 12:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=My8u4kRmGK+Yn8/6QhVO+EnqDs3urMiLBxUcHmmyiGk=;
        b=UcFlC9OhsKqP3QUePtkbMS7mo/ibRjDzrbPHmpCZ8njlXrOFkM2hBoVx05wMHJqoq0
         rMls6J6TkFWss4JvG614aHONu5Z5C/3ZqZZ4ylzMnbYmPkh+L0c9pp8FjcewgBY+qiAq
         YPHdtSYtlZUAyWvCNkd/B1tBANSJrTuHuQbT0jKDaEeJStOXyBrGNyl7L63Zxv0Ix0YU
         8HlAQI9uyd5hFst8Hpv3xxaOcq4Bq0hVXW+0AMB37o4IFQIvwEorhLQNE6C0g5REhGRV
         PuCBHD5y2JqM156Lklpq5p8zM58NJsaihK5z10jRDNVcC/8rWTfiMx5NleoBG8/1Icei
         W6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=My8u4kRmGK+Yn8/6QhVO+EnqDs3urMiLBxUcHmmyiGk=;
        b=mk5BBEho/dXcKJR6h5WLogYoweVXdbMiNNfnm+vGAJ4bUqiJ1p03Qe9V0b9aGw2juf
         WpvVaONGxdYJSpjMNqPa3eDvd+ywAJHl4R9FFdGJfQZcrXCDu1Gm+zwsLjkkm2AiZQ1G
         bKPPrRmlDATFGnCqj5Silw+2iT3YaMZj3TwY69jTuZ1CObDo8J2I2JHo2b17vTfj619X
         pkfFoVsADZpdA3w1IqPK3Hi3jMJv0TU4uXp9t/mMEHuRZ/r7TfBCoz1YsFYF7etQrt2c
         1IHc+nHA+0AUobXwbP52/daUPCtRtPQdxHk18MD+6QVKGgStcyxt7AhljOju937E+hdK
         2n6w==
X-Gm-Message-State: ANoB5plw6qKIrODmaypSL/qxFMnLFcpnVKRWL1f7i5vCjWXuW9mEs9XC
        /e7RO4jqzi0Fr2DKV8a4CSA=
X-Google-Smtp-Source: AA0mqf4oImiJC3pygvUY6NUG2A7aDmbpiDXe7PORw+aNCo2Foi05c3TORWEg7Yh4zqDkFEQEZkJB6Q==
X-Received: by 2002:a05:6a00:1bcb:b0:574:ba25:1e43 with SMTP id o11-20020a056a001bcb00b00574ba251e43mr18146677pfw.63.1669666991536;
        Mon, 28 Nov 2022 12:23:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u4-20020a63ef04000000b00476b165ff8bsm7189694pgh.57.2022.11.28.12.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:23:10 -0800 (PST)
Message-ID: <3249e731-e7bd-e9f5-1c76-3ac41def3565@gmail.com>
Date:   Mon, 28 Nov 2022 12:23:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 01/10] dt-bindings: net: dsa: sf2: fix
 brcm,use-bcm-hdr documentation
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-2-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/22 14:47, Colin Foster wrote:
> The property use-bcm-hdr was documented as an entry under the ports node
> for the bcm_sf2 DSA switch. This property is actually evaluated for each
> port. Correct the documentation to match the actual behavior and properly
> reference dsa-port.yaml for additional properties of the node.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

