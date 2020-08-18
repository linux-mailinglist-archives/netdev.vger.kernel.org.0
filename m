Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB689248E40
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHRSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:54:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:37322 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgHRSyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:54:54 -0400
IronPort-SDR: TLHeFtoprP4hkaY73v7fadayHWqi9KHlXqzjqRzlSJRu0P4xrSxSwJII2bexPmAVKjCIrJPLLy
 5bJXEjr0plBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="216513838"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="216513838"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:54:54 -0700
IronPort-SDR: +7s3CJXK2gDJa0TPz8ssq51eHa81b8kEVxhbC2yiNsY9wAXaKKy3ycnHIveFWhmL3m2Dz7nBk6
 ilonmNSTCRHw==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471919245"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:54:32 -0700
Date:   Tue, 18 Aug 2020 11:54:32 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/4] sfc: really check hash is valid before using it
Message-ID: <20200818115432.00004f3d@intel.com>
In-Reply-To: <c91aa83a-edf1-8faa-2ca7-a8157cb99623@solarflare.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
        <c91aa83a-edf1-8faa-2ca7-a8157cb99623@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 13:43:30 +0100
Edward Cree <ecree@solarflare.com> wrote:

> Actually hook up the .rx_buf_hash_valid method in EF100's nic_type.
> 
> Fixes: 068885434ccb ("sfc: check hash is valid before using it")
> Reported-by: Martin Habets <mhabets@solarflare.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
