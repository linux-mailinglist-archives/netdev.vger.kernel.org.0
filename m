Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D221A22B551
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgGWSAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:00:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:1461 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgGWSAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 14:00:43 -0400
IronPort-SDR: jgHXyw6+L6rNfCxQPGO7xfxNaycjJGX1g0kgwiiBBPIuYJfJRC83Gu14hlnaYAo7vzwDMX7v4m
 bZf1va3DXM8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130157437"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="130157437"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 11:00:30 -0700
IronPort-SDR: rV986WkXV24vDCe0/orRjumt6cItPeODNA0x+4rwY0+/dQw6tVuDwYI6dWd3SK5lJUPcj6CvXy
 p5VpaK2iGoPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="432822778"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 23 Jul 2020 11:00:29 -0700
Date:   Thu, 23 Jul 2020 19:55:37 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v3 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200723175537.GA62715@ranger.igk.intel.com>
References: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 07:35:02PM +0200, Maciej Fijalkowski wrote:
> v2->v3:
> - call map_poke_untrack() on each previously registered subprog's aux
>   struct to prog array if adding poke descriptor or tracking the aux
>   struct failed (Daniel)
> 
I just realized that I don't handle it properly for later cases when for
example subprogram JITing fails :< aux structs will still be exposed,
so probably v4 is needed...
