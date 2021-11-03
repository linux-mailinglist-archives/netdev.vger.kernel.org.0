Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1954447DB
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhKCSGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 14:06:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:9730 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhKCSGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 14:06:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="231512207"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="231512207"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 11:03:56 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="667620843"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 11:03:52 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miKbp-003Kje-6e;
        Wed, 03 Nov 2021 20:03:37 +0200
Date:   Wed, 3 Nov 2021 20:03:36 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v3 2/2] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
Message-ID: <YYLO+A2Psg9wloN9@smile.fi.intel.com>
References: <YYLJG1y8owwehew+@smile.fi.intel.com>
 <20211103174527.GA701082@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103174527.GA701082@bhelgaas>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 12:45:27PM -0500, Bjorn Helgaas wrote:
> On Wed, Nov 03, 2021 at 07:38:35PM +0200, Andy Shevchenko wrote:
> > On Wed, Nov 03, 2021 at 06:10:55PM +0100, Jonas Dreßler wrote:
> 
> > > +	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
> > > +			     HostCmd_ACT_GEN_GET, 0, &ver_ext, false)) {
> > > +		mwifiex_dbg(priv->adapter, MSG,
> > > +			    "Checking hardware revision failed.\n");
> > > +	}
> > 
> > Checkpatch won't warn you if string literal even > 100. So move it to one line
> > and drop curly braces. Ditto for the case(s) below.
> 
> I don't understand the advantage of making this one line.  I *do*
> understand the advantage of joining a single string so grep can find
> it more easily.  But that does make the code a little bit uglier, and
> in a case like this, you don't get the benefit of better grepping, so
> I don't see the point.

Then disregard my comment. I've no hard feelings about it :-)

-- 
With Best Regards,
Andy Shevchenko


