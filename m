Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241CE47016D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbhLJNYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:24:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:16005 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241521AbhLJNYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 08:24:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="238146111"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="238146111"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 05:20:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="463663341"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 05:20:29 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mvfoB-004VJe-30;
        Fri, 10 Dec 2021 15:19:31 +0200
Date:   Fri, 10 Dec 2021 15:19:30 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
 <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 02:06:07PM +0100, Marc Kleine-Budde wrote:
> On 09.12.2021 13:58:40, Andy Shevchenko wrote:
> > On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:

...

> > Marc, what do you think about this change?
> 
> LGTM, added to linux-can-next/testing.

Thanks for applying this and hi311x patches!

-- 
With Best Regards,
Andy Shevchenko


