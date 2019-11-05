Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7959DF05FA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbfKET11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:27:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45006 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389691AbfKET10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:27:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id f2so13937764wrs.11;
        Tue, 05 Nov 2019 11:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TS0c8t0Yec7dovuIxvCrYz0hDgxjTYo80RG1uxbH9jo=;
        b=TuhfALu8qHdPVfM/crTLQttYEzAY5DdTVlthRHAizm6yvtXYTk5ZuMMBbAefWI/VJR
         /uGBKS9VgtfQzUTTxtQhlcgoEm2nKttCnffF9FR7dvM+TTT9yPePuNeeKfO1hWqpVnQG
         8REqGL//m7sfKeZrkGp+wH+v4hfdk2yu9ASxswVnOMmJKzq6vAaNnfp+bcpRk4OsXrkh
         5+QuryBd61xYrGPqtRZk7+RfuvN+e72gZ0fzyaTxMD7/fTbhmjwawbgrlkUJlPYKM6s5
         jlX0ChFNK+4YAaHvVt58HymhXqe2KJTvDe503f0phQmQGL6X7xjCi5watu6S4winEW9Y
         Wx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TS0c8t0Yec7dovuIxvCrYz0hDgxjTYo80RG1uxbH9jo=;
        b=oqUaAooZhn8PGRTLkoazel5UoFFPb/4Uu/SCQZBJj0pSci2SN4i7NClo9zXtR1UnLt
         uxrXup/P8zFPXuDLkp9B+W7HWUpmoN406w/vtSTpJPav1BxqE6+wWxzHhOQLbzyuMCQq
         CPDOUuSs8P40IayEwBRqU/FruR21x4roZpcTjTvQ3z0Zr2dzN2his0wG/AWY+rZwox+p
         uTDdaBE/sGOz6XDk9zNg729PdbUsrsLlQsZqZeZ/q4hHPzYWLAJWn33F3m1BLOQWK/D9
         fdOfdUQG4pPNNGDkSQyWcKsW9CZ7I5QPyIpi0dqfxhShhf1dSsIkNH9DdQMV4Nb+fHYy
         5LGg==
X-Gm-Message-State: APjAAAVcb7H6wz6j4fKNJoRFF00zGzsa+aFZeLExgC8JvziYhxzeup09
        frB0YDsnPVcUBFxXWf5Df8SsjefL
X-Google-Smtp-Source: APXvYqw8HTvoLrx+lVGKATwxgFLRblHBKIrN4Q6MuXFiAeR+BBujK5DQMb0B3qJ1mQqlLuXzvdeDXQ==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr27688138wri.298.1572982043144;
        Tue, 05 Nov 2019 11:27:23 -0800 (PST)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e15sm21151469wrx.58.2019.11.05.11.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 11:27:22 -0800 (PST)
Subject: Re: [PATCH net 1/3] net: bcmgenet: use RGMII loopback for MAC reset
To:     Scott Branden <scott.branden@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
 <1572980846-37707-2-git-send-email-opendmb@gmail.com>
 <8c5c8028-a897-bf70-95ba-a1ffc8b68264@broadcom.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <5f68345e-c58d-3d99-189b-b4be39c4b899@gmail.com>
Date:   Tue, 5 Nov 2019 11:27:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8c5c8028-a897-bf70-95ba-a1ffc8b68264@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 11:14 AM, Scott Branden wrote:
> Hi Doug,
> 
> On 2019-11-05 11:07 a.m., Doug Berger wrote:
>> As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
>> during UniMAC sw_reset") the UniMAC must be clocked while sw_reset
>> is asserted for its state machines to reset cleanly.
>>
>> The transmit and receive clocks used by the UniMAC are derived from
>> the signals used on its PHY interface. The bcmgenet MAC can be
>> configured to work with different PHY interfaces including MII,
>> GMII, RGMII, and Reverse MII on internal and external interfaces.
>> Unfortunately for the UniMAC, when configured for MII the Tx clock
>> is always driven from the PHY which places it outside of the direct
>> control of the MAC.
>>
>> The earlier commit enabled a local loopback mode within the UniMAC
>> so that the receive clock would be derived from the transmit clock
>> which addressed the observed issue with an external GPHY disabling
>> it's Rx clock. However, when a Tx clock is not available this
>> loopback is insufficient.
>>
>> This commit implements a workaround that leverages the fact that
>> the MAC can reliably generate all of its necessary clocking by
>> enterring the external GPHY RGMII interface mode with the UniMAC in
>> local loopback during the sw_reset interval. Unfortunately, this
>> has the undesirable side efect of the RGMII GTXCLK signal being
>> driven during the same window.
>>
>> In most configurations this is a benign side effect as the signal
>> is either not routed to a pin or is already expected to drive the
>> pin. The one exception is when an external MII PHY is expected to
>> drive the same pin with its TX_CLK output creating output driver
>> contention.
>>
>> This commit exploits the IEEE 802.3 clause 22 standard defined
>> isolate mode to force an external MII PHY to present a high
>> impedance on its TX_CLK output during the window to prevent any
>> contention at the pin.
>>
>> The MII interface is used internally with the 40nm internal EPHY
>> which agressively disables its clocks for power savings leading to
>> incomplete resets of the UniMAC and many instabilities observed
>> over the years. The workaround of this commit is expected to put
>> an end to those problems.
>>
>> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> ---
>>   drivers/net/ethernet/broadcom/genet/bcmgenet.c |  2 --
>>   drivers/net/ethernet/broadcom/genet/bcmmii.c   | 33
>> ++++++++++++++++++++++++++
>>   2 files changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index 0f138280315a..a1776ed8d7a1 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -1996,8 +1996,6 @@ static void reset_umac(struct bcmgenet_priv *priv)
>>         /* issue soft reset with (rg)mii loopback to ensure a stable
>> rxclk */
>>       bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN,
>> UMAC_CMD);
>> -    udelay(2);
>> -    bcmgenet_umac_writel(priv, 0, UMAC_CMD);
>>   }
>>     static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> index 17bb8d60a157..fcd181ae3a7d 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> @@ -221,8 +221,38 @@ int bcmgenet_mii_config(struct net_device *dev,
>> bool init)
>>       const char *phy_name = NULL;
>>       u32 id_mode_dis = 0;
>>       u32 port_ctrl;
>> +    int bmcr = -1;
>> +    int ret;
>>       u32 reg;
>>   +    /* MAC clocking workaround during reset of umac state machines */
>> +    reg = bcmgenet_umac_readl(priv, UMAC_CMD);
>> +    if (reg & CMD_SW_RESET) {
>> +        /* An MII PHY must be isolated to prevent TXC contention */
>> +        if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
>> +            ret = phy_read(phydev, MII_BMCR);
>> +            if (ret >= 0) {
>> +                bmcr = ret;
>> +                ret = phy_write(phydev, MII_BMCR,
>> +                        bmcr | BMCR_ISOLATE);
>> +            }
>> +            if (ret) {
>> +                netdev_err(dev, "failed to isolate PHY\n");
>> +                return ret;
>> +            }
>> +        }
>> +        /* Switch MAC clocking to RGMII generated clock */
>> +        bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
>> +        /* Ensure 5 clks with Rx disabled
>> +         * followed by 5 clks with Reset asserted
>> +         */
>> +        udelay(4);
> How do these magic delays work, they are different values?
> In one case you have a udelay(4) to ensure rx disabled for 5 clks.
> Yet below you have a udelay(2) to ensure 4 more clocks?
The delays are based on 2.5MHz clock cycles (the clock used for 10Mbps).
5 clocks is 2us.

The udelay(4) is for 10 clocks: rx is disabled for 5 and then 5 more
clocks with reset held. The requirement is poorly specified and this is
a conservative interpretation.

The udelay(2) allows at least 5 more clocks without reset before rx can
be enabled.

>> +        reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
>> +        bcmgenet_umac_writel(priv, reg, UMAC_CMD);
>> +        /* Ensure 5 more clocks before Rx is enabled */
>> +        udelay(2);
>> +    }
>> +
>>       priv->ext_phy = !priv->internal_phy &&
>>               (priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
>>   @@ -254,6 +284,9 @@ int bcmgenet_mii_config(struct net_device *dev,
>> bool init)
>>           phy_set_max_speed(phydev, SPEED_100);
>>           bcmgenet_sys_writel(priv,
>>                       PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
>> +        /* Restore the MII PHY after isolation */
>> +        if (bmcr >= 0)
>> +            phy_write(phydev, MII_BMCR, bmcr);
>>           break;
>>         case PHY_INTERFACE_MODE_REVMII:
> 

Regards,
    Doug
