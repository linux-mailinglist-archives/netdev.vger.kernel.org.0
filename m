Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428CB2869F5
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgJGVPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:15:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:41074 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgJGVPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:15:41 -0400
IronPort-SDR: sTGRNYUahob76ejz3zxoL2q3D3k5EIBNhKmETRLc1JeLxO1P5bisMX0lzMBTvS7ySZkp5OcPLp
 imsd+qHQwQZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="145033174"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="145033174"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:15:41 -0700
IronPort-SDR: hQ93WwKj/ENtrFjhPwSxoR2GuetApys0ihYlpREUttYGxzKUkrpN0+zDWsnw5VMn8eNtU1PYVD
 JY8KMlqlBNlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="297670049"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 07 Oct 2020 14:15:39 -0700
Date:   Wed, 7 Oct 2020 23:08:05 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 3/7] igb: XDP extack message on error
Message-ID: <20201007210805.GB48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-4-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-4-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:02PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Add an extack error message when the RX buffer size is too small
> for the frame size.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
