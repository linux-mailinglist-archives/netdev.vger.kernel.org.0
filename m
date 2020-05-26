Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385E11E19FE
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 05:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbgEZDep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 23:34:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:51228 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388470AbgEZDep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 23:34:45 -0400
IronPort-SDR: HAWbu8lSsvek0W/XzwrbQWIV5kwysCtFSZ5KlJ/VfSh5RcaFosFsD/yt/5NDENQCG5SRnBXfjg
 ZjPMqC2//zMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 20:34:44 -0700
IronPort-SDR: MOZBYrYX/DUAebIUWDovCopbLCdy3VvnTcgIltOfLMbccoZqlMJj91iMgfXh9V2/AqrP6IE6DJ
 JElbVHTP6cIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,435,1583222400"; 
   d="scan'208";a="291033511"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by fmsmga004.fm.intel.com with ESMTP; 25 May 2020 20:34:43 -0700
Date:   Tue, 26 May 2020 11:34:48 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Stable@vger.kernel.org, Rui Zhang <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] e1000e: Do not wake up the system via WOL if device
 wakeup is disabled
Message-ID: <20200526033448.GA8838@chenyu-office.sh.intel.com>
References: <9f7ede2e2e8152704258fc11ba3755ae93f50741.1590081982.git.yu.c.chen@intel.com>
 <20200526002355.B2FAE20657@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526002355.B2FAE20657@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,
On Tue, May 26, 2020 at 12:23:55AM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)").
> 
> The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.
> 
> v5.6.14: Build OK!
> v5.4.42: Build OK!
> v4.19.124: Build OK!
> v4.14.181: Build OK!
> v4.9.224: Failed to apply! Possible dependencies:
>     c8744f44aeae ("e1000e: Add Support for CannonLake")
> 
> v4.4.224: Failed to apply! Possible dependencies:
>     16ecba59bc33 ("e1000e: Do not read ICR in Other interrupt")
>     18dd23920703 ("e1000e: use BIT() macro for bit defines")
>     74f31299a41e ("e1000e: Increase PHY PLL clock gate timing")
>     c8744f44aeae ("e1000e: Add Support for CannonLake")
>     f3ed935de059 ("e1000e: initial support for i219-LM (3)")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
We could discard the change for v4.9 and v4.4 IMO, as their impact should be
minor.

Thanks,
Chenyu
> -- 
> Thanks
> Sasha
