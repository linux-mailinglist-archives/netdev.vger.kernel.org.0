Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD39554759
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353850AbiFVLEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355165AbiFVLEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:04:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF15C39831;
        Wed, 22 Jun 2022 04:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655895842; x=1687431842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=zJMEWEjiFSil7/EFxLbQZ8fjyyIDnFeySnwGQSaAETs=;
  b=GigkjZFeSRazy/sBGPnBBV1FR1te4BicvCwll4fPZU6HHV0gTmjA5/rs
   TkiPUVpoKJyTr9boVIAtJrOecp0R09tawmgNwsmZFYmBxN69dlNObKi0o
   5RNtY6niaPx1BzpOlbQhDXcSgZhGmnOfFwm81irAkbUza6xBeKjU0fWQh
   XHiCeehGB1QIGJ18CVLiuaTlIGYqHPjN/5KuDFwY67YD+0mPGadlVe4yw
   g5TnIKb6dUXFAGaqOV+IDwb+2qQABBW5YKxjpzj7uguLozmaN4rFecY9i
   iDA9icNnV3WQ6do589OqE1GdrEWzauFDzlMjCCgmLv5xfxKR/9jviLgeV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="260207794"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="260207794"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:03:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677484279"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:03:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3y98-000sGU-59;
        Wed, 22 Jun 2022 14:03:42 +0300
Date:   Wed, 22 Jun 2022 14:03:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrL3DQD92ijLam2V@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:08:13AM +0200, Marcin Wojtas wrote:
> wt., 21 cze 2022 o 13:42 Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> napisał(a):

...

> It's not device on MDIO bus, but the MDIO controller's register itself
> (this _CSR belongs to the parent, subnodes do not refer to it in any
> way). The child device requires only _ADR (or whatever else is needed
> for the case the DSA device is attached to SPI/I2C controllers).

More and more the idea of standardizing the MDIOSerialBus() resource looks
plausible. The _ADR() usage is a bit grey area in ACPI specification. Maybe
someone can also make it descriptive, so Microsoft and others won't utilize
_ADR() in any level of weirdness.


-- 
With Best Regards,
Andy Shevchenko


