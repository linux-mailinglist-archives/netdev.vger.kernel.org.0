Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07AB30D070
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhBCApk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:45:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:44239 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhBCAp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:45:29 -0500
IronPort-SDR: ooP5yWCS1qr2djAAgrSSlMLJM/oHJ+RBVvsupcH49c1UQ7S6kMEvutqIF+gvPPdzIYXDwuBspJ
 advLaAWPTmhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265791230"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="265791230"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:44:48 -0800
IronPort-SDR: 3LBguOexd8PLpZ/1JyW4zqN3CZWn53XIXrj0NgpJ6HcB6pByefQu8eZaV4p15KGusbWWsyTVti
 lcqHIYWQUFtQ==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392025337"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.172.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:44:48 -0800
Date:   Tue, 2 Feb 2021 16:44:48 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 4/7] octeontx2-af: Physical link
 configuration support
Message-ID: <20210202164448.00005c51@intel.com>
In-Reply-To: <1612157084-101715-5-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-5-git-send-email-hkelam@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hariprasad Kelam wrote:

> From: Christina Jacob <cjacob@marvell.com>
> 
> CGX LMAC, the physical interface support link configuration parameters
> like speed, auto negotiation, duplex  etc. Firmware saves these into
> memory region shared between firmware and this driver.
> 
> This patch adds mailbox handler set_link_mode, fw_data_get to
> configure and read these parameters.
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
