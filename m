Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD210489C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKUCkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfKUCkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V+pfx8QvxJTxf8RUv66add8NSdEt0StKMRUZW6HmeLY=; b=0Q+M9ZduB+Q/pl4LfdUJDVxMUJ
        njurEBT0/I3QtyGaJ4Lmj939qlSZO67slJlO0ydF6kMQH2zbSQ4GRbwuSc4rq9rt/BNBEwM8Vt625
        bGQjaa7UTDYZmUwxTej7B0JXd0XWIpM1YjUipeYqVBijDB/9oEY/SdXio/C4mnySCH2o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcAV-00073t-Bf; Thu, 21 Nov 2019 03:26:03 +0100
Date:   Thu, 21 Nov 2019 03:26:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: add some quirks for GPON modules
Message-ID: <20191121022603.GG18325@lunn.ch>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
 <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:42:47AM +0000, Russell King wrote:
> Marc Micalizzi reports that Huawei MA5671A and Alcatel/Lucent G-010S-P
> modules are capable of 2500base-X, but incorrectly report their
> capabilities in the EEPROM.  It seems rather common that GPON modules
> mis-report.
> 
> Let's fix these modules by adding some quirks.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
