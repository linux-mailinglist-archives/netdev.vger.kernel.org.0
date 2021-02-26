Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2C326A07
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:31:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:32453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhBZWbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 17:31:20 -0500
IronPort-SDR: iDM6JJ0ECG7SCx8JSvnm6ndIa9kLEIXTcxnPFUkgBXoIuCeVBX9NUxoiiawwYGuMT5RVCvQJHf
 oMb8oPYHZpXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="173150048"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="173150048"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 14:30:39 -0800
IronPort-SDR: rYrTUz2gi+ZCYEP2CYrKlMXHfTAmFK8H8OcJF9uzaZLLpce6yCRYZf/upyjKPP4zgBkcBbmNoh
 xJRu8EWrXaKg==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="516660573"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.213.184.154])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 14:30:38 -0800
Date:   Fri, 26 Feb 2021 14:30:32 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>,
        Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH net 2/2] igb: Fix duplicate include guard
Message-ID: <20210226143032.00005184@intel.com>
In-Reply-To: <20210222040005.20126-2-tseewald@gmail.com>
References: <20210222040005.20126-1-tseewald@gmail.com>
        <20210222040005.20126-2-tseewald@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Seewald wrote:

> The include guard "_E1000_HW_H_" is used by two separate header files in
> two different drivers (e1000/e1000_hw.h and igb/e1000_hw.h). Using the
> same include guard macro in more than one header file may cause
> unexpected behavior from the compiler. Fix this by renaming the
> duplicate guard in the igb driver.
> 
> Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

Change is simple and makes sense.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
