Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A4F44BCB6
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhKJIVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:21:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41408 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhKJIVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:21:53 -0500
Message-ID: <c342fbf3-44b2-ce22-888f-363b709ea986@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636532345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BN0MsiNbgeRKb+wkl1o9CWyi634gHXLRKnp+TwIJuMo=;
        b=2jdebMqMvjbryDpOrBpDXQUQiTiL/S+JXKDJMKO3RJSXmVPI76It05CXknKsVBf2Oy77jn
        Ymgsk64r+QZnCwiXlZ0I2lDZH5Wgsh0YnfF19Ro6TKOJkJ8SIisSVXgZ0BYDj0SerJBh/h
        nAFmOYN6PnXtpx6Bz/UmJHcyOQ/uvpn79MpVFPvVpQBmhhYPj2yuXbe2UHrm1i4I3zQ4H+
        ZZUuwysRn+eFjGR/H3c0eKlJ/KYR5rUImOwycRZQC9TmtISKEi8GEp6Ow2zMxqk+mHr1Tm
        sRc7LMONau9rQQXXMHv4M8gE/yxly4utyFxY43GLIPIJUXzyOJJjgkq2VwSVDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636532345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BN0MsiNbgeRKb+wkl1o9CWyi634gHXLRKnp+TwIJuMo=;
        b=T5DrVa8i7km/keaSIh/JD0Zt7lo6ne8WiNRjMVgAoz6JJ0FrbPR34+ri4LBep3Jpqfg5oF
        4zByVAA3oQK1OrAQ==
Date:   Wed, 10 Nov 2021 09:19:04 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/7] net: dsa: b53: Add BroadSync HD register
 definitions
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-2-martin.kaistra@linutronix.de>
 <6839c4e9-123d-227a-630d-fae8a2df6483@gmail.com>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <6839c4e9-123d-227a-630d-fae8a2df6483@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 09.11.21 um 19:04 schrieb Florian Fainelli:
> On 11/9/21 1:50 AM, Martin Kaistra wrote:
>> From: Kurt Kanzenbach <kurt@linutronix.de>
>>
>> Add register definitions for the BroadSync HD features of
>> BCM53128. These will be used to enable PTP support.
>>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>> ---
> 
> [snip]
> 
>> +/*************************************************************************
>> + * ARL Control Registers
>> + *************************************************************************/
>> +
>> +/* Multiport Control Register (16 bit) */
>> +#define B53_MPORT_CTRL			0x0e
>> +#define   MPORT_CTRL_DIS_FORWARD	0
>> +#define   MPORT_CTRL_CMP_ETYPE		1
>> +#define   MPORT_CTRL_CMP_ADDR		2
>> +#define   MPORT_CTRL_CMP_ADDR_ETYPE	3
>> +#define   MPORT_CTRL_SHIFT(x)		((x) << 1)
>> +#define   MPORT_CTRL_MASK		0x2
> 
> The mask should be 0x3 since this is a 2-bit wide field.
> 

Correct, thanks.
Currently, this mask is not used, as I am just writing
MPORT0_TS_EN |
  (MPORT_CTRL_CMP_ETYPE << MPORT_CTRL_SHIFT(0))
to the register. Should I keep the definition anyway?
