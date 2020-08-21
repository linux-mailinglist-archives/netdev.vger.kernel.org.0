Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23EF24E1A2
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgHUUAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:00:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:43119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbgHUT7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:59:40 -0400
IronPort-SDR: coxufCFWbO97Y51czNC5uvxpfNRzBH8XgRS2gSw3sodFPA7t4P5nTSRx/6TIXCol9GG8zjejfJ
 Nc6N/VgYMDvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="173658055"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="173658055"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:59:39 -0700
IronPort-SDR: +N961mZ9YIUL8nxa8Vs+5MsMfAfiughcAEwmSuRupC9QN8jZOUlnOKtfHASQ4BA92CfB+hxyvO
 T5x55sZGz1dw==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298045154"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:59:38 -0700
Date:   Fri, 21 Aug 2020 12:59:36 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net v2 PATCH 1/2] net: ethernet: ti: cpsw: fix clean up of
 vlan mc entries for host port
Message-ID: <20200821125936.00003fc7@intel.com>
In-Reply-To: <20200821134912.30008-1-m-karicheri2@ti.com>
References: <20200821134912.30008-1-m-karicheri2@ti.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri wrote:

> To flush the vid + mc entries from ALE, which is required when a VLAN
> interface is removed, driver needs to call cpsw_ale_flush_multicast()
> with ALE_PORT_HOST for port mask as these entries are added only for
> host port. Without this, these entries remain in the ALE table even
> after removing the VLAN interface. cpsw_ale_flush_multicast() calls
> cpsw_ale_flush_mcast which expects a port mask to do the job.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Patch makes sense. Please resend with a Fixes: tag.
