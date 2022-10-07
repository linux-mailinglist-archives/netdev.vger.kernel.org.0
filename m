Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928005F7FE0
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJGVZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJGVZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:25:58 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC13C43612
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:25:57 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d27so2603195qtw.8
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pp3PkNdpP6jrpj+2aY9vM5YFVJap6BN+ylh/P+ZmqCQ=;
        b=BwwO755p9NGTK+jw/Jm945MjRSatJXV3PX9Bpt7qwsN70+f2/XXunJJXibUP5l9rp7
         JqP3icDS19X6tdwddnJYvYMh0RXb5feHt50Fe5C5l+nsbiGo20HwjErZoWldsXv1bjYc
         ZTwPtWBD4MkjPLYXSzbSCfSkoMndRUzjCV62nKy2HFNvczouML9SQgLCDm1fX6c8mPEu
         w0AuaRC7KiisOCQotAk0rn+zJxm3ttBA/CdnycyimTkiAmiLyIooZIeDDCxHWZXuk6+C
         DcHnfMCrHdosqEp3Ao+hqKkHvFfCDvYfh+yA5HKyjG76oa8julyR1UENtFgBph1CSmez
         RWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pp3PkNdpP6jrpj+2aY9vM5YFVJap6BN+ylh/P+ZmqCQ=;
        b=Jtl49zU2Rz2Of23x88BO24SvR2CnZsjMw+EXVNmvF24kTdEyCBDug7SbMM5eAoCkvc
         1qjsxTFEEgf174pHLbiNWBIYUyqrGFhqWDpiA2vpAFNE6X/eV7zy+CM1s7h1TlDzIYSh
         kdFV08nYMNVluBJDeCxkBOBd59iqeAc+CnqsVGUimgV0fmB3oIys5wmn1fqcMnKK2jZb
         +LOnQXLGSboAk6zJhkblLiGYW5IsBSY5KirbqJIaajFO84BHQQcQ7hxiVEUIvSL7bnNF
         K9WrKtsEw0oBKFBoZx/Xa2FFVF/gVYJNkymxznc5S/F4f775IreNUaOctszwD2gbSuay
         eAuw==
X-Gm-Message-State: ACrzQf16UPAn3vUpvax2fr7Pn/hCS1RKZUp9nf1OVJiGllJMyUbn9pUN
        OBmqLtnsnwAwbVHBkg5GelI=
X-Google-Smtp-Source: AMsMyM4IVyQL8e1ldgW7ejKvXkivsbYmt0BIXTluu0teimSk6wCTBzk23s9DK5Qw6kAThT9W52E3Dg==
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id j16-20020a05622a039000b0035d44abc615mr6064206qtx.594.1665177957035;
        Fri, 07 Oct 2022 14:25:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ey23-20020a05622a4c1700b0035cf31005e2sm2897179qtb.73.2022.10.07.14.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:25:56 -0700 (PDT)
Message-ID: <3a95403f-0f26-6f64-1cd6-7770808f8514@gmail.com>
Date:   Fri, 7 Oct 2022 14:25:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm() helper
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, imx@lists.linux.dev
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221007154246.838404-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/22 08:42, Shenwei Wang wrote:
> The recent commit
> 
> 'commit 47ac7b2f6a1f ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state")'
> 
> requires the MAC driver explicitly tell the phy driver who is
> managing the PM, otherwise you will see warning during resume
> stage.
> 
> Add a helper to let the MAC driver has a way to tell the PHY
> driver it will manage the PM.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

This is fine and needed, but first net-next tree is currently closed, 
and second, you need to submit the user of that helper function in the 
same patch series.
-- 
Florian
