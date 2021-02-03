Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3330D0D9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBCBcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:32:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:47732 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhBCBcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:32:04 -0500
IronPort-SDR: LrYhDNPX/dWvzqtflLZLcDeS0Fkw7BVOy2iXCwv4iU14+E56xR2GHlDsl6YG5AKNatc4BWPejr
 8/PV+ak2vyqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265798048"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="265798048"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:31:24 -0800
IronPort-SDR: g0VbV6d3mrvXz2+hOUonCRCouFigUTY7NNeJ2htRsfi0jTnOUllhrOO4IPRmpZKeKQKoONICoG
 4hx83+WohOrA==
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="392054902"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:31:23 -0800
Date:   Tue, 2 Feb 2021 17:31:23 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 0/2] chelsio: cxgb: Use threaded interrupts for deferred
 work
Message-ID: <20210202173123.00001840@intel.com>
In-Reply-To: <20210202170104.1909200-1-bigeasy@linutronix.de>
References: <20210202170104.1909200-1-bigeasy@linutronix.de>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior wrote:

> Patch #2 fixes an issue in which del_timer_sync() and tasklet_kill() is
> invoked from the interrupt handler. This is probably a rare error case
> since it disables interrupts / the card in that case.
> Patch #1 converts a worker to use a threaded interrupt which is then
> also used in patch #2 instead adding another worker for this task (and
> flush_work() to synchronise vs rmmod).
> 
> This has been only compile tested.

Hi! Thanks for your patch. Do all drivers that use worker threads need
to convert like this or only some?

In future revisions, please indicate the tree
you're targeting, net or net-next.  ie [PATCH net-next v1] I'd also
invert the two paragraphs and talk about patch #1 first.

Jesse
