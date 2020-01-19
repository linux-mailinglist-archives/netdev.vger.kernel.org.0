Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01AD141F51
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 19:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgASST1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 13:19:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34609 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgASST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 13:19:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id w5so13185776wmi.1
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 10:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rXhimSObuhW0TkxR3fbP5IsqZWWIM9bkva0/cfMBqEA=;
        b=nAZONpHMLsNA0bgwJ7Ul6gCyliVluWR4CfQWQHyYVkqH48uxN7F34tOHNwReigaFA+
         qAd+lF0xMUbDaq4ZGGwDhnwIVG1g/8zRZOWUu60tD/oVDATpkeLfXUkG0HlO19UdCKzm
         NlftaJ3swYGp0KyShIgLAXU8wjKn6mHRmRKV4hdUdu56etAhUo8anLbiPPm84wBuspGz
         qmVycMSx5c+8g6B8CnaPie+4OpGThWVOv7U940ydQtMtcau2Sq7TcoDc4JpXBt5w3nu2
         2oRnwXpgkavADr7Vd2wL5b7W3+YpYAe7TVlvGs0RcHdwj+02CpuonoRDuLbqMZTfXPEO
         m0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rXhimSObuhW0TkxR3fbP5IsqZWWIM9bkva0/cfMBqEA=;
        b=ZFidVC5DFpPGEdTSw0DNQ/sRprO0AIb0tQ9dd7whKfbkWg6wuROf6Rs4ReT3wkBU5U
         6Lbj7/FeYJKsofiEpdnhnl5P/yXxk7hPJfxoJgqZsAtk368rtfg4hGN6dIILUIi8nvdx
         WfRrit6W+7BZPo623/CHB9jRAAzFrvokG9zznMiJ+7dapJ3aauHRVPlcYKv/GH/VXp1c
         75tUpggv5H0wuzryIhsqonU2M0XUGBBPzNCbq0y619D6pEpjO0gLf5irk4D9IRibuHws
         O16x+JebH9MPEA7qwfx409xU68aZ0v54Etke658ruyETm1E9VwXlRXbXuPMO0Oyqw0uT
         KNiQ==
X-Gm-Message-State: APjAAAXL5nouavFrDvhJud9ZguQsch1JS8ZrKo/IXdgqO0SfHzZsPWCU
        nKcR1LqY7mzwPg2CPI3MUgDoQd0K
X-Google-Smtp-Source: APXvYqzEzIQUi/9QLGVFHB6Ae2Vkc39W/ysK/KkFy1UYeit/OwM5wzrPtOByAYt5cXcEElJ538oBlw==
X-Received: by 2002:a7b:c3d2:: with SMTP id t18mr15764101wmj.90.1579457964482;
        Sun, 19 Jan 2020 10:19:24 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id q3sm18280700wmj.38.2020.01.19.10.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 10:19:23 -0800 (PST)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
Date:   Sun, 19 Jan 2020 19:19:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119175109.GB17720@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2020 18:51, Andrew Lunn wrote:
> Hi Heiner
> 
>> Almost all drivers have the running check. I found five that don't:
>>
>> *ag71xx, fec_mpc52xx*
>> They don't have the running check but should, because the PHY is
>> attached in ndo_open only.
> 
> So long an ndo_close() sets the phydev pointer to NULL, it should be
> safe. But do the drivers do this?
> 
Setting ndev->phydev to NULL is done by phy_detach(), typically
called from phy_disconnect(). Both drivers do this.
In mpc52xx_fec_close() there might be a small chance for a race
because the chip is stopped before calling phy_diconnect().
Stopping the chip may make the MDIO bus unaccessible.

Actually I was wondering why we need to check at all whether
net_device is running. Typically the PHY is connected / disconnected
in ndo_open / ndo_close, and if both are implemented sanely then
checking for ndev->phydev should be sufficient.

Also it seems we don't consider situations like runtime PM yet.
Then the MDIO bus may not be accessible, but ndev is running
and PHY is attached. Maybe we should add a check for ndev being
present? Because typically netif_device_detach() is called
when (runtime-)suspending.

>> *agere, faraday, rdc*
>> They don't have the running check and attach the PHY in probe.
>>
>> So yes, we could add a second helper w/o the running check, even if
>> it's just for three drivers. There may be more in the future.
>>
>>> Do you plan to convert any more MAC drivers?
>>>
>> Not yet ;) Question would be whether one patch would be sufficient
>> or whether we need one patch per driver that needs to be ACKed by
>> the respective maintainer.
> 
> For this sort of mechanical change, i would do one patch for all
> without running, and another with running. If any driver needs more
> than a mechanical change, then do a patch per driver, and get the
> maintainer involved.
> 
>     Andrew
> 

Heiner
