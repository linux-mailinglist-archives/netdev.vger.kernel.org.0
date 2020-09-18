Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FB92706CC
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgIRUR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIRUOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:14:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9353C0613D2;
        Fri, 18 Sep 2020 13:14:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id v14so3577730pjd.4;
        Fri, 18 Sep 2020 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IvbpL2kRFTPNxXj1C+N6SPyFmZryvUU4YqZvGmqgRFA=;
        b=IJhVRUA/qjrWlGaO2xpKEsecyOoMvKcv863pEaFYqycBIaYKAXvBG335Zkl7E7lZqC
         sIVv7kZTgibOAPpjtAELcS9iOD0qarEqexKBCHuGCBpxZQW+dEW6+VR5h023gEyyQmtR
         UQ8uSoZztJ2q90JA6wBh20f/7uxi0tqgBH29hyv/yZRnqeoUUoX4uMPitlgP8sRhDyfm
         FzuC6gXvacMhEpd85kLcjyTOEmXUutLX8TMh4e2RK9GxpRYHE+1hUmp3pZdW8Mt71+bZ
         5u5AZVzMDhqJcGap+MmdxzeZdr3mBmU2b3o5DOL6ZK+GPlkYHlTKsjHafZH8L/raV9q7
         4J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IvbpL2kRFTPNxXj1C+N6SPyFmZryvUU4YqZvGmqgRFA=;
        b=GpcQ3N+mmVZBNyQV5r0kXtf80juiMBnpyNNzPKdHzha+LIFbREReHXchlsmB1UDhOH
         kTy6Am5ABDmd/BTu/DE6tWGCrdJ9gDz5i72Wt4MiZ3B4w6TF3fuE4rWvPKfyzuHG0i7d
         0hPpSvECCqs+f+4i2yvHe52Ab2kca09yDdJh2JUlouKe5QPhJzRzqg3HJwr1Oevdw57E
         gKWAX833KXePV1qFUNxBgxaN7i0rEd1uoh8PQUa60pT4CjymmSqjPkQrQBPGAbaraZNY
         10jYR2TymkY9lTIQyEJE4nhxWcbZrvWzOkTForj5Vn4WDoaSezDxuwYG8b0OI7DArRDQ
         wwjA==
X-Gm-Message-State: AOAM533YrIBVB4Tyul47AaitmXvkPK2Kt9kioWWwdwFBt+AKavzFkSNM
        U6rn9fbfnFLMHb59o26MldluhYzmxbTdbQ==
X-Google-Smtp-Source: ABdhPJzHRQ/hHUcsgPAgbWWw7Bk5MiJqqml6/j7xIDTjp4RPMHiusWWxUHDNcr++oDYVrqXNF1ev7Q==
X-Received: by 2002:a17:90a:49c8:: with SMTP id l8mr13903352pjm.24.1600460089114;
        Fri, 18 Sep 2020 13:14:49 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj6sm3603465pjb.10.2020.09.18.13.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:14:48 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/3] ethtool: Add 100base-FX link mode entries
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200918191453.13914-1-dmurphy@ti.com>
 <20200918191453.13914-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c0d54d0d-8c60-e0e6-ade2-b06737a31663@gmail.com>
Date:   Fri, 18 Sep 2020 13:14:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918191453.13914-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 12:14 PM, Dan Murphy wrote:
> Add entries for the 100base-FX full and half duplex supported modes.
> 
> $ ethtool eth0
>          Supported ports: [ FIBRE ]
>          Supported link modes:  100baseFX/Half 100baseFX/Full
>          Supported pause frame use: Symmetric Receive-only
>          Supports auto-negotiation: No
>          Supported FEC modes: Not reported
>          Advertised link modes: 100baseFX/Half 100baseFX/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: No
>          Advertised FEC modes: Not reported
>          Speed: 100Mb/s
>          Duplex: Full
>          Auto-negotiation: off
>          Port: MII
>          PHYAD: 1
>          Transceiver: external
>          Supports Wake-on: gs
>          Wake-on: d
>          SecureOn password: 00:00:00:00:00:00
>          Current message level: 0x00000000 (0)
> 
>          Link detected: yes
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
