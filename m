Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3954333A230
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 02:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhCNBjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 20:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhCNBjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 20:39:37 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5897FC061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:39:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t29so4383851pfg.11
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dvnJuWNIGHufSsYVK/nUfhwbUOnRCWqU8lhxVL+Ckwo=;
        b=o1kx7dpwfZilMY9tQl/H1E+w3+bTOCLxXzQGEZ1+D3VeK6tAVCbCIDVfxcm3izGC4K
         TqeCyeu4bqexPnnc13I7VrdI+Km8RlmcB7mn057DzMO4j+VVPztf02X0Y6lZ7abSZ5RH
         RMmJ3AFq4/fH2cjpf5p5DRjO+csAe4FxS8GuXMKpe3A3/WwH3CaGYct9mmoaICwBEFiP
         qEX3CVkM9Abghkda86i95LiSky2QTvTFQ/mPr0Yt/8LT8pPJUMH/9d702KtnbwIKoqk1
         jcAQ3+GS4jYwMiG/sCzVW5PqVGuzRQpC7TqN5n/YKYKXMot7L3FJqTRKHblpZ4D3dkZ6
         QTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dvnJuWNIGHufSsYVK/nUfhwbUOnRCWqU8lhxVL+Ckwo=;
        b=LL2PW7dQjV7a+iyyvpaLariiXbJBcIGr5nPYNBmNs1XgURgoheNgk3GTJeDB3FhKMd
         DkR8CtVOXzLnbGRPlVEvCmI7CqL0afWhmUHOEuKcyG0slnDgCMGAmjZ6bH0XFm4ykjnj
         r9x255hGnVT3ThlpsU/GA6hpxKMz4zq/AEfJVIFzjT0wrl87349Vj4ZGPEUOBtC9+7LF
         M/r8QdSR5yc7LAmJQQ4dH5bIwEirWtQ1TIAP/ah0DLsIgI+QakQXffZnvwoU+Y69c7xh
         Z+ISBBzBKGHfbU131FOUdrPhGj1CraI6sMw2/TbUAS+m1fgIsr+/0gje1j1YFrYaow+D
         P7OQ==
X-Gm-Message-State: AOAM5328NkB+Gne6XM2oSdI+XZgDSF+1d/u/CxW6Rd/xMg+uGnGtwpi6
        eHPpsVmp1ye5FbN5unLkAnO9spjPucM=
X-Google-Smtp-Source: ABdhPJzPeUgh3VOWNek9M1UYdgmCMNtQXNTNBiDle0lQ0kqGsbiwagfybJOdcDZQ05Y8f9QbC4ZwZw==
X-Received: by 2002:a63:b60b:: with SMTP id j11mr17636118pgf.19.1615685974386;
        Sat, 13 Mar 2021 17:39:34 -0800 (PST)
Received: from [10.230.29.33] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm9277239pfc.81.2021.03.13.17.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 17:39:33 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/4] net: dsa: hellcreek: Use boolean value
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-3-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e83c56b5-8a9b-0273-29a0-b60bc3097540@gmail.com>
Date:   Sat, 13 Mar 2021 17:39:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210313093939.15179-3-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2021 1:39 AM, Kurt Kanzenbach wrote:
> hellcreek_select_vlan() takes a boolean instead of an integer.
> So, use false accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
