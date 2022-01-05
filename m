Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8C4854FF
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbiAEOsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:48:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:25975 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240844AbiAEOsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 09:48:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641394125; x=1672930125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BluWvZ/SzIyu7H1lFCAHJFGwIQioSeRbHSiFGYvZDCg=;
  b=amsm9mw3qkThqE5nsuFWMts4AvL70fG9y5aI9F2CpmKg2ryy8GWREK5R
   sJSdf0d8LeubW9uH320y/ChV1fjjBaWsipEbXkgdJsx2iQIqR8e/oOcGl
   3C7DAZRZ7nbxOow4QSXSM9goxuLEz1wpGnprTa5df4OXRF6mgnR1iehnd
   MXuWNn6ECWKs8y9/NMVoLaNKI/5sI3sT0buuu4a4sOJM0xRq75ry5uY/D
   Yq2nsiHks0zv5ikNlDmkD00ZUILoSTE0vPVvI63Dk6iCrpPaX8UbLlTY3
   BIf8ZY+lkhrBJ/lGHq31FNKg80sbrGwUPg4iCnc2/X80vVneNJeP+02Gb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242665290"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="242665290"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 06:48:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="526561703"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 06:48:42 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n57ZV-006jg0-SK;
        Wed, 05 Jan 2022 16:47:25 +0200
Date:   Wed, 5 Jan 2022 16:47:25 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <YdWvfdRTpPZ0YcSD@smile.fi.intel.com>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
 <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
 <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
 <YdWpWSMhzmElnIJH@smile.fi.intel.com>
 <20220105143448.pnckx2wgal2y3rll@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105143448.pnckx2wgal2y3rll@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 03:34:48PM +0100, Marc Kleine-Budde wrote:
> On 05.01.2022 16:21:13, Andy Shevchenko wrote:
> > On Fri, Dec 10, 2021 at 03:19:31PM +0200, Andy Shevchenko wrote:
> > > On Fri, Dec 10, 2021 at 02:06:07PM +0100, Marc Kleine-Budde wrote:
> > > > On 09.12.2021 13:58:40, Andy Shevchenko wrote:
> > > > > On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:
> > > 
> > > ...
> > > 
> > > > > Marc, what do you think about this change?
> > > > 
> > > > LGTM, added to linux-can-next/testing.
> > > 
> > > Thanks for applying this and hi311x patches!
> > 
> > Can we have a chance to see it in the v5.17-rc1?
> 
> Yes:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=linux-can-next-for-5.17-20220105
> 
> 'about to send that PR.

Cool, thanks! Happy new year!

-- 
With Best Regards,
Andy Shevchenko


