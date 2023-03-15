Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFCC6BAF73
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCOLn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCOLn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:43:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9205421A09;
        Wed, 15 Mar 2023 04:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678880636; x=1710416636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KST0rCAJhGL/COIU6hqmVN80y0QSSX7J/nA1+/5MpLE=;
  b=JE4InaFEM9sCmkEeIHb1Hnp41ydvYW2UnyXPA0LNw97q+YR7zy955xgl
   tT2AK0nA17VGJElrG1PYdq/zdrmKY30s/a7m5+UQ4CPR4eF1micMTv0Cr
   fAbNeTeXyH/IQKDIduZQPqyAvf9P+3AUHf2Q9xFGl9fyD7gS3z15B+RYr
   zCQk4afX78hOzS/fBtMM9aLMq8ySMkNBNCGsmGruS8hmrhC+aL9mxIZ0X
   CB/ZqTTimEMHNL9sWvooWsVQvE+G5ek4NGZMBF0TULp9dzvYb8t460Af3
   vtA9qfnVTthquipw/yXGDN8V3RjB/17LWRAOREighrUoVxsxRarDnRbL3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335164814"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335164814"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:43:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803253335"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803253335"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:43:51 -0700
Date:   Wed, 15 Mar 2023 12:43:42 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Durai Manickam KR <durai.manickamkr@microchip.com>
Cc:     Hari.PrasathGE@microchip.com,
        balamanikandan.gunasundar@microchip.com,
        manikandan.m@microchip.com, varshini.rajendran@microchip.com,
        dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
        balakrishnan.s@microchip.com, claudiu.beznea@microchip.com,
        cristian.birsan@microchip.com, nicolas.ferre@microchip.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, richardcochran@gmail.com,
        linux@armlinux.org.uk, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, pabeni@redhat.com
Subject: Re: [PATCH 0/2] Add PTP support for sama7g5
Message-ID: <ZBGvbuue5e3vR8Fs@localhost.localdomain>
References: <20230315095053.53969-1-durai.manickamkr@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315095053.53969-1-durai.manickamkr@microchip.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:20:51PM +0530, Durai Manickam KR wrote:
> This patch series is intended to add PTP capability to the GEM and 
> EMAC for sama7g5.
> 
> Durai Manickam KR (2):
>   net: macb: Add PTP support to GEM for sama7g5
>   net: macb: Add PTP support to EMAC for sama7g5
> 
>  drivers/net/ethernet/cadence/macb_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Side question, doesn't it need any software implementation? Or it is
already implemented, or it is only hw caps?

> -- 
> 2.25.1
> 
