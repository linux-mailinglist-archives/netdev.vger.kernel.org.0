Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A26247CB39
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 03:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhLVCCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 21:02:37 -0500
Received: from relay037.a.hostedemail.com ([64.99.140.37]:22379 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230185AbhLVCCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 21:02:37 -0500
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 72E5E275;
        Wed, 22 Dec 2021 02:02:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id BC8F820011;
        Wed, 22 Dec 2021 02:02:28 +0000 (UTC)
Message-ID: <b1c43c75659847134e6bdce75c7fa0319060fcc4.camel@perches.com>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
From:   Joe Perches <joe@perches.com>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Tue, 21 Dec 2021 18:02:27 -0800
In-Reply-To: <SJ0PR11MB51812066CF2DD4458231F280D97C9@SJ0PR11MB5181.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
         <20211221065047.290182-2-mike.ximing.chen@intel.com>
         <60d35206a67a98a0d0fd58d6f47c8dd1312e168e.camel@perches.com>
         <SJ0PR11MB51812066CF2DD4458231F280D97C9@SJ0PR11MB5181.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.24
X-Stat-Signature: urk96airecfwyths7cu4gctkk787z81c
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: BC8F820011
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/NOdS66y2QwsFfCnu5ScR19ZTGBZSXi+g=
X-HE-Tag: 1640138548-970428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 23:22 +0000, Chen, Mike Ximing wrote:
> > From: Joe Perches <joe@perches.com>
[]
> > > diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
> > []
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > []
> > > +MODULE_LICENSE("GPL v2");
> > 
> > Should use "GPL" not "GPL v2".
> > 
> > https://lore.kernel.org/lkml/alpine.DEB.2.21.1901282105450.1669@nanos.tec.linutronix.de/
> > 
> We support v2 only.

This is specific to the MODULE_LICENSE use.

I think you should read the link above.


