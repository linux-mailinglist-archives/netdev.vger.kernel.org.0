Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56297318B7
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFAANL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:13:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfFAANK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:13:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 016BE1503F992;
        Fri, 31 May 2019 17:13:09 -0700 (PDT)
Date:   Fri, 31 May 2019 17:13:09 -0700 (PDT)
Message-Id: <20190531.171309.290138318415845331.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V5 net-next 0/6] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531.145456.1740583785604198757.davem@davemloft.net>
References: <cover.1559281985.git.richardcochran@gmail.com>
        <20190531.145456.1740583785604198757.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 17:13:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 31 May 2019 14:54:56 -0700 (PDT)

> From: Richard Cochran <richardcochran@gmail.com>
> Date: Thu, 30 May 2019 22:56:20 -0700
> 
>> This series adds support for PTP (IEEE 1588) P2P one-step time
>> stamping along with a driver for a hardware device that supports this.
>  ...
> 
> Series applied, will push out after build testing :-)

This also does not build.

Please do an allmodconfig build and save me from having to do this
another time.

Thank you.

====================
ERROR: "register_mii_tstamp_controller" [drivers/ptp/ptp_ines.ko] undefined!
ERROR: "unregister_mii_tstamp_controller" [drivers/ptp/ptp_ines.ko] undefined!
ERROR: "unregister_mii_timestamper" [drivers/of/of_mdio.ko] undefined!
ERROR: "register_mii_timestamper" [drivers/of/of_mdio.ko] undefined!
ERROR: "unregister_mii_timestamper" [drivers/net/phy/libphy.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:91: __modpost] Error 1
make: *** [Makefile:1290: modules] Error 2
====================
