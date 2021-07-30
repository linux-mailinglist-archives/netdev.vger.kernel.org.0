Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D273DBB06
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhG3Osj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:48:39 -0400
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:17910 "EHLO
        rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhG3Osj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=795; q=dns/txt; s=iport;
  t=1627656514; x=1628866114;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n3PkM/+InBuHzKFjtN6VP5Z6K9yetavVDut1DYLO1yY=;
  b=GaXjf1epBtd1HnTsagrEGjG58G2YFum4ImwgBK61Bi9DTP5EiAqpBpH4
   x4FM74NMtsXQF2Xa8Cqtk1+lLpMzwooDhgxJd7b67O4RVNhTqRcTSPP+F
   Oeu5CF+ETt3e9K8vBrUmq6Qt1w0W/fWxlTo5Y9l7Z//bF1i8DOV3BZagd
   A=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="915063875"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Jul 2021 14:48:32 +0000
Received: from zorba ([10.24.25.85])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 16UEmUWR021352
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 30 Jul 2021 14:48:32 GMT
Date:   Fri, 30 Jul 2021 07:48:30 -0700
From:   Daniel Walker <danielwa@cisco.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Balamurugan Selvarajan <balamsel@cisco.com>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC-PATCH] net: stmmac: Add KR port support.
Message-ID: <20210730144830.GO1633923@zorba>
References: <20210729234443.1713722-1-danielwa@cisco.com>
 <YQNrmB9XHkcGy5D0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQNrmB9XHkcGy5D0@lunn.ch>
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.24.25.85, [10.24.25.85]
X-Outbound-Node: rcdn-core-5.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 05:01:44AM +0200, Andrew Lunn wrote:
> On Thu, Jul 29, 2021 at 04:44:42PM -0700, Daniel Walker wrote:
> > From: Balamurugan Selvarajan <balamsel@cisco.com>
> > 
> > For KR port the mii interface is a chip-to-chip
> > interface without a mechanical connector. So PHY
> > inits are not applicable. In this case MAC is
> > configured to operate at forced speed(1000Mbps)
> > and full duplex. Modified driver to accommodate
> > PHY and NON-PHY mode.
> 
> I agree with Florian here. Look at all the in kernel examples of a SoC
> MAC connected to an Ethernet switch. Some use rgmii, others 1000BaseX
> or higher. But they all follow the same scheme, and don't need
> invasive MAC driver changes.


Can you provide the examples which you looked at ?

Daniel
