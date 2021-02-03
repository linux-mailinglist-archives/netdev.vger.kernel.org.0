Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1D30DFB6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhBCQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:27:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233269AbhBCQ1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:27:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l7Kyz-0043ZV-4Z; Wed, 03 Feb 2021 17:26:21 +0100
Date:   Wed, 3 Feb 2021 17:26:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBrOrQ1kzmW5LrgX@lunn.ch>
References: <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
 <YBRGj5Shy+qpUUgS@lunn.ch>
 <20210130141952.GB4652@nanopsycho.orion>
 <251d1e12-1d61-0922-31f8-a8313f18f194@gmail.com>
 <20210201081641.GC4652@nanopsycho.orion>
 <YBgE84Qguek7r27t@lunn.ch>
 <20210203145751.GD4652@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203145751.GD4652@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >When the platform line card driver is on the BMC, you need a proxy in
> >between. Isn't this what IPMI and Redfish is all about? The proxy
> >driver can offer the same interface as the platform line card driver.
> 
> Do you have any example of kernel driver which is doing some thing like
> that?

drivers/hwmon/ibmaem.c is a pretty normal looking HWMON driver, for
temperature/power/energy sensors which are connected to the BMC and
accessed over IPMI.

char/ipmi/ipmi_watchdog.c as the name suggests is a watchdog. At first
glance its API to user space follows the standard API, even if it does
not make use of the watchdog subsystem core.

These two should give you examples of how you talk to the BMC from a
kernel driver.

	 Andrew
