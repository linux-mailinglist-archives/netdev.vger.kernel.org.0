Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8422CC36D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgLBRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgLBRU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:20:59 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F2EC0613CF;
        Wed,  2 Dec 2020 09:20:19 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w187so1658829pfd.5;
        Wed, 02 Dec 2020 09:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7KHBQ3FFeij6nIYULiVBIitM8cmj2kd6+hLkh1RP120=;
        b=SS/ZRs5HJXTkuR6dvNByKk0HFgHQqi3m6fLygjAw94+hn9b+dy1dNNksvgQOfrN6HT
         Gr861/VrvFvYamM4Ak2S7uYfgoxAaqCWK0+M7zZq3YsNCDMHStBfqm5WUgkx8yBVQwLH
         DnJXP5AxJUXwxdkSXbRV1Osl9CGsZLZHG+MbyAOFOFN1dm9/pZk8J7VEfBZaLXW9PRpN
         sp9B7MEIjjiBS6FOGcQebYfVLRHmvkhFipI7iCxXBaEFZExHOUOTy+qjm/30v82J+1p5
         N8xqkPCy/dfPUWsX0acdCHdWRd9qMei6frD8sCdC0uAEW9RwpZlVX5m279WTBodODKuR
         kVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7KHBQ3FFeij6nIYULiVBIitM8cmj2kd6+hLkh1RP120=;
        b=TEtEJRRLF2v2fL6hFDrjqwjPrBsiWXkAYG0yNLBLkJWbMnwJyP7+dKzuM2R1WvS66N
         9Vgrv7UZ2y+EtN5d8GIv4lisUGuWGtajbKlL+Z2YyqHJcZTXk+njJfUNOxGuctdA5AFf
         qeOv27hlLkRCpz/upKZteYI6vUiJxcqIQDGsZISneETwip6FT4jEybLaqOlfxqxgBOrz
         fP2Ixeprs29+XPV1Dxyvx6VmpzlvRMhTD2Cj12zps6OW/AOgLYSR/xmZNmzNfWGWxyJL
         OC9+IKWMCWJbQ0Gg0y8otT7o8YF+VbWv7wGoKiC+B1cAl3Fn21dWsOnHXaiaZw+zqaIi
         tGwA==
X-Gm-Message-State: AOAM532GOv0HlcQrIQ0hohz26Tgw8PWsSn20YEN+w+8Y4fOP9PAA4OcQ
        t9ZbRGSRgmwOt11XeCvjlMXM5/uTn7E=
X-Google-Smtp-Source: ABdhPJyPQf708bK1Rt6cKi8o3NdZVlvrMD4oXan2bkr4uGiuP1l7dOpoF6g9mLJ8vftX4INaTQknPQ==
X-Received: by 2002:a63:dc44:: with SMTP id f4mr229627pgj.281.1606929618394;
        Wed, 02 Dec 2020 09:20:18 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j24sm303893pga.84.2020.12.02.09.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 09:20:17 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02693387-8bfa-f105-26de-69fc21e93c65@gmail.com>
Date:   Wed, 2 Dec 2020 09:20:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202140904.24748-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 6:09 AM, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>


Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
