Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CED12ED788
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbhAGTgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:36:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAGTgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:36:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxb4Q-00Gjcy-AB; Thu, 07 Jan 2021 20:35:42 +0100
Date:   Thu, 7 Jan 2021 20:35:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 07/18] net: iosm: char device for FW flash & coredump
Message-ID: <X/dijqVDmDJ6Pu1/@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-8-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107170523.26531-8-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:35:12PM +0530, M Chetan Kumar wrote:
> Implements a char device for flashing Modem FW image while Device
> is in boot rom phase and for collecting traces on modem crash.

Since this is a network device, you might want to take a look at
devlink support for flashing devices.

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html

And for collecting crashes and other health information, consider
devlink region and devlink health.

It is much better to reuse existing infrastructure than do something
proprietary with a char dev.

	    Andrew
