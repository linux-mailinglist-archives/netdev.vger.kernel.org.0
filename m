Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E12D6B6F9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 08:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfGQGvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 02:51:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:46893 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfGQGvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 02:51:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 23:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,273,1559545200"; 
   d="scan'208";a="195145932"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 23:51:13 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 5/5] PTP: Add support for Intel PMC Timed GPIO Controller
In-Reply-To: <33864ede-1ce1-92f2-f049-a975060b2743@pensando.io>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-6-felipe.balbi@linux.intel.com> <33864ede-1ce1-92f2-f049-a975060b2743@pensando.io>
Date:   Wed, 17 Jul 2019 09:51:13 +0300
Message-ID: <87h87l2ly6.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Shannon Nelson <snelson@pensando.io> writes:

> On 7/16/19 12:20 AM, Felipe Balbi wrote:
>> Add a driver supporting Intel Timed GPIO controller available as part
>> of some Intel PMCs.
>>
>> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
>
> Hi Felipe, just a couple of quick comments:
>
> There are several places where a line is continued on the next line, but 
> should be indented to match the opening parenthesis on a function call 
> or 'if' expression.
>
> Shouldn't there be a kthread_stop() in intel_pmc_tgpio_remove(), or did 
> I miss that somewhere?

Oops :-p

I could've sworn I had added it when disabling the pin. I'll review
that, sure.

-- 
balbi
