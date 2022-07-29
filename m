Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D22584FF8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 14:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiG2MIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 08:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiG2MIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 08:08:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42A87F62;
        Fri, 29 Jul 2022 05:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659096522; x=1690632522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=BU/nh2fbY29DK8WaA1aA/wBUoWc0oOBzxFt4YYd12KM=;
  b=AgwaKQVtcNLHSbcPhpH37QvZMI0N+UIy5bII6Oxr33m7W4luyl8Y2FxE
   Orb+TuurlgXAc1yc2DUdSsQ76qco3hrnftKvoorBmV9lTH0wRS5NLxvaX
   WMt6owJErwfII9T7YR7dBZn1WT4h1niJf0ABlfnA4lNIaUOLhwXlZKRPp
   Nb1jZKSS9z8wo3EI/TlJWBwuou8TIvkIKK2u0Ohv4/+S7DbxPhvVWp9HN
   p6olbZs+SowuBpfAF7m39BS3GEK1vZGb62xpFXWvrsWyRGUn8wi/qMqdJ
   d265RV4wnLL9iVLRNVZin96VaA3ivu3qhCZQzQoJ3Q8wn69qoixGupNmL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="289952153"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="289952153"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 05:08:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="604947944"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 05:08:34 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oHOn8-001eTi-0s;
        Fri, 29 Jul 2022 15:08:30 +0300
Date:   Fri, 29 Jul 2022 15:08:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YuPNvr9RkaJoZdRg@smile.fi.intel.com>
References: <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
 <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
 <YtWzWdkFVMg0Hyvf@smile.fi.intel.com>
 <20220718223942.245f29b6@thinkpad>
 <YtXHFQqB3M5Picdl@smile.fi.intel.com>
 <20220719091800.3116daf1@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220719091800.3116daf1@dellmb>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 09:18:00AM +0200, Marek Behún wrote:
> On Mon, 18 Jul 2022 23:48:21 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > On Mon, Jul 18, 2022 at 10:39:42PM +0200, Marek Behún wrote:
> > > On Mon, 18 Jul 2022 22:24:09 +0300
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

...

> > > 2. even if there was a problem with name collision, I think the place
> > >    that needs to be fixed is swnode system. What use are swnodes if
> > >    they cannot be used like this?  
> > 
> > Precisely, that's why I don't want to introduce an API that needs to be fixed.
> 
> Aha, so you want to ensure that root swnodes are created with unique
> name?
> 
> Can't we just make it so that named software node must have a parent?

That's my proposal, but it might have a downside effect on the existing users
(chtwc_int33fe).

-- 
With Best Regards,
Andy Shevchenko


