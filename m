Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A705B3A1FEE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhFIWVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:21:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:20664 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIWVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:21:42 -0400
IronPort-SDR: u2IyVKA1gkQ0htT9LOFhE+RykOU032BsHfXhtv1WnLJvz8ZEOLsszzV6LedUxWQhwM196ey4SG
 Cfb2FmqHdOZQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="185556025"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="185556025"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 15:19:46 -0700
IronPort-SDR: nv+aQ2uz386ovpA9ZvQDqGWhF8Ul9InQEU47EE7X0D3FGsGXEsXO1lZCpHWPq79AD8+47KZ28t
 NLO+dMQZrEhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="477096374"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jun 2021 15:19:44 -0700
Date:   Thu, 10 Jun 2021 00:07:13 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        j.vosburgh@gmail.com, andy@greyhouse.net, vfalico@gmail.com,
        andrii@kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for XDP bonding
Message-ID: <20210609220713.GA14929@ranger.igk.intel.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210609135537.1460244-4-joamaki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609135537.1460244-4-joamaki@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 01:55:37PM +0000, Jussi Maki wrote:
> Add a test suite to test XDP bonding implementation
> over a pair of veth devices.

Cc: Magnus

Jussi,
AF_XDP selftests have very similar functionality just like you are trying
to introduce over here, e.g. we setup veth pair and generate traffic.
After a quick look seems that we could have a generic layer that would
be used by both AF_XDP and bonding selftests.

WDYT?

> 
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 342 ++++++++++++++++++
>  tools/testing/selftests/bpf/vmtest.sh         |  30 +-
>  2 files changed, 360 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
