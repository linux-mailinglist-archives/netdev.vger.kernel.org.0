Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982323B843
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgHDJ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:57:04 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28686 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHDJ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:57:04 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0749uoPn000757;
        Tue, 4 Aug 2020 02:56:51 -0700
Date:   Tue, 4 Aug 2020 15:13:26 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ganji Aravind <ganji.aravind@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200804094321.GA32270@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
 <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200731110904.GA1571@chelsio.com>
 <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200731211733.GA25665@chelsio.com>
 <20200801212202.7e4f3be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200802171221.GA29010@chelsio.com>
 <20200803141304.79a7d05f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803141304.79a7d05f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, August 08/03/20, 2020 at 14:13:04 -0700, Jakub Kicinski wrote:
> On Sun, 2 Aug 2020 22:42:28 +0530 Rahul Lakkireddy wrote:
> > The config file contains very low-level firmware and device specific
> > params and most of them are dependent on the type of Chelsio NIC.
> > The params are mostly device dependent register-value pairs.
> > We don't see users messing around with the params on their own
> > without consultation. The users only need some mechanism to flash
> > the custom config file shared by us on to their adapter. After
> > device restart, the firmware will automatically pick up the flashed
> > config file and redistribute the resources, as per their requested
> > use-case.
> > 
> > We're already foreseeing very long awkward list (more than 50 params)
> > for mapping the config file to devlink-dev params and are hoping this
> > is fine. Here's a sample on how it would look.
> > 
> > hw_sge_reg_1008=0x40800
> > hw_sge_reg_100c=0x22222222
> > hw_sge_reg_10a0=0x01040810
> > hw_tp_reg_7d04=0x00010000
> > hw_tp_reg_7dc0=0x0e2f8849
> > 
> > and so on.
> 
> I have no details on what you're actually storing in the config, 
> and I don't care what your format is.
> 
> If it's a configuration parameter - it needs a proper API.
> 
> If it's a low level board param or such - it doesn't need a separate
> flashable partition and can come with the rest of FW.
> 
> I know the firmware flashing interface is a lovely, binary, opaque
> interface which vendors love. We'll not entertain this kind of abuse.
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>

Sure, will drop the patch for now and revisit again, as part of
devlink or better API.

Thanks,
Rahul
