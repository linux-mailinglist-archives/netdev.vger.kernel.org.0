Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8982676F6
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgILAtt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 20:49:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:58878 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgILAtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 20:49:47 -0400
IronPort-SDR: MVXx2rb9JX4M/mIrK41RAHza9AXiAQXX4QsA8DMj/tZkfGKJn/6PQKNKhP2RV7nTMf1txUbxUM
 bs8KpYcVRjfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="156274322"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="156274322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 17:49:42 -0700
IronPort-SDR: ecmaGFAwIHhYe3cRmDcE3rKRI/v5PhtgkZ7vFobDOf297ueu0It4fCRj7hfZfT9cu8hNuDmG5K
 HC2RpLSNIw7A==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="481528292"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.99.126])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 17:49:40 -0700
Date:   Fri, 11 Sep 2020 17:49:39 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
Message-ID: <20200911174939.00001817@intel.com>
In-Reply-To: <115bce2a-daaa-a7c5-3c48-44ce345ea008@solarflare.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911012337.14015-12-jesse.brandeburg@intel.com>
        <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
        <20200911144207.00005619@intel.com>
        <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
        <20200911152642.62923ba2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <115bce2a-daaa-a7c5-3c48-44ce345ea008@solarflare.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote:

> On 11/09/2020 23:26, Jakub Kicinski wrote:
> > #declare _MCDI_BUF_LEN(_len)   DIV_ROUND_UP(_len, 4)
> >
> > 	efx_dword_t txbuf[_MCDI_BUF_LEN(MC_CMD_PTP_IN_TRANSMIT_LENMAX)];
> >
> > Would that work?
> That could work, yes.  Though, probably lose the leading underscore
>  in that case.

Ok, I made a split-out patch for that change in v2, it seems to work
once I found a name that didn't collide.

Thanks for the useful discussion!
