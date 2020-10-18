Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6262917AA
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 15:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgJRNsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 09:48:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:35767 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgJRNsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 09:48:54 -0400
IronPort-SDR: P8CQW5qD9lMLW4lziZYHRzurJWHaPKYcbjACXmieJ6iQqqq2u/cCKeMZr35UT3lYUt/FiJad7f
 G1sMgGLSzP6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9777"; a="153837708"
X-IronPort-AV: E=Sophos;i="5.77,391,1596524400"; 
   d="scan'208";a="153837708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2020 06:48:53 -0700
IronPort-SDR: pp7PfR0d4kl9846foObBfkKhIKwHbdo0bNigheNIqNCoMKqjOQMtiSg/n+hMy7E6SURyWRU6jv
 PKKgzJAgN5Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,391,1596524400"; 
   d="scan'208";a="522828696"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 18 Oct 2020 06:48:49 -0700
Date:   Sun, 18 Oct 2020 15:39:51 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH v2 0/6] igb: xdp patches followup
Message-ID: <20201018133951.GB34104@ranger.igk.intel.com>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017071238.95190-1-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 09:12:32AM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> This patch series addresses some of the comments that came back
> after the igb XDP patch was accepted.
> Most of it is code cleanup.
> The last patch contains a fix for a tx queue timeout
> that can occur when using xdp.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Sorry for not getting back at v1 discussion, I took some time off.

For the series:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Couple nits:
- you don't need SOB line within cover letter, I suppose
- next time please specify the tree in the subject that you're targetting
  this set to land; is it net or net-next? net-next is currently closed so
  you probably would have to come back with this once it will be open
  again
- SOB line should be at the end of tags within commit message of patch;
  I'm saying 'should' because I'm not sure if it's hard requirement.

> 
> Change from v1:
>     * Drop patch 5 as the igb_rx_frame_truesize won't match
>     * Fix typo in comment
>     * Add Suggested-by and Reviewed-by tags
>     * Add how to avoid transmit queue timeout in xdp path
>       is fixed in the commit message
> 
> Sven Auhagen (6):
>   igb: XDP xmit back fix error code
>   igb: take vlan double header into account
>   igb: XDP extack message on error
>   igb: skb add metasize for xdp
>   igb: use xdp_do_flush
>   igb: avoid transmit queue timeout in xdp path
> 
>  drivers/net/ethernet/intel/igb/igb.h      |  5 ++++
>  drivers/net/ethernet/intel/igb/igb_main.c | 32 +++++++++++++++--------
>  2 files changed, 26 insertions(+), 11 deletions(-)
> 
> -- 
> 2.20.1
> 
