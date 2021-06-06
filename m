Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D981839CBF2
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFFA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 20:56:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:47919 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhFFA4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 20:56:12 -0400
IronPort-SDR: qpzvihpEEDaZGQKRs1Jmb6V9+5F2Z+pHIl/tG5n9fIgI89oYgsHhwMSSJgU9iNuXe46YXnzyIu
 Uece5OkT0Lsg==
X-IronPort-AV: E=McAfee;i="6200,9189,10006"; a="184150402"
X-IronPort-AV: E=Sophos;i="5.83,252,1616482800"; 
   d="scan'208";a="184150402"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2021 17:54:23 -0700
IronPort-SDR: Z9Git1Ru7Cz8NqeCFcygTofXGZrBDyXZeGZue/4AhMzH2zN/hc+LeqsFrvdhc+Y6yrvy+UE0Ty
 Yt8ECc9QyuNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,252,1616482800"; 
   d="scan'208";a="439617649"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 05 Jun 2021 17:54:23 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id AE541580522;
        Sat,  5 Jun 2021 17:54:21 -0700 (PDT)
Date:   Sun, 6 Jun 2021 08:54:18 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210606005418.GA9776@linux.intel.com>
References: <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
 <YLbqv0Sy/3E2XaVU@lunn.ch>
 <20210602141557.GA29554@linux.intel.com>
 <YLed2G1iDRTbA9eT@lunn.ch>
 <20210602235155.GA31624@linux.intel.com>
 <20210605003722.GA4979@linux.intel.com>
 <YLvENQ/aadG0TcRp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLvENQ/aadG0TcRp@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 08:36:37PM +0200, Andrew Lunn wrote:
> > Can you take a look at the latest implementation and provide
> > feedback?
> 
> I think we are close, so please submit a proper patch.
>

Will do. Thanks Andrew!

 VK 
