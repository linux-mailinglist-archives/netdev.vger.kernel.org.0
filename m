Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD15371621
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhECNpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 09:45:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:40533 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhECNpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 09:45:31 -0400
IronPort-SDR: KW/lmZeDThbqGT/G8ohXE0RrQjA6ZOZ8kzZuRxLRs/AemjjcuGDR/ku5SFg7FApF0G182jpiCC
 rz+WnG7hOQtw==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="194599329"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="194599329"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 06:44:37 -0700
IronPort-SDR: GURVkr9B8GzRJo4MUYh1yQbB4MCXVa+9RP88dFlCc/C528SG8waOt26o8RJEQcu4tlJ8JwQihT
 C3OUyGYlfWbg==
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="462542361"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 06:44:29 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ldYs4-009HF3-7p; Mon, 03 May 2021 16:44:24 +0300
Date:   Mon, 3 May 2021 16:44:24 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Timo =?iso-8859-1?B?U2NobPzfbGVy?= <schluessler@krause.de>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Null pointer dereference in mcp251x driver when resuming from
 sleep
Message-ID: <YI/+OP4z787Tmd05@smile.fi.intel.com>
References: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 03:11:40PM +0200, Frieder Schrempf wrote:
> Hi,
> 
> with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference
> exception from the mcp251x driver when I resume from sleep (see trace
> below).
> 
> As far as I can tell this was working fine with 5.4. As I currently don't
> have the time to do further debugging/bisecting, for now I want to at least
> report this here.
> 
> Maybe there is someone around who could already give a wild guess for what
> might cause this just by looking at the trace/code!?

Does revert of c7299fea6769 ("spi: Fix spi device unregister flow") help?

-- 
With Best Regards,
Andy Shevchenko


