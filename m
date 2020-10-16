Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3460290D40
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410856AbgJPV0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:26:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:22820 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411184AbgJPVZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:25:39 -0400
IronPort-SDR: +JIoeyB8reOZzbwUCWhK9gGY+IGKMgCq3FSpYq9nu8oDmvMSlZ0+7E65qLH7YuNmtWFHR3O/1W
 uPJ5hiAusMIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="154490440"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="154490440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:25:36 -0700
IronPort-SDR: pX/qUY3S8bWZDKRBtOEAJRbzXnolptBJFq6m1e3IBhPvtnGK6pQlQ/EBw3ljsp2oxP27bRoRgP
 RIcAp4DbjRUg==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="315041967"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:25:36 -0700
Date:   Fri, 16 Oct 2020 14:25:35 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next v2 0/9] net: ethernet: ti: am65-cpsw: add multi
 port support in mac-only mode
Message-ID: <20201016142535.0000390f@intel.com>
In-Reply-To: <20201015231913.30280-1-grygorii.strashko@ti.com>
References: <20201015231913.30280-1-grygorii.strashko@ti.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Grygorii Strashko wrote:

> Hi
> 
> This series adds multi-port support in mac-only mode (multi MAC mode) to TI
> AM65x CPSW driver in preparation for enabling support for multi-port devices,
> like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.

For the series
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
