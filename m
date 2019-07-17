Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4256B6FB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 08:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfGQGw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 02:52:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:8898 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfGQGw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 02:52:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 23:52:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,273,1559545200"; 
   d="scan'208";a="167877794"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jul 2019 23:52:55 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
In-Reply-To: <20190716164123.GB2125@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716164123.GB2125@localhost>
Date:   Wed, 17 Jul 2019 09:52:55 +0300
Message-ID: <87ef2p2lvc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Richard Cochran <richardcochran@gmail.com> writes:

> On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
>> TGPIO is a new IP which allows for time synchronization between systems
>> without any other means of synchronization such as PTP or NTP. The
>> driver is implemented as part of the PTP framework since its features
>> covered most of what this controller can do.
>
> Can you provide some background on this new HW?  Is the interface
> copper wires between chips?  Or is it perhaps coax between hosts?

It's just a pin, like a GPIO. So it would be a PCB trace, flat flex,
copper wire... Anything, really.

I think most of the usecases will involve devices somehow on the same
PCB, so a trace or flat flex would be more common. Perhaps Chris has a
better idea in mind? :-)

-- 
balbi
