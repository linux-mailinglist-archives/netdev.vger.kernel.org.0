Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD32510217
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352463AbiDZPpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348561AbiDZPpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:45:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E25F74850;
        Tue, 26 Apr 2022 08:42:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p6so3435363pjm.1;
        Tue, 26 Apr 2022 08:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mkAiWyPhdlD7e1Z/gpT9jMCqV3vsrhfRYPhRMfnvJO0=;
        b=TaHATRTJwJHqsCqS2xEBlv6yBrYs0VJr0ClZJaLQBGwXZBJagebc+1vGjE+iPkNmEu
         AfQg/LzWmCdvqI1dDWaDBGJYfmGPOQ2HJWGzcp2EneKB5omeAPGrlvMsiTly0xwPOl9+
         ZtJ4gZm1iZQpFGDYYtTUjn6XoMfZjg0f3ILxFQ0HkXlL4vsGaHlJrZiGol2Kf9z7+YK4
         KFQlKVFZp73718XauWKHrGCVSAsh33cMygLQ7ka4LZKHM5nmcsf86L23B/nl/H/t6SIc
         xsvqrdf07KEtHyfU5EoRjvP9XkDcJZgW0zl/gX1h4DBYTpTYQCqRpo9EaRX9QeJdLNPN
         JgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mkAiWyPhdlD7e1Z/gpT9jMCqV3vsrhfRYPhRMfnvJO0=;
        b=MGJAAgDEHQ9tmWgiqJqq2/sURs/G3xUdNpkNwsmaE1TG7Qqi/9OMS+yqOqvnVPcNf4
         nbFFbVZ/7KZJAKD87Rah4dQez5CPDcEPFaJnXO1vmq/E2RsRmNdQFRQ0+UpGw7NNgMXH
         8yYfOeq9nSpUEThtrKXueZF9sp5inH0EXQdjj5i6cDFv2sOBAndMt3sKo4v8yuGH7FOl
         AkySP20JlhxG/uKa+eAhc2dhJxrCHOXji61EU934xIOvRGiIE1QzWql6/4nrbkLZvWXi
         3MPa2LaranPlqoUc1N/sl9L2jRkVcT7DecYrgDOCOudjDFv9piidKtRAX0sW/eH4uxzG
         H9VA==
X-Gm-Message-State: AOAM533AQM7kIl172zjDpYUikN4a0ZmXOiXOypfQq57kEyzDc8LlMfMQ
        9jpGI0WqVZJMKdRagPdTFgE=
X-Google-Smtp-Source: ABdhPJyo24E6WK3N7Y00h2mZM57XuguDl+o2a2UTKmV8d5ty3eJrQIQ9E7G31XihG1HfqrPrfocGrw==
X-Received: by 2002:a17:902:d545:b0:15d:4a7:d3c1 with SMTP id z5-20020a170902d54500b0015d04a7d3c1mr13148473plf.52.1650987755650;
        Tue, 26 Apr 2022 08:42:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9-20020aa78009000000b004fde2dd78b0sm15040858pfi.109.2022.04.26.08.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 08:42:35 -0700 (PDT)
Message-ID: <b2f06a62-6ad7-ea92-7035-2a29f0e6affd@gmail.com>
Date:   Tue, 26 Apr 2022 08:42:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC v1 1/3] net: dsa: mt753x: make reset optional
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-2-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426134924.30372-2-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 06:49, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Currently a reset line is required, but on BPI-R2-Pro board
> this reset is shared with the gmac and prevents the switch to
> be initialized because mdio is not ready fast enough after
> the reset.
> 
> So make the reset optional to allow shared reset lines.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

This looks fine however 
Documentation/devicetree/bindings/net/dsa/mt7530.txt still has some 
verbiage that suggests that the 'reset' property is mandatory, so you 
might need to update the binding (and as a separate patch we should make 
it YAML).
-- 
Florian
