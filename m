Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160FB3A4B39
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 01:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFKXbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 19:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhFKXbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 19:31:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F80C061574;
        Fri, 11 Jun 2021 16:29:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q15so3626456pgg.12;
        Fri, 11 Jun 2021 16:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vfb32CW3letaMLJHXeIHTJ3ceXe5bQNSjVJ58Gfn1MQ=;
        b=UmeloGWYT75GJ0LlcGbvqx2p1rEjMqEypI4N1Uqz8f4orlajVIZGZShgV78iz2pB5m
         KT2jz1ymn7ukrqk7ACFc8eJVOhQOr8SPk6GKhwFTRYFFgQOWPecekGnff0rvxGcnGbJw
         uYdJ9gRaLJMLdpONElIyItCUKjyxag/XHo55IHZBLsjofGtP9iAb+UXIMD6KBZFqnUCy
         LKVbN8ORVatf47Zm7eulBxfw2bR21FnCv+R2NvHkTb2NA9+bH28+Z/N1f03t3JRbyZ8W
         qcdgLrfilkeH2WmtfCFNDLfYstrtLjd4NBocKYY+AZ6gotK/4SLjLKm3E+wY0gQXLqry
         6toA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vfb32CW3letaMLJHXeIHTJ3ceXe5bQNSjVJ58Gfn1MQ=;
        b=f2SB9c8SF2nMqL9Vd1ALfl9Su0UUWohy81IbvoiEQOPU7cAYC+WD+c26H9FJ/czUqz
         KmtMogyK6kINsf/JQ9KoT9xP/Ky7YYkAldPxhTP1x9tBItrCvdFkofpgupbNJ00OwgFZ
         BWNybvye//9hSNwUWlPpIcvDE/l/QDmG6KPd7m9mFetx4wZZFSTCZD+4Pqix+sgiozdC
         olYIK2PoxRLPtpVspZ3wRXdCRADh6rZCnTE3JkiZRkHgcCItTrGzk5fQB4FehHAsleR5
         C3x/AM3vpWYWTp1UvQ0pA5ykujlN1PcI9wQkJ7pkGAOdda12HEmbNlWqVRikpU2w9dZR
         rwuw==
X-Gm-Message-State: AOAM5330VkPkFJqz7glMWI+9SyP19cxTaSqYVOMvD8mk7O+/pKuiI0up
        5KdOWbSfydHa5utPorf55g8=
X-Google-Smtp-Source: ABdhPJythpWperkJW1bUvE1kBhDJNUREZsrhH0V7vAei3eV/Thd5ihwIVmCtPjE573iAnSGPpWO+kA==
X-Received: by 2002:a63:dc03:: with SMTP id s3mr5931935pgg.354.1623454139844;
        Fri, 11 Jun 2021 16:28:59 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s13sm6292801pgi.36.2021.06.11.16.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 16:28:59 -0700 (PDT)
Subject: Re: [PATCH net-next v4 3/9] net: phy: micrel: use consistent
 alignments
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c34f41c3-5a63-d501-7ea4-425d4fe9789c@gmail.com>
Date:   Fri, 11 Jun 2021 16:28:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:15 AM, Oleksij Rempel wrote:
> This patch changes the alignments to one space between "#define" and the
> macro.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
