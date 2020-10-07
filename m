Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61220286A62
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgJGVlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:41:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:49351 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgJGVlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:41:51 -0400
IronPort-SDR: ZjVZQ6iWSIuW4njyUBZXcQXquzGzEqTCMzbI0EGyDVY3MGO6RaqAUoL7IqE//HV1lg4N6VXnWY
 qD9Yd6QH5Xyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="161714837"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="161714837"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:41:51 -0700
IronPort-SDR: D9ncHPqBeZzPhUx8Aruryvr7B34xmyeq7/TvyBjLHVV9jERBKxzN8YahNxmjNlkywWU02FsI6a
 dTlTgikpRFgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="519039908"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 07 Oct 2020 14:41:48 -0700
Date:   Wed, 7 Oct 2020 23:34:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 6/7] igb: use xdp_do_flush
Message-ID: <20201007213414.GE48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-7-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-7-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:05PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Since it is a new XDP implementation change xdp_do_flush_map
> to xdp_do_flush.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
