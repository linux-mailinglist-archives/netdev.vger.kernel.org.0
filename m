Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E82D9AB6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgLNPSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:18:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:6075 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407076AbgLNPRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 10:17:48 -0500
IronPort-SDR: QnHrRcL5ySFmSlcF6phZWrI7QZN+jYxJ0NkKgd9m16vRUVxigM5Nsx2WB7csgfuNbTU8hbMero
 KqD+6L9H6EzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="173951506"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="173951506"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 07:17:07 -0800
IronPort-SDR: lNPF00ciK5Gtp944ROTXfleYBCOhzczUlCIRfz5JCfqnQdVnEkuU6rnHnA3BEInFXCjCZwDXB/
 a7Aa4FLjrEnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="333478153"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 14 Dec 2020 07:17:06 -0800
Date:   Mon, 14 Dec 2020 16:07:40 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH net-next 5/8] ice: move skb pointer from rx_buf to rx_ring
Message-ID: <20201214150740.GA15222@ranger.igk.intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
 <20201211164956.59628-6-maciej.fijalkowski@intel.com>
 <20201211202315.570b6605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211202315.570b6605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 08:23:15PM -0800, Jakub Kicinski wrote:
> On Fri, 11 Dec 2020 17:49:53 +0100 Maciej Fijalkowski wrote:
> > @@ -864,14 +865,12 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
> >   * for use by the CPU.
> >   */
> >  static struct ice_rx_buf *
> > -ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
> > -	       const unsigned int size)
> > +ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size)
> >  {
> 
> FWIW I think you missed adjusting kdoc here.

How ironic :) sorry for that.
