Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE92452FD
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgHOV5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgHOVwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:52:08 -0400
X-Greylist: delayed 472 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 Aug 2020 10:03:57 PDT
Received: from mail.pqgruber.com (mail.pqgruber.com [IPv6:2a05:d014:575:f70b:4f2c:8f1d:40c4:b13e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E2FC0A893F
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:03:57 -0700 (PDT)
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 59269C68644;
        Sat, 15 Aug 2020 18:55:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1597510557;
        bh=I9ZmWpkm54DPqqg4crS+PjZSSwUmYlntk43wtmiMMNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mqc2vvekdxKOQuojDn2nQEP4WL+paGLgsN3BTPrVhLQ54BRZRWosa2yKxrBrIukjl
         +km26XL0Wu5MqMMecs42B+4RteOry5qbZUP0I0TvhWcjqZTcIg4UDtBD7VrLDCscJE
         ZysXxOXH6H14nMTR1ae9KhGPQpJDyQ+8FiJLlKh8=
Date:   Sat, 15 Aug 2020 18:55:56 +0200
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     andrew@lunn.ch
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>,
        David Miller <davem@davemloft.net>, Dave Karr <dkarr@vyex.com>
Subject: Re: [PATCH net-next v5] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200815165556.GA503896@workstation.tuxnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502152504.154401-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch / commit f166f890c8 ("net: ethernet: fec: Replace interrupt
driven MDIO with polled IO") broke networking on i.MX6Q boards with
Marvell 88E1510 PHYs (Copper / 1000Base-T).

Reverting said commit fixes the problem.

We also reverted 7cdaa4cc4b ("net: ethernet: fec: prevent tx starvation
under high rx load") but that was just for the revert of the problematic
commit to apply cleanly on top of 5.8 / 5.8.1.

Best regards,
Clemens
