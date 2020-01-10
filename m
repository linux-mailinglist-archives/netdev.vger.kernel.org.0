Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB0136F46
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgAJO0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:26:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbgAJO0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:26:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cWGwCc62opavZnegbiqCMtfyBG1T7+ozcmU/luokREM=; b=cvmCthiCJhkSj4eL7Otj+ZmXlu
        Kd7YxwWKApotRkPUWC4Z2aDxzr1GfvUwJ6VIGbZjH2N6HZhIu9MRo8g5sRf7S3FtzgP8g5hVNdte/
        GavVqoBmtcdYHEhYruYVoxNaNFqYvlZ2EoaVGt7aWyuHjG9yd52D7vya027Tg0En60i8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipvFE-0007eu-Kp; Fri, 10 Jan 2020 15:26:36 +0100
Date:   Fri, 10 Jan 2020 15:26:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110142636.GI19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But I have no clue whether that would trigger on a link status
> *change*.

It should do, but without testing...

> Is there a way to test this without pulling the cable? My board sits
> in a data centre, so is not easily accessible to me.

Down and up the other end?

     Andrew
