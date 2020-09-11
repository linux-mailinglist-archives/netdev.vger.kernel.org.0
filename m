Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E276D266A30
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgIKVmJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 17:42:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:22593 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIKVmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 17:42:08 -0400
IronPort-SDR: BKb1Lj5ykTBfqod5hlQIe2ZZ8bYTb9ImBBV80nFcjvPA6VdOOhji84pr4Dk4g6NG+TsZEIWYpQ
 ZtZhH+RNoeew==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="156306752"
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="156306752"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 14:42:08 -0700
IronPort-SDR: OPpjnZl/JVIgjJnhqJFeNR9d9vTtL1AKKqS5LvUH18SRMYMEGQPcV+bbjjb6ZINzDN/iZMv1cb
 szpNIvYExbWA==
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="450120794"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.99.126])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 14:42:07 -0700
Date:   Fri, 11 Sep 2020 14:42:07 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
Message-ID: <20200911144207.00005619@intel.com>
In-Reply-To: <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911012337.14015-12-jesse.brandeburg@intel.com>
        <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote:
> On 11/09/2020 02:23, Jesse Brandeburg wrote:
> > + * @MC_CMD_PTP_IN_TRANSMIT_LENMAX: hack to get W=1 to compile

> I think I'd rather have a bogus warning than bogus kerneldocto suppress it;
>  please drop this line (and encourage toolchain folks to figure out how to
>  get kerneldoc to ignore macros it can't understand).
> Apart from that, the sfc and sfc/falcon parts LGTM.
> 
> -ed

Thanks Ed, I think I might just remove the /** on that function then
(removing it from kdoc processing), would that be acceptable in the
meantime? Of course I'd remove the line I added as well.

- Jesse

