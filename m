Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21B6397CC2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhFAWzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:55:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:7004 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhFAWzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:55:21 -0400
IronPort-SDR: k8kKGTIQRZM4vldxgJtAXmRLvHlahr4zqseUuYf7AGDa86YjVZ54G+ydOv2loz7ys3ZWTQx0Cr
 rChinm0G7TCg==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="200645940"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="200645940"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 15:53:38 -0700
IronPort-SDR: FvEmDQWzTVhQd/WWqFcCGAW6HmJXwMVVR8bLQvrSXfd4I0F6d/lz+Xf7/vbINV9W9Pm13zt9CE
 lb58nMB2c3fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="399766174"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 01 Jun 2021 15:53:38 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id BAB63580427;
        Tue,  1 Jun 2021 15:53:35 -0700 (PDT)
Date:   Wed, 2 Jun 2021 06:53:32 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: enable platform specific
 safety features
Message-ID: <20210601225332.GA28151@linux.intel.com>
References: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
 <YLawrTO4pkgc6tnb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLawrTO4pkgc6tnb@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 12:11:57AM +0200, Andrew Lunn wrote:
> On Tue, Jun 01, 2021 at 09:52:35PM +0800, Wong Vee Khee wrote:
> > On Intel platforms, not all safety features are enabled on the hardware.
> 
> Is it possible to read a register is determine what safety features
> have been synthesised?
>

No. The value of these registers after reset are 0x0. We need to set it
manually.

VK
