Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE80248EC9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgHRTfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:35:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:40868 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHRTfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 15:35:30 -0400
IronPort-SDR: GJ4WNk/7oA7sw5+Nb+tDCQQON5/c2HvX+Y/Ja0BXa33cwxpyxTEQVAZ/YbO+qvxPjgIRqAfgCV
 88i9samzRQBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142815416"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="142815416"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:35:29 -0700
IronPort-SDR: Rwq7k8JxiLY9p1KyU0wzN0M4cTnWkaDivPCdnmgL2yAvau+TtZE9xDs7ZDW2IDXMbDno+mX2Lt
 IkuomfAkp35g==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471935411"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:35:29 -0700
Date:   Tue, 18 Aug 2020 12:35:29 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ganji Aravind <ganji.aravind@chelsio.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <vishal@chelsio.com>, <rahul.lakkireddy@chelsio.com>
Subject: Re: [PATCH net 2/2] cxgb4: Fix race between loopback and normal Tx
 path
Message-ID: <20200818123529.00005d5f@intel.com>
In-Reply-To: <20200818154058.1770002-3-ganji.aravind@chelsio.com>
References: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
        <20200818154058.1770002-3-ganji.aravind@chelsio.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ganji Aravind wrote:

> Even after Tx queues are marked stopped, there exists a
> small window where the current packet in the normal Tx
> path is still being sent out and loopback selftest ends
> up corrupting the same Tx ring. So, ensure selftest takes
> the Tx lock to synchronize access the Tx ring.
> 
> Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
> Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

