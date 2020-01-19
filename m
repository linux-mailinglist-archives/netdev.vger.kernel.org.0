Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5752A141F2E
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 18:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgASRSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 12:18:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37550 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgASRSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 12:18:11 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so12376015wmf.2
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 09:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3DFFJ9yDFjFizPiAxsOOSE6hwi2X0fhR5N9HZt3YgPY=;
        b=kEGXP1mgiQIoxoBgbvpjQlMBLs+zVGPzE2kWaIP0JUmxVWT5SDnBfugAvstPmdmTde
         7cbW2HapSg2w+LSOQffS8OZwVqA3VJyetzlLoQtkUf3JjdUY5Hm91Mz87uO0/nS0f3Eu
         iRlsB7oRel5UVIvXMzumvUXyrC6+b7NLzWrALIP9S4Q1PtuUj27setuNLx+L+WXpWLfQ
         Yq41bswk8I333XPUFE+fWXaOTeeIqNw8t1IiU1foWhslshqzx3V1URFmqhgHLPvJMe2/
         wSikdTfYSpC8X7Rdvj6PJm/kvINluoReLQV/azcb2G+y12xp9sxd8rGGQeWfPVfI4yg6
         11lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DFFJ9yDFjFizPiAxsOOSE6hwi2X0fhR5N9HZt3YgPY=;
        b=p1d3OHh5FPxs0IeFzMfA47gEzLbefwxtrJsSdy5yBvkQXCa/kW/PxvZccAWflSEIc0
         nR6GHYCBcXRS33ihgUdldNPMjH26q8JSaebw2UZ4vP7ATXQ9sUZcMqvPlvIZyM4nhyRR
         X9HXVc+kcb9rVD1G4nJLbAUuhOpfPAHOjAuoBl/KQhhcd7Ga0uebrbYPY9m1WdTR86jw
         Iv5m/1QU4Xhs2VHs5W3uqdrAUz4YG8+vApZu4CWAsUAenDnQ+gWANK1i4VRe+QHVFx6w
         1El3Z1kmV9FYn5sZw+Ywr+93rkdL8uU+sq1HtZFfFNhbQIqotZ5/O3CfuZfJNxcvMWxg
         jW+Q==
X-Gm-Message-State: APjAAAWQtuj1JwBwpTjUAw5PI9WsT5CDULqxYvrC3g0pzh+rsDE3DkoT
        qIqSAGx76vHErD2UfuGGQ/5Bn8Z0
X-Google-Smtp-Source: APXvYqyiGYw7ZBEjxorce65q4szSxN03luVIyuD9ygjKXVXpydMSL7u8EOzEw2RjvZZPvGKnLr596Q==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr14815035wms.152.1579454289583;
        Sun, 19 Jan 2020 09:18:09 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id b68sm19830182wme.6.2020.01.19.09.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 09:18:09 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
X-Google-Original-From: Heiner Kallweit <hkallweit1@googlemail.com>
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
Message-ID: <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
Date:   Sun, 19 Jan 2020 18:18:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119161240.GA17720@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2020 17:12, Andrew Lunn wrote:
> On Sun, Jan 19, 2020 at 02:31:06PM +0100, Heiner Kallweit wrote:
>> A number of network drivers has the same glue code to use phy_mii_ioctl
>> as ndo_do_ioctl handler. So let's add such a generic ndo_do_ioctl
>> handler to phylib. As first user convert r8169.
> 
> Hi Heiner
> 
Hi Andrew,

> Looks sensible. 
> 
> Two questions:
> 
> Did you look at how many drivers don't make the running check? I know
> there are some MAC drivers which allow PHY ioctls when the interface
> is down.  So maybe we want to put _running_ into this helper name, and
> add anther helper which does not check for running?
> 
Almost all drivers have the running check. I found five that don't:

*ag71xx, fec_mpc52xx*
They don't have the running check but should, because the PHY is
attached in ndo_open only.

*agere, faraday, rdc*
They don't have the running check and attach the PHY in probe.

So yes, we could add a second helper w/o the running check, even if
it's just for three drivers. There may be more in the future.

> Do you plan to convert any more MAC drivers?
> 
Not yet ;) Question would be whether one patch would be sufficient
or whether we need one patch per driver that needs to be ACKed by
the respective maintainer.

>    Andrew
> 
Heiner
