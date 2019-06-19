Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C454B8F6
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfFSMok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:44:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbfFSMok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 08:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oF6P+ACF0Y2JFhAjtVOgzpA0oW5syeHiby1lqhM0jRA=; b=1sNz137Y+5YnAiRovEAwbnlCq+
        W7NYHUJPUQGPduwkwY7wnhRv44j+HiPM4RMUYKup/RzXKe899oOiBrVniVsGJzxrKcg7pgZI8oo4R
        VSvu+4S+Sddh7mrJzEJ/oxhA4alpZbAoSrTNpEIU7xRVhqfLx/RG6TWucD8nDl5VpJs4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hdZx3-0000t9-V0; Wed, 19 Jun 2019 14:44:33 +0200
Date:   Wed, 19 Jun 2019 14:44:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Message-ID: <20190619124433.GC26784@lunn.ch>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
 <20190619030729.GA26784@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81472623A@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC81472623A@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It looks like most o the TSN_WARN should actually be netdev_dbg().
> > 
> >    Andrew
> 
> Hi Andrew,
> This file is targeted for dual licensing which is GPL-2.0 OR BSD-3-Clause.
> This is the reason why we are using wrappers around the functions so that
> all the function call is generic.

I don't see why dual licenses should require wrappers. Please explain.

  Thanks
	Andrew
