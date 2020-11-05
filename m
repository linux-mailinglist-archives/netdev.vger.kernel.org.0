Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C052A77D9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgKEHRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:17:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:6774 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgKEHRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 02:17:00 -0500
IronPort-SDR: nHSVSuMP39z1cSNiKXE9rijdFbO0H05btoY0ueEEi8C0L1qmmKIC9ha+RMh13FImXRXdLQxDiC
 axfqYoXIevhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="230967106"
X-IronPort-AV: E=Sophos;i="5.77,452,1596524400"; 
   d="scan'208";a="230967106"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 23:16:58 -0800
IronPort-SDR: p1Es1VYoQz+1TPwDNrvcvJOhHvHKNbS3/nkphq28tpxzTSnhk0QL9Q2Zxy76FTynORKQUkKdqY
 P0Sj3oPheVhA==
X-IronPort-AV: E=Sophos;i="5.77,452,1596524400"; 
   d="scan'208";a="539261431"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 23:16:55 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 05 Nov 2020 09:16:52 +0200
Date:   Thu, 5 Nov 2020 09:16:52 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yehezkel Bernat <yehezkelshb@gmail.com>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 09/10] thunderbolt: Add DMA traffic test driver
Message-ID: <20201105071652.GW2495@lahna.fi.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
 <20201104140030.6853-10-mika.westerberg@linux.intel.com>
 <CA+CmpXvcTDXZV=NFXHUL6fhyj+=CMSCoCWkwjNOitwRJAi5C1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CmpXvcTDXZV=NFXHUL6fhyj+=CMSCoCWkwjNOitwRJAi5C1g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 08:38:10PM +0200, Yehezkel Bernat wrote:
> On Wed, Nov 4, 2020 at 4:00 PM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > +#define DMA_TEST_DATA_PATTERN          0x0123456789abcdefLL
> 
> Have you considered making it configurable? For mem test, for example, there is
> a reason to try different patterns. Not sure if it's relevant here.

Yes, we did but we went for the simple hard-coded for now. This can
always be enhanched if needed :)
