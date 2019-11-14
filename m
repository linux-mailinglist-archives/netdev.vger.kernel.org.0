Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39C4FC7D0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKNNgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:36:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfKNNgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9IUh79pYlrw+MCzgIebbfLLelftXtyNiSMHcctlQUko=; b=K2j/O1eC8VnfznbqIWySUdT8V6
        u8me8U104ntp55Go7ft732JBOn/FaYPjNFAruEUeXrQEjfi1IBNvZyFsLwLZw/8juORnzhGFwiL16
        dSjJi7eKKuNn2XFWkr/DCPtgnfcy38J2Ds6q4IRdSPmLmYf/DU/4wYPIe0448jHVcWuA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iVFIU-0004DY-Sm; Thu, 14 Nov 2019 14:36:30 +0100
Date:   Thu, 14 Nov 2019 14:36:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make HOSTPRIO a kernel config
Message-ID: <20191114133630.GB16076@lunn.ch>
References: <20191112212515.6663-1-olteanv@gmail.com>
 <CA+h21hqpO91_LduJhhW7c1fr_0JJg54m8ovu5An-Ly+bzVtQ6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqpO91_LduJhhW7c1fr_0JJg54m8ovu5An-Ly+bzVtQ6g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would a devlink property be better for this?

Yes, more flexible than a kernel config. And the plumbing is now in
place, so it should not be too much effort.

       Andrew
