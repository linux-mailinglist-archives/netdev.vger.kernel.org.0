Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3D4B91C6
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiBPTwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:52:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiBPTwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:52:06 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7A97ED88
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:51:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z17so2790058plb.9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9qN+zpu3XqdfqJZBhwh4RpCO6CWTrFxsUAK1WkuvOyw=;
        b=jqbmHHJM/023Jy9esP/m/eD3aFR4ZDZ3I7m569wQfjgfC1k7QJESfchwxB41Nv3ZSk
         jFf0Nosn4yJqcu2S3wemVUZ584faxAFpV0BLAFFXG6xsmjCW+0Qd3bTjj8kfITfsiTRx
         gKkohZfZTB8DSIV7QBMkjNenf62vMIAIseCHX8AG4D6s5kJdKL603AmTFyI3TeCNjVrj
         EyqKv/OOFYI9usG/IjyHpH4yaEnf6jhBXRfO/EuB5UVjZcGyIeIsFKTD2EpyIfqifUz0
         piwbKyALbu6Q6whRGUd0LCwC/327xQYPekddhEw/n2PKH/MkBQ88ar3FjTOIBkvmCt1Q
         xF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9qN+zpu3XqdfqJZBhwh4RpCO6CWTrFxsUAK1WkuvOyw=;
        b=lUXORw0v68WqiOXj/vuPtwdYa9CgwuIjzKYn/5Wka11bpTvhby1pT0Q0Kfyt6j8Xu1
         MImfRgCk4ggtkDSrayWxUZS2/Zhp0TNISSXjAMD+xMu8H+pELi0VxdgAHf/YTkrDKP3u
         0519omtUMT78eEDJ5vG3XYgmeGoN+nx9dyOhySExSIe/dQ9wMUDbZ3gZwkHj7D2rqpk8
         5dz63BYPyJgIndKkqozjLw5ivFNgo4UQAfNZakzmsUvM+/3jesEKm1niHI34mExHGBmx
         9vk4TvLtUAhdPtg4kk80FgHSHpKiVoogNYsV77UbrMqN0ilcodMk+EbbksTzh5O3Kisp
         vYZA==
X-Gm-Message-State: AOAM533HRNzszczwwidwSmCQSzJdE/EUKHNyaZQUIfDGmN/Sa4chpimx
        eHNxn2zSsYhvkersLAqLAgzmb4Ifloc=
X-Google-Smtp-Source: ABdhPJyLrKOXu//ts9mKz86jcRkfMMun54Co3vJqePZWM3umZTE3tFt68lOhQnnppppUJrExBr4jmA==
X-Received: by 2002:a17:90b:1d84:b0:1b4:dc8e:2cc2 with SMTP id pf4-20020a17090b1d8400b001b4dc8e2cc2mr3560102pjb.122.1645041111701;
        Wed, 16 Feb 2022 11:51:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q17sm45454699pfk.108.2022.02.16.11.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 11:51:51 -0800 (PST)
Subject: Re: [PATCH RFC net-next 2/5] net: dsa: b53: populate
 supported_interfaces and mac_capabilities
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
 <E1nFdPN-006Wh6-LC@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6c6c8a56-fb78-214b-ed85-999bb76680f7@gmail.com>
Date:   Wed, 16 Feb 2022 11:51:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <E1nFdPN-006Wh6-LC@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 6:48 AM, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the Broadcom
> B53 DSA switches in preparation to using these for the generic
> validation functionality.
> 
> The interface modes are derived from:
> - b53_serdes_phylink_validate()
> - SRAB mux configuration
> 
> NOTE: much of this conversion is a guess as the driver doesn't contain
> sufficient information. I would appreciate a thorough review and
> testing of this change before it is merged.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

This patch breaks with the following:

[    2.680318] b53-srab-switch 18036000.ethernet-switch sfp
(uninitialized): failed to validate link configuration for in-band status
[    2.692470] error creating PHYLINK: -22
[    2.696441] b53-srab-switch 18036000.ethernet-switch sfp
(uninitialized): error -22 setting up PHY for tree 0, switch 0, port 5

Adding more debug shows us the following:

[    2.804854] phylink_validate: unable to find a mode for 4
0000000,000001ff,0060004c
[    2.812807] phylink_validate: unable to find a mode for 4
0000000,000001ff,0060004c
[    2.820733] b53-srab-switch 18036000.ethernet-switch sfp
(uninitialized): failed to validate link configuration for in-band status
[    2.832868] error creating PHYLINK: -22

4 = PHY_INTERFACE_MODE_SGMII and the config->supported_interfaces bitmap
is printed. If we add this hunk, you entire patch set works again:

@@ -178,10 +180,14 @@ void b53_serdes_phylink_get_caps(struct b53_device
*dev, int port,
                __set_bit(PHY_INTERFACE_MODE_1000BASEX,
                          config->supported_interfaces);
                config->mac_capabilities |= MAC_1000FD;
+               __set_bit(PHY_INTERFACE_MODE_SGMII,
+                         config->supported_interfaces);
                break;
        default:
                break;
        }
--
Florian
