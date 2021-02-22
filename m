Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC17632102E
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhBVFNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBVFNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:13:08 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D057C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:12:28 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id s23so2672599oot.12
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BHdzpaRs7gnEiWyZVk5LkyLac4zLwGguwspYIDJHqvU=;
        b=hsPtedNu8bFGFPwdl+Di45j+0Td0qUo4NIhZxEd14MSXVURfIXdBQXqutFCjQCy0oW
         FM+WaPlTPscLb6g+CCWKlh727HJie1qFYObqEA/Ut2mPjiGJ8z3vsmMIpKgJYqlCh34Q
         PvVPpBz0L6rgLLSZtDCXSOo1BwO1VeXl7dnvpR8wOv+7AHqRVZmWRSzSh7sqbS4Ah367
         2UWw7vFx30xLtR+p7MBPLKvaLCbyCTZ9TDBmOP80ZP3SW503A+7q3TtywcSmRuv+ZIbn
         lJE1kVPwirV3Mq3KyPT1HpxDlqtRmXX9QNaGqv3j5TyeNvj0Oa8QRScXfNJVEsTEOaFa
         rItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BHdzpaRs7gnEiWyZVk5LkyLac4zLwGguwspYIDJHqvU=;
        b=G3q8L0yJZTpHOG08s92yJjI14lJNylaWABbJH1wQicq0csq39Z46mxg52MUgObXndL
         BYqBPemrXyUwaJNgKUB9uDHy5kpSguo9EywEH8mrUKl+4hd6jjS56gpRtXMKPAtBY+S1
         y8Sq05CvqEqRgwsYZAhGr8qooe4IwFjzJnpNnnAtObtdX0wo6912gxXrfWO9UMppF18s
         IzvfGpMPyiPhVbBfRZJCRCEt+bxkFkXUXqqH+4kLBvu7yIx1yTomWYKKX0blQ3NeJuiN
         8yiapFcBm+MLYL1P5k74K1KbvWKKKVCzSQPc4h/vpEEjRa8dIwN+88oXk9Q+PEFQyPrg
         LGhw==
X-Gm-Message-State: AOAM533cHy8Q2Kx1U4YA8BVHO4k3JYf2N5jtix1e0Jr+I+T10JNFEF5h
        PNc19CVGgciYSSvIi9cfhwn+ysFBOlg=
X-Google-Smtp-Source: ABdhPJxhSmcW61b4c0rWvZHqsmwnfJpGPrOn6U+Y6KJEyA78b0jWQQmbTX+TbN29NyWjAbNd0TD4IA==
X-Received: by 2002:a4a:e3da:: with SMTP id m26mr12602579oov.31.1613970748041;
        Sun, 21 Feb 2021 21:12:28 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id o18sm3283065ooi.16.2021.02.21.21.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:12:27 -0800 (PST)
Subject: Re: [RFC PATCH net-next 02/12] Documentation: networking: dsa:
 rewrite chapter about tagging protocol
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <50f2bbbc-6f25-e36c-1cd4-0f611e665c9d@gmail.com>
Date:   Sun, 21 Feb 2021 21:12:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The chapter about tagging protocols is out of date because it doesn't
> mention all taggers that have been added since last documentation
> update. But judging based on that, it will always tend to lag behind,
> and there's no good reason why we would enumerate the supported
> hardware. Instead we could do something more useful and explain what
> there is to know about tagging protocols instead.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[snip]

> +Some tagging protocols, such as those in category 1 (shifting the MAC DA as
> +seen by the DSA master), require the DSA master to operate in promiscuous mode,
> +to receive all frames regardless of the value of the MAC DA. This can be done
> +by setting the ``promisc_on_master`` property of the ``struct dsa_device_ops``.

Nit: may require. DSA_TAG_PROTO_BRCM_PREPEND is an example of category 1 
tagger however the usual (and only?) DSA master (bgmac) does not require 
promiscuous mode. With that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
