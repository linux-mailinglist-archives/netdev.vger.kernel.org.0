Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FC0267684
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgIKX2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:28:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:18098 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgIKX2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:28:45 -0400
IronPort-SDR: AJ2tqXm0wD3etlGtoUydO02OglJtw2smqHiIapK2JNZdq3PP48E3gFEH/pF6Q+bpRNSmVe3mP4
 qQjGy5DgiN5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220426655"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="220426655"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:28:44 -0700
IronPort-SDR: TnDhiiwf+7bl2mnM3YaQSfNwd8CuRkgo1ci9/ye48d3ZnzjkqHvXEBHURB7IK/leVQJakwSJut
 u0Y1qAmku/cg==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="285796178"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.99.126])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:28:44 -0700
Date:   Fri, 11 Sep 2020 16:28:43 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [RFC PATCH net-next v1 05/11] intel-ethernet:
 make W=1 build cleanly
Message-ID: <20200911162843.00002730@intel.com>
In-Reply-To: <877dt0nr8r.fsf@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911012337.14015-6-jesse.brandeburg@intel.com>
        <877dt0nr8r.fsf@intel.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius Costa Gomes wrote:


> > diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
> > index 4e7a0810eaeb..2120dacfd55c 100644
> > --- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
> > +++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
> > @@ -139,6 +139,7 @@ static void e1000_phy_init_script(struct e1000_hw *hw)
> >  		 * at the end of this routine.
> >  		 */
> >  		ret_val = e1000_read_phy_reg(hw, 0x2F5B, &phy_saved_data);
> > +		e_dbg("Reading PHY register 0x2F5B failed: %d\n", ret_val);
> >
> 
> Adding this debug statement seems unrelated.

Thanks, in the next version I actually addressed this in the commit
message, that this one change was to solve the "you didn't use ret_val"
with a conceivably useful message. I also rejiggered the patches to
have the register read lvalue removals all in their own patch instead
of squashed together with kdoc changes.

> 
> >  		/* Disabled the PHY transmitter */
> >  		e1000_write_phy_reg(hw, 0x2F5B, 0x0003);
> 
> Apart from this,
> 
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 

Thanks for the review!
