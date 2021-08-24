Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD93F60F7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhHXOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:53:15 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:28531 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237816AbhHXOxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:53:14 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id F0348402ECA;
        Tue, 24 Aug 2021 14:33:40 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-133-152.trex.outbound.svc.cluster.local [100.96.133.152])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id E2E88402EA8;
        Tue, 24 Aug 2021 14:33:38 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.133.152 (trex/6.3.3);
        Tue, 24 Aug 2021 14:33:40 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Attack-Glossy: 7c70750a65989e35_1629815620642_2978677931
X-MC-Loop-Signature: 1629815620642:4164483608
X-MC-Ingress-Time: 1629815620642
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Date:Subject:In-Reply-To:References:Cc:To:From:
        Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pYGndTSuBhdYtsig6UISFCHAQdimMYMZvLX860uJV08=; b=WRsA8LmXKXN0EuzskYU1cxiIPF
        Uk8HLCf3GUVGX7C3S7w7MsqUkcRZRpqexsxXM0KUQFybPkzq/vXS11kyh+ywRgG9bTXpaAl5XqzgJ
        k/AxoocfVA6lkd6nFXPN0lEvvjZsPt63swloDqGRY/oerEdcWC5uflFFb4fQA0nvLrRM2z1sc7NO5
        s2F846IS3JUdUaAauSFEcHq6QrCWNahvqGuxaCYk2Jbqq93/wqGnF4OhGfWwMFdaaJ2S6xW6zBT79
        sY/Jqew0emJz/5eequTrrCkr8dlORbvYWIeoBZximqI7KTgN7VRuJW5SIoi9XybadE4Wmix5DI8A/
        b4zoJUNA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:34532 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIXUf-007ht0-RP; Tue, 24 Aug 2021 15:33:36 +0100
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     <linux-usb@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>    <20210823135229.36581-6-john.efstathiades@pebblebay.com>        <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com> <20210824065303.17f23421@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824065303.17f23421@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: RE: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state transitions
Date:   Tue, 24 Aug 2021 15:33:13 +0100
Organization: Pebble Bay Consulting Ltd
Message-ID: <02d701d798f5$04a23df0$0de6b9d0$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQHPAB61dMYAY/LsGMENMAjMWftvdQFrXfllAlVKFxsBlFp99AImpXjOq1gIZxA=
X-AuthUser: john.efstathiades@pebblebay.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you expect the device-initiated transitions to always be causing
> trouble or are there scenarios where they are useful?

It's a particular problem on Android devices.

> Having to recompile the driver is a middle ground rarely chosen
> upstream. If the code has very low chance of being useful - let's
> remove it (git will hold it forever if needed); if there are reasonable
> chances someone will find it useful it should be configurable from user
> space, or preferably automatically enabled based on some device match
> list.

I like the sound of the device match list but I don't know what you mean.
Is there a driver or other reference you could point me at that provides
additional info?

> > > Was linux-usb consulted? Adding the list to Cc.
> >
> > No, they weren't, but the change was discussed with the driver
> maintainer at
> > Microchip.
> 
> Good to hear manufacturer is advising but the Linux USB community
> may have it's own preferences / experience.

Understood.

> > > Please split the ret code changes to a separate, earlier patch.
> >
> > There are ret code changes in later patches in this set. As a general,
> rule
> > should ret code changes be put into their own patch?
> 
> It's case by case, in this patch the ret code changes and error
> propagation does not seem to be inherently related to the main
> change the patch is making. I think you're referring to patch 7 -
> similar comment indeed applies there. I'd recommend taking the
> error propagation changes into a separate patch (can be a single
> one for code extracted from both patches).

Thanks, I am working on this and have incorporated the error propagation
changes from patch 7.


