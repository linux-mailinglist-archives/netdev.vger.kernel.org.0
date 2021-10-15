Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC142F8BA
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbhJOQxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241603AbhJOQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:53:48 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCFC061570;
        Fri, 15 Oct 2021 09:51:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q19so8860813pfl.4;
        Fri, 15 Oct 2021 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zb9G1+QE6TPjcDQWwrFaaor3TCEf2EiGzb+MS9GU7D8=;
        b=XY99bZaRyYvFlMJ7FRdZGyNr6JdUPvFgp7MJuCUg6ulGJzgYiltl1LarRL0+PnNLX1
         +Q+yT8P7aJF+GROBgsbXXrc+I1zsfaUAshek0gcqtyIBQ0PED6XFhlT3aEQGj3OFSkm5
         XMcgllev9uy4VL6qf6Oljv5nzgS9Tk0RQWNKZXYeNRpaFyq/8KgIm7EHt7QwwJfzFohP
         j9erJ/n0UA9VCXImdor5eZKwElu0U+CVcgeVJV3W2YhKSa4UlIqjnl7DeEFEZfJCgRH+
         bsUiCQhL3JOrbQCtIKc8Gtb3Fwna5kMeemZHdq/SgDNTUfRA/apjVcFq5lhh022qdJ+C
         8iKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zb9G1+QE6TPjcDQWwrFaaor3TCEf2EiGzb+MS9GU7D8=;
        b=O/aOeZGF83l1N7pl5p22Ox0zQsQ6P6k7Qws/sEuZrEEKk9pd31b1pUgYut7WzIFGDf
         IuNYCVP4mKf5tiT/qf8cJv5C0Ul6WMEQmf1rUoW0cCpPnIfdYZARhrbmlGCZa0+UN/MI
         w0y8MCuVaNMLxn4w64Eebe5b2cFbxrY/CnMNFjL6682XpVvi/fRqMPOUQAFTuuQZR9p+
         iCQ6C9dk7g9tbpyrFkVkQeF/fNAjPpOGAWsgyoN1JdIH2H8PmybFylmqtYQ02DgLMO5v
         Ww7zcBr56ejlXNKcw7Gw2BWF4N2JrGcN7QYMgnPRhjgsQtgwQKRZX7dRZB0w1Twuhvby
         Ze3Q==
X-Gm-Message-State: AOAM53341uPVzXd26glc4RVC36V6y4yJT2R0WPhvRHan3XQhoI+Ai3F3
        p+9kuBlJyMVClf9MHCXRZsw=
X-Google-Smtp-Source: ABdhPJxyNLQFBFqpTmsYlhliHjDREd1duHZRhxCnMSMedF4vPcF92BYNycEBRVFVpGFc+/trXdfb9w==
X-Received: by 2002:aa7:808d:0:b0:44b:31ab:c763 with SMTP id v13-20020aa7808d000000b0044b31abc763mr13022551pff.4.1634316701134;
        Fri, 15 Oct 2021 09:51:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gk1sm3919321pjb.2.2021.10.15.09.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:51:40 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] dt-bindings: net: dsa: sja1105: fix example
 so all ports have a phy-handle of fixed-link
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d3e20bf2-797a-ae9b-c5e5-35bc68c1d10c@gmail.com>
Date:   Fri, 15 Oct 2021 09:51:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> All ports require either a phy-handle or a fixed-link, and port 3 in the
> example didn't have one. Add it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
