Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2602B428552
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhJKCuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhJKCuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:50:10 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE230C061570;
        Sun, 10 Oct 2021 19:48:10 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id o204so14550124oih.13;
        Sun, 10 Oct 2021 19:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rB0jy0vpwiblrk5yT433/gDQBNOVLb3BwFhWsJbyq1I=;
        b=mhSp5Dc+49JylgRxtvz4asKc2ISrC3yhOrDucsQbPqBGDhPqR/+g6l3OeA7Q+21jMF
         zij7cdztCwxGWUa4iKncEbj+Zw86x+C8mll2WuiNYV/gpi1RsF+tw6X3xQq+w88+6OHe
         fPccsCiBzFmrQ39j+xKo/4BZfFESJf+Rt/UE5/PxUfVFdgptEZ7ti1E5Th6jYW7pTN+n
         ZhZxzrCnp8BTB36RssQFAZQA5+nG/9u1mSTr976YJDx8f6buTxYT5XtvDsk8c+jfKcWJ
         bl9mdrzsa+yIln1jIuI/7xX93fEULFyXMioCR3+JB4u8FU58kRyUsX4kErWbip3Y5HAv
         +7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rB0jy0vpwiblrk5yT433/gDQBNOVLb3BwFhWsJbyq1I=;
        b=El9P0Em04LXIJ+IhAt43Z5TEp/XhfzzK3V/2kC6RTCXghaeoTTOfRTF1nGjgEB9wky
         GvanAPectsaL3sFFa+oSJq34UKzx/15kZdEu6tNzdDwwLZdiA+RX4KfeJMoO6V5W36zz
         C6tVimH7HWhgV8eBybjn+b9djsZeeEWiT7NbaHI9+5HKIyJaEpbw4sAk+uMqJYViGXCr
         oeHHx+b2XvRxbx09Pz4xCTYpuruFjE9nPRXH0GGCqo/auzoAGB1oECNqcwUwAng7+FKe
         RRK6W6fnkNZ8OJ9+7V9Y6VY4IJ1A+ISPMR6KS5GgmUKhcjLU90ZMGYt4CWpDFLJyiS3O
         n7RA==
X-Gm-Message-State: AOAM5314wTQ0StpUY+Rr9Px+ZYizma5KHPXYo4xuLFuFWbZmv+VtPSM5
        TVOdeJi4r5KLPYw+BkHs5nA=
X-Google-Smtp-Source: ABdhPJz/mmu0Z91EnDCm2evuxGNVKDWJG4WnfpHMev7fmxaDdvLnLnAqszSzDdIJjgTB9b5Gocb0Ig==
X-Received: by 2002:a54:4d89:: with SMTP id y9mr16626296oix.22.1633920490258;
        Sun, 10 Oct 2021 19:48:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:3cb6:937e:609b:a590? ([2600:1700:dfe0:49f0:3cb6:937e:609b:a590])
        by smtp.gmail.com with ESMTPSA id c9sm903323otn.77.2021.10.10.19.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:48:09 -0700 (PDT)
Message-ID: <484c3594-910d-eacb-6844-88a8ba9b7b3a@gmail.com>
Date:   Sun, 10 Oct 2021 19:48:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 10/14] drivers: net: dsa: qca8k: add support
 for pws config reg
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-11-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-11-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Some qca8327 switch require to force the ignore of power on sel
> strapping. Some switch require to set the led open drain mode in regs
> instead of using strapping. While most of the device implements this
> using the correct way using pin strapping, there are still some broken
> device that require to be set using sw regs.
> Introduce a new binding and support these special configuration.
> As led open drain require to ignore pin strapping to work, the probe
> fails with EINVAL error with incorrect configuration.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
