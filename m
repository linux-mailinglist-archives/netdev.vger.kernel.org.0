Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DFE24E95A
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgHVT0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgHVT0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:26:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAF5C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:26:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id z23so2371722plo.8
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fl556EI0QaDT3nGWmjJ76wWcZTJECG5f4n2lOERNF6w=;
        b=m219KSkKxJ3H4LQY3ptVnV3vWYtvrt81yf6AL23P81davikSTRWBj+cAZpNeehv3cf
         /6nvC/X9Zs5cnC4JpCPnhXgOW9xZAstuoXIxJtMbmGQ8OPKEKJCvZRrK5mrwIkHaGHVK
         AaeqYWkNvvOCYXiMlh6Da+ZOtM8tm4/7ShHR7ypf2G36K3RElqKiquY5jYSZI7+Ed3qc
         iQMugoCQPy0D3xn7hglTNB/FLhAqDg7fjtNALuiKrKHXIGq7Gq6MyLisUUtPH1BqhGO1
         +RyaVYzsQjlpMNSOucfxdLV1rXi2VQ8VDJFWFkg10uUS2A3T9LgNAEzAmeRLGicf0hqW
         xBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fl556EI0QaDT3nGWmjJ76wWcZTJECG5f4n2lOERNF6w=;
        b=Cb8w1nLGsqM8c8JN1LPSUhWkDM3m+1lR56EbU7UG5Q115U+FvMmzTazm/PyXz+Wdud
         uTBUiovnfFxJ2fH3fBW2f7iVtt2VDfbLNnJdJuPGhuA/wnfHF9YWIS+BB4Y6DSlOKuEh
         QI1BCn2lr9Q4i/usYEENkHkz74ziiNn9vj4u1qbxyrlPBM52GzMM5LYfd0BZZ+7VWibG
         040T1cYtwp2RoSk44Uv5xeLb5OYoxsLulYl9wJ0WiKf8AJXxvIMCR8TS0I/m/HPTeTZk
         6qzZIOmFMnGmiBL/2CWct2wyVhR39LBX7T3ITvyBZ1l9q46DujaJB/2qrz5j3KyCiePX
         riUw==
X-Gm-Message-State: AOAM533HiDKoF9UNsYjewbDF5xcRs25X+A6RSuyVKUUpe57aKqT/99FM
        7+glzLI5gT5EtVL/EKGBAbmA2pDSc/0=
X-Google-Smtp-Source: ABdhPJyRyEzhbflJ7kw5A3tqkZ1BONeE0tyPKOFZhAlVLIrA38nOcA1bYsX42Oh5fckmpWaiXDEfmg==
X-Received: by 2002:a17:90a:f697:: with SMTP id cl23mr4242812pjb.47.1598124368208;
        Sat, 22 Aug 2020 12:26:08 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 2sm6593050pfv.27.2020.08.22.12.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 12:26:07 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/5] net/phy/mdio-i2c: Move header file to
 include/linux/mdio
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200822180611.2576807-1-andrew@lunn.ch>
 <20200822180611.2576807-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5660a8a7-bfc3-ed06-7889-5602d888e6cc@gmail.com>
Date:   Sat, 22 Aug 2020 12:26:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200822180611.2576807-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2020 11:06 AM, Andrew Lunn wrote:
> In preparation for moving all MDIO drivers into drivers/net/mdio, move
> the mdio-i2c header file into include/linux/mdio so it can be used by
> both the MDIO driver and the SFP code which instantiates I2C MDIO
> busses.
> 
> v2:
> Add include/linux/mdio
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
