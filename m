Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3943440DBBC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhIPNww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:52:52 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:46143 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbhIPNwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:52:51 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1083522239;
        Thu, 16 Sep 2021 15:51:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1631800290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ORj/1YpuSNDPqULVXqQ2alAAdyZzofgAhRepXbWdap4=;
        b=QuYcedHldgHD1L5o8D4fTOXCtT8DVtvyyZ8oIAPYfZik1OS7sLMT47IDqEdV97TSTsVnZR
        thuI+KWf8J9L9tyUQyydchwl1VZwPU0lbJC0wcuMKKIgGvf+MXXUs8kQZhLOlkto8qbfXb
        t2AtrUaUbrpW7vtwWaV3OI/2AodO9gQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 16 Sep 2021 15:51:28 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for the
 PHY
In-Reply-To: <20210916130908.zubzqs6i6i7kbbol@skbuf>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
 <20210830183015.GY22278@shell.armlinux.org.uk>
 <20210830183623.kxtbohzy4sfdbpsl@skbuf>
 <20210916130908.zubzqs6i6i7kbbol@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f65348840296deb814f4a39f5146c29d@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-09-16 15:09, schrieb Vladimir Oltean:
> On Mon, Aug 30, 2021 at 09:36:23PM +0300, Vladimir Oltean wrote:
>> On Mon, Aug 30, 2021 at 07:30:15PM +0100, Russell King (Oracle) wrote:
>> > Can we postpone this after this merge window please, so I've got time
>> > to properly review this. Thanks.
>> 
>> Please review at your discretion, I've no intention to post a v3 right
>> now, and to the best of my knowledge, RFC's are not even considered 
>> for
>> direct inclusion in the git tree.
> 
> Hello Russell, can you please review these patches if possible? I
> would like to repost them soon.

I planned to test this on my board with the AR8031 (and add support 
there),
but it seems I won't find time before my vacation, unfortunately.

-michael
