Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C97163314
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgBRUam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:30:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgBRUam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:30:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 141011233E54C;
        Tue, 18 Feb 2020 12:30:42 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:30:39 -0800 (PST)
Message-Id: <20200218.123039.424878470018392744.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: fec: Prevent unbind operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218153444.4899-1-festevam@gmail.com>
References: <20200218153444.4899-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:30:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 18 Feb 2020 12:34:44 -0300

> After performing an unbind/bind operation the network is no longer
> functional on i.MX6 (which has a single FEC instance):
> 
> # echo 2188000.ethernet > /sys/bus/platform/drivers/fec/unbind
> # echo 2188000.ethernet > /sys/bus/platform/drivers/fec/bind
> [   10.756519] pps pps0: new PPS source ptp0
> [   10.792626] libphy: fec_enet_mii_bus: probed
> [   10.799330] fec 2188000.ethernet eth0: registered PHC device 1
> # udhcpc -i eth0
> udhcpc: started, v1.31.1
> [   14.985211] fec 2188000.ethernet eth0: no PHY, assuming direct connection to switch
> [   14.993140] libphy: PHY fixed-0:00 not found
> [   14.997643] fec 2188000.ethernet eth0: could not attach to PHY
> 
> On SoCs with two FEC instances there are some cases where one FEC instance
> depends on the other one being present. One such example is i.MX28, which
> has the following FEC dependency as noted in the comments:
 ...
> Prevent the unbind operation to avoid these issues.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
