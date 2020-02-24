Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8459F16B58A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgBXX3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:29:20 -0500
Received: from mga18.intel.com ([134.134.136.126]:21404 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgBXX3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 18:29:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 15:29:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="230823501"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by orsmga008.jf.intel.com with ESMTP; 24 Feb 2020 15:29:19 -0800
Date:   Mon, 24 Feb 2020 15:29:09 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        mingo@redhat.com, x86@kernel.org, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 1/5] drivers/ptp: Add Enhanced handling
 of reserve fields
Message-ID: <20200224232909.GF1508@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-2-christopher.s.hall@intel.com>
 <0f868a7e-5806-4976-80b5-0185a64b42a0@intel.com>
 <20200203014544.GA3516@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203014544.GA3516@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 05:45:44PM -0800, Richard Cochran wrote:
> On Fri, Jan 31, 2020 at 08:54:19AM -0800, Jacob Keller wrote:
> > 
> > Not that it's a big deal, but I think this might read more clearly if
> > this was "cmd == PTP_PIN_GETFUNC2 && check_rsv_field(pd.rsv)"
> 
> +1

Yes. Good point.
