Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08941B530C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgDWDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWDRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:17:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40695C03C1AA;
        Wed, 22 Apr 2020 20:17:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k22so3228187eds.6;
        Wed, 22 Apr 2020 20:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aR+qXvnJ8+GuNzazGRLZb5Q+H9sJRFcwSA5eXi7K0rA=;
        b=j482jQhMRy70zAMZaavtaLmHBPl0M0Jyqr1aQtFlysTQw8lmqM+QlyAObcdcKa68ai
         bWdxVuSIsogrBwVKsm3bAuiS8yLfGI4rpFLlu2pvikciAA2vsHYYMnj+UjvO+wNKNzvI
         aTwcLf38za8rPz55hTVmRF/xY7KS3fYJLwCMFWvdpz49RjoRkBJgNZPsmZgbIsH7YN3L
         OvhMlD/DXxue4DcougAMTANS4TDWV4t9f3Clf53PPu4iKH5/x9yxLn/c6Ks6QXzRw8lg
         BCRqhqFk/Dnl21DyGdNWY+pucZjtTlw/0mrTl6QhWTKOFyTwhgiqRWdTZe31fPoqNgjS
         16NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aR+qXvnJ8+GuNzazGRLZb5Q+H9sJRFcwSA5eXi7K0rA=;
        b=Wf3a3vycRUJjkaR1FT4IKkI2efqhOftPkrkeIu72hwKatmRh61sPfgCHdrBukZG7RB
         Uj1VRxnZLr9jl3JnTqZgy9CKaVHhUbChFLtuG82JNcbxra8gXPz7r7vpHZN8p9zFvI0T
         SU7+Evgit0wRWmbvI4nBdJdvZa23tUSEYD86t7iJXmCmymO2HspVePciT/T/5Vo/ImV2
         vgeZLIltvwh2FTNlKnS9IWfn1TlVax6spN7PHysT1BjWVkNFmiSqJNjHkeyXOuGT5Mtv
         TwCtZXL+UE0XG1pgMBGoE9feEtBKucauWSiUpbZzxhZbBw67gOMWbFTdwIV2oo5oUGR2
         sZ7A==
X-Gm-Message-State: AGi0PuaIqm6Q8Aj1sVG9BjzyaIcRBTHjeNObljrEhshmbnxTHWBOebnR
        lrUfPC+HeHLUnaU3zGc6HVhYba3b
X-Google-Smtp-Source: APiQypIvfd/8p99rOL+LDEasXibI5N7USA0uZxAd/qUfBVLZxGUnJ1fDPg2E14LwjfypUXn95E+VWQ==
X-Received: by 2002:a50:a985:: with SMTP id n5mr1180165edc.338.1587611839699;
        Wed, 22 Apr 2020 20:17:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id du16sm256270ejc.92.2020.04.22.20.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:17:19 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/4] net: phy: tja11xx: add initial TJA1102
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <264beb18-522b-3608-49d1-3c17a3c79c59@gmail.com>
Date:   Wed, 22 Apr 2020 20:17:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422092456.24281-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2020 2:24 AM, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> Both PHYs are similar but have different amount of functionality. For
> example PHY 1 has no PHY ID and no health monitor.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
