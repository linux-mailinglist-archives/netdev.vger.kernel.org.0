Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10CD31DAF7
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhBQNv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:51:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:64437 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhBQNvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 08:51:53 -0500
IronPort-SDR: JzwiFj0SmnIpbqieihnLQBmx57mRkJy2lFS0z0G63718IlLr52qSOpkNtatgVqGokqya+5IZQ3
 0dm7E5fXPDlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="202416163"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="202416163"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 05:50:06 -0800
IronPort-SDR: Sn1UNc3NY5KdPzI6hywaTZO83Ua+4LFs6vru1yboiQGthZGzhFy8MJVlArWjcg/KlC/vIRX2G6
 klDb6PahATew==
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="366980157"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 05:50:03 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lCNDM-005icp-3T; Wed, 17 Feb 2021 15:50:00 +0200
Date:   Wed, 17 Feb 2021 15:50:00 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        linux@rasmusvillemoes.dk, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: check for NULL device_node name in
 device_node_string()
Message-ID: <YC0fCAp6wxJfizD7@smile.fi.intel.com>
References: <20210217121543.13010-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217121543.13010-1-info@metux.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 01:15:43PM +0100, Enrico Weigelt, metux IT consult wrote:
> Under rare circumstances it may happen that a device node's name is NULL
> (most likely kernel bug in some other place).

What circumstances? How can I reproduce this? More information, please!

> In such situations anything
> but helpful, if the debug printout crashes, and nobody knows what actually
> happened here.
> 
> Therefore protect it by an explicit NULL check and print out an extra
> warning.

...

> +				pr_warn("device_node without name. Kernel bug ?\n");

If it's not once, then it's possible to have log spammed with this, right?

...

> +				p = "<NULL>";

We have different standard de facto for NULL pointers to be printed. Actually
if you wish, you may gather them under one definition (maybe somewhere under
printk) and export to everybody to use.

-- 
With Best Regards,
Andy Shevchenko


