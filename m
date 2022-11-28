Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1D63B3A1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiK1Ura (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiK1Ur3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:47:29 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC32ED62;
        Mon, 28 Nov 2022 12:47:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso15289032pjt.0;
        Mon, 28 Nov 2022 12:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+a308E9n0+BsJ+GD+yH9OTTarCe7rpTnFkBE4bloDA4=;
        b=KiOS99RBN/UCbLYsrhj0wGDMNNpqML3eSh3NkVw79KVu/q2xbFsucge1Fx8Vajm+p0
         c+2z4unDH7Z4To9kAqmpgp2UA0PfpjjCnKNmCvpdScnjACHKayTBbRrFVgkwb4FxBZF7
         0z7AwARUOAvjkl3FApNj1r+Sk0+FVTkVcxsgG3/Z1/1f+n8xRXc21D3ONcYzfo+YAhS7
         4WUrruMY+5sLtfKwwDLJq6BthKWl6iRCYJIJCAcZi1koLvwqoqArp5aDX3GGFFwZtbRM
         PWUfXplz1KHNY6q3Wi1sxKyiXzEF17s8ok52iwmUQvGKwrdoJ04xxScEihmBbTEIeXh9
         7i+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+a308E9n0+BsJ+GD+yH9OTTarCe7rpTnFkBE4bloDA4=;
        b=0l4Bj+4RuboHzVPBHotyUyUSWcOxj+xXaenrK4jC+8oLfCg4kVs8oeyaGZTAGaSBIW
         qQIokawZyGv20W6/QUmlIIf21fHlK4ADaM+lsQ8mkyXruHd3GVAPSn/Y/z26J4lBzLb8
         P4tgxLF6uYmnZ1SeEJ1SsXIv3vLcwchgnYLBjyfY2s8RkUHTM5lxyr/XMeFZEKKMfEP+
         mXJgT1CK2LolfiRtcoTTr6cBVaNmHwesZArleFpZsJ25sKUq0juZkwLETOtL1U/BtDIp
         H23oLKwDx9YgAuwezXApNKCZ+FidfbLwucOcUlM4mAKWWVi8sYGwcx0NESA2TlevHKTC
         qTEg==
X-Gm-Message-State: ANoB5pnc3EM+KJf4gCo5vdVPOlnjU4p3Xc4GczlNtFn1iCN9C17FlZUL
        RTo2sl9SE3qUSAqydiO/RKY=
X-Google-Smtp-Source: AA0mqf5KR5J4KA6OryCqEhwhS5fiBTncCvtZXnlE1zasZUm34SA+YWcLNxdEIn+euwoZ//iuHt8gJA==
X-Received: by 2002:a17:90a:de93:b0:219:4139:7589 with SMTP id n19-20020a17090ade9300b0021941397589mr4432484pjv.188.1669668447924;
        Mon, 28 Nov 2022 12:47:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s6-20020a170902ea0600b0017f36638010sm9184618plg.276.2022.11.28.12.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:47:27 -0800 (PST)
Message-ID: <515a94f2-95b3-3c00-58d7-488deb16b64b@gmail.com>
Date:   Mon, 28 Nov 2022 12:47:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 09/10] dt-bindings: net: add generic
 ethernet-switch-port binding
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
        George McCollister <george.mccollister@gmail.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-10-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-10-colin.foster@in-advantage.com>
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
> The dsa-port.yaml binding had several references that can be common to all
> ethernet ports, not just dsa-specific ones. Break out the generic bindings
> to ethernet-switch-port.yaml they can be used by non-dsa drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

