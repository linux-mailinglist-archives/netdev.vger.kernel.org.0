Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0875FE211
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiJMSwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiJMSvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:51:45 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CBA18347
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:49:47 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id i9so1876517qvu.1
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SpiOZdhs8DkPfxMIeo17LG9S/lTyDpfq6Tzt1fvQgiE=;
        b=Ki7BXDIsOAs2d8IRlb3OHYg07FqRdwfGAcX/YuQvENX4X4gLe+PdKqDnvrX8qe1oUL
         M2xh4acuHPHDAftUjU6YXbqqUUGi7s7vFz1aIkGsSWCaoqMXd8WxV18Pzwbb3ak3pKCW
         w/U6crLc3UyXQc3IWWWli2a6iPDm5ZcGc264J3g0cerGefkoK2wEvZmxYeFCdYYgns5Q
         p3xQTp2TlfRcTI4mMmJkiR435K5bie6vIWPpFqO/I7XRcph5Yjr2BLzERptdf6JQHp6l
         3+kAjzTqYBHdT3krbiK3KPbiBooMCFHi7F84xKhazwf1Gxo/3mR6NxlBXe5TjBc0QJw2
         OqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpiOZdhs8DkPfxMIeo17LG9S/lTyDpfq6Tzt1fvQgiE=;
        b=XPMhZ898TVEaa4+7klDtwb9H5BDmNNNUwI3C9x+S4PCOSNeZwSQnO1aEJHEqIwSmzL
         h41cczh+NZ4qYO3rK2EOY6QuiAm9YspWsqQK2sDS16sqe2e1DbhCVliBO8Nr8kp1jQVa
         tc024qhzvb82PGicwLJ467856z4Rs9fPs4eRRZEIDEbmWc8mrEYzE45qW61ClDAn19+E
         zLdraqCwU93i8ptlRFPKGrMyQcC4XVFDCzHushNakaT4zVEO3ftbPfvTmziBxfWSst3q
         6vianPYqqLT5qmRPI+hIEJDB9Z75+InfOZELUGm2dKFN9OgjZHLLgd8ailDseqPNVMVj
         CWEw==
X-Gm-Message-State: ACrzQf2SNHrJX+xTv4J0ehTYZCEk6LdeuGJ+1KbmzwjgbtulxpIRoCFk
        04qNk0JQVuTabzIBoQ2rbzQ=
X-Google-Smtp-Source: AMsMyM5FCRoHrM/azxvKD7WtMMpuO+Jx4fYXgDuPE0V3s7qhBDL2AcmK82A2VStcm2YBSSRyi0T1jQ==
X-Received: by 2002:a05:6214:518b:b0:4b1:dae2:4537 with SMTP id kl11-20020a056214518b00b004b1dae24537mr1009917qvb.2.1665686939334;
        Thu, 13 Oct 2022 11:48:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g10-20020ac8070a000000b0039cc47752casm432705qth.77.2022.10.13.11.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 11:48:58 -0700 (PDT)
Message-ID: <aa6b1fcd-b8d8-2df4-b4a8-b77f7a7e5fb2@gmail.com>
Date:   Thu, 13 Oct 2022 11:48:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 2/2] net: stmmac: Enable mac_managed_pm phylink config
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
 <20221013133904.978802-3-shenwei.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013133904.978802-3-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/22 06:39, Shenwei Wang wrote:
> Enable the mac_managed_pm configuration in the phylink_config
> structure to avoid the kernel warning during system resume.
> 
> 'Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state")'
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

Same comment as patch #1, the Fixes tag is improperly formatted and does 
not require the use of ' before and after.

With that fixed:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
