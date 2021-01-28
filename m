Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A286930747F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhA1LLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:11:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:58317 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhA1LK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 06:10:59 -0500
IronPort-SDR: DFQBtcOw5+BAGZfTiQ3jiETQcG5ISXr8zLS69GvPIUtBxm+Yaq2gG4GccZBoX0PXI7vMjtBkaq
 o1+i3iN5PmJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="241742155"
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="241742155"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 03:09:11 -0800
IronPort-SDR: oLTOeHJAxZveY+y0cspU8swh3mUykqlmfDB8CBvJ7nLRG4fyjW6mcagPZOo5rs3vUPhbqZP1K6
 kC7ATHgNjRPw==
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="473506403"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 03:09:07 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 28 Jan 2021 13:09:04 +0200
Date:   Thu, 28 Jan 2021 13:09:04 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        netdev@vger.kernel.org, Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH 00/12] Rid W=1 warnings from Thunderbolt
Message-ID: <20210128110904.GR2542@lahna.fi.intel.com>
References: <20210127112554.3770172-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127112554.3770172-1-lee.jones@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

On Wed, Jan 27, 2021 at 11:25:42AM +0000, Lee Jones wrote:
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Only 1 small set required for Thunderbolt.  Pretty good!
> 
> Lee Jones (12):
>   thunderbolt: dma_port: Remove unused variable 'ret'
>   thunderbolt: cap: Fix kernel-doc formatting issue
>   thunderbolt: ctl: Demote non-conformant kernel-doc headers
>   thunderbolt: eeprom: Demote non-conformant kernel-doc headers to
>     standard comment blocks
>   thunderbolt: pa: Demote non-conformant kernel-doc headers
>   thunderbolt: xdomain: Fix 'tb_unregister_service_driver()'s 'drv'
>     param
>   thunderbolt: nhi: Demote some non-conformant kernel-doc headers
>   thunderbolt: tb: Kernel-doc function headers should document their
>     parameters
>   thunderbolt: swit: Demote a bunch of non-conformant kernel-doc headers
>   thunderbolt: icm: Fix a couple of formatting issues
>   thunderbolt: tunnel: Fix misspelling of 'receive_path'
>   thunderbolt: swit: Fix function name in the header

I applied all of the changes that touch static functions. For non-static
functions I will send a patch set shortly that adds the missing bits for
the kernel-doc descriptions. I also fixed $subject lines of few patches
("switch:" instead of "swit:").

Please check that I got everything correct in

  git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt.git next

Thanks!
