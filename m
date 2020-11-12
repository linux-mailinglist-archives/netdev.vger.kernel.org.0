Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50942B0E89
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgKLTz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:55:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:46984 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgKLTz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:55:26 -0500
IronPort-SDR: kVaPLMUmW6bXPuzYgc5H++I5FNcrIQ7+Rk2y5EzafziUi15NXR/pbEmrLHiEN8kqzfjFwnmLoR
 4zCj6MLZ2ulg==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="166863401"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="166863401"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 11:55:25 -0800
IronPort-SDR: DsUlTVVOlynqrt86LqUK7pV/urlmnAAbQ28PeqqZbeqlVhkgqUMMa23YwX5sm35xuJfyuWHRUh
 Yw5q7WJ8TJAA==
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="357213971"
Received: from jlee24-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.177.92])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 11:55:25 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-11-10
In-Reply-To: <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
 <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 12 Nov 2020 11:55:24 -0800
Message-ID: <87blg28i4z.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
>
> Pulled, thanks!
>
> Please double check the use of the spin lock in patch 3. Stats are
> updated in an atomic context when read from /proc, you probably need 
> to convert that spin lock to _bh.

I just did some tests with lockdep enabled, reading from /proc/net/dev
in a loop, and everything seems fine. Am I missing something?


Cheers,
-- 
Vinicius
