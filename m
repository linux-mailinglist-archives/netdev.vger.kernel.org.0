Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4843C142072
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 23:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgASW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 17:28:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43326 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgASW2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 17:28:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so27658820wre.10
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 14:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1BC7st0GjfHOGGzTf6K7776HWzldwCgwVETQHZ2nxhI=;
        b=Xamzi6pp+UfmhK1W/UBF1wYNVBWhn7mUXBgp7v34mZjlJ22rGffDQGaxn3i3yeEDY7
         +74w2+C4uxgKs+k/7GgTlPp5FuuyrtfgKHELrM09SpCeuRMsyt/bfRv7q1E1F01orMlT
         iktXziFd+TCNjSeH883q0/8DT9hyt4sVZdmIHLKux29mn70PfTNXdFDe2B116V6M6fM/
         iGA6mzPrH8l/RUtiKbax470vrrTPQmGXz27z3K96em0oMOXcinw8Skk7oxZTiyh+jSjb
         cLPeEfQ0WDpCMHGPoHVvGgSurGtZ94hhtqJxAAsuhCiuZSE+th08tDkpK9CoL6ygjp52
         ThrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1BC7st0GjfHOGGzTf6K7776HWzldwCgwVETQHZ2nxhI=;
        b=L/eCh13wzy7yzn7wewidQ1Mg26Dt+g3fbXIbXjgwYs2Muy6ccIIeVQI3IIa1zwdlPn
         SaNx1v5xSyxXf92fRsvMu3f2lr0JB0Jr8WFmXi0aPSedKN+hAWWkCXyj+x3Av7lGmz/O
         hv8dTP9MA2/gv+HgYV1kFiQOSvtQWh0ljk4PZNkTOhKXCIYVU7Ylx7JoEL0+9ZxsKJnM
         YLVPCqRNogleTUw2hMVr6acgad/+VTLy7EV5g9Q9h/2VtCaK2Bk8tnul+00eV+kcTALy
         Dv8KXbS0vnaJFzkLrppmFixZ4tRtqY/CTJw3u8ap9pfaxLvaC9GBKCdWf94SBpILA6Tj
         ko/w==
X-Gm-Message-State: APjAAAUtAhZNMm+plzAazct9C7jspKHwfUdMg4XncFvnluxD8nk4ETiS
        blo27EVnZ53750F4aGEZFlPWany/
X-Google-Smtp-Source: APXvYqwYKQ9+un69UuzqqmtYiUdB/RsAafWRsgpDAMsta7QoDCJ7mQ0wsfGsASTDYwrorhwNwNvXRA==
X-Received: by 2002:a5d:5487:: with SMTP id h7mr6818627wrv.18.1579472899601;
        Sun, 19 Jan 2020 14:28:19 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id l15sm43019569wrv.39.2020.01.19.14.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 14:28:18 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
 <20200119175109.GB17720@lunn.ch>
 <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
 <20200119185035.GC17720@lunn.ch>
 <82737a2f-b6c1-943e-42a2-d42d87212457@gmail.com>
 <20200119205059.GD17720@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <154281b8-43c5-ba18-1860-03e4b0c785fd@gmail.com>
Date:   Sun, 19 Jan 2020 23:28:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119205059.GD17720@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2020 21:50, Andrew Lunn wrote:
>> Speaking for r8169:
>> If interface is up and cable detached, then it runtime-suspends
>> and goes into PCI D3 (chip and MDIO bus not accessible).
>> But ndev is "running" and PHY is attached.
> 
> Hi Heiner
> 
Hi Andrew,

> And how does it get out of this state? I assume the PHY interrupts
> when the link is established. Is phylib handling this interrupt? If
> so, when phylib accesses the MDIO bus, the bus needs to be runtime PM
> aware. And if the bus is runtime PM aware, the IOCTL handler should
> work, when the device is runtime suspended.  If the MAC is handling
> this interrupt, and it is the MAC interrupt handler which is run-time
> unsuspending, then the ioctl handler is not going to work unless it
> also runtime unsuspends.
> 
The chip (wherever the magic happens) generates a PCI PME if WoL
config includes detection of physical link-up. The PCI core then
runtime-resumes the device.
I'd prefer the ioctl to return an error here instead of e.g.
0xffff for a register read.

> 	Andrew
> 
Heiner
