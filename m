Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0E1B1864
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDTV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:26:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:57542 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgDTV0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:26:07 -0400
IronPort-SDR: Sx8C34kV9vvDvn7eq09Qelo9l+BlN1AFursp8V6+YaTTvVfx7UsBhbJHI7vH/0tZ4Fk92LfE/9
 StJ4hEgtk52w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:26:07 -0700
IronPort-SDR: yvliXu2qriBQcDWzHbcW81UNPs+z5/SAqq1AKjA4J7R3QaNQFx40nchFr8qNTv8oo2BYta0Yhf
 oIsvrXtYSwfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="273308923"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002.jf.intel.com with ESMTP; 20 Apr 2020 14:26:03 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jQdva-0027yQ-9T; Tue, 21 Apr 2020 00:26:06 +0300
Date:   Tue, 21 Apr 2020 00:26:06 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/2] net: bcmgenet: Drop ACPI_PTR() to avoid compiler
 warning
Message-ID: <20200420212606.GD185537@smile.fi.intel.com>
References: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
 <d193529a-57af-b694-32e4-cd64455c6a96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d193529a-57af-b694-32e4-cd64455c6a96@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:18:34AM -0700, Florian Fainelli wrote:
> 
> 
> On 4/20/2020 11:16 AM, Andy Shevchenko wrote:
> > When compiled with CONFIG_ACPI=n, ACPI_PTR() will be no-op, and thus
> > genet_acpi_match table defined, but not used. Compiler is not happy about
> > such data. Drop ACPI_PTR() for good.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thank you!

Please, do not apply this, I will combine all patches together in a series.
I have more because of that ACPI enabling work.

-- 
With Best Regards,
Andy Shevchenko


