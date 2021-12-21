Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979E947BA5F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhLUHAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:00:24 -0500
Received: from relay039.a.hostedemail.com ([64.99.140.39]:58157 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233417AbhLUHAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:00:24 -0500
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id A3E7C20C97;
        Tue, 21 Dec 2021 07:00:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 3F9176001A;
        Tue, 21 Dec 2021 07:00:19 +0000 (UTC)
Message-ID: <60d35206a67a98a0d0fd58d6f47c8dd1312e168e.camel@perches.com>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
From:   Joe Perches <joe@perches.com>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Date:   Mon, 20 Dec 2021 23:00:18 -0800
In-Reply-To: <20211221065047.290182-2-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
         <20211221065047.290182-2-mike.ximing.chen@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F9176001A
X-Spam-Status: No, score=-3.40
X-Stat-Signature: jrkkjzbrga8q1q9c6nn4mrpq1ajsfff4
X-Rspamd-Server: rspamout06
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19oQMkjbcvXcXXcPiNLlM1rvJxciEvuPcM=
X-HE-Tag: 1640070019-100663
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 00:50 -0600, Mike Ximing Chen wrote:
> Add a DLB entry to the MAINTAINERS file.

btw: Nice documentation

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -9335,6 +9335,13 @@ L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	arch/x86/include/asm/intel-family.h
>  
> +INTEL DYNAMIC LOAD BALANCER DRIVER
> +M:	Mike Ximing Chen <mike.ximing.chen@intel.com>
> +S:	Maintained
> +F:	Documentation/ABI/testing/sysfs-driver-dlb
> +F:	drivers/misc/dlb/
> +F:	include/uapi/linux/dlb.h
> +
>  INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
>  M:	Jani Nikula <jani.nikula@linux.intel.com>
>  M:	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

Section is not in the appropriate alphabetic order.

dynamic should be after drm

> diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
[]
> +// SPDX-License-Identifier: GPL-2.0-only
[]
> +MODULE_LICENSE("GPL v2");

Should use "GPL" not "GPL v2".

https://lore.kernel.org/lkml/alpine.DEB.2.21.1901282105450.1669@nanos.tec.linutronix.de/


