Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BE3EE922
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhHQJGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:06:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:47808 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhHQJGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:06:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238106986"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238106986"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:05:23 -0700
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="471089536"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:05:20 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mFv22-00Agg5-H2; Tue, 17 Aug 2021 12:05:14 +0300
Date:   Tue, 17 Aug 2021 12:05:14 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     David Thompson <davthompson@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH v1 6/6] TODO: net: mellanox: mlxbf_gige: Replace
 non-standard interrupt handling
Message-ID: <YRt7yqoukWSYmHMg@smile.fi.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-7-andriy.shevchenko@linux.intel.com>
 <CACRpkdavU=_Fo3DQkD_MAT9Ur-RX46v0L-O=tqibpUtdUhe-NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdavU=_Fo3DQkD_MAT9Ur-RX46v0L-O=tqibpUtdUhe-NA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 01:06:06AM +0200, Linus Walleij wrote:
> On Mon, Aug 16, 2021 at 2:00 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> 
> > Since GPIO driver supports interrupt handling, replace custom routine with
> > simple IRQ request.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
> 
> Don't you also need to remove this file from Makefile?

Of course, this is simply to show the intention. It's just a hint, I have no
time to write the code for Mellanox, really :-)

-- 
With Best Regards,
Andy Shevchenko


