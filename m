Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A189A9AC4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfIEGkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:40:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbfIEGkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 02:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jaOS9HgHTlVD8C1Eqdv5Xybi81D/yYlxVzy1ayZf3jw=; b=DxYU4DWnBmVLQJPd6CjzQVxzfB
        KlQKhyIh3qqefvSm5EB+JSdOh3v96UoohgUE1tWYvUwASVF2B1KIUFN3aHBu9dJ6tXSvvkZ9V7bqx
        rT7MRHAB4ON2SEGcR8GBOIclAEMn6nvyIv7Iw8tnUbnS2rVqPjgi9ntFe/ZmovyHJfYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i5lR4-0000FB-HY; Thu, 05 Sep 2019 08:40:02 +0200
Date:   Thu, 5 Sep 2019 08:40:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 net-next] net: stmmac: Add support for MDIO interrupts
Message-ID: <20190905064002.GB415@lunn.ch>
References: <1567605774-5500-1-git-send-email-weifeng.voon@intel.com>
 <20190904145804.GA9068@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81475C23E@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC81475C23E@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> The change log is near the end of the patch:
> /**
> --
> Changelog v2
> *mdio interrupt mode or polling mode will depends on mdio interrupt enable bit
> *Disable the mdio interrupt enable bit in stmmac_release
> *Remove the condition for initialize wait queues
> *Applied reverse Christmas tree
> 1.9.1

At the end, nobody sees it, because everybody else does it at the beginning.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html?highlight=submitting#the-canonical-patch-format

This talks about the ---. David prefers to see the change log before
the ---. Other maintainers want it after the ---.

> 
> > 
> > The formatting of this patch also looks a bit odd. Did you use git
> > format-patch ; git send-email?
> 
> Yes, I do git format-patch, then ./scripts/checkpatch.pl. 
> Lastly git send-email

What looked odd is the missing --- marker. git format-patch should of
create that as part of the patch.

       Andrew
