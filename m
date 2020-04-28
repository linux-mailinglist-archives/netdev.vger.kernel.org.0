Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845521BCF74
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgD1WIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:08:46 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:60913 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgD1WIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:08:46 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C90EA22723;
        Wed, 29 Apr 2020 00:08:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588111724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myGuBLUwQYONGjQ6yZ2CWpyFDpYWeIGIuAOZQXqOz/Q=;
        b=r8jzenhzebzmYYalcaQtE0JxGupuhw3zKZ42/KHT/2f5rtX79ok+ZubXV6YamOPkgpoIPn
        byVFcAGXonBNy/VPK/GkmYVMnpUkISIk/nnghW+r1BUN6uie7sUdPArGdhU4Bf2L6B3wmK
        MigNaM8w3vqC6Km8uIaabeY1jzcB3+w=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Apr 2020 00:08:43 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 4/4] net: phy: bcm54140: add second PHY ID
In-Reply-To: <20200428212926.GE30459@lunn.ch>
References: <20200428210854.28088-1-michael@walle.cc>
 <20200428210854.28088-4-michael@walle.cc> <20200428212926.GE30459@lunn.ch>
Message-ID: <272c9ebf238c61603ea947fea0d51b02@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: C90EA22723
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 2020-04-28 23:29, schrieb Andrew Lunn:
> On Tue, Apr 28, 2020 at 11:08:54PM +0200, Michael Walle wrote:
>> This PHY have to PHY IDs depending on its mode. Adjust the mask so 
>> that
>> it includes both IDs.
> 
> Hi Michael
> 
> I don't have a strong opinion, but maybe list it as two different
> PHYs? I do sometimes grep for PHY IDs, and that would not work due to
> the odd mask.

Me neither. I just looked odd to have actually the same PHY listed twice
with just another id. That makes me wonder if it is possible to have
the same PHY driver name twice. IIRC it is at leased used somewhere
in the sysfs. If that is true, I'd prefer to just have one PHY
"BCM54140" instead of a "BCM54140 (QSGMII)" and "BCM54140 (4x SGMII)".
Because it is actually the same PHY but only another interface towards
the MAC is used.

-michael
