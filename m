Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6920FB85
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbgF3SPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgF3SPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:15:42 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8186C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:15:41 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f18so13053259wrs.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oAX578iVpoILmsDp+hKDNoo89GfBVvv9D8BadnIUrys=;
        b=Sp7OUutQ00ejKGSIFY22e9OyeAbsJu6yY0Xr39VkmoTwAutWTS9em0RFFa4buHO4Wl
         UUAAV/KCnQxzFqNd9axdFRhZ2g2rJet04cU2Aji1cK89lrjSAXEz0YbybApQJ7llWHwZ
         caRZRl9are7deMDUJAcjsKOLjgVtMDeZcs6fHNTwF2tOHm8EJ6bzkX9YxTokt1/N7DDO
         7N2cZOz4yaimQIxC2mzeOj7JeWXEsNhW8ON+qIN28f3ze7SQDNTJY1das9+TeBvNK+mn
         BilpBFm7mBOza3HeJk7vNHJEjH2/V8f/vPvjJLeOLPlAUs99S2+98hGGGxX6RDyJHXR+
         BP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oAX578iVpoILmsDp+hKDNoo89GfBVvv9D8BadnIUrys=;
        b=lOB9id75kKfDqbObiwAwGpiSiosHVuzZA16uWzvkgDEIvgvv9w+6evf/M3DbhAahTB
         TbAx1qistA3n/PwgJXZWJkDAHzEb7RKi2f/DUj+g2O92KlJmES7SqCL1ANFO1Eo13Xx4
         aW5cm4QAZWJWzTnQjxdJTtEK74VT5pY38BSDGSUQcVcTlTgEspgnoOvRAwyqLFvLg6V0
         u/zB0doMHl1x+N0I/I/e2SvKROMeprHm30hwLt+AOf9ugCXlguLX2Q1cgtZG8jWnay1Z
         LBidHv0hzgOk6A7m33xQNKKcYE54J4J0LPAJYGxtLWRbc5Dadj9+hIcEkHJhN9LY5Hbr
         1lBw==
X-Gm-Message-State: AOAM533Y4EAdUQsBR4DNVxp625YcV0OX5PWV0iC1Ecaf5VvXyu5OSrAj
        WsoI4PUAoPcIpHC6hiyeP11f+b/h
X-Google-Smtp-Source: ABdhPJxm55DRKXCnaGZ+oIQhlxdjUQdOq3zATf/WeKmf8g9hqg4SU/7uEYwlnuUZ2kx69LBZBxzn5Q==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr22254541wrt.236.1593540940224;
        Tue, 30 Jun 2020 11:15:40 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e17sm4284706wrr.88.2020.06.30.11.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:15:39 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 01/13] net: phylink: update ethtool reporting
 for fixed-link modes
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFT-0006O2-Ol@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b927587e-c3a6-6075-d4f7-211606224ce7@gmail.com>
Date:   Tue, 30 Jun 2020 11:15:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFT-0006O2-Ol@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:28 AM, Russell King wrote:
> Comparing the ethtool output from phylink and non-phylink fixed-link
> setups shows that we have some differences:
> 
> - The "auto-negotiation" fields are different; phylink reports these
>   as "No", non-phylink reports these as "Yes" for the supported and
>   advertising masks.
> - The link partner advertisement is set to the link speed with non-
>   phylink, but phylink leaves this unset, causing all link partner
>   fields to be omitted.
> 
> The phylink ethtool output also disagrees with the software emulated
> PHY dump via the MII registers.
> 
> Update the phylink fixed-link parsing code so that we better reflect
> the behaviour of the non-phylink code that this facility replaces, and
> bring the ethtool interface more into line with the report from via the
> MII interface.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
