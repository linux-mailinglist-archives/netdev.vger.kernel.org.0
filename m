Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75E865C97F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjACWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbjACWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:20:06 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2403164B5;
        Tue,  3 Jan 2023 14:19:47 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id j16so25737237qtv.4;
        Tue, 03 Jan 2023 14:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vlsqXR9Z8ZTnyT8kW7sPZRNV6TNSbNbBGDYLhcwR+Qk=;
        b=dmdkMDc/YHWm0TNz0eIBJ/XGILOClmyM/tKG7ExtcmNQVXs/fIKkIPoNN5GAj+kfHM
         amZwwRfkXdlsCIe4MPIDUmxAgI79d4WRp1CfFsubKd+Xglfwgh0S8uWHwXVjyxaPwon6
         1H431Uw0nZWzBFhryBLFsWWmNtxz65F3TuT3sB3d03FlNLXaPspLhHX6gGwRIPhuPM7x
         iu4OWcuzeybA/bwM+UuVl3chiPPK4x76zRQm/7udJiJnjUhMeU7w3WQ4ukT7/nVPj4NJ
         PcxhPF8amBlnTFHlbeeJgHZ4TRzQM7hshDcGyf7N1fZhoOaNAlUHlfTPdYKYKG7FISsE
         eP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlsqXR9Z8ZTnyT8kW7sPZRNV6TNSbNbBGDYLhcwR+Qk=;
        b=t1cgF+Ne8qrJqmNxGqsQtkmFkXATmrDtXRXBLOo3ru82pI5E6PhdVDI8PTE0M4nGoi
         1JordJ7S2YTbKowcAtZYWpfsHHmsstdak0hli4CfSu7A+0d1pHj2PfzjwNwcVgdZymDv
         O47lTwy+Qi+RyFF/iChT4dlen5Df0I1fGU+xSUVDumCkNSlW1N1yDuvBiOowj1T/Ennp
         /lNZrWl50YFSqhcRetBhupCqdyb1GjwpxuTNfUvB4DkH45d+ZV180zZzK/gizN0B4ZxD
         v+Oq6WUpmYEO61ALDNo2rJBBNH0MD+EsRjPrsUMvRpxMmdPd/CO+51F5ZgkioFWD0+vP
         kZPA==
X-Gm-Message-State: AFqh2kpkNMzS0k55FoaLBNECBzsRLVOkdhOlj9N3q0F/B1qArkqOxsXe
        mL0e+flwtRK3KPNimzUvidA=
X-Google-Smtp-Source: AMrXdXsGsjsrB9AcKzMCzEqklUI9nm2c3uPSa70otNvz7vExtyhtj7gtbzCz9MgPJaULLoodG5H59g==
X-Received: by 2002:ac8:5211:0:b0:3a7:e384:92b6 with SMTP id r17-20020ac85211000000b003a7e38492b6mr64414936qtn.19.1672784386769;
        Tue, 03 Jan 2023 14:19:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m5-20020ac807c5000000b003a530a32f67sm19430531qth.65.2023.01.03.14.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 14:19:45 -0800 (PST)
Message-ID: <d42ecd28-9fe8-9376-8c42-4245120cab9f@gmail.com>
Date:   Tue, 3 Jan 2023 14:19:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 net-next 01/10] dt-bindings: dsa: sync with maintainers
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
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
 <20230103051401.2265961-2-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230103051401.2265961-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/2/23 21:13, Colin Foster wrote:
> The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
> listed as the maintainers for generic dsa bindings. Update dsa.yaml and
> dsa-port.yaml accordingly.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

