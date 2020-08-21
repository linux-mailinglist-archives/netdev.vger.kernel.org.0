Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD32C24DE82
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgHURdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:33:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:33419 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgHURdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:33:18 -0400
IronPort-SDR: hAa0BFXSjEMCF0B1SRhLmkk/TrR/BYGhzrfhhke6dBxF/nx40Ty40ZyTQ8epby+IPq60pQzPZH
 gQ91i/GXILmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="143226420"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="143226420"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:33:18 -0700
IronPort-SDR: ZRTpf96J2YZjKg9AaHEdo6J7pn9HAiKe2JdvhudZKa7aeVskIEAiuw28N2FjiGr5mUx4akdb2y
 IL+jczi9DgYQ==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298010709"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:33:17 -0700
Date:   Fri, 21 Aug 2020 10:33:16 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 03/11] qed: swap param init and publish
Message-ID: <20200821103316.000026b9@intel.com>
In-Reply-To: <20200727184310.462-4-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-4-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> In theory that could lead to race condition
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
