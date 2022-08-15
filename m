Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC7593482
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiHOSJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiHOSJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:09:16 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A473529C8C;
        Mon, 15 Aug 2022 11:09:15 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id y4so4970581qvr.7;
        Mon, 15 Aug 2022 11:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=35BvP9EA6UmVAWVwUm9hFAUDuAeF8dpNkQ9qW8oNTB4=;
        b=jucWJuC9qvN4lki55uHyX7PERPzNfa8Ji9ed4mbdY+F/XjglZn2GS7DRSSM+I7gJXy
         g2VDVCt1NnVqNvvKnXGyo2pZoRIGsnX7nHdAaUHkJWPHWkXEmecqnED6ivmXkFiQKd0L
         W55Rk+XQcZ2OmU8qyarBDhNEx+K5nrOivVqxQEOIcI6G7gzY7mZ5a6p3iqXgFo/GLjEK
         z26wmO0X/876nBR/pc0D4H+lWpd07379rjcxzwQdb2zs+iXBFgVCkFgTAN4Bt3gxvZl8
         T6ap+6R6ZagOxUtirf2ezRrbk486i7SKOa3xK6nac5LqbXsQnxrovv0B7yIdfJ3NIZdD
         OXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=35BvP9EA6UmVAWVwUm9hFAUDuAeF8dpNkQ9qW8oNTB4=;
        b=0fLKLYm8nUInd+Ele9Dcg34pAaeO0fPoOCksXQqIwFycxmuwMSpnKVI+ywqZRUmQMr
         gR39zalJTRFsFZM/WtC9ios0xoAGA/FO6Y1qW5KCVeKHOOdoalQYFcGgrCWrnlBhzMAC
         8v4Fre6T2RiUkjUPPfcV8gWA7IXQaWJs2YJfJ/0QekXDtvo2MgFTrOG05rNHhbAfsDGP
         AvgHSAomcYlxP83sG8XacTITRT3XPf2elE80ht7YND/G8zYB88AYnuCs+xx7LcNyyvY/
         AoLdlgX42niHMrLsn66xReNEnS3H5OWzV8z97hLf1whM/p8C9SSoejblGeqg/kilNm8f
         zC3A==
X-Gm-Message-State: ACgBeo3wLpRCO7er1A2TN+HEtbK8siWRVzxyUQGGzCRA9SqJruNrOO5/
        pb/I2RWTsbg8RiIIkfK7KXg=
X-Google-Smtp-Source: AA6agR4haNDihliJMwbXVir8pO28zMsz56l90jSW3Mrz4IaeRNTqrPLvDHHY5cfuqsqbOgCBV6Bl0g==
X-Received: by 2002:a05:6214:2a84:b0:476:feb2:f436 with SMTP id jr4-20020a0562142a8400b00476feb2f436mr14623928qvb.43.1660586954722;
        Mon, 15 Aug 2022 11:09:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y23-20020ac87c97000000b00342f8984348sm8360320qtv.87.2022.08.15.11.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 11:09:14 -0700 (PDT)
Message-ID: <d75b23fb-74e5-3986-26d0-9ae83158c7ce@gmail.com>
Date:   Mon, 15 Aug 2022 11:09:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: phy: broadcom: Implement suspend/resume for
 AC131 and BCM5241
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220815174356.2681127-1-f.fainelli@gmail.com>
 <YvqJyg3eUusc8jkC@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YvqJyg3eUusc8jkC@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 8/15/22 11:00, Russell King (Oracle) wrote:
> On Mon, Aug 15, 2022 at 10:43:56AM -0700, Florian Fainelli wrote:
>> +	/* We cannot use a read/modify/write here otherwise the PHY continues
>> +	 * to drive LEDs which defeats the purpose of low power mode.
>> +	 */
> ...
>> +	/* Set standby mode */
>> +	reg = phy_read(phydev, MII_BRCM_FET_SHDW_AUXMODE4);
>> +	if (reg < 0) {
>> +		err = reg;
>> +		goto done;
>> +	}
>> +
>> +	reg |= MII_BRCM_FET_SHDW_AM4_STANDBY;
>> +
>> +	err = phy_write(phydev, MII_BRCM_FET_SHDW_AUXMODE4, reg);
> 
> Does the read-modify-write problem extend to this register? Why would
> the PHY behave differently whether you used phy_modify() here or not?
> On the mdio bus, it should be exactly the same - the only difference
> is that we're guaranteed to hold the lock over the sequence whereas
> this drops and re-acquires the lock.

What read-modify-write problem are you referring to, that is, are you 
talking about my statement about setting BMCR.PDOWN only or something else?

I could use phy_modify(), sure.
-- 
Florian
