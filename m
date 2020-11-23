Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E592F2C18A6
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbgKWWmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:42:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:19640 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731256AbgKWWmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:42:53 -0500
IronPort-SDR: 87DmANnE7o2Rr+IY+8jHF8Nm4+iXbClIYDRZAwpm5soQjAIXyqkc4U0t//zKs0c2+hdlJFXOKW
 irzTAgnUUgzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="151698745"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="151698745"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:42:52 -0800
IronPort-SDR: 2OsBzmgX8tyPu2NGVoLl/WxdhYtC3uvvCVYJcrBnBVudNq6A2iPX4j1tm6eB3Q5BUaA3iozbBy
 PmF5UOKBOudw==
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="546586676"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.57.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:42:52 -0800
Date:   Mon, 23 Nov 2020 14:42:52 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next resend 1/2] enetc: Fix endianness issues for
 enetc_ethtool
Message-ID: <20201123144252.000066b8@intel.com>
In-Reply-To: <20201119101215.19223-2-claudiu.manoil@nxp.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
        <20201119101215.19223-2-claudiu.manoil@nxp.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Claudiu Manoil wrote:

> These particular fields are specified in the H/W reference
> manual as having network byte order format, so enforce big
> endian annotation for them and clear the related sparse
> warnings in the process.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Thanks for fixing these warnings!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
