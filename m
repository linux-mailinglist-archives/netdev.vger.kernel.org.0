Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C08322CE6
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBWOxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:53:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:14553 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhBWOxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 09:53:08 -0500
IronPort-SDR: nrf8LLaFqIf+7hkxhechQeDOvcPgR7siDRZHmDk/gt+wa1/AyE7hyztcCjdwspWPMY7UqnmTHO
 n9g0f8xcGu5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="269778255"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="269778255"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 06:52:25 -0800
IronPort-SDR: 8ACHBOpDJtpr2/T4MVdTGS+O3w4bC2vt40M9I04497fZoHqzJHO6+gtH3ui1ceaC/aYOLJYE+m
 SsLIsdwffHeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="366612356"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 23 Feb 2021 06:52:23 -0800
Date:   Tue, 23 Feb 2021 15:41:36 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next v2 4/4] selftests/bpf: introduce xsk statistics
 tests
Message-ID: <20210223144136.GB51139@ranger.igk.intel.com>
References: <20210223103507.10465-1-ciara.loftus@intel.com>
 <20210223103507.10465-5-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223103507.10465-5-ciara.loftus@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 10:35:07AM +0000, Ciara Loftus wrote:
> This commit introduces a range of tests to the xsk testsuite
> for validating xsk statistics.
> 
> A new test type called 'stats' is added. Within it there are
> four sub-tests. Each test configures a scenario which should
> trigger the given error statistic. The test passes if the statistic
> is successfully incremented.
> 
> The four statistics for which tests have been created are:
> 1. rx dropped
> Increase the UMEM frame headroom to a value which results in
> insufficient space in the rx buffer for both the packet and the headroom.
> 2. tx invalid
> Set the 'len' field of tx descriptors to an invalid value (umem frame
> size + 1).
> 3. rx ring full
> Reduce the size of the RX ring to a fraction of the fill ring size.
> 4. fill queue empty
> Do not populate the fill queue and then try to receive pkts.

Thanks for adding descriptions!

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 137 ++++++++++++++++++++---
>  tools/testing/selftests/bpf/xdpxceiver.h |  13 +++
>  2 files changed, 136 insertions(+), 14 deletions(-)
> 
