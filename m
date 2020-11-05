Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952A22A77E0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgKEHTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:19:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:38421 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgKEHTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 02:19:46 -0500
IronPort-SDR: iP6Y7n+73uIUOBuuhQQf3KG/y5on6sH495iMuHXH5h9rdv0CJLqtILJu8JAhylxfoEvkY6SlRh
 v3fAWM2b6ELg==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="156331240"
X-IronPort-AV: E=Sophos;i="5.77,452,1596524400"; 
   d="scan'208";a="156331240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 23:19:44 -0800
IronPort-SDR: hPFez/pYy589J5b3IG8IIFg1tpC6oHEmU+EYBsxtzjjkUCodYZ9mP0wei+SUxMzrCtgH/eTuEm
 QLe/66+37T2g==
X-IronPort-AV: E=Sophos;i="5.77,452,1596524400"; 
   d="scan'208";a="354177010"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 23:19:41 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 05 Nov 2020 09:17:26 +0200
Date:   Thu, 5 Nov 2020 09:17:26 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yehezkel Bernat <yehezkelshb@gmail.com>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] thunderbolt: Add DMA traffic test driver
Message-ID: <20201105071726.GX2495@lahna.fi.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
 <CA+CmpXtqdfJ_gWCUG6DABFabSzWv7m3cex3Aja9Nddp5u_tyNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CmpXtqdfJ_gWCUG6DABFabSzWv7m3cex3Aja9Nddp5u_tyNg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 08:39:01PM +0200, Yehezkel Bernat wrote:
> On Wed, Nov 4, 2020 at 4:00 PM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > Hi all,
> >
> > This series adds a new Thunderbolt service driver that can be used on
> > manufacturing floor to test that each Thunderbolt/USB4 port is functional.
> > It can be done either using a special loopback dongle that has RX and TX
> > lanes crossed, or by connecting a cable back to the host (for those who
> > don't have these dongles).
> >
> > This takes advantage of the existing XDomain protocol and creates XDomain
> > devices for the loops back to the host where the DMA traffic test driver
> > can bind to.
> >
> > The DMA traffic test driver creates a tunnel through the fabric and then
> > sends and receives data frames over the tunnel checking for different
> > errors.
> 
> For the whole series,
> 
> Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>

Thanks!
