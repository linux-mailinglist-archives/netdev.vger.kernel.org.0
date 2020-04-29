Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB21E1BE3F3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD2QfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:35:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2QfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 12:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gJ6dA2WzObd3dMwH5IHj1oP7HzaK0xUinQxZQf2+enc=; b=M+gJ1LZSCi7zI9VMIZuMsssO/J
        9cbIeE6eFTJsAJTeIMqkdkSsDJAA51ICHxOD3gUOcnvofSvp7+Qj0AbUYEAuRTgaxQ9IFFA8WHmaG
        nxfLUmWh74xyOGjzHFGionONkLzQgMMFeE/lw2R00OhYc7ZxoOMthSgFQvA1379wCELY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTpfy-000IOF-AR; Wed, 29 Apr 2020 18:35:10 +0200
Date:   Wed, 29 Apr 2020 18:35:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Message-ID: <20200429163510.GD66424@lunn.ch>
References: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <20200429152519.GB66424@lunn.ch>
 <CH2PR17MB35423A4698E4068CDE3E18A6DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CH2PR17MB35423A4698E4068CDE3E18A6DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 03:48:56PM +0000, Badel, Laurent wrote:
> ﻿Hi Andrew, 
> 
> Thanks for the reply. It's the mainline tree, was 5.6.-rc7 at the time.
> There's no tree mentioned for the ethernet PHY library in the maintainers files, 
> but am I expected to test against net/ or net-next/ ? 
> I'm happy to do so but should I use rather use net/ since this is more of a bugfix? 

The netdev FAQ talks about this. You need to submit against net, to
David Miller.

	Andrew
