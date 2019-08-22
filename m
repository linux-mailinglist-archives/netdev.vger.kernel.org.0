Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746A098EC9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfHVJJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:09:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:16157 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730438AbfHVJJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 05:09:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 02:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="208075494"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 02:08:57 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i0j5T-0006YZ-5I; Thu, 22 Aug 2019 12:08:55 +0300
Date:   Thu, 22 Aug 2019 12:08:55 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Message-ID: <20190822090855.GL30120@smile.fi.intel.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
 <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
 <20190821092541.GW30120@smile.fi.intel.com>
 <MN2PR18MB2528511CEFCBC2BE07947BAAD3A50@MN2PR18MB2528.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB2528511CEFCBC2BE07947BAAD3A50@MN2PR18MB2528.namprd18.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 05:46:07AM +0000, Sudarsana Reddy Kalluru wrote:
> 
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Andy Shevchenko
> > Sent: Wednesday, August 21, 2019 2:56 PM
> > To: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Cc: Mark Fasheh <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>;
> > ocfs2-devel@oss.oracle.com; Ariel Elior <aelior@marvell.com>; Sudarsana
> > Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-
> > linux-l2@marvell.com>; David S. Miller <davem@davemloft.net>;
> > netdev@vger.kernel.org; Colin Ian King <colin.king@canonical.com>
> > Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for
> > wider use
> > 
> > On Wed, Aug 21, 2019 at 09:29:04AM +0800, Joseph Qi wrote:
> > > On 19/8/21 00:31, Andy Shevchenko wrote:
> > > > There are users already and will be more of BITS_TO_BYTES() macro.
> > > > Move it to bitops.h for wider use.

> > > > -#define BITS_TO_BYTES(x) ((x)/8)>
> > > I don't think this is a equivalent replace, or it is in fact wrong
> > > before?
> > 
> > I was thinking about this one and there are two applications:
> > - calculus of the amount of structures of certain type per PAGE
> >   (obviously off-by-one error in the original code IIUC purpose of
> > STRUCT_SIZE)
> > - calculus of some threshold based on line speed in bytes per second
> >   (I dunno it will have any difference on the Gbs / 100 MBs speeds)
> > 
> I see that both the implementations (existing vs new) yield same value for standard speeds 10G (i.e.,10000), 1G (1000) that device supports. Hence the change look to be ok.

Thank you for testing, may I use your Tested-by tag?

-- 
With Best Regards,
Andy Shevchenko


