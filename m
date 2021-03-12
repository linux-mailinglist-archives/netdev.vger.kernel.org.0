Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8933949A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCLRXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhCLRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:23:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02F0C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:23:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d23so9019321plq.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+PlA+w98tZfxzKgBhTCiqEjwKZyH1oH73GVfGF+2zdE=;
        b=ko6l+EAOLMX3b/YqqGo19XdI3W/ZD/uA6iZA1Lj45q8nEH8WtH5Oi0ydwXBOYOdyjJ
         EoHIedhXQXyZx4uWRlgA/6A0qP9nvXx1kZuz1ctZB333QDUXZGiWyaCkSHj+dNZhkRck
         XXyI3hq6terC9cpcFLNwYCZ8ElRcjmL+xllYvfXvUqysxTKjpi2tW+0diJwln7NEyce/
         YrjvNhGH7xX/3V18EiIOh31i25FvFN6pqweN1znN0fAaAFiI2/MchmvxlWxi2nXbRQ0o
         tPc+LoBQPINmaVhuiN4xIdgL4isrrjzDfx1HynndW5KQwEjrMldlbX4uKBw8JjC6DD39
         gOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+PlA+w98tZfxzKgBhTCiqEjwKZyH1oH73GVfGF+2zdE=;
        b=h5AHw7xt1meYod1Rtc+gyMa9916KaDCms/ZR4PM7f5ZvAqobizZTwA6fFkb0IIzZ63
         6CEC2rSIzzYtQefi1diiaeXBRoVRMzY7Mg/5R6kBa9yARwMP6Bu8qS92kHskZxi09eUS
         Y95mgdrZUJR/HaMNivAeVp45dmOsC62GRlGC5a0i1Lfin2RYPkmLFqYrieewEiwXjxJO
         Dh05ez/ZEH06//43UZSJyj9BQV3uRE82xW/w3cIwHWHjoDaUbGXDiXgWbWgmR5K1wUbE
         ZPU5rNMA5g2MvOPRVmTqYNT9mE3a4MIyZX15niW0kYQYadBVEcsO4V42Zh8yDs7Nywy3
         NF1w==
X-Gm-Message-State: AOAM530AjHj48yJ7IFdbJAHJCHqf22IELy+k69ss2KWTYcW6qB/MtrNX
        /XUc8rYjcrEOZuPWtLQxYNI=
X-Google-Smtp-Source: ABdhPJy7i1/mHt+MyNhnItpMFZdIYWrbVc+N6QEjKUSBZDdt39n4GgaUFB+IPZpuexw/qHNb4M3AFA==
X-Received: by 2002:a17:90a:ff15:: with SMTP id ce21mr15225131pjb.172.1615569782370;
        Fri, 12 Mar 2021 09:23:02 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 14sm5977205pfy.55.2021.03.12.09.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 09:23:01 -0800 (PST)
Subject: Re: [PATCH V2 net-next 2/2] net: dsa: bcm_sf2: setup BCM4908 internal
 crossbar
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210312104108.10862-1-zajec5@gmail.com>
 <20210312104108.10862-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dba93972-27c2-116c-c188-7ddb41eaf02b@gmail.com>
Date:   Fri, 12 Mar 2021 09:22:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312104108.10862-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 2:41 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
> crossbar. It allows connecting its selected external ports to internal
> ports. It's used by vendors to handle custom Ethernet setups.
> 
> BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is used for
> connecting external BCM53134S switch. GPHY4 is usually used for WAN
> port. More fancy devices use SerDes for 2.5 Gbps Ethernet.
> 
>               ┌──────────┐
> SerDes ─── 0 ─┤          │
>               │   3x2    ├─ 0 ─── switch port 7
>  GPHY4 ─── 1 ─┤          │
>               │ crossbar ├─ 1 ─── runner (accelerator)
>  rgmii ─── 2 ─┤          │
>               └──────────┘
> 
> Use setup data based on DT info to configure BCM4908's switch port 7.
> Right now only GPHY and rgmii variants are supported. Handling SerDes
> can be implemented later.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
