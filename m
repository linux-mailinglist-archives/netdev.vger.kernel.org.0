Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D1411B6DE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388844AbfLKQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:03:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388821AbfLKQD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 11:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JC7q0sPt/GRGBIf2Uf74AucDMKhObwoznRVXHT//S3Q=; b=ZlQJFkn9tJIjt29SdqX1PpHMRK
        pTityYajvTA/tvyRey6gPYVYmEMxu+G/zBPejLTSbFE2Gk7trOW6/vtgjB2OYyQNsFRHWIlhLGhAt
        8vM8PVrbairl+z8kzRcI2CVzx2R/PJ4fLSR6P9XQMuonoOFZfQ+VuhuGKM3oVwbJLIFk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1if4SP-0005m0-6C; Wed, 11 Dec 2019 17:03:21 +0100
Date:   Wed, 11 Dec 2019 17:03:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Chng, Jack Ping" <jack.ping.chng@linux.intel.com>,
        devel@driverdev.osuosl.org, cheol.yong.kim@intel.com,
        andriy.shevchenko@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mallikarjunax.reddy@linux.intel.com,
        davem@davemloft.net
Subject: Re: FW: [PATCH v2] staging: intel-gwdpa: gswip: Introduce Gigabit
 Ethernet Switch (GSWIP) device driver
Message-ID: <20191211160321.GA21225@lunn.ch>
References: <5f85180573a3fb20238d6a340cdd990f140ed6f0.1576054234.git.jack.ping.chng@intel.com>
 <20191211092738.GA505511@kroah.com>
 <BYAPR11MB317606F8BE2B60C4BAD872F1DE5A0@BYAPR11MB3176.namprd11.prod.outlook.com>
 <c26e56cf-eb04-5992-252a-e66f6029d6ac@linux.intel.com>
 <20191211121724.GA514307@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211121724.GA514307@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > We are trying to upstream the datapath code for Intel new NoC gateway
> > (please refer to intel-gwdpa.txt at the end of the patch). It consists of
> > ethernet, WIFI and passive optics handling. Since the code is quite huge, we
> > have broken it into parts for internal review.
> > 
> > As we have seen past upstream example such as fsl/dpaa, we thought that it
> > is better for us to start the upstreaming of the driver into staging folder
> > to get feedback from the community.
> > 
> > Is this the right approach? Or do we upstream all the drivers into
> > drivers/soc folder when we have all the drivers ready?
> 
> Why is drivers/soc/ the place to put networking drivers?
> 
> Please please please work with the Intel Linux kernel developers who
> know how to do this type of thing and do not require the kernel
> community to teach you all the proper development model and methods
> here.

I see a lot in common with dpaa2 here. You have a non traditional
hardware architecture. That means it does not nicely fit into the tree
as other drivers do.

There also appears to of been a huge amount of code development behind
closed doors, same as dpaa2. And because of the non traditional
architecture, you have had to make all sorts of design decisions. And
because that happened behind closed door, i'm sure some are
wrong. dpaa2 has been in staging for around 2 1/2 years now. It takes
that amount of time to discuss how non traditional hardware should be
supported in Linux, an re-write the drivers as needed because of the
wrong design decisions.

I kind of expect you are going to have a similar experience. So as
well as getting the Intel Linux kernel developers involved for process
and architecture support, you might want to look at how the dpaa2
drivers have evolved, what they got wrong, what they got right. How is
your hardware similar and different. And look at what parts of dpaa2
have moved out of staging, and maybe consider that code as a good
model to follow.

      Andrew
