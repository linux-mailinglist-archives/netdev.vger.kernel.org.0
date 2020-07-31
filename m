Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB78B234462
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 13:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgGaLJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 07:09:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11680 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbgGaLJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 07:09:21 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06VB94GN017456;
        Fri, 31 Jul 2020 04:09:05 -0700
Date:   Fri, 31 Jul 2020 16:39:04 +0530
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200731110904.GA1571@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
 <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, July 07/30/20, 2020 at 16:23:35 -0700, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 20:41:38 +0530 Ganji Aravind wrote:
> > Update set_flash to flash firmware configuration image
> > to flash region.
> 
> And the reason why you need to flash some .ini files separately is?

Hi Jakub,

The firmware config file contains information on how the firmware
should distribute the hardware resources among NIC and
Upper Layer Drivers(ULD), like iWARP, crypto, filtering, etc.

The firmware image comes with an in-built default config file that
distributes resources among the NIC and all the ULDs. However, in
some cases, where we don't want to run a particular ULD, or if we
want to redistribute the resources, then we'd modify the firmware
config file and then firmware will redistribute those resources
according to the new configuration. So, if firmware finds this
custom config file in flash, it reads this first. Otherwise, it'll
continue initializing the adapter with its own in-built default
config file.

Thanks
-Ganji Aravind.
