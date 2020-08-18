Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9B248E5F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRTBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:37754 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgHRTBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 15:01:40 -0400
IronPort-SDR: MtBPYiPP8r1+fwJoFv9qHRYfUZGdV9I4RUsitdeQMM87y+Sxzp1/GRmG/aGkEMMF7AZuvqW9kv
 gRrhAdAapMPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142811414"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="142811414"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:01:39 -0700
IronPort-SDR: 1bgrrDziltHz3nyD+m6JC8nzJwN5cD6bDwOLLFN4zrrBYdbozgJAgKD4fPkirXL3AcxeH53Tb+
 RJ3aIj/TLM+w==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="279478877"
Received: from ammccann-mobl.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:01:39 -0700
Date:   Tue, 18 Aug 2020 12:01:37 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net 3/4] sfc: null out channel->rps_flow_id after
 freeing it
Message-ID: <20200818120137.00004035@intel.com>
In-Reply-To: <20200818115857.000078e5@intel.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
        <ea34ed03-23e8-568f-ec50-1f238bc0a350@solarflare.com>
        <20200818115857.000078e5@intel.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse Brandeburg wrote:

> Edward Cree wrote:
> 
> > If an ef100_net_open() fails, ef100_net_stop() may be called without
> >  channel->rps_flow_id having been written; thus it may hold the address
> >  freed by a previous ef100_net_stop()'s call to efx_remove_filters().
> >  This then causes a double-free when efx_remove_filters() is called
> >  again, leading to a panic.
> > To prevent this, after freeing it, overwrite it with NULL.
> > 
> > Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
> > Signed-off-by: Edward Cree <ecree@solarflare.com>

My mailer messed up my previous reply, but this is what I meant to say:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

