Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D366CB58
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfGRI7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 04:59:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:13975 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfGRI7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 04:59:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 01:59:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="158725434"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 01:59:11 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
In-Reply-To: <20190717173645.GD1464@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-5-felipe.balbi@linux.intel.com> <20190716163927.GA2125@localhost> <87k1ch2m1i.fsf@linux.intel.com> <20190717173645.GD1464@localhost>
Date:   Thu, 18 Jul 2019 11:59:10 +0300
Message-ID: <87ftn3iuqp.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Richard Cochran <richardcochran@gmail.com> writes:

> On Wed, Jul 17, 2019 at 09:49:13AM +0300, Felipe Balbi wrote:
>> No worries, I'll work on this after vacations (I'll off for 2 weeks
>> starting next week). I thought about adding a new IOCTL until I saw that
>> rsv field. Oh well :-)
>
> It would be great if you could fix up the PTP ioctls as a preface to
> your series.

no problem, anything in particular in mind? Just create new versions of
all the IOCTLs so we can actually use the reserved fields in the future?

cheers

-- 
balbi
