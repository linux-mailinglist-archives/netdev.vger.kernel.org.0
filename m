Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA0C20AABC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgFZDcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:32:09 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:34246 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgFZDcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:32:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 688A5180A815E;
        Fri, 26 Jun 2020 03:32:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:6742:7576:7903:10004:10400:10848:10903:11232:11657:11658:11914:12043:12219:12291:12297:12740:12760:12895:13069:13141:13230:13311:13357:13439:13972:14096:14097:14181:14659:14721:21080:21433:21627:21740:30012:30054:30055:30064:30074:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: slope56_350060d26e52
X-Filterd-Recvd-Size: 2587
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:32:06 +0000 (UTC)
Message-ID: <f8b49d7e88a0e5016a16a03dd50b28e73c2a49cc.camel@perches.com>
Subject: Re: [net-next v3 14/15] iecm: Add iecm to the kernel build system
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Thu, 25 Jun 2020 20:32:05 -0700
In-Reply-To: <20200626020737.775377-15-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-15-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
[]
> diff --git a/Documentation/networking/device_drivers/intel/iecm.rst b/Documentation/networking/device_drivers/intel/iecm.rst
[]
> @@ -0,0 +1,93 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +========================
> +Intel Ethernet Common Module
> +========================
> +
> +The Intel Ethernet Common Module is meant to serve as an abstraction layer
> +between device specific implementation details and common net device driver
> +flows. This library provides several function hooks which allow a device driver
> +to specify register addresses, control queue communications, and other device
> +specific functionality.  Some functions are required to be implemented while
> +others have a default implementation that is used when none is supplied by the
> +device driver.  Doing this, a device driver can be written to take advantage
> +of existing code while also giving the flexibility to implement device specific
> +features.
> +
> +The common use case for this library is for a network device driver that wants

to

> +specify its own device specific details but also leverage the more common
> +code flows found in network device drivers.


