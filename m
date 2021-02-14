Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC031AEA6
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBNBTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBNBTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:19:42 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6EC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:19:02 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d20so4054212oiw.10
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pTzRChob67T6AhG9Vag8qO9PE6JiXcZZbxMd1aGPhlo=;
        b=Ll8UKvxKOr4J8KGFqVIpSHbQp2pum/97HLiucn7e/ZRZwoc1r1ce6rZ3ISOPaXFyOY
         LwT7QkpEQSB3WxIwWEwOyRx2SjhWYf3XWw2RtsfPdA5FfUiakhIW+hkh3Gr6g5pQTUcG
         Gl+Re5cmCFXLZ2/PODohpYHYquqyVohYVZ+yCTlTDLjM89ffvPtNJnX8YcySL9ZgHrqQ
         lPLhybiswKjwuwKsDHJA/2D4UrpPXgFnWN2tHBMPR4s7ZiHO9RwlTfyPuQZde/opSDEh
         aSLdSFx9uQOmY66NtOtGCGWfoXrcQf5lY8vPhEAsD9VIyZPqvTURc0RfvpMMpNL40JIs
         ZJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pTzRChob67T6AhG9Vag8qO9PE6JiXcZZbxMd1aGPhlo=;
        b=nVWNnF7bgx9JUdb4e6KRB/5P11nrOXMFc4xi6d5hV8zTQ6Bibr6rAC4qAOxF2BH6tr
         N63aawhJ5FEV76GgVRHoZ5AAivrXUxHu1A9T6M4dgangmrrF6RHPMf8QkOAqk615uq6L
         f2bMHwdEBo1RmJHluRd2J/I3gYipolUfUlqaCB87aD9uPd7CvPBHUKU6pxDTAgOBODPp
         r/Dll42sBybTSeKm8PIqyFvBt2DzKcN7mAUBnJ7PaAQebXVviZNpp1dnF3rbJ42om9wF
         FoBfjyq4gfxgtRY9XO3LinfEa9G/kXab5pg48IfsyAbb9Z/amkJaW/6G7Hs5/lyoP1Ek
         fZ4w==
X-Gm-Message-State: AOAM531qrJeJFqP5UllIImxwrTjvrZEFPqsrIN3pGeBxpYAF6Sne8gdt
        y9YmLZmMjRMBU0u3wQwzmaU=
X-Google-Smtp-Source: ABdhPJydnfH+QC+JxgA4ZDvVvzuJnBnp7YgdYTZhNAOqPfMQN8iJKfyuHzoC6l/6+ZK7hxf1YKVrvA==
X-Received: by 2002:aca:4e8e:: with SMTP id c136mr4296747oib.173.1613265541519;
        Sat, 13 Feb 2021 17:19:01 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id p13sm2650920oti.6.2021.02.13.17.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:19:01 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: sja1105: make devlink property
 best_effort_vlan_filtering true by default
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210213204632.1227098-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2dd5efde-0188-e88f-7885-3ba10ea0358c@gmail.com>
Date:   Sat, 13 Feb 2021 17:18:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204632.1227098-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:46, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The sja1105 driver has a limitation, extensively described under
> Documentation/networking/dsa/sja1105.rst and
> Documentation/networking/devlink/sja1105.rst, which says that when the
> ports are under a bridge with vlan_filtering=1, traffic to and from
> the network stack is not possible, unless the driver-specific
> best_effort_vlan_filtering devlink parameter is enabled.
> 
> For users, this creates a 'wtf' moment. They need to go to the
> documentation and find about the existence of this property, then maybe
> install devlink and set it to true.
> 
> Having best_effort_vlan_filtering enabled by the kernel by default
> delays that 'wtf' moment (maybe up to the point that it never even
> happens). The user doesn't need to care that the driver supports
> addressing the ports individually by retagging VLAN IDs until he/she
> needs to use more than 32 VLAN IDs (since there can be at most 32
> retagging rules). Only then do they need to think whether they need the
> full VLAN table, at the expense of no individual port addressing, or
> not.
> 
> But the odds that an sja1105 user will need more than 32 VLANs
> terminated by the CPU is probably low. And, if we were to follow the
> principle that more advanced use cases should require more advanced
> preparation steps, then it makes more sense for ping to 'just work'
> while CPU termination of > 32 VLAN IDs to require a bit more forethought
> and possibly a driver-specific devlink param.
> 
> So we should be able to safely change the default here, and make this
> driver act just a little bit more sanely out of the box.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
