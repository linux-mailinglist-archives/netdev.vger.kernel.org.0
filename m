Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB1C577765
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiGQQ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiGQQ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:58:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2459F2C
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c139so2489100pfc.2
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0/+5dIm0QtkVmWcywKoxeuYnlNflCIpLI2ZDmU70WH4=;
        b=iDsFb/1vOVEyGz6FjGk+Qn6jm/1kJc/aWvBJnyQRVEQcfh2ykm4DoZiEezWL3xrw8a
         4v+gxKvhaJ30GjSuaLbg4LoLTd31ijPKSsqSa9LS0s0Xb5zRTEv2IS7hqOroMeiz6ofk
         aly63qLvlyKmCOQH+HGPmyHQy2OFs0uMN9CAC5s4Gagwd7wcK979dlD4MbNJ0l53/fJG
         wdi8KPzq4kd6uUwivW6u+evYpG8joLRVF8/IJsD1byOBScMWFH36eUN0QypM5B6GwXrh
         LHP0KrIi0JkTRKddbBQAoiMQAidh731V6nepPPH6UaM0LpAo26OLB4pPgFoVOJsgYfrR
         dlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0/+5dIm0QtkVmWcywKoxeuYnlNflCIpLI2ZDmU70WH4=;
        b=DwAT7M52LgCYjAg1Xc/MBO+Fw5gCJ+9POQv8C8TuZfvbyF4GbXg/s4vAua4+XgN2Nj
         wXXLB083jzzP5kq0wI3LeqIzOf9E+t+H0a3KSI7ca1MoDrILYIPKiq9uqftjHgwg9hoE
         5PYv9Mnzg/Pt9jseBLxQG9FNljn+w0uXIKOn815Yc6MMppp4EpPE8iSK1+ai1DRdn83k
         IJ7aS7MjK9QiQm6RZ0XFXD6crx/dIvU7SotonFDze8KTY6mb75xWitcl2t6wAbBYAuwZ
         6SHiWuL4we2viWeMGG+AkIj1fv32gJM5a3SW5oZ2aDn5P282W8JframJBu7dWrepLxlc
         xAAQ==
X-Gm-Message-State: AJIora/BtuGW/2ci6vSLEzDfGsKyf2B4Yp89Xp7TAyhj6nK2MYmjIBj4
        X/ICPw2TgO6FC0BcWCYlgm6r08Wca/A=
X-Google-Smtp-Source: AGRyM1suUTBuJVb6im2RmCEoYO0JJRnl7QUIs632K2IQ7FzW7sHP5rNdmcAqDnNhLtExMkosXLcynw==
X-Received: by 2002:a63:64c6:0:b0:413:6562:5ffc with SMTP id y189-20020a6364c6000000b0041365625ffcmr21811946pgb.418.1658077126451;
        Sun, 17 Jul 2022 09:58:46 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id co6-20020a17090afe8600b001f1acb6c3ebsm2112332pjb.34.2022.07.17.09.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:58:46 -0700 (PDT)
Message-ID: <5e65307d-56f1-2c58-2f39-641fe2617824@gmail.com>
Date:   Sun, 17 Jul 2022 09:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 06/15] docs: net: dsa: document the teardown method
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> A teardown method was added to dsa_switch_ops without being documented.
> Do so now.
> 
> Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
