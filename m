Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BD8EE4EA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfKDQmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:42:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfKDQmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 11:42:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sHehTGcVoX2o9hizOaow9QsBaYLM8i35tX23WVyF6H4=; b=HG1hjyBfZkWV9J95TsPA1owdqx
        jMpZh4dVKajkKUfxqltYYhJ5EFvydqJWB0Co+19lgFtFwT9TVVkhTOLrRlLjYf1o53lPFzEPrrGr6
        ujgMEDt4UprxGPMRU3d7FxittQcP0shp2+dOv1IR6LqpnddJY93iu8Zc/DaBRyb/ty0s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRfQf-00057J-Bt; Mon, 04 Nov 2019 17:42:09 +0100
Date:   Mon, 4 Nov 2019 17:42:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jack Ping CHNG <jack.ping.chng@intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        andriy.shevchenko@intel.com, mallikarjunax.reddy@linux.intel.com,
        cheol.yong.kim@intel.com
Subject: Re: [PATCH v1] staging: intel-dpa: gswip: Introduce Gigabit Ethernet
 Switch (GSWIP) device driver
Message-ID: <20191104164209.GC16970@lunn.ch>
References: <03832ecb6a34876ef26a24910816f22694c0e325.1572863013.git.jack.ping.chng@intel.com>
 <20191104122009.GA2126921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104122009.GA2126921@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 01:20:09PM +0100, Greg KH wrote:
> On Mon, Nov 04, 2019 at 07:22:20PM +0800, Jack Ping CHNG wrote:
> > This driver enables the Intel's LGM SoC GSWIP block.
> > GSWIP is a core module tailored for L2/L3/L4+ data plane and QoS functions.
> > It allows CPUs and other accelerators connected to the SoC datapath
> > to enqueue and dequeue packets through DMAs.
> > Most configuration values are stored in tables such as
> > Parsing and Classification Engine tables, Buffer Manager tables and
> > Pseudo MAC tables.
> 
> Why is this being submitted to staging?  What is wrong with the "real"
> part of the kernel for this?

Or even, what is wrong with the current driver?
drivers/net/dsa/lantiq_gswip.c?

Jack, your patch does not seem to of made it to any of the lists. So i
cannot comment on it contents. If this is a switch driver, please
ensure you Cc: the usual suspects for switch drivers.

       Andrew
