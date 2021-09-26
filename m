Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855194185B1
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 04:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhIZCec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 22:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhIZCeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 22:34:31 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63545C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 19:32:56 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so19047544ota.6
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Sva3BNZoW0LFmSuFmnteVexjbS9+JL6L9zD2vGZCDa4=;
        b=Q1K3vTgy6f+ZT6ecfmenJLTHgXhRXm8PwMTdBSORWrtsvPLQUmhA3xk26g6msw8HTg
         IHSLLfIlnEJTL0j9WgK7SfKiL4yZuXD+eo6Bw/x2C+aScec5uYybxRCpzIn4S4bxKPzY
         O30dhaqrkdXadtO7ADP/zMFZVrysuGgXRnx7JdfKulzF9Xw9P/LFUXcsk/usQFA3fLEi
         O9apwzQwDCYI0d8azpeB0OcAq/yaIpxQDhGv7HqBewugoK4sv9MIC6PzaORDs6CE62dm
         uEFGkr0WmGhaCRNxyDGV/TwHHbiGMoPi0YitX3WSTeCyukNyfMgs+3dMj6BlAqtJz/sa
         ZxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sva3BNZoW0LFmSuFmnteVexjbS9+JL6L9zD2vGZCDa4=;
        b=vee/cqHndORQu6rzj/Tf/es6cAJwU28RJetgV5bSmSAc+nyWFxB+XHntokYXHHa8XM
         W3whI77DYuKDa9v7qQaMmHiKYe2dlyHSlp2KR8QJei5P5hblE8Z3wu4pyfgZam8PfqmJ
         ACsTitJmCp5KvjdJbqPbHtXmF3vpBVbbFj2ttHplTpveInYw5KscvSmKODhhoQHs7AQb
         Z3a4exhniD1nkIeb7X7gUW/eC9nwR1UHFDJ6LhmF/2//MMGMOpZLjU5P2wkwn1Spif8J
         mD4+Ebsom+Q2VgZ1qskB9g/Vm2vjH22tr234SqShAcJpzWCPob3RoVvEjdmTNzWUQEx+
         HnfQ==
X-Gm-Message-State: AOAM5335Lxq5G5C6xRKf+G7XjL9vhZdRk6YSx7Sf65GMJW9vw3UY0S2t
        fYni08CFSJt1cTz19pUhd6o=
X-Google-Smtp-Source: ABdhPJzOX5UwLRgLsbZKgOUkzXS2iMpIaZfgliQbLwbijiAhhr+IwZj8ZBPEmaQCHsCu9LgcWuaEpQ==
X-Received: by 2002:a9d:4a8d:: with SMTP id i13mr11342404otf.180.1632623575778;
        Sat, 25 Sep 2021 19:32:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e? ([2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e])
        by smtp.gmail.com with ESMTPSA id bf6sm3221682oib.0.2021.09.25.19.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 19:32:55 -0700 (PDT)
Message-ID: <60fdb958-1bd9-13e6-03e0-218beef86ab8@gmail.com>
Date:   Sat, 25 Sep 2021 19:32:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 4/6 v7] net: dsa: rtl8366rb: Fix off-by-one bug
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
 <20210925225929.2082046-5-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210925225929.2082046-5-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2021 3:59 PM, Linus Walleij wrote:
> The max VLAN number with non-4K VLAN activated is 15, and the
> range is 0..15. Not 16.
> 
> The impact should be low since we by default have 4K VLAN and
> thus have 4095 VLANs to play with in this switch. There will
> not be a problem unless the code is rewritten to only use
> 16 VLANs.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
