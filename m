Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316EE52F07B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351560AbiETQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351534AbiETQXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:23:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CBF17D38E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:23:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q76so8132461pgq.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BzTIjLFgI/4DNCbVKVgCgTv6ggS62nm8SPfLBkmMwB0=;
        b=VP6mijatCvPTB1Xt3JKsa+gtl0XpsYkaNnT46EUNRH033Vis/7AuwDtdei0srXow3C
         uuaMu2ekoCmJSaj+q25/u4kojvJxMTvXlnzG3CYUkHkCZswgAbEi+VG5IDGFP2kyVKxw
         pyVbvEe+Y3zEX7KQm4RG6ptvuMyJy53wDnOjAStUqdr4TsYz45OkvqGvaiRCRv/bk+lg
         mjT3L0uVxHzPtvtglrb0fMQx25RHpD1mRWcAI8DJQtHmlKiTsOlcEOKdSPTDlQ25b8Jh
         0dDK08qVYOdfMH41MKjLaPL80ctl45OdtoNaQy3tehya+C1sK6veXs6S05R4aqzXJVHU
         zctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BzTIjLFgI/4DNCbVKVgCgTv6ggS62nm8SPfLBkmMwB0=;
        b=TeurCP7JhgLC+OEN7AsrpbrTcLaWW8s3D3XVNjbk8JVklkdoVKoel5cR1hk5zX6XR9
         utHkgVxF27xrPaTGpYulV6kt5e0I7OgDES2Xzd5TF5Asn/AyboAICanlh27p0q96JUEk
         /5s3qp8HbksplDOcJlIOAhDueurzG7VkQbe0H66+kLrxoqvQlqU3Xj4hte0Ijk9/Gh3n
         pm52buOSNvQGXsl8zwKP+OE8h5gILIjdIwne9QFVN3nMSGGXccGoZXT+nNO1swt+G5kh
         BS+exBn8n6lZlyqWd9NxktkGV6d6dofyehzg/t+lMImcy26JgjQqcO6zLlYRfT7L87Yo
         H6iA==
X-Gm-Message-State: AOAM531b2PME4fFOhaJA6eBCLfJOo0/h1hwH8Og4RLSfA3LSmYJAa6A+
        j6wcZQthx3ec4CNBS8NIxtw=
X-Google-Smtp-Source: ABdhPJxFu8Ij8zVoRuTXWQW9GGooIxP6QrfsLuNSpQZOdnUL9WT2VqkbkJ/skYFoaQXchVeZcP0p0w==
X-Received: by 2002:a05:6a00:198f:b0:50e:7e6:6d5c with SMTP id d15-20020a056a00198f00b0050e07e66d5cmr10606108pfl.20.1653063779722;
        Fri, 20 May 2022 09:22:59 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e21-20020a170902d39500b0015f4b7a012bsm5901125pld.251.2022.05.20.09.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 09:22:59 -0700 (PDT)
Message-ID: <437b7685-5990-bab5-d321-3246a03f41ac@gmail.com>
Date:   Fri, 20 May 2022 09:22:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mans Rullgard <mans@mansr.com>
References: <20220520051523.10281-1-rdunlap@infradead.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/2022 10:15 PM, Randy Dunlap wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
> they are limited to VLAN_8021Q if the latter is enabled. This prevents
> the Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>    Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>    Selected by [y]:
>    - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
