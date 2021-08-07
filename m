Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0093E35F3
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhHGOsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 10:48:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhHGOso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 10:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xk437ZK+XzJVD1Kge5a4sgFw8KUmaw3G46w6ax86i/I=; b=GmyXZz2H5ziYlbr6jxmAVr9z2Y
        P7ytkcrsbv2z6cjobDfvcCyFvs77S64MsD3oo7tOiBy/uKsiiKRMcuxf7dP+QyrZfg3IWz3iTqiuf
        3VFAviN9Pn7cGIe/ozCzi0ZLdkJNqR++0M3v0zqsWxJslY2hI2EwSxMdAk37Zty48D1E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCN8y-00GVAU-RT; Sat, 07 Aug 2021 16:17:44 +0200
Date:   Sat, 7 Aug 2021 16:17:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ARM: kirkwood: add missing <linux/if_ether.h> for
 ETH_ALEN
Message-ID: <YQ6WCK0Sytb0nxj9@lunn.ch>
References: <YQxk4jrbm31NM1US@makrotopia.org>
 <cde9de20efd3a75561080751766edbec@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde9de20efd3a75561080751766edbec@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What kernel is this? I've just tested with this exact commit as
> base and it compiles just fine.
> 
> I'm not saying including the file is wrong, but it seems it isn't
> needed in the upstream kernel and I don't know if it qualifies for
> the stable queue therefore.

I would like to see a reproducer for mainline. Do you have a kernel
config which generates the problem.

The change itself does seems reasonable, so if we can reproduce it, i
would be happy to merge it for stable.

      Andrew
