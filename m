Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFACC212ED4
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGBV1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBV1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:27:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32832C08C5C1;
        Thu,  2 Jul 2020 14:27:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEE83128449C8;
        Thu,  2 Jul 2020 14:27:43 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:27:42 -0700 (PDT)
Message-Id: <20200702.142742.455023767824311035.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: set the correct number of
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
References: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:27:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Thu, 2 Jul 2020 12:44:50 +0300

> The number of ports is incorrectly set to the maximum available for a DSA
> switch. Even if the extra ports are not used, this causes some functions
> to be called later, like port_disable() and port_stp_state_set(). If the
> driver doesn't check the port index, it will end up modifying unknown
> registers.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

Applied and queued up for -stable, thanks.
