Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF0D20D1E0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgF2Soe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:44:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:40929 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgF2SoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:44:03 -0400
IronPort-SDR: aMRl0ipVosfCwUhF1VDBTEqP/lWnXrJMhXUekRlP632VPhj+0wG70z9zLD+bm6TBqlQaNtz3PB
 udw0o68ergxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134305624"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="134305624"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 08:37:24 -0700
IronPort-SDR: RB/icnubY2lBD7O/rv4knM0Rpo9Ty+Si0hRQAlks201NpDfZKw6GIx4laReiipYYuFtTO+KblP
 pQkmViIVrT+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="386425848"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 29 Jun 2020 08:37:21 -0700
Received: by lahna (sSMTP sendmail emulation); Mon, 29 Jun 2020 18:37:20 +0300
Date:   Mon, 29 Jun 2020 18:37:20 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] thunderbolt: XDomain and NHI improvements
Message-ID: <20200629153720.GR5180@lahna.fi.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 04:01:35PM +0300, Mika Westerberg wrote:
> Hi,
> 
> This small series improves the "data" path handling when doing host-to-host
> connections over TBT/USB4 cable. First patch delays setting nodename upon
> first connect to allow the userspace to fill in host name. Rest of the
> series deal with the NHI (TBT/USB4 host interface) HopID allocation so that
> by dropping the E2E workaround which was never used, we can use DMA rings
> starting from 1 to transfer data over the TBT/USB4 fabric.
> 
> Mika Westerberg (4):
>   thunderbolt: Build initial XDomain property block upon first connect
>   thunderbolt: No need to warn if NHI hop_count != 12 or hop_count != 32
>   thunderbolt: NHI can use HopIDs 1-7
>   thunderbolt: Get rid of E2E workaround
> 
>  drivers/net/thunderbolt.c     |  4 +-
>  drivers/thunderbolt/nhi.c     | 30 ++---------
>  drivers/thunderbolt/switch.c  |  7 ++-
>  drivers/thunderbolt/xdomain.c | 94 ++++++++++++++++++++---------------
>  include/linux/thunderbolt.h   |  2 -
>  5 files changed, 64 insertions(+), 73 deletions(-)

Queued these for v5.9.
