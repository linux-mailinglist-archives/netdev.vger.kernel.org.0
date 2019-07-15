Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1479F6879E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfGOLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 07:01:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:26027 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbfGOLBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 07:01:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 04:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="250799348"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2019 04:01:43 -0700
Received: from abityuts-desk1.fi.intel.com (abityuts-desk1.fi.intel.com [10.237.68.147])
        by linux.intel.com (Postfix) with ESMTP id E6861580372;
        Mon, 15 Jul 2019 04:01:41 -0700 (PDT)
Message-ID: <cab2d7f27cc57a0bc680bd5f7e483461b841b96b.camel@gmail.com>
Subject: Re: [PATCH] ethtool: igb: dump RR2DCDELAY register
From:   Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org
Date:   Mon, 15 Jul 2019 14:01:40 +0300
In-Reply-To: <20190715091334.GB24551@unicorn.suse.cz>
References: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
         <20190715091334.GB24551@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-15 at 11:13 +0200, Michal Kubecek wrote:
> > +	/*
> > +	 * Starting from kernel version 5.3 the registers dump buffer grew from
> > +	 * 739 4-byte words to 740 words, and word 740 contains the RR2DCDLAY
> 
> nit: "E" missing here:                                                    ^

Fixed and sent out v2.

> > +	fprintf(stdout,
> > +		"0x05BF4: RR2DCDELAY  (Max. DMA read delay)            0x%08X\n",
> > +		regs_buff[739]);
> 
> Showing a delay as hex number doesn't seem very user friendly but that
> also applies to many existing registers so it's probably better to be
> consistent and perhaps do an overall cleanup later.

Agree.

Thanks!

