Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38826D95E3
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbjDFLiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238550AbjDFLh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:37:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B8C903F
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680780898; x=1712316898;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TYCI1MKcaL1MNZiKdaUVy/2CYgHHghIwYri0YjG/a/4=;
  b=YhJAi7yZePZt+xxkS4pVZ2xcRfI4VXGmytnC11JTIQBMed+56ISpwJKw
   ikVEBVgmFdLqLjuVz4LhN6fuAHH83fnK3qq1xycfy4Zs1Dk2WYykVlHRc
   Uo6VrxPPFnWv5VXOHhFNJ+KlxeCyCZ0YKfkq8leX5y9eYBDa5O3UfcXlZ
   U1Vt/+QZubczE17Cti4Bbks9i+4NE2crl5e7czzwQDIFPVfuwsjlJyA9T
   +kfHcUQdyZ7+FFozhQBDFiag5pWCFqonpaDCjvyGpeumH9ssS5sXAlIPD
   YtxKdRQDupYg/+1EPEA2QPqcQXoOgBjuKCP+YHj6lk3QB8WUqC3ma9uOG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="326755187"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="326755187"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:34:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="776450222"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="776450222"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:34:56 -0700
Date:   Thu, 6 Apr 2023 13:34:53 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de
Subject: Re: [PATCH net-next v3 4/5] ice: specify field names in ice_prot_ext
 init
Message-ID: <ZC6uXW5WMcnAet7F@localhost.localdomain>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
 <20230405075113.455662-5-michal.swiatkowski@linux.intel.com>
 <68714dbe-3a43-9e3a-2bb5-8f1659b4a979@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68714dbe-3a43-9e3a-2bb5-8f1659b4a979@intel.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 03:25:53PM +0200, Alexander Lobakin wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Date: Wed, 5 Apr 2023 09:51:12 +0200
> 
> > Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
> > macro to rewrite anonymous initializers to named one. No functional
> > changes here.
> > 
> > Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_switch.c | 68 +++++++++++----------
> >  1 file changed, 36 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> > index b55cdb9a009f..8872e26d1368 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> > @@ -4540,6 +4540,11 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
> >  	return status;
> >  }
> >  
> > +#define ICE_PROTOCOL_ENTRY(id, ...) {	\
> > +	.prot_type = id,		\
> > +	.offs	   = {__VA_ARGS__},	\
> 
> Minor: please use one tab in between field name and `=` sign (you have
> spaces there for now).
> 
> > +}
> > +
> >  /* This is mapping table entry that maps every word within a given protocol
> >   * structure to the real byte offset as per the specification of that
> >   * protocol header.
> > @@ -4550,38 +4555,37 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
> >   * structure is added to that union.
> >   */
> >  static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
> > -	{ ICE_MAC_OFOS,		{ 0, 2, 4, 6, 8, 10, 12 } },
> > -	{ ICE_MAC_IL,		{ 0, 2, 4, 6, 8, 10, 12 } },
> > -	{ ICE_ETYPE_OL,		{ 0 } },
> > -	{ ICE_ETYPE_IL,		{ 0 } },
> > -	{ ICE_VLAN_OFOS,	{ 2, 0 } },
> > -	{ ICE_IPV4_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
> > -	{ ICE_IPV4_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
> > -	{ ICE_IPV6_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
> > -				 26, 28, 30, 32, 34, 36, 38 } },
> > -	{ ICE_IPV6_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
> > -				 26, 28, 30, 32, 34, 36, 38 } },
> > -	{ ICE_TCP_IL,		{ 0, 2 } },
> > -	{ ICE_UDP_OF,		{ 0, 2 } },
> > -	{ ICE_UDP_ILOS,		{ 0, 2 } },
> > -	{ ICE_VXLAN,		{ 8, 10, 12, 14 } },
> > -	{ ICE_GENEVE,		{ 8, 10, 12, 14 } },
> > -	{ ICE_NVGRE,		{ 0, 2, 4, 6 } },
> > -	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
> > -	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
> > -	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
> > -	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
> > -	{ ICE_VLAN_EX,          { 2, 0 } },
> > -	{ ICE_VLAN_IN,          { 2, 0 } },
> > -	{ ICE_HW_METADATA,	{ ICE_SOURCE_PORT_MDID_OFFSET,
> > -				  ICE_PTYPE_MDID_OFFSET,
> > -				  ICE_PACKET_LENGTH_MDID_OFFSET,
> > -				  ICE_SOURCE_VSI_MDID_OFFSET,
> > -				  ICE_PKT_VLAN_MDID_OFFSET,
> > -				  ICE_PKT_TUNNEL_MDID_OFFSET,
> > -				  ICE_PKT_TCP_MDID_OFFSET,
> > -				  ICE_PKT_ERROR_MDID_OFFSET,
> > -				}},
> > +	ICE_PROTOCOL_ENTRY(ICE_MAC_OFOS, 0, 2, 4, 6, 8, 10, 12),
> > +	ICE_PROTOCOL_ENTRY(ICE_MAC_IL, 0, 2, 4, 6, 8, 10, 12),
> > +	ICE_PROTOCOL_ENTRY(ICE_ETYPE_OL, 0),
> > +	ICE_PROTOCOL_ENTRY(ICE_ETYPE_IL, 0),
> 
> BTW, as offset arguments go into the array declaration, you can even
> omit such single-zero-element declarations. I.e., if I'm not mistaken,
> these two equal to just:
> 
> 	ICE_PROTOCOL_ENTRY(ICE_ETYPE_OL),
> 	ICE_PROTOCOL_ENTRY(ICE_ETYPE_IL),
> 
> But: 1) better to recheck; 2) up to you, maybe it's better to explicitly
> mention zero offsets here.
> 

Good to know, will recheck.

As 0 offset is valid (0 means 0 offset not protocol without offset) I
preffere to mention 0 here.

> > +	ICE_PROTOCOL_ENTRY(ICE_VLAN_OFOS, 2, 0),
> > +	ICE_PROTOCOL_ENTRY(ICE_IPV4_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
> > +	ICE_PROTOCOL_ENTRY(ICE_IPV4_IL,	0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
> > +	ICE_PROTOCOL_ENTRY(ICE_IPV6_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
> > +			   20, 22, 24, 26, 28, 30, 32, 34, 36, 38),
> > +	ICE_PROTOCOL_ENTRY(ICE_IPV6_IL, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
> > +			   22, 24, 26, 28, 30, 32, 34, 36, 38),
> > +	ICE_PROTOCOL_ENTRY(ICE_TCP_IL, 0, 2),
> > +	ICE_PROTOCOL_ENTRY(ICE_UDP_OF, 0, 2),
> > +	ICE_PROTOCOL_ENTRY(ICE_UDP_ILOS, 0, 2),
> > +	ICE_PROTOCOL_ENTRY(ICE_VXLAN, 8, 10, 12, 14),
> > +	ICE_PROTOCOL_ENTRY(ICE_GENEVE, 8, 10, 12, 14),
> > +	ICE_PROTOCOL_ENTRY(ICE_NVGRE, 0, 2, 4, 6),
> > +	ICE_PROTOCOL_ENTRY(ICE_GTP, 8, 10, 12, 14, 16, 18, 20, 22),
> > +	ICE_PROTOCOL_ENTRY(ICE_GTP_NO_PAY, 8, 10, 12, 14),
> > +	ICE_PROTOCOL_ENTRY(ICE_PPPOE, 0, 2, 4, 6),
> > +	ICE_PROTOCOL_ENTRY(ICE_L2TPV3, 0, 2, 4, 6, 8, 10),
> > +	ICE_PROTOCOL_ENTRY(ICE_VLAN_EX, 2, 0),
> > +	ICE_PROTOCOL_ENTRY(ICE_VLAN_IN, 2, 0),
> > +	ICE_PROTOCOL_ENTRY(ICE_HW_METADATA, ICE_SOURCE_PORT_MDID_OFFSET,
> 
> Nit: I think here's the exceptional case when you can specify this
> second argument on the next line, i.e. break the line even though it
> fits into 80 chars. This looks a bit off to me :D
>

Right, will move it

> > +			   ICE_PTYPE_MDID_OFFSET,
> > +			   ICE_PACKET_LENGTH_MDID_OFFSET,
> > +			   ICE_SOURCE_VSI_MDID_OFFSET,
> > +			   ICE_PKT_VLAN_MDID_OFFSET,
> > +			   ICE_PKT_TUNNEL_MDID_OFFSET,
> > +			   ICE_PKT_TCP_MDID_OFFSET,
> > +			   ICE_PKT_ERROR_MDID_OFFSET),
> 
> Hmm, could this patch go as 3/5, i.e. before this last element is
> introduced, so that there'll be 16 lines less in diffstat?
>

Sure, I will rebase

Thanks,
Michal
> >  };
> >  
> >  static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
> 
> Thanks,
> Olek
