Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F63920E8
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhEZTdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:33:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:58465 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhEZTdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:33:50 -0400
IronPort-SDR: 08Iss5CDVh2XNMQpamHIvLkM0qVZzEkT/ikcPgrk/aPvP0ulk5VpunOXN2MaidJ7hyhB79PbZS
 rKJLHg5oVD5w==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="223746441"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="223746441"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:32:13 -0700
IronPort-SDR: 7lVBb8F0/kEdc31JNLmG5hOeV50t2w7whsgGB05tUzKK8LM/Cae57uggs1vmb6QYk2C6gezhQO
 klKAKNrcclrg==
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="397922936"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:32:11 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1llzGC-00EsQn-Cy; Wed, 26 May 2021 22:32:08 +0300
Date:   Wed, 26 May 2021 22:32:08 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251xfd: Fix header block to clarify
 independence from OF
Message-ID: <YK6iOB/u9wJZy8cG@smile.fi.intel.com>
References: <20210526191801.70012-1-andriy.shevchenko@linux.intel.com>
 <20210526192214.ksgyjescrtnhg5yq@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526192214.ksgyjescrtnhg5yq@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 09:22:14PM +0200, Marc Kleine-Budde wrote:
> On 26.05.2021 22:18:01, Andy Shevchenko wrote:
> > The driver is neither dependent on OF, nor it requires any OF headers.
> > Fix header block to clarify independence from OF.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Does it already work on ACPI?

Nope.

> Applied to linux-can-next/testing.

Please, scratch this (because of above).

I'll send out a v2 shortly.

-- 
With Best Regards,
Andy Shevchenko


