Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D498F3F5A4B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhHXJA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:00:29 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:52967 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235396AbhHXJA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:00:26 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BA3B9541A85;
        Tue, 24 Aug 2021 08:59:39 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-17-244.trex.outbound.svc.cluster.local [100.96.17.244])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id CC926541E6F;
        Tue, 24 Aug 2021 08:59:37 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.17.244 (trex/6.3.3);
        Tue, 24 Aug 2021 08:59:39 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Shoe-Spicy: 0a0e57163cb71ea3_1629795579291_3221969190
X-MC-Loop-Signature: 1629795579291:1426253782
X-MC-Ingress-Time: 1629795579291
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Date:Subject:In-Reply-To:References:Cc:To:From:
        Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DOQwcDkhSRipWIPoC1AMW2JUFZ3b2sns9QhIkdA4BZ4=; b=kiFU1atF+qghr8BQTeK1KIexmn
        aHqWMBCD9SbZRk7hbLiYu7u+vjJddd1KHhHQ9sG70bZXfjjpVVCUI5Qbt4dVR/RD19mXjtNlqJSkD
        ur/6ISTgCW8+AWhzx3YUW1QyCw0MWPglv4oQe9LoFUwh0KROEjKusoXFHR/6VBhq4ebEwPTZzlbvb
        oZMyVPySIGAu+bRXusBWc19djQXFyNpzifq2A7sLrSVca8sTZYUVYIXgCKo68zmEjEWq8dQYh1tA5
        SAlviFX/px8W6doklSiwLRe3KaYsIC4SS/HqVnyE+QV0CbTCN9ezVxoiklP+xTAuH8/P+jidz05jQ
        oP1UWueQ==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:39069 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mISHQ-002Sgw-NT; Tue, 24 Aug 2021 09:59:35 +0100
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Jakub Kicinski'" <kuba@kernel.org>, <linux-usb@vger.kernel.org>
Cc:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>    <20210823135229.36581-6-john.efstathiades@pebblebay.com> <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: RE: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state transitions
Date:   Tue, 24 Aug 2021 09:59:12 +0100
Organization: Pebble Bay Consulting Ltd
Message-ID: <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQHPAB61dMYAY/LsGMENMAjMWftvdQFrXfllAlVKFxurdYEy8A==
X-AuthUser: john.efstathiades@pebblebay.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > +/* Enabling link power state transitions will reduce power consumption
> > + * when the link is idle. However, this can cause problems with some
> > + * USB3 hubs resulting in erratic packet flow.
> > + */
> > +static bool enable_link_power_states;
> 
> How is the user supposed to control this? Are similar issues not
> addressed at the USB layer? There used to be a "no autosuspend"
> flag that all netdev drivers set..

The change is specific to U1 and U2 transitions initiated by the device
itself and does not affect ability of the device to respond to
host-initiated U1 and U2 transitions.

There is no user access to this. The driver would have to be recompiled to
change the default. 

> 
> Was linux-usb consulted? Adding the list to Cc.
> 
No, they weren't, but the change was discussed with the driver maintainer at
Microchip.

> >  		/* reset MAC */
> >  		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
> >  		if (unlikely(ret < 0))
> > -			return -EIO;
> > +			return ret;
> >  		buf |= MAC_CR_RST_;
> >  		ret = lan78xx_write_reg(dev, MAC_CR, buf);
> >  		if (unlikely(ret < 0))
> > -			return -EIO;
> > +			return ret;
> 
> Please split the ret code changes to a separate, earlier patch.

There are ret code changes in later patches in this set. As a general, rule
should ret code changes be put into their own patch?

