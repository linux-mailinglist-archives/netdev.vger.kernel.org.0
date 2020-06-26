Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D903E20AAC5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgFZDft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:35:49 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:45818 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgFZDft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:35:49 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 268F3182CED28;
        Fri, 26 Jun 2020 03:35:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:4321:5007:6119:6742:7576:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12740:12760:12895:13019:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:30046:30054:30055:30064:30067:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: home85_2002a2026e52
X-Filterd-Recvd-Size: 2425
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:35:45 +0000 (UTC)
Message-ID: <b7101ba0cd470df3be74a970c2a2e50de43ed7e6.camel@perches.com>
Subject: Re: [net-next v3 15/15] idpf: Introduce idpf driver
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        kbuild test robot <lkp@intel.com>
Date:   Thu, 25 Jun 2020 20:35:44 -0700
In-Reply-To: <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> From: Alan Brady <alan.brady@intel.com>
> 
> Utilizes the Intel Ethernet Common Module and provides
> a device specific implementation for data plane devices.
[]
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
[]
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2020 Intel Corporation */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include "idpf_dev.h"
> +#include "idpf_devids.h"
> +
> +#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
> +static const char idpf_driver_string[] = DRV_SUMMARY;
> +static const char idpf_copyright[] = "Copyright (c) 2020, Intel Corporation.";
> +
> +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> +MODULE_DESCRIPTION(DRV_SUMMARY);
> +MODULE_LICENSE("GPL v2");
[]
> +static int __init idpf_module_init(void)
> +{
> +	int status;
> +
> +	pr_info("%s", idpf_driver_string);

missing format terminating newline.

> +	pr_info("%s\n", idpf_copyright);



