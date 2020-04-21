Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8481B3194
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 23:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDUVJr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 17:09:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:9050 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgDUVJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 17:09:47 -0400
IronPort-SDR: Ma/wV6waLUGQyFezAXEJSw2NnjKjqMoUwSAulvAUR3wcLqP0YVIpyn/sDnOlzWI1Kwp4mwLXHI
 S2soWnlHQI5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 14:09:47 -0700
IronPort-SDR: tz6Jy4CG+mmgSUvAMZ+x6/J7TTFSthCusXtRk0a+xji1sAPX0xliMzg/f2Oc2MmJVA2LtDTc3m
 y+H6PYIfAosg==
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="279783906"
Received: from pvrobles-mobl1.amr.corp.intel.com (HELO localhost) ([10.254.110.52])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 14:09:46 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200421.122610.891640326169718840.davem@davemloft.net>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com> <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com> <20200421.122610.891640326169718840.davem@davemloft.net>
Subject: Re: [net-next 02/13] igc: Use netdev log helpers in igc_main.c
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     andre.guedes@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, aaron.f.brown@intel.com
To:     David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
        kuba@kernel.org
Date:   Tue, 21 Apr 2020 14:09:45 -0700
Message-ID: <158750338551.60047.10607495842380954746@pvrobles-mobl1.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David/Jakub,

Quoting David Miller (2020-04-21 12:26:10)
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Mon, 20 Apr 2020 16:43:02 -0700
> 
> > It also takes this opportunity to improve some messages and remove
> > the '\n' character at the end of messages since it is automatically
> > added to by netdev_* log helpers.
> 
> Where does this happen?  I can't find it.

A while ago, I came across this LWN article [1] that says printk() begins a
new line in the output unless the KERN_CONT flag is used.

This is probably buried deep down in printk() implementation so that's why it
is hard to find. From a quick look, I think the trick is done in
vprintk_store() and log_output() in kernel/printk/printk.c.

Anyways, I can tell you the driver log messages look exactly the same with or
without the ending '\n'.

> I'm tossing this series, you have to explain where this happens
> because I see several developers who can't figure this out at all.

Hope that clarifies and this series is still good to be merged.

Regards,

Andre

[1] https://lwn.net/Articles/732420/
