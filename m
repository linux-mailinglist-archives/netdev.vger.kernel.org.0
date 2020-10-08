Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D41287DA5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgJHVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJHVJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:09:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BCDC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:09:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y20so3367237pll.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dewoZa5/BtaaJ3TH74wNoz9thBTRX1rjX9EbofhxM44=;
        b=LcVh7sefSrI2dgdaXHXlea4LY5ueGHyq4MEISEFqqV8yFawSR+CrfR+5gxM4rbCiLr
         HPN2U0yNRsnZ2Jlu3R3+RLdW548BQYCe4N7Eq4hOkJxlnm1BDM2z4NWZkj4NojHr7cXZ
         AWpzI9MaUkv7IhqKio3XJByzTOMBO+k9Dvw8BlcodIVKdpgh81pZKBhTh1DjpZPhhNBN
         pl0vsVBBNZD0BshUQQBXr9RuR9cAcSpvzYW7MYenAFShbBm9sJs/p4AdDo6rUToTXteK
         xcsZTIfbWCgSUfwGX1DGRbny9UIB2tfDKifYpt959aYtZ4UbQXjcfrayfBYhvA19m7OO
         YExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dewoZa5/BtaaJ3TH74wNoz9thBTRX1rjX9EbofhxM44=;
        b=jz2HBz39z10V2lO+bbwtU+7yw/kK2ITfoLvPMAHo9FM/J6/vEETKqB347pNpPWiliE
         40VfXAivRertSSNbG82L4ECpZLnh8MhBBiwYobqqWZ1S+ivzYPr85XGsPaTEYX25XtFr
         oI0z2+Co5qy0/o0S7ScOxrkOnw0vtisZo6cR2fklEthVbSDUJHXxyaXV+7T0bGWM6Ve8
         0agSNUDUOLDGXfUWmytWxglaFCJly5LH/Tm1A7Ae/TUdP/JHL2ButybzcvJsULWzfY0s
         XoAmZ6QY/tD3aJtBcOLpPdMof+kezgfUFrr1MBUwphtmIFtupJGC/OC5kYLJ3+d4onYU
         ZNhw==
X-Gm-Message-State: AOAM533qR3VyLYdSd4US2CBXYsRkvJKemt60m6HlKnc8x4Wtb9z7oY6N
        v6QsDY0+x0HFtmbknsOkMSqXynrupGtDkQ==
X-Google-Smtp-Source: ABdhPJzmz7SVDsQZZKwimY1QnMlZtYTrckK/Dz7Pgvkx8YgXNlx5GSrWwUBDPZLGD1RWLiyCMmzJgA==
X-Received: by 2002:a17:902:6508:b029:d3:b362:72b5 with SMTP id b8-20020a1709026508b02900d3b36272b5mr9219012plk.55.1602191360162;
        Thu, 08 Oct 2020 14:09:20 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cx20sm7913915pjb.4.2020.10.08.14.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:09:19 -0700 (PDT)
Subject: Re: [net-next PATCH v4] net: dsa: rtl8366rb: Roof MTU for switch
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20201008210340.75133-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6a92a2f0-70b8-0fc1-d01f-21eb8d68aea2@gmail.com>
Date:   Thu, 8 Oct 2020 14:09:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008210340.75133-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/2020 2:03 PM, Linus Walleij wrote:
> The MTU setting for this DSA switch is global so we need
> to keep track of the MTU set for each port, then as soon
> as any MTU changes, roof the MTU to the biggest common
> denominator and poke that into the switch MTU setting.
> 
> To achieve this we need a per-chip-variant state container
> for the RTL8366RB to use for the RTL8366RB-specific
> stuff. Other SMI switches does seem to have per-port
> MTU setting capabilities.
> 
> Fixes: 5f4a8ef384db ("net: dsa: rtl8366rb: Support setting MTU")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
