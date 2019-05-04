Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53BC136FC
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEDCIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:08:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35375 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:08:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id t87so3215697pfa.2;
        Fri, 03 May 2019 19:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0V9WHYLf/+Gtbh4WFYNlIORvJKcTlOIjOihcXbRsuk=;
        b=q49Fd9ajOPNvGtE79jzdIov48UYeFD3rr2D55J707hmlYy0NSYJ5yhTMCucmx0MCEH
         NGhKBRXSQ2h+4gmzJ2zVQPiQnysiQoJDEhlObhjFLdZ9YZdjRog52sJs0QUY924HxJY4
         KKKceA8erlFBO6hnsU/Nt0WsCWvEVqercw5+Kiw+Nz2N9YNPNu1DMOCmDd10klfN8jLq
         D/WU3NeSvV80z1MQfXkJP7AB2fQKCKwLEw2hlWofZDLh2sFdzyXl/mGkq7dr1nBdN0Ii
         X/Z5qAiUH9xYVwQ6xr0aXCJ2kBmRCc5SJf8lBpJaAjehdTQ0RHTsZc2k4VO1aLgZvldN
         iaIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a0V9WHYLf/+Gtbh4WFYNlIORvJKcTlOIjOihcXbRsuk=;
        b=ey8j/pS2tH0Uc3Ulrr0k4OAJR61awT4ypTTw67KERzAZMpYVPZQmJeLZ5mKJl/b4cy
         bMkuDjUdq9pjrWV2ySZ+wlO8YGxvIyx86djckJOLP3irKkxmPyh8EJLsPoQjHtvAfbjI
         trfrE9xIYS1gDU8eNyTpZlJzlTDbzDEKlI/F61acBeqpNiEEy5HwnAOr6Sqh2Jinnu6W
         +UbFrEd0m7opYefVpOsuEzqZjWYEmDY3UNZGbuyeBK3Dslmof//gUVjsRukFUn6YsTf4
         4RTv+V8U7m5Nw0bBm8EUy3Zigk7YGUAYrZRQX+K8JVFlfu92fdOSv/Jbkf3F7ziHnlYH
         fZpg==
X-Gm-Message-State: APjAAAWjRluzMFPWKkzIkrIVlGl2txjbtz/BVmpQbwTnCZzBIR5oXvam
        FaczNKPepr/4cwEDo7sl4uBiazVd
X-Google-Smtp-Source: APXvYqxNtvXLSPRjJBL0vw/kZjM8jgTID8LSc2pIDfM9CwA+CFR+KlwWT3rnMuIOOG9NSoM4C+Px6w==
X-Received: by 2002:a63:e550:: with SMTP id z16mr15039321pgj.329.1556935695593;
        Fri, 03 May 2019 19:08:15 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id f6sm3805085pgq.11.2019.05.03.19.08.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:08:14 -0700 (PDT)
Subject: Re: [PATCH net-next 6/9] net: dsa: Add a private structure pointer to
 dsa_port
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3e2677f9-e372-c7df-5b05-815e1e0003f0@gmail.com>
Date:   Fri, 3 May 2019 19:08:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> This is supposed to share information between the driver and the tagger,
> or used by the tagger to keep some state. Its use is optional.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
