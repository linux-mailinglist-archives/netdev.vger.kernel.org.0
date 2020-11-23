Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B02C1898
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbgKWWkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:40:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:51414 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731237AbgKWWkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:40:13 -0500
IronPort-SDR: ZdrtUlzKrT3ba8niE182cb5m75EchQno9C79UBrOLqLmP61C3Rkcq3EImxj+WQ4nRUwMP2AaxG
 KV8Mqf1/Khog==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="171075195"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="171075195"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:40:12 -0800
IronPort-SDR: oRIxvwNst8eDCvD63ZAGlEkoz2ntOS94PH/gB01sMDhGhsUtVR5Xek1btIm2I8Gdj6ZXcl5uZV
 A5o+sixGncBQ==
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="546586193"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.57.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:40:11 -0800
Date:   Mon, 23 Nov 2020 14:40:11 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v2 1/2] ethtool: Add CMIS 4.0 module type to
 UAPI
Message-ID: <20201123144011.0000713e@intel.com>
In-Reply-To: <1606123198-6230-2-git-send-email-moshe@mellanox.com>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
        <1606123198-6230-2-git-send-email-moshe@mellanox.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moshe Shemesh wrote:

> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> CMIS 4.0 document describes a universal EEPROM memory layout, which is
> used for some modules such as DSFP, OSFP and QSFP-DD modules. In order
> to distinguish them in userspace from existing standards, add
> corresponding values.
> 
> CMIS 4.0 EERPOM memory includes mandatory and optional pages, the max

typo? s/EERPOM/EEPROM

> read length 768B includes passive and active cables mandatory pages.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

rest was ok.
