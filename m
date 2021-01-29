Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F39308BB2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhA2RfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:35:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhA2Rcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 12:32:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5Xcl-003Dyo-6v; Fri, 29 Jan 2021 18:31:59 +0100
Date:   Fri, 29 Jan 2021 18:31:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadim Pasternak <vadimp@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBRGj5Shy+qpUUgS@lunn.ch>
References: <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Platform line card driver is aware of line card I2C topology, its
> responsibility is to detect line card basic hardware type, create I2C
> topology (mux), connect all the necessary I2C devices, like hotswap
> devices, voltage and power regulators devices, iio/a2d devices and line
> card EEPROMs, creates LED instances for LED located on a line card, exposes
> line card related attributes, like CPLD and FPGA versions, reset causes,
> required powered through line card hwmon interface.

So this driver, and the switch driver need to talk to each other, so
the switch driver actually knows what, if anything, is in the slot.

    Andrew
