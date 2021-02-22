Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B613321039
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhBVFWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhBVFWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:22:15 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC255C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:21:34 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id j1so857216oiw.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x1fW5ZByoWL77XGdGIwBHMhyqj9oarKnPYJ4qfMxV5I=;
        b=oG1bHstsiOOX7P+Xyg0dNEqsySX3Y6PyTZZLdAWkytB9RQj715b2OBfvoXV3l1DekQ
         TGZ754bJirK77UXIIJd39kYXo5CdXRHjd4T4tHfareau2SV5RarF/yq9Klr7uhwheq0s
         CaqjsOHqyNd0Mz4u/VEU6ovgkCEfyBKz9Rws3nfcsTD07nirl2xEuAYcpE2f+KnS+029
         vmsYxqLXMPlAD37KFvw/VeEQLD4V2u8D4/un7hq5dba9L/9R2VshJ/GGADmElr8xRPb3
         xmSDfeeeiDd1NNgFnfRsFree0s1g7DWnvuN7bxGAKpTOgKOe35cPYMr4u1cNtxGf79Gf
         La/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x1fW5ZByoWL77XGdGIwBHMhyqj9oarKnPYJ4qfMxV5I=;
        b=hHR/zzMPWNOSl1nVDuGaDVRX2hTC0/8uwR7UjmQN6QYG8wnZEoIsWwX5OQm1VyKaOQ
         AMddn57fdvEZoQkAO5aYR194sIwqH71qoout4eiJuzovnVCLXTIi+PyxmzLXzleNg004
         Gs3vzAV3g9FFMazmZkvSW5r3vG1xC7zJxul9mqhDIBg/cmTJLfvghmHtQopH1015iQCO
         Dir5vmGGO3snuWzQ7XfCHB4IrpWHuR2LQSL6tTFpZ4Gq+6hP9bwTo05p35awVmvkCJpG
         2NFE7O4XNdwx4RE30JmhjXesgsjv0ELfDgvSGLCMcbnI8SZT1S26SefBWgkSZMory3LS
         K0cw==
X-Gm-Message-State: AOAM532ijQb/r4L4AE1xoPeVu5/DCE+b5jtyM6PoYacI/VeEIbBsJyXW
        eZcvKywX4kbBW+WTiZulZ3g=
X-Google-Smtp-Source: ABdhPJwMi2qodDrqS07qx7hLydF+2IRvzVVt1Mqs8xpvzZlfd4NBdS2T2UPoi5LySwkcuwUEKCHbRg==
X-Received: by 2002:aca:1c08:: with SMTP id c8mr14515919oic.7.1613971294251;
        Sun, 21 Feb 2021 21:21:34 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id o20sm3274378oor.14.2021.02.21.21.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:21:33 -0800 (PST)
Subject: Re: [RFC PATCH net-next 10/12] Documentation: networking: dsa: add
 paragraph for the HSR/PRP offload
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
 <20210221213355.1241450-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6c5e405c-782f-1959-630e-08f5492f0ccb@gmail.com>
Date:   Sun, 21 Feb 2021 21:21:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for offloading a HSR/PRP network interface.
> 
> Cc: George McCollister <george.mccollister@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
