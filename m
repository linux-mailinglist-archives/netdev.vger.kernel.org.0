Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3316C883C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjCXWUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCXWUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:20:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD3A1EFF3;
        Fri, 24 Mar 2023 15:20:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id kq3so3116404plb.13;
        Fri, 24 Mar 2023 15:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1AYjfv+sbtAs2LxlpgvvgVOVYFU8ZwYiXDg6pE2/sk=;
        b=VXfNxArfFNAdW/jp9m7JrqB+OHafrR5P1bfrO5t0DYtCa2o1f4MpRqsuMPM1OJ4jvk
         mpoQiOri5np8rv/NZ+p3fz/PtngTGAdX9d0yXbfLZrBsdE31oC0tVYnYc6kdsItROU2z
         paZNcID/SfrZSkyXwSOP/6j/HuGOd/1EoNwRaSORJRIFte9Ph4noPI7KyqUlE5pwjudr
         XFEGmCnLlXES8QZzy9sjAtre1cokO0Bjk5d+WEly2nr54CQsg4y9TmVMGgPWo8UWnLxm
         3NKwT73S/xfr/DbF6Ep6Rd+niP9/gY7vnceOdLTdCWcxyip3RqFNN86XZoKgE43zUG4q
         8Efg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v1AYjfv+sbtAs2LxlpgvvgVOVYFU8ZwYiXDg6pE2/sk=;
        b=xIoqiOnzFxJDkzDD1cdduFoKOg/eLaS+awQz7kOCCRzn6s1FBA+hFi8+x8Mg1xTTOl
         qPH+WL7WDXHPy0XpAOxe/v+TGztG5+iH6D07iZ2QFS09fP4bCuOq4mrsdkBVhUEgCmLc
         PZAg9GKQs4f2HIqTWQFKxIVs5Cc5VY2l43yVVxjhb67X/lLVF2SyR2KwS7Sn1fQGrxPs
         0GVKTrISxYthmzvVuOOd5HMz0xy1PCVVauZLbRHTaH8b5BCjMgs98LzwZhCG4SsUN/Oi
         aBDzbjZcaDMWRPw/+0jY+Ai0Q9NY6DBNHs8hix4iwP6brt+jFhNJ3kf/WS6hPXP7k/AH
         rg1g==
X-Gm-Message-State: AAQBX9cBRFYpINkBRLFwoGkACCXkWo9vOAQfyhviFARGVrl8r6IWqN+L
        CkuQqm9IEj1MF+CLCeXWgTA=
X-Google-Smtp-Source: AKy350ZlkFbp2BmfORtCwfmBsdOid0PrNxpGkxdZxbdv6RXzex7UHUvsqC3on+NLPWtp5X+OUHPHKA==
X-Received: by 2002:a17:902:d2c7:b0:19d:1834:92b9 with SMTP id n7-20020a170902d2c700b0019d183492b9mr5356828plc.56.1679696438815;
        Fri, 24 Mar 2023 15:20:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jo18-20020a170903055200b0019aa5e0aadesm14696249plb.110.2023.03.24.15.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:20:38 -0700 (PDT)
Message-ID: <f7d13e6c-68e9-3cb8-7e7c-cad363755684@gmail.com>
Date:   Fri, 24 Mar 2023 15:20:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 4/6] net: dsa: microchip: ksz8: ksz8_fdb_dump:
 avoid extracting ghost entry from empty dynamic MAC table.
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-5-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> If the dynamic MAC table is empty, we will still extract one outdated
> entry. Fix it by using correct bit offset.
> 
> Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

