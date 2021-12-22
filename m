Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1A147D8B1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbhLVV0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:26:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhLVV0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 16:26:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BwMYfR9U8yM/q7ThpgNC7zzPhi1AvJNM1qrr3iUCFl8=; b=vdqnk7LB1yok04uIKBnP+vAeHH
        +2cTDhed22kA2uiWJQ0cHp+nHErmUL2HQs5DJJ+UqfekipnH6BiED4Kws0BmlLE89TBn10lzoOnQk
        qTYujcEUbwTZiPT3h+Qo1J0PElmTwQCbPJf/7Y0NS9l/gW/7tD38KWvMsMwPHHVJtzmQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n098A-00HG0W-J8; Wed, 22 Dec 2021 22:26:38 +0100
Date:   Wed, 22 Dec 2021 22:26:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcOYDi1s5x5gU/5w@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcJJh9e2QCJOoEB/@lunn.ch>
 <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > pointing to skbufs? How are the lifetimes of skbufs managed? How do you get skbufs out of the NIC? Are
> > you using XDP?
> 
> This is not a network accelerator in the sense that it does not have
> direct access to the network sockets/ports. We do not use XDP.

So not using XDP is a problem. I looked at previous versions of this
patch, and it is all DPDK. But DPDK is not in mainline, XDP is. In
order for this to be merged into mainline you need a mainline user of
it.

Maybe you should abandon mainline, and just get this driver merged
into the DPDK fork of Linux?

     Andrew
