Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32A1C1752
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgEAOBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:01:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbgEANZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 09:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+J9/XuzaYZkc7KdhEejKIjHZVQxLgr8ct3mRcOr6mp0=; b=g/PRKZN4p6dyVNt4voSziF0z/E
        Jyx5pk2UnFy84ELAeLCgLm6gMKGB89jV8il6E/xtca+x80qWrYpR5tvzJfj+EyIC6y3FG4q4Y4Jn6
        ho3kN8mFp+Clul4Gr7uFAAiCNMo1XHwAQBRRTZodNXcZl0vaR/J8Nxq7TjGxAsMX1PQo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUVfQ-000XTu-Ff; Fri, 01 May 2020 15:25:24 +0200
Date:   Fri, 1 May 2020 15:25:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200501132524.GB128166@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200501000015.GC22077@lunn.ch>
 <20200501062223.GA15217@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501062223.GA15217@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Vadym
> > 
> > What are the plans for getting the firmware into linux-firmware git
> > repo?
> > 
> > 	Andrew
> 
> Well, what is the procedure ? I was thinking that probably after
> conceptual part will be approved and I will send official PATCH series
> along with the firmware image to the linux-firmware ?

Hi Vadym

I just wanted to ensure you actually were going to send the
firmware. For the Marvell 10G PHYs, you need to signed an NDA with
Marvell to get the firmware, and you probably cannot distribute
it. Marvell seems to have no interest in making the firmware
available. So we NACKed support for loading the firmware a runtime.

If you have all the legal mumbo jumbo in place to make the firmware
available, great. You can post it for merging to linux-firmware now.

Thanks
	   Andrew

