Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12926562C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 02:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgIKAtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 20:49:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:5656 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgIKAt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 20:49:29 -0400
IronPort-SDR: hbI4Wpj4FGBLkzC73pKlZi0O+ONug1rfkttASzyVCudzYo2EYqM6CP4tqVST0IHcQj1CWsuKPS
 AbLWjOB/+4cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="146358752"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="146358752"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 17:49:28 -0700
IronPort-SDR: xWqMXWZuXTZtbYgAP7S4J7Fz1oIf3SOG+wKboK9U3OB0suep9m4UNgyXAe1uRwaFazczbvMqVF
 H4VL4rKTE+3w==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="329563965"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.96.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 17:49:27 -0700
Date:   Thu, 10 Sep 2020 17:49:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] Fix some kernel-doc warnings for i40e
Message-ID: <20200910174926.00004f0e@intel.com>
In-Reply-To: <20200910150934.34605-1-wanghai38@huawei.com>
References: <20200910150934.34605-1-wanghai38@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote:

> Wang Hai (3):
>   i40e: Fix some kernel-doc warnings in i40e_client.c
>   i40e: Fix some kernel-doc warnings in i40e_common.c
>   i40e: Fix a kernel-doc warning in i40e_ptp.c
> 
>  drivers/net/ethernet/intel/i40e/i40e_client.c | 2 --
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 2 --
>  drivers/net/ethernet/intel/i40e/i40e_ptp.c    | 1 -
>  3 files changed, 5 deletions(-)
> 


Please see my patchset [1]: I've already fixed all of these and many
others.

In fact, before you continue, I have a whole set done making the entire
drivers/net/ethernet directory compile cleanly with W=1, that I'm about
to send, but they depend on [1]

[1]
https://patchwork.ozlabs.org/project/intel-wired-lan/list/?series=&submitter=189&state=&q=&archive=&delegate=

