Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCEE248EC1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHRTdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:33:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:26217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgHRTdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 15:33:47 -0400
IronPort-SDR: 7qH/19wGeprVHN8bksTkKQ4stFIYtm5reiwAxR2OTIYvKqnB1c+2od5Zy94jk+UEApfVIulaY8
 apQBPmSfXH9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="154964147"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="154964147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:33:46 -0700
IronPort-SDR: v5XFWJ+JbbST5YSh2TT6s3AbtjRmYomkCEn+9y76bTsu2i6WchpZ9P7DI5+kwWpUNff3IyVcHp
 SEe4twE0/8qw==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="471935034"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 12:33:46 -0700
Date:   Tue, 18 Aug 2020 12:33:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ganji Aravind <ganji.aravind@chelsio.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <vishal@chelsio.com>, <rahul.lakkireddy@chelsio.com>
Subject: Re: [PATCH net 1/2] cxgb4: Fix work request size calculation for
 loopback test
Message-ID: <20200818123345.00007802@intel.com>
In-Reply-To: <20200818154058.1770002-2-ganji.aravind@chelsio.com>
References: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
        <20200818154058.1770002-2-ganji.aravind@chelsio.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ganji Aravind wrote:

> Work request used for sending loopback packet needs to add
> the firmware work request only once. So, fix by using
> correct structure size.
> 
> Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
> Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>

changes look ok, but to understand why this change fixed the bug, you
could have just mentioned that the cpl_tx_pkt struct has a _core member
inside of it, and then I wouldn't have had to waste review time digging
through the code in the kernel.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
