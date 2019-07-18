Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE96CB55
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbfGRI6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 04:58:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:10418 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfGRI6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 04:58:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 01:58:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="173124356"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga006.jf.intel.com with ESMTP; 18 Jul 2019 01:58:10 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
In-Reply-To: <20190717173915.GE1464@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716164123.GB2125@localhost> <87ef2p2lvc.fsf@linux.intel.com> <20190717173915.GE1464@localhost>
Date:   Thu, 18 Jul 2019 11:58:09 +0300
Message-ID: <87imrziuse.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Richard Cochran <richardcochran@gmail.com> writes:

> On Wed, Jul 17, 2019 at 09:52:55AM +0300, Felipe Balbi wrote:
>> 
>> It's just a pin, like a GPIO. So it would be a PCB trace, flat flex,
>> copper wire... Anything, really.
>
> Cool.  Are there any Intel CPUs available that have this feature?

At least canon lake has it, but its BIOS doesn't enable it. This is
something that will be more important on future CPUs.

-- 
balbi
