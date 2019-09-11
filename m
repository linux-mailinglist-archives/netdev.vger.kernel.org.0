Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B81AF56E
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 07:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfIKFYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 01:24:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:50332 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfIKFYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 01:24:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 22:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="178908590"
Received: from mjtillin-mobl1.ger.corp.intel.com ([10.252.1.17])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2019 22:24:10 -0700
Message-ID: <7783b8532d544ee38517b8c6a20dea97c3589618.camel@intel.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Malamud <alex.malamud@intel.com>
Date:   Wed, 11 Sep 2019 08:24:09 +0300
In-Reply-To: <20190911004229.74d2763a@canb.auug.org.au>
References: <20190911004229.74d2763a@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 00:42 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   aa43ae121675 ("iwlwifi: LTR updates")
> 
> is missing a Signed-off-by from its committer.

Oops, that was my fault.  What can we do about it? Is it enough if I
give my s-o-b publicly here?

I hereby sign off this change:

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>


--
Cheers,
Luca.

